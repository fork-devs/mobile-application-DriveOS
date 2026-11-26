import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/fleet/application/fleet_application.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/remote/appointment_api.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/remote/customer_vehicle_api.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/remote/registration_api.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/repositories/fleet_repository_impl.dart';

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
  group('Fleet Layers', () {
    test('GetAppointments and ManageAppointmentLifecycle parse responses',
        () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final mockClient = MockClient((request) async {
        if (request.url.path == ApiConstants.appointments) {
          return http.Response(
            jsonEncode([
              {
                'id': 'a-1',
                'branchId': 'b-1',
                'customerId': 'c-1',
                'vehicleId': 'v-1',
                'scheduledStart': '2026-11-25T10:00:00Z',
                'scheduledEnd': '2026-11-25T11:30:00Z',
                'status': 'SCHEDULED',
                'notes': 'Brake inspection',
              },
            ]),
            200,
          );
        }
        if (request.url.path == ApiConstants.appointmentConfirm('a-1')) {
          return http.Response(
            jsonEncode({
              'id': 'a-1',
              'branchId': 'b-1',
              'customerId': 'c-1',
              'vehicleId': 'v-1',
              'scheduledStart': '2026-11-25T10:00:00Z',
              'scheduledEnd': '2026-11-25T11:30:00Z',
              'status': 'CONFIRMED',
            }),
            200,
          );
        }
        return http.Response('{}', 404);
      });

      final apiClient = ApiClient(sessionStorage: storage, client: mockClient);
      final repository = FleetRepositoryImpl(
        appointmentApi: AppointmentApi(apiClient),
        customerVehicleApi: CustomerVehicleApi(apiClient),
        registrationApi: RegistrationApi(apiClient),
      );

      final list = await GetAppointments(repository)(branchId: 'b-1');
      expect(list, hasLength(1));
      expect(list.first.status, 'SCHEDULED');

      final confirmed =
          await ManageAppointmentLifecycle(repository).confirm('a-1');
      expect(confirmed.status, 'CONFIRMED');
    });

    test('CreateVehicle normalizes plate and VIN to uppercase', () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final mockClient = MockClient((request) async {
        expect(request.url.path, ApiConstants.vehicles);
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['plate'], 'ABC-123');
        expect(body['vin'], '1NXBR32E85Z123456');

        return http.Response(
          jsonEncode({
            'id': 'v-1',
            'tenantId': 't-1',
            'customerId': 'c-1',
            'plate': body['plate'],
            'brand': 'Toyota',
            'model': 'Corolla',
            'year': 2022,
            'vin': body['vin'],
            'validationStatus': 'PENDING',
            'status': 'ACTIVE',
          }),
          201,
        );
      });

      final apiClient = ApiClient(sessionStorage: storage, client: mockClient);
      final repository = FleetRepositoryImpl(
        appointmentApi: AppointmentApi(apiClient),
        customerVehicleApi: CustomerVehicleApi(apiClient),
        registrationApi: RegistrationApi(apiClient),
      );

      final vehicle = await CreateVehicle(repository)(
        customerId: 'c-1',
        plate: ' abc-123 ',
        brand: 'Toyota',
        model: 'Corolla',
        year: 2022,
        vin: '1nxbr32e85z123456',
      );

      expect(vehicle.plate, 'ABC-123');
      expect(vehicle.vin, '1NXBR32E85Z123456');
    });
  });
}
