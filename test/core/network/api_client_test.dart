import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event.dart';
import 'package:mobile_application_driveos/core/infrastructure/event/stream_domain_event_bus.dart';
import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/core/network/app_exception.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';

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
  group('ApiClient', () {
    test('refreshes token once on 401 and retries original request', () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      await storage.saveSession(
        accessToken: 'expired-token',
        refreshToken: 'valid-refresh',
        userId: 'u-1',
        tenantId: 't-1',
        email: 'admin@driveos.pe',
        fullName: 'Admin',
        roles: ['WORKSHOP_ADMIN'],
      );

      var refreshCalls = 0;
      final mockClient = MockClient((request) async {
        if (request.url.path == ApiConstants.authRefresh) {
          refreshCalls++;
          final payload = jsonDecode(request.body) as Map<String, dynamic>;
          expect(payload['refreshToken'], 'valid-refresh');
          expect(payload['tenantId'], 't-1');
          return http.Response(
            jsonEncode({
              'accessToken': 'fresh-token',
              'refreshToken': 'fresh-refresh',
            }),
            200,
          );
        }

        if (request.headers['authorization'] == 'Bearer expired-token') {
          return http.Response(
            jsonEncode({'message': 'Token expired'}),
            401,
          );
        }

        expect(request.headers['authorization'], 'Bearer fresh-token');
        return http.Response(jsonEncode({'ok': true}), 200);
      });

      final apiClient = ApiClient(
        sessionStorage: storage,
        client: mockClient,
      );

      final result = await apiClient.get(ApiConstants.branches);
      expect(result, {'ok': true});
      expect(refreshCalls, 1);
      expect(await storage.getAccessToken(), 'fresh-token');
      expect(await storage.getRefreshToken(), 'fresh-refresh');
    });

    test('emits SessionExpiredEvent and clears session when refresh fails',
        () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      await storage.saveSession(
        accessToken: 'expired-token',
        refreshToken: 'revoked-refresh',
        userId: 'u-1',
        tenantId: 't-1',
        email: 'admin@driveos.pe',
        fullName: 'Admin',
        roles: ['WORKSHOP_ADMIN'],
      );

      final bus = StreamDomainEventBus();
      final expiredEvents = <SessionExpiredEvent>[];
      final sub = bus.on<SessionExpiredEvent>().listen(expiredEvents.add);

      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'message': 'Unauthorized'}), 401);
      });

      final apiClient = ApiClient(
        sessionStorage: storage,
        eventBus: bus,
        client: mockClient,
      );

      await expectLater(
        () => apiClient.get(ApiConstants.branches),
        throwsA(isA<AuthenticationException>()),
      );

      await Future<void>.delayed(Duration.zero);
      expect(expiredEvents, hasLength(1));
      expect(storage.isAuthenticated, isFalse);

      await sub.cancel();
      await bus.dispose();
    });
  });
}
