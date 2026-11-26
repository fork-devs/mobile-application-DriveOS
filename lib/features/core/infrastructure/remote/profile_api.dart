import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/remote/dtos/core_dto.dart';

/// HTTP client for `erp-tenant-service` owner, employee, and unified profiles.
class ProfileApi {
  final ApiClient _apiClient;

  /// Creates a [ProfileApi] backed by [_apiClient].
  const ProfileApi(this._apiClient);

  /// Fetches the authenticated user's profile context (`/profiles/me`).
  Future<UserProfileContextDto> getMyProfileContext() async {
    final response = await _apiClient.get(ApiConstants.profilesMe);
    return UserProfileContextDto.fromJson(response as Map<String, dynamic>);
  }

  /// Updates the authenticated user's profile image URL.
  Future<UserProfileContextDto> updateMyProfileImage(
    String profileImageUrl,
  ) async {
    final response = await _apiClient.put(
      ApiConstants.profilesMeImage,
      body: {'profileImageUrl': profileImageUrl},
    );
    return UserProfileContextDto.fromJson(response as Map<String, dynamic>);
  }

  /// Uploads a binary profile image for the authenticated user.
  Future<UserProfileContextDto> uploadMyProfileImage(String filePath) async {
    final response = await _apiClient.multipartPost(
      ApiConstants.profilesMeImageUpload,
      filePath: filePath,
    );
    return UserProfileContextDto.fromJson(response as Map<String, dynamic>);
  }

  /// Looks up a unified profile by [documentNumber].
  Future<UnifiedProfileLookupDto> lookupProfileByDocument(
    String documentNumber,
  ) async {
    final response = await _apiClient.get(
      ApiConstants.profiles,
      queryParameters: {'documentNumber': documentNumber},
    );
    return UnifiedProfileLookupDto.fromJson(response as Map<String, dynamic>);
  }

  /// Creates an owner profile.
  Future<OwnerProfileDto> createOwnerProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.owners,
      body: {
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'documentType': documentType,
        'documentNumber': documentNumber,
        'phone': phone,
      },
    );
    return OwnerProfileDto.fromJson(response as Map<String, dynamic>);
  }

  /// Updates an owner profile.
  Future<OwnerProfileDto> updateOwnerProfile({
    required String ownerId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.ownerById(ownerId),
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'documentType': documentType,
        'documentNumber': documentNumber,
        'phone': phone,
      },
    );
    return OwnerProfileDto.fromJson(response as Map<String, dynamic>);
  }

  /// Creates an employee profile.
  Future<EmployeeProfileDto> createEmployeeProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.employees,
      body: {
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'documentType': documentType,
        'documentNumber': documentNumber,
        'phone': phone,
      },
    );
    return EmployeeProfileDto.fromJson(response as Map<String, dynamic>);
  }

  /// Updates an employee profile.
  Future<EmployeeProfileDto> updateEmployeeProfile({
    required String employeeId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.employeeById(employeeId),
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'documentType': documentType,
        'documentNumber': documentNumber,
        'phone': phone,
      },
    );
    return EmployeeProfileDto.fromJson(response as Map<String, dynamic>);
  }
}
