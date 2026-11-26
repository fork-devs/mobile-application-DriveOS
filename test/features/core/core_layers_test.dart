import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event.dart';
import 'package:mobile_application_driveos/core/infrastructure/event/stream_domain_event_bus.dart';
import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/core/application/core_application.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/remote/branch_api.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/remote/profile_api.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/remote/workshop_api.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/repositories/core_repository_impl.dart';

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
  group('Core Tenant Layers', () {
    test('SelectActiveBranch persists branch and emits ActiveBranchChangedEvent',
        () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final bus = StreamDomainEventBus();
      final events = <ActiveBranchChangedEvent>[];
      final sub = bus.on<ActiveBranchChangedEvent>().listen(events.add);

      final apiClient = ApiClient(
        sessionStorage: storage,
        eventBus: bus,
        client: MockClient((_) async => http.Response('{}', 200)),
      );
      final repository = CoreRepositoryImpl(
        workshopApi: WorkshopApi(apiClient),
        branchApi: BranchApi(apiClient),
        profileApi: ProfileApi(apiClient),
        sessionStorage: storage,
        eventBus: bus,
      );

      final selectBranch = SelectActiveBranch(repository);
      await selectBranch(
        branchId: 'b-101',
        branchName: 'Sede Surco',
        workshopId: 'w-1',
      );

      await Future<void>.delayed(Duration.zero);

      expect(storage.activeBranchId, 'b-101');
      expect(storage.activeBranchName, 'Sede Surco');
      expect(storage.activeWorkshopId, 'w-1');
      expect(events, hasLength(1));
      expect(events.first.branchId, 'b-101');

      await sub.cancel();
      await bus.dispose();
    });

    test('GetBranchesByWorkshop and GetMyProfileContext parse API responses',
        () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final bus = StreamDomainEventBus();

      final mockClient = MockClient((request) async {
        if (request.url.path == ApiConstants.branches) {
          return http.Response(
            jsonEncode([
              {
                'id': 'b-1',
                'workshopId': 'w-1',
                'code': 'SUC-01',
                'name': 'Sede Surco',
                'address': 'Av. Caminos del Inca 450',
                'phone': '+51987654321',
                'latitude': -12.1211,
                'longitude': -77.0297,
              },
            ]),
            200,
          );
        }
        if (request.url.path == ApiConstants.profilesMe) {
          return http.Response(
            jsonEncode({
              'userId': 'u-1',
              'roles': ['WORKSHOP_ADMIN'],
              'owner': {
                'ownerId': 'o-1',
                'firstName': 'Carlos',
                'lastName': 'Quispe',
                'documentType': 'DNI',
                'documentNumber': '40112233',
                'phone': '+51987112233',
              },
              'employee': null,
              'customer': null,
            }),
            200,
          );
        }
        return http.Response('{}', 404);
      });

      final apiClient = ApiClient(
        sessionStorage: storage,
        eventBus: bus,
        client: mockClient,
      );
      final repository = CoreRepositoryImpl(
        workshopApi: WorkshopApi(apiClient),
        branchApi: BranchApi(apiClient),
        profileApi: ProfileApi(apiClient),
        sessionStorage: storage,
        eventBus: bus,
      );

      final branches = await GetBranchesByWorkshop(repository)('w-1');
      expect(branches, hasLength(1));
      expect(branches.first.name, 'Sede Surco');

      final profile = await GetMyProfileContext(repository)();
      expect(profile.userId, 'u-1');
      expect(profile.owner?.id, 'o-1');
      expect(profile.owner?.firstName, 'Carlos');

      await bus.dispose();
    });
  });
}
