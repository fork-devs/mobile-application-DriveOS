import 'package:mobile_application_driveos/core/network/app_exception.dart';
import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';

/// Use case that inspects an onboarding invitation token.
class GetInvitationDetails {
  final AuthRepository _repository;

  /// Creates a [GetInvitationDetails] use case.
  const GetInvitationDetails(this._repository);

  /// Fetches invitation metadata for [token].
  Future<InvitationDetails> call(String token) =>
      _repository.getInvitationDetails(token.trim());
}

/// Use case that accepts an invitation and activates the user account.
class AcceptInvitation {
  final AuthRepository _repository;

  /// Creates an [AcceptInvitation] use case.
  const AcceptInvitation(this._repository);

  /// Accepts [token] with [password] and returns the active [UserSession].
  ///
  /// Throws [AccessDeniedException] if the invited role is not mobile-enabled.
  Future<UserSession> call({
    required String token,
    required String password,
  }) async {
    final session = await _repository.acceptInvitation(
      token: token.trim(),
      password: password,
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
