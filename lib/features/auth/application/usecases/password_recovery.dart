import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';

/// Use case that initiates password recovery for a user account.
class ForgotPassword {
  final AuthRepository _repository;

  /// Creates a [ForgotPassword] use case.
  const ForgotPassword(this._repository);

  /// Requests a password recovery email for [email] within [tenantId].
  Future<void> call({required String email, required String tenantId}) =>
      _repository.forgotPassword(
        email: email.trim(),
        tenantId: tenantId.trim(),
      );
}

/// Use case that confirms a password reset using a recovery token.
class ResetPassword {
  final AuthRepository _repository;

  /// Creates a [ResetPassword] use case.
  const ResetPassword(this._repository);

  /// Applies [newPassword] using [token] within [tenantId].
  Future<void> call({
    required String token,
    required String newPassword,
    required String tenantId,
  }) {
    return _repository.resetPassword(
      token: token.trim(),
      newPassword: newPassword,
      tenantId: tenantId.trim(),
    );
  }
}
