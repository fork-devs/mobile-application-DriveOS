import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_application_driveos/core/auth/mobile_role_scope.dart';
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
  group('RoleRouter', () {
    test('resolves supported mobile roles', () {
      expect(
        RoleRouter.resolveScopeOrNull(['WORKSHOP_ADMIN']),
        MobileRoleScope.workshopAdmin,
      );
      expect(
        RoleRouter.resolveScopeOrNull(['TECHNICIAN']),
        MobileRoleScope.technician,
      );
      expect(
        RoleRouter.resolveScopeOrNull(['CUSTOMER']),
        MobileRoleScope.customer,
      );
    });

    test('returns null for roles not supported on mobile', () {
      expect(RoleRouter.resolveScopeOrNull(['SUPERADMIN']), isNull);
      expect(RoleRouter.resolveScopeOrNull(['BRANCH_MANAGER']), isNull);
      expect(RoleRouter.resolveScopeOrNull(['SECRETARY']), isNull);
      expect(RoleRouter.resolveScopeOrNull(['SERVICE_ADVISOR']), isNull);
      expect(RoleRouter.isSupportedForMobile(['SERVICE_ADVISOR']), isFalse);
    });

    test('resolves initial route based on session state and branch', () async {
      final storage = SessionStorage(store: _InMemoryKeyValueStore());
      expect(RoleRouter.resolveInitialRoute(storage), '/login');

      await storage.saveSession(
        accessToken: 'acc-1',
        refreshToken: 'ref-1',
        userId: 'u-1',
        tenantId: 't-1',
        email: 'tech@driveos.pe',
        fullName: 'Tech User',
        roles: ['TECHNICIAN'],
      );
      expect(
        RoleRouter.resolveInitialRoute(storage, preferActiveBranch: true),
        '/branches',
      );

      await storage.saveActiveBranch(
        branchId: 'b-1',
        branchName: 'Surquillo',
      );
      expect(
        RoleRouter.resolveInitialRoute(storage, preferActiveBranch: true),
        '/main',
      );

      await storage.saveSession(
        accessToken: 'acc-2',
        refreshToken: 'ref-2',
        userId: 'u-2',
        tenantId: 't-1',
        email: 'customer@driveos.pe',
        fullName: 'Customer User',
        roles: ['CUSTOMER'],
      );
      expect(
        RoleRouter.resolveInitialRoute(storage, preferActiveBranch: true),
        '/customer',
      );
    });
  });
}
