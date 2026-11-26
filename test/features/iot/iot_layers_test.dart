import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/iot/application/iot_application.dart';
import 'package:mobile_application_driveos/features/iot/infrastructure/remote/iot_api.dart';
import 'package:mobile_application_driveos/features/iot/infrastructure/repositories/iot_repository_impl.dart';

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
  group('IoT Layers', () {
    test('ManageObd2Devices normalizes MAC and links device', () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final mockClient = MockClient((request) async {
        if (request.url.path == ApiConstants.obd2Devices) {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body['macAddress'], 'AA:BB:CC:DD:EE:FF');
          return http.Response(
            jsonEncode({
              'id': 'dev-1',
              'branchId': 'b-1',
              'macAddress': body['macAddress'],
              'status': 'AVAILABLE',
            }),
            201,
          );
        }
        if (request.url.path == ApiConstants.obd2Registrations) {
          return http.Response(
            jsonEncode({
              'id': 'reg-1',
              'obd2DeviceId': 'dev-1',
              'branchId': 'b-1',
              'vehicleId': 'v-1',
              'status': 'ACTIVE',
            }),
            201,
          );
        }
        return http.Response('{}', 404);
      });

      final apiClient = ApiClient(sessionStorage: storage, client: mockClient);
      final repository = IotRepositoryImpl(iotApi: IotApi(apiClient));
      final manageDevices = ManageObd2Devices(repository);

      final device = await manageDevices.createDevice(
        branchId: 'b-1',
        macAddress: ' aa:bb:cc:dd:ee:ff ',
      );
      expect(device.macAddress, 'AA:BB:CC:DD:EE:FF');

      final reg = await manageDevices.linkDevice(
        obd2DeviceId: 'dev-1',
        branchId: 'b-1',
        vehicleId: 'v-1',
      );
      expect(reg.status, 'ACTIVE');
    });

    test('ManageTelemetryAndDiagnostics parses diagnostics and alerts',
        () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final mockClient = MockClient((request) async {
        if (request.url.path == ApiConstants.vehicleDiagnostics('v-1')) {
          return http.Response(
            jsonEncode({
              'tenant_id': 't-1',
              'vehicle_id': 'v-1',
              'overall_status': 'WARNING',
              'last_speed_kmh': 64.5,
              'last_engine_rpm': 2450,
              'last_coolant_temp_c': 104,
              'last_location': {
                'latitude': -12.1191,
                'longitude': -77.0305,
              },
              'active_dtcs': ['P0300'],
              'active_alerts': [
                {
                  'id': 'alert-1',
                  'vehicle_id': 'v-1',
                  'code': 'P0300',
                  'severity': 'WARNING',
                  'title': 'Misfire',
                  'description': 'Random cylinder misfire detected',
                },
              ],
            }),
            200,
          );
        }
        return http.Response('{}', 404);
      });

      final apiClient = ApiClient(sessionStorage: storage, client: mockClient);
      final repository = IotRepositoryImpl(iotApi: IotApi(apiClient));
      final telemetry = ManageTelemetryAndDiagnostics(repository);

      final diag = await telemetry.getDiagnostics('v-1');
      expect(diag.overallStatus, 'WARNING');
      expect(diag.activeDtcs, ['P0300']);
      expect(diag.activeAlerts, hasLength(1));
      expect(diag.lastLocation?.latitude, -12.1191);
    });
  });
}
