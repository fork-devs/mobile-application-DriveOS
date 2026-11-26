import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';

/// Use case that retrieves the authenticated user's account details.
class GetCurrentUser {
  final AuthRepository _repository;

  /// Creates a [GetCurrentUser] use case.
  const GetCurrentUser(this._repository);

  /// Returns the current [UserAccount].
  Future<UserAccount> call() => _repository.getCurrentUser();
}

/// Use case that updates the authenticated user's email address.
class UpdateUserEmail {
  final AuthRepository _repository;

  /// Creates an [UpdateUserEmail] use case.
  const UpdateUserEmail(this._repository);

  /// Updates [userId]'s email to [email] and refreshes session tokens.
  Future<UserSession> call({required String userId, required String email}) =>
      _repository.updateEmail(userId: userId, email: email.trim());
}

/// Use case that updates the authenticated user's password.
class UpdateUserPassword {
  final AuthRepository _repository;

  /// Creates an [UpdateUserPassword] use case.
  const UpdateUserPassword(this._repository);

  /// Updates [userId]'s password from [currentPassword] to [newPassword].
  Future<void> call({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) {
    return _repository.updatePassword(
      userId: userId,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}

/// Use case that uploads a new profile avatar for the authenticated user.
class UploadUserAvatar {
  final AuthRepository _repository;

  /// Creates an [UploadUserAvatar] use case.
  const UploadUserAvatar(this._repository);

  /// Uploads the image at [filePath] for [userId].
  Future<UserAccount> call({
    required String userId,
    required String filePath,
  }) {
    return _repository.uploadAvatar(userId: userId, filePath: filePath);
  }
}
