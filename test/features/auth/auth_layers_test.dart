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
import 'package:mobile_application_driveos/features/auth/application/auth_application.dart';
import 'package:mobile_application_driveos/features/auth/infrastructure/remote/auth_api.dart';
import 'package:mobile_application_driveos/features/auth/infrastructure/remote/user_api.dart';
import 'package:mobile_application_driveos/features/auth/infrastructure/repositories/auth_repository_impl.dart';

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
  group('Auth Layers', () {
    test('LoginWithPassword persists session and emits UserLoggedInEvent',
        () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final bus = StreamDomainEventBus();
      final loggedInEvents = <UserLoggedInEvent>[];
      final sub = bus.on<UserLoggedInEvent>().listen(loggedInEvents.add);

      final mockClient = MockClient((request) async {
        expect(request.url.path, ApiConstants.authLogin);
        return http.Response(
          jsonEncode({
            'accessToken': 'acc-123',
            'refreshToken': 'ref-123',
            'tokenType': 'Bearer',
            'expiresIn': 3600,
            'userId': 'u-1',
            'tenantId': 't-1',
            'email': 'admin@driveos.pe',
            'fullName': 'Workshop Admin',
            'roles': ['WORKSHOP_ADMIN'],
          }),
          200,
        );
      });

      final apiClient = ApiClient(
        sessionStorage: storage,
        eventBus: bus,
        client: mockClient,
      );
      final repository = AuthRepositoryImpl(
        authApi: AuthApi(apiClient),
        userApi: UserApi(apiClient),
        sessionStorage: storage,
        eventBus: bus,
      );
      final login = LoginWithPassword(repository);

      final session = await login(
        email: 'admin@driveos.pe',
        password: 'Password123!',
        tenantId: 't-1',
      );

      await Future<void>.delayed(Duration.zero);

      expect(session.userId, 'u-1');
      expect(storage.isAuthenticated, isTrue);
      expect(storage.tenantId, 't-1');
      expect(loggedInEvents, hasLength(1));
      expect(loggedInEvents.first.roles, ['WORKSHOP_ADMIN']);

      await sub.cancel();
      await repository.dispose();
      await bus.dispose();
    });

    test('LoginWithPassword rejects unsupported mobile roles and logs out',
        () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      final bus = StreamDomainEventBus();

      final mockClient = MockClient((request) async {
        if (request.url.path == ApiConstants.authLogin) {
          return http.Response(
            jsonEncode({
              'accessToken': 'acc-999',
              'refreshToken': 'ref-999',
              'userId': 'u-2',
              'tenantId': 't-1',
              'email': 'advisor@driveos.pe',
              'fullName': 'Service Advisor',
              'roles': ['SERVICE_ADVISOR'],
            }),
            200,
          );
        }
        return http.Response(jsonEncode({'success': true}), 200);
      });

      final apiClient = ApiClient(
        sessionStorage: storage,
        eventBus: bus,
        client: mockClient,
      );
      final repository = AuthRepositoryImpl(
        authApi: AuthApi(apiClient),
        userApi: UserApi(apiClient),
        sessionStorage: storage,
        eventBus: bus,
      );
      final login = LoginWithPassword(repository);

      await expectLater(
        () => login(
          email: 'advisor@driveos.pe',
          password: 'Password123!',
        ),
        throwsA(isA<AccessDeniedException>()),
      );

      expect(storage.isAuthenticated, isFalse);

      await repository.dispose();
      await bus.dispose();
    });
  });
}
