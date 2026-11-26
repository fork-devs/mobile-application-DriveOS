import 'package:mobile_application_driveos/core/network/app_exception.dart';
import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';

/// Use case that authenticates a user with email and password.
class LoginWithPassword {
  final AuthRepository _repository;

  /// Creates a [LoginWithPassword] use case.
  const LoginWithPassword(this._repository);

  /// Signs in using [email], [password], and optional [tenantId].
  ///
  /// Throws [AccessDeniedException] if the authenticated account does not hold
  /// a mobile-supported role (`WORKSHOP_ADMIN`, `TECHNICIAN`, or `CUSTOMER`).
  Future<UserSession> call({
    required String email,
    required String password,
    String? tenantId,
  }) async {
    final session = await _repository.loginWithPassword(
      email: email.trim(),
      password: password,
      tenantId: tenantId?.trim().isEmpty == true ? null : tenantId?.trim(),
    );

    if (!session.hasMobileAccess) {
      await _repository.logout();
      throw AccessDeniedException(
        message: 'Your role is not enabled for DriveOS Mobile.',
      );
    }

    return session;
  }
}
