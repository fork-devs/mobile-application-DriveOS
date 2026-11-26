import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/inventory/application/inventory_application.dart';
import 'package:mobile_application_driveos/features/inventory/infrastructure/remote/inventory_api.dart';
import 'package:mobile_application_driveos/features/inventory/infrastructure/repositories/inventory_repository_impl.dart';

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
  group('Inventory Layers', () {
    test('ManageInventoryProducts lists products and adds batch', () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final mockClient = MockClient((request) async {
        if (request.url.path == ApiConstants.inventoryProducts) {
          return http.Response(
            jsonEncode([
              {
                'id': 'p-1',
                'branchId': 'b-1',
                'category': 'LUBRICANTES',
                'name': 'Synthetic Oil 5W-30',
                'sku': 'LUB-5W30-1L',
                'salePrice': 45.0,
                'minimumStock': 10,
                'currentStock': 24,
                'lowStockAlert': false,
                'batches': [],
              },
            ]),
            200,
          );
        }
        if (request.url.path == ApiConstants.inventoryProductBatches('p-1')) {
          return http.Response(
            jsonEncode({
              'id': 'batch-1',
              'batchNumber': 'LOT-2026-11A',
              'quantity': 24,
              'remainingQuantity': 24,
              'purchasePrice': 31.5,
            }),
            201,
          );
        }
        return http.Response('{}', 404);
      });

      final apiClient = ApiClient(sessionStorage: storage, client: mockClient);
      final repository = InventoryRepositoryImpl(
        inventoryApi: InventoryApi(apiClient),
      );
      final manageProducts = ManageInventoryProducts(repository);

      final products = await manageProducts.listByBranch(branchId: 'b-1');
      expect(products, hasLength(1));
      expect(products.first.sku, 'LUB-5W30-1L');

      final batch = await manageProducts.addBatch(
        productId: 'p-1',
        batchNumber: 'lot-2026-11a',
        quantity: 24,
        purchasePrice: 31.5,
      );
      expect(batch.batchNumber, 'LOT-2026-11A');
      expect(batch.remainingQuantity, 24);
    });

    test('ManageSparePartsAndStock reserves stock and fetches balance',
        () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final mockClient = MockClient((request) async {
        if (request.url.path == ApiConstants.inventoryStockReserve) {
          return http.Response(
            jsonEncode({
              'id': 'mov-1',
              'tenantId': 't-1',
              'sparePartId': 'sp-1',
              'branchId': 'b-1',
              'movementType': 'RESERVE',
              'quantity': 2,
              'referenceId': 'wo-1',
            }),
            201,
          );
        }
        if (request.url.path ==
            ApiConstants.inventoryStockBalance('sp-1', 'b-1')) {
          return http.Response(
            jsonEncode({
              'sparePartId': 'sp-1',
              'branchId': 'b-1',
              'totalIn': 10,
              'totalOut': 2,
              'totalReserved': 2,
              'availableStock': 6,
            }),
            200,
          );
        }
        return http.Response('{}', 404);
      });

      final apiClient = ApiClient(sessionStorage: storage, client: mockClient);
      final repository = InventoryRepositoryImpl(
        inventoryApi: InventoryApi(apiClient),
      );
      final stock = ManageSparePartsAndStock(repository);

      final movement = await stock.reserve(
        sparePartId: 'sp-1',
        branchId: 'b-1',
        quantity: 2,
        workOrderId: 'wo-1',
      );
      expect(movement.movementType, 'RESERVE');

      final balance = await stock.getBalance(
        sparePartId: 'sp-1',
        branchId: 'b-1',
      );
      expect(balance.availableStock, 6);
    });
  });
}
