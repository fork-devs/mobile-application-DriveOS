import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';

/// Use case that revokes the active session and clears local credentials.
class Logout {
  final AuthRepository _repository;

  /// Creates a [Logout] use case.
  const Logout(this._repository);

  /// Executes the sign-out flow.
  Future<void> call() => _repository.logout();
}
