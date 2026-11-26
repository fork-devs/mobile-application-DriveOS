import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/auth/infrastructure/remote/dtos/auth_dto.dart';

/// HTTP client for `erp-auth-service` authentication, OTP, and invitations.
class AuthApi {
  final ApiClient _apiClient;

  /// Creates an [AuthApi] backed by [_apiClient].
  const AuthApi(this._apiClient);

  /// Authenticates with [email], [password], and optional [tenantId].
  Future<AuthResponseDto> loginWithPassword({
    required String email,
    required String password,
    String? tenantId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.authLogin,
      body: {
        'email': email,
        'password': password,
        'tenantId': ?tenantId,
      },
    );
    return AuthResponseDto.fromJson(response as Map<String, dynamic>);
  }

  /// Authenticates with a Google OAuth [idToken] and optional [tenantId].
  Future<AuthResponseDto> loginWithGoogle({
    required String idToken,
    String? tenantId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.authGoogle,
      body: {
        'idToken': idToken,
        'tenantId': ?tenantId,
      },
    );
    return AuthResponseDto.fromJson(response as Map<String, dynamic>);
  }

  /// Refreshes the session using [refreshToken] and [tenantId].
  Future<AuthResponseDto> refreshSession({
    required String refreshToken,
    required String tenantId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.authRefresh,
      body: {
        'refreshToken': refreshToken,
        'tenantId': tenantId,
      },
    );
    return AuthResponseDto.fromJson(response as Map<String, dynamic>);
  }

  /// Revokes the active session on the server.
  Future<void> logout({
    required String refreshToken,
    required String tenantId,
  }) async {
    await _apiClient.post(
      ApiConstants.authLogout,
      body: {
        'refreshToken': refreshToken,
        'tenantId': tenantId,
      },
    );
  }

  /// Sends a 6-digit OTP verification code to [email].
  Future<void> sendOtp({required String email}) async {
    await _apiClient.post(
      ApiConstants.authOtpSend,
      body: {'email': email},
    );
  }

  /// Verifies the 6-digit OTP [code] for [email].
  Future<void> verifyOtp({
    required String email,
    required String code,
  }) async {
    await _apiClient.post(
      ApiConstants.authOtpVerify,
      body: {
        'email': email,
        'code': code,
      },
    );
  }

  /// Registers a verified owner or customer account.
  Future<AuthResponseDto> registerAccount({
    required String email,
    required String password,
    required String fullName,
    required String documentNumber,
    required String accountType,
    String? tenantId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.authRegistrations,
      body: {
        'email': email,
        'password': password,
        'fullName': fullName,
        'documentNumber': documentNumber,
        'accountType': accountType,
        'tenantId': tenantId,
      },
    );
    return AuthResponseDto.fromJson(response as Map<String, dynamic>);
  }

  /// Requests a password recovery email for [email] within [tenantId].
  Future<void> forgotPassword({
    required String email,
    required String tenantId,
  }) async {
    await _apiClient.post(
      ApiConstants.authForgotPassword,
      body: {
        'email': email,
        'tenantId': tenantId,
      },
    );
  }

  /// Resets the user's password using [token] and [newPassword].
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String tenantId,
  }) async {
    await _apiClient.post(
      ApiConstants.authResetPassword,
      body: {
        'token': token,
        'newPassword': newPassword,
        'tenantId': tenantId,
      },
    );
  }

  /// Retrieves invitation metadata for [token].
  Future<InvitationDetailsDto> getInvitationDetails(String token) async {
    final response = await _apiClient.get(
      ApiConstants.authInvitationByToken(token),
    );
    return InvitationDetailsDto.fromJson(response as Map<String, dynamic>);
  }

  /// Accepts an invitation [token] with [password].
  Future<AuthResponseDto> acceptInvitation({
    required String token,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.authInvitationsAccept,
      body: {
        'token': token,
        'password': password,
      },
    );
    return AuthResponseDto.fromJson(response as Map<String, dynamic>);
  }
}
