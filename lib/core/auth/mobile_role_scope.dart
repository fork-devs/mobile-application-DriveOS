import 'package:mobile_application_driveos/core/storage/session_storage.dart';

/// Represents the three user roles supported by DriveOS Mobile.
enum MobileRoleScope {
  /// Workshop administrator (`WORKSHOP_ADMIN`).
  workshopAdmin,

  /// Workshop technician / mechanic (`TECHNICIAN`).
  technician,

  /// End customer (`CUSTOMER`).
  customer,
}

/// Resolves the active [MobileRoleScope] and initial route from session roles.
class RoleRouter {
  RoleRouter._();

  /// Returns the highest-privilege supported [MobileRoleScope] for [roles],
  /// or `null` if none of the roles are permitted on mobile.
  static MobileRoleScope? resolveScopeOrNull(List<String> roles) {
    final normalized = roles
        .map((role) => role.trim().toUpperCase().replaceFirst('ROLE_', ''))
        .toSet();

    if (normalized.contains('WORKSHOP_ADMIN')) {
      return MobileRoleScope.workshopAdmin;
    }

    if (normalized.contains('TECHNICIAN')) {
      return MobileRoleScope.technician;
    }

    if (normalized.contains('CUSTOMER')) {
      return MobileRoleScope.customer;
    }

    return null;
  }

  /// Returns whether [roles] grants access to DriveOS Mobile.
  static bool isSupportedForMobile(List<String> roles) =>
      resolveScopeOrNull(roles) != null;

  /// Returns the initial route path for the current [sessionStorage] state.
  static String resolveInitialRoute(
    SessionStorage sessionStorage, {
    bool preferActiveBranch = false,
  }) {
    if (!sessionStorage.isAuthenticated) {
      return '/login';
    }

    final scope = resolveScopeOrNull(sessionStorage.roles);
    if (scope == null) {
      return '/login';
    }

    return switch (scope) {
      MobileRoleScope.customer => '/customer',
      MobileRoleScope.technician || MobileRoleScope.workshopAdmin =>
        (preferActiveBranch && sessionStorage.hasActiveBranch)
            ? '/main'
            : '/branches',
    };
  }
}
