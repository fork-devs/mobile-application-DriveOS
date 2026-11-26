import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/billing/application/billing_application.dart';
import 'package:mobile_application_driveos/features/billing/infrastructure/remote/billing_api.dart';
import 'package:mobile_application_driveos/features/billing/infrastructure/repositories/billing_repository_impl.dart';

class _InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, String> _data = {};

  @override
  Future<void> delete(String key) async => _data.remove(key);

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<Map<String, String>> readAll() async => Map<String, String>.from(_data);

  @override
  Future<void> write(String key, String value) async => _data[key] = value;
}

void main() {
  group('Billing Layers', () {
    test('ManageQuotes lists customer quotes and approves a quote', () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final mockClient = MockClient((request) async {
        if (request.url.path == ApiConstants.quotesMe) {
          return http.Response(
            jsonEncode([
              {
                'id': 'q-1',
                'workOrderId': 'wo-1',
                'branchId': 'b-1',
                'subtotalAmount': 400.0,
                'discountPercentage': 10.0,
                'totalAmount': 360.0,
                'status': 'PENDING',
                'items': [],
              },
            ]),
            200,
          );
        }
        if (request.url.path == ApiConstants.quoteApprove('q-1')) {
          return http.Response(
            jsonEncode({
              'id': 'q-1',
              'workOrderId': 'wo-1',
              'branchId': 'b-1',
              'subtotalAmount': 400.0,
              'discountPercentage': 10.0,
              'totalAmount': 360.0,
              'status': 'APPROVED',
              'items': [],
            }),
            200,
          );
        }
        return http.Response('{}', 404);
      });

      final apiClient = ApiClient(sessionStorage: storage, client: mockClient);
      final repository = BillingRepositoryImpl(
        billingApi: BillingApi(apiClient),
      );
      final manageQuotes = ManageQuotes(repository);

      final quotes = await manageQuotes.listMine();
      expect(quotes, hasLength(1));
      expect(quotes.first.totalAmount, 360.0);

      final approved = await manageQuotes.approve('q-1');
      expect(approved.status, 'APPROVED');
    });

    test('ManageCheckouts executes direct checkout and parses payment',
        () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final mockClient = MockClient((request) async {
        expect(request.url.path, ApiConstants.checkouts);
        return http.Response(
          jsonEncode({
            'id': 'chk-1',
            'quoteId': 'q-1',
            'workOrderId': 'wo-1',
            'voucherType': 'BOLETA',
            'series': 'B001',
            'correlativo': 42,
            'customerDocument': '45678912',
            'customerName': 'Carlos Mendoza',
            'totalAmount': 350.0,
            'status': 'PAID',
            'totalPaid': 350.0,
            'payment': {
              'id': 'pay-1',
              'provider': 'CASH',
              'amount': 350.0,
              'status': 'SUCCEEDED',
            },
          }),
          201,
        );
      });

      final apiClient = ApiClient(sessionStorage: storage, client: mockClient);
      final repository = BillingRepositoryImpl(
        billingApi: BillingApi(apiClient),
      );
      final manageCheckouts = ManageCheckouts(repository);

      final result = await manageCheckouts.directCheckout(
        quoteId: 'q-1',
        type: 'boleta',
        customerDocumentType: 'dni',
        customerDocumentNumber: '45678912',
        customerName: 'Carlos Mendoza',
        method: 'cash',
      );

      expect(result.status, 'PAID');
      expect(result.payment?.method, 'CASH');
      expect(result.totalPaid, 350.0);
    });
  });
}
