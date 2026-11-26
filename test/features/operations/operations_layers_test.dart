import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/operations/application/operations_application.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/remote/service_api.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/remote/work_order_api.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/remote/work_order_task_api.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/repositories/operations_repository_impl.dart';

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
  group('Operations Layers', () {
    test('ManageWorkOrders fetches /me and transitions status', () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final mockClient = MockClient((request) async {
        if (request.url.path == ApiConstants.workOrdersMe) {
          return http.Response(
            jsonEncode([
              {
                'orderId': 'wo-1',
                'number': 'WO-2026-0001',
                'status': 'OPEN',
                'customerId': 'c-1',
                'vehicleId': 'v-1',
                'branchId': 'b-1',
              },
            ]),
            200,
          );
        }
        if (request.url.path == ApiConstants.workOrderComplete('wo-1')) {
          return http.Response(
            jsonEncode({
              'orderId': 'wo-1',
              'status': 'COMPLETED',
              'origin': 'IN_PROGRESS',
              'closedAt': '2026-11-25T18:00:00Z',
            }),
            200,
          );
        }
        return http.Response('{}', 404);
      });

      final apiClient = ApiClient(sessionStorage: storage, client: mockClient);
      final repository = OperationsRepositoryImpl(
        workOrderApi: WorkOrderApi(apiClient),
        taskApi: WorkOrderTaskApi(apiClient),
        serviceApi: ServiceApi(apiClient),
      );
      final manageWorkOrders = ManageWorkOrders(repository);

      final myOrders = await manageWorkOrders.listMine();
      expect(myOrders, hasLength(1));
      expect(myOrders.first.number, 'WO-2026-0001');

      final transition = await manageWorkOrders.complete('wo-1');
      expect(transition.status, 'COMPLETED');
      expect(transition.origin, 'IN_PROGRESS');
      expect(transition.closedAt, isNotNull);
    });

    test('ManageWorkOrderTasks starts task and adds spare part proposal',
        () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final mockClient = MockClient((request) async {
        if (request.url.path == ApiConstants.workOrderTaskStart('t-1')) {
          return http.Response(
            jsonEncode({
              'id': 't-1',
              'workOrderId': 'wo-1',
              'serviceId': 's-1',
              'assignedMechanicId': 'm-1',
              'description': 'Brake pad replacement',
              'status': 'DOING',
              'evidenceImages': [],
              'products': [],
              'totalAmount': 150.0,
            }),
            200,
          );
        }
        if (request.url.path == ApiConstants.workOrderTaskProducts('t-1')) {
          return http.Response(
            jsonEncode({
              'id': 'tp-1',
              'productId': 'p-1',
              'quantity': 2,
              'unitPrice': 85.0,
              'totalAmount': 170.0,
              'approvalStatus': 'PENDING_SUPERVISOR_CHECK',
            }),
            201,
          );
        }
        return http.Response('{}', 404);
      });

      final apiClient = ApiClient(sessionStorage: storage, client: mockClient);
      final repository = OperationsRepositoryImpl(
        workOrderApi: WorkOrderApi(apiClient),
        taskApi: WorkOrderTaskApi(apiClient),
        serviceApi: ServiceApi(apiClient),
      );
      final manageTasks = ManageWorkOrderTasks(repository);

      final task = await manageTasks.start('t-1');
      expect(task.status, 'DOING');

      final product = await manageTasks.addProduct(
        taskId: 't-1',
        productId: 'p-1',
        quantity: 2,
        unitPrice: 85.0,
      );
      expect(product.approvalStatus, 'PENDING_SUPERVISOR_CHECK');
      expect(product.totalAmount, 170.0);
    });
  });
}
