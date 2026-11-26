import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/shared/application/shared_application.dart';
import 'package:mobile_application_driveos/features/shared/infrastructure/remote/shared_api.dart';
import 'package:mobile_application_driveos/features/shared/infrastructure/repositories/shared_repository_impl.dart';

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
  group('Shared Layers', () {
    test('ManageIdentityValidations validates RUC and plate', () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final mockClient = MockClient((request) async {
        if (request.url.path == ApiConstants.validateRuc('20601234567')) {
          return http.Response(
            jsonEncode({
              'ruc': '20601234567',
              'razonSocial': 'EMPRESA TRANSPORTES S.A.C.',
              'estado': 'ACTIVO',
              'condicion': 'HABIDO',
              'esValido': true,
              'fromCache': true,
            }),
            200,
          );
        }
        if (request.url.path == ApiConstants.validatePlate('ABC-123')) {
          return http.Response(
            jsonEncode({
              'placa': 'ABC-123',
              'marca': 'TOYOTA',
              'modelo': 'COROLLA',
              'vin': '1NXBR32E85Z123456',
              'esValido': true,
              'fromCache': false,
            }),
            200,
          );
        }
        return http.Response('{}', 404);
      });

      final apiClient = ApiClient(sessionStorage: storage, client: mockClient);
      final repository = SharedRepositoryImpl(sharedApi: SharedApi(apiClient));
      final validations = ManageIdentityValidations(repository);

      final ruc = await validations.validateRuc(' 20601234567 ');
      expect(ruc.esValido, isTrue);
      expect(ruc.razonSocial, 'EMPRESA TRANSPORTES S.A.C.');

      final plate = await validations.validatePlate('abc-123');
      expect(plate.esValido, isTrue);
      expect(plate.marca, 'TOYOTA');
    });

    test('ManageMediaAndHealth checks service health', () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final mockClient = MockClient((request) async {
        expect(request.url.path, ApiConstants.integrationHealth);
        return http.Response(jsonEncode({'status': 'UP'}), 200);
      });

      final apiClient = ApiClient(sessionStorage: storage, client: mockClient);
      final repository = SharedRepositoryImpl(sharedApi: SharedApi(apiClient));
      final mediaAndHealth = ManageMediaAndHealth(repository);

      final health = await mediaAndHealth.checkHealth();
      expect(health.status, 'UP');
    });
  });
}
