import 'package:mobile_application_driveos/features/auth/domain/model/aggregates/user_session.dart';
import 'package:mobile_application_driveos/features/auth/domain/model/entities/invitation_details.dart';
import 'package:mobile_application_driveos/features/auth/domain/model/entities/user_account.dart';

/// Output port defining authentication and user account operations.
abstract interface class AuthRepository {
  /// Authenticates a user with [email], [password], and optional [tenantId].
  Future<UserSession> loginWithPassword({
    required String email,
    required String password,
    String? tenantId,
  });

  /// Authenticates a user using a Google OAuth [idToken] and optional [tenantId].
  Future<UserSession> loginWithGoogle({
    required String idToken,
    String? tenantId,
  });

  /// Refreshes the active session using [refreshToken] and [tenantId].
  Future<UserSession> refreshSession({
    required String refreshToken,
    required String tenantId,
  });

  /// Revokes the active session on the server and clears local state.
  Future<void> logout();

  /// Sends a 6-digit verification OTP code to [email].
  Future<void> sendOtp({required String email});

  /// Verifies the 6-digit OTP [code] sent to [email].
  Future<void> verifyOtp({
    required String email,
    required String code,
  });

  /// Registers a new account (`OWNER` or `CUSTOMER`) after OTP and DNI checks.
  Future<UserSession> registerAccount({
    required String email,
    required String password,
    required String fullName,
    required String documentNumber,
    required String accountType,
    String? tenantId,
  });

  /// Requests a password recovery email for [email] within [tenantId].
  Future<void> forgotPassword({
    required String email,
    required String tenantId,
  });

  /// Resets a password using recovery [token], [newPassword], and [tenantId].
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String tenantId,
  });

  /// Validates and returns details for an invitation [token].
  Future<InvitationDetails> getInvitationDetails(String token);

  /// Accepts an invitation [token] by setting [password].
  Future<UserSession> acceptInvitation({
    required String token,
    required String password,
  });

  /// Returns the currently authenticated user's profile.
  Future<UserAccount> getCurrentUser();

  /// Updates the user's [email] and returns the refreshed [UserSession].
  Future<UserSession> updateEmail({
    required String userId,
    required String email,
  });

  /// Updates the user's password after verifying [currentPassword].
  Future<void> updatePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });

  /// Uploads a new profile avatar from [filePath] for [userId].
  Future<UserAccount> uploadAvatar({
    required String userId,
    required String filePath,
  });
}
