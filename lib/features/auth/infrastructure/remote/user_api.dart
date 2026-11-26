import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/auth/infrastructure/remote/dtos/auth_dto.dart';

/// HTTP client for `erp-auth-service` authenticated user endpoints.
class UserApi {
  final ApiClient _apiClient;

  /// Creates a [UserApi] backed by [_apiClient].
  const UserApi(this._apiClient);

  /// Fetches the authenticated user's profile.
  Future<UserAccountDto> getCurrentUser() async {
    final response = await _apiClient.get(ApiConstants.usersMe);
    return UserAccountDto.fromJson(response as Map<String, dynamic>);
  }

  /// Updates the user's email address and returns refreshed tokens.
  Future<AuthResponseDto> updateEmail({
    required String userId,
    required String email,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.userEmail(userId),
      body: {'email': email},
    );
    return AuthResponseDto.fromJson(response as Map<String, dynamic>);
  }

  /// Updates the user's password.
  Future<void> updatePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.put(
      ApiConstants.userPassword(userId),
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  /// Uploads a new profile avatar for [userId] from [filePath].
  Future<UserAccountDto> uploadAvatar({
    required String userId,
    required String filePath,
  }) async {
    final response = await _apiClient.multipartPost(
      ApiConstants.userAvatar(userId),
      filePath: filePath,
    );
    return UserAccountDto.fromJson(response as Map<String, dynamic>);
  }
}
