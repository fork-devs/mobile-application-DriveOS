import 'package:mobile_application_driveos/core/network/app_exception.dart';
import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';

/// Use case that authenticates a user with a Google OAuth ID token.
class LoginWithGoogle {
  final AuthRepository _repository;

  /// Creates a [LoginWithGoogle] use case.
  const LoginWithGoogle(this._repository);

  /// Signs in with [idToken] and optional [tenantId].
  ///
  /// Throws [AccessDeniedException] if the account lacks a mobile role.
  Future<UserSession> call({
    required String idToken,
    String? tenantId,
  }) async {
    final session = await _repository.loginWithGoogle(
      idToken: idToken,
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
