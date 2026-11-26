import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';

/// Use case that sends a 6-digit OTP verification code to an email address.
class SendOtp {
  final AuthRepository _repository;

  /// Creates a [SendOtp] use case.
  const SendOtp(this._repository);

  /// Sends an OTP code to [email].
  Future<void> call({required String email}) =>
      _repository.sendOtp(email: email.trim());
}

/// Use case that verifies a 6-digit OTP code for an email address.
class VerifyOtp {
  final AuthRepository _repository;

  /// Creates a [VerifyOtp] use case.
  const VerifyOtp(this._repository);

  /// Verifies [code] for [email].
  Future<void> call({required String email, required String code}) =>
      _repository.verifyOtp(email: email.trim(), code: code.trim());
}
