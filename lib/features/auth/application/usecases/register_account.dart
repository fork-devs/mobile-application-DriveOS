import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';

/// Use case that registers a new verified owner or customer account.
class RegisterAccount {
  final AuthRepository _repository;

  /// Creates a [RegisterAccount] use case.
  const RegisterAccount(this._repository);

  /// Registers a new account (`OWNER` or `CUSTOMER`) and returns a session.
  Future<UserSession> call({
    required String email,
    required String password,
    required String fullName,
    required String documentNumber,
    required String accountType,
    String? tenantId,
  }) {
    return _repository.registerAccount(
      email: email.trim(),
      password: password,
      fullName: fullName.trim(),
      documentNumber: documentNumber.trim(),
      accountType: accountType.trim().toUpperCase(),
      tenantId: tenantId?.trim().isEmpty == true ? null : tenantId?.trim(),
    );
  }
}
