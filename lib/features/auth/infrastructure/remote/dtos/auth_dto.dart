import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';

/// Wire DTO representing an `AuthResponse` from `erp-auth-service`.
class AuthResponseDto {
  /// The JWT access token.
  final String accessToken;

  /// The refresh token.
  final String refreshToken;

  /// The token scheme.
  final String tokenType;

  /// Token lifetime in seconds.
  final int expiresIn;

  /// The authenticated user identifier.
  final String userId;

  /// The tenant identifier.
  final String tenantId;

  /// The user's email address.
  final String email;

  /// The user's full name.
  final String fullName;

  /// The assigned role codes.
  final List<String> roles;

  /// Creates an [AuthResponseDto].
  const AuthResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.userId,
    required this.tenantId,
    required this.email,
    required this.fullName,
    required this.roles,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'accessToken': final String accessToken,
      'refreshToken': final String refreshToken,
      'userId': final String userId,
      'tenantId': final String tenantId,
      'email': final String email,
    }) {
      final rawRoles = json['roles'];
      final roles = rawRoles is List
          ? rawRoles.map((role) => role.toString()).toList()
          : const <String>[];

      return AuthResponseDto(
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenType: json['tokenType']?.toString() ?? 'Bearer',
        expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 3600,
        userId: userId,
        tenantId: tenantId,
        email: email,
        fullName: json['fullName']?.toString() ?? email,
        roles: roles,
      );
    }

    throw const FormatException('Invalid or incomplete AuthResponse JSON.');
  }

  /// Converts this DTO into a [UserSession] domain aggregate.
  UserSession toDomain() {
    return UserSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
      userId: userId,
      tenantId: tenantId,
      email: email,
      fullName: fullName,
      roles: roles,
    );
  }
}

/// Wire DTO representing a `UserResponse` from `erp-auth-service`.
class UserAccountDto {
  /// The user identifier.
  final String id;

  /// The tenant identifier.
  final String tenantId;

  /// The user's email address.
  final String email;

  /// The user's full name.
  final String fullName;

  /// Whether MFA is enabled.
  final bool mfaEnabled;

  /// The assigned role codes.
  final List<String> roles;

  /// The creation timestamp.
  final DateTime? createdAt;

  /// The optional avatar URL.
  final String? avatarUrl;

  /// Creates a [UserAccountDto].
  const UserAccountDto({
    required this.id,
    required this.tenantId,
    required this.email,
    required this.fullName,
    required this.mfaEnabled,
    required this.roles,
    this.createdAt,
    this.avatarUrl,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory UserAccountDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'tenantId': final String tenantId,
      'email': final String email,
    }) {
      final rawRoles = json['roles'];
      final roles = rawRoles is List
          ? rawRoles.map((role) => role.toString()).toList()
          : const <String>[];

      return UserAccountDto(
        id: id,
        tenantId: tenantId,
        email: email,
        fullName: json['fullName']?.toString() ?? email,
        mfaEnabled: json['mfaEnabled'] == true,
        roles: roles,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        avatarUrl: json['avatarUrl']?.toString(),
      );
    }

    throw const FormatException('Invalid or incomplete UserResponse JSON.');
  }

  /// Converts this DTO into a [UserAccount] domain entity.
  UserAccount toDomain() {
    return UserAccount(
      id: id,
      tenantId: tenantId,
      email: email,
      fullName: fullName,
      mfaEnabled: mfaEnabled,
      roles: roles,
      createdAt: createdAt,
      avatarUrl: avatarUrl,
    );
  }
}

/// Wire DTO representing invitation metadata from `erp-auth-service`.
class InvitationDetailsDto {
  /// The invitation identifier.
  final String id;

  /// The tenant identifier.
  final String tenantId;

  /// The invited user's email address.
  final String email;

  /// The invited user's full name.
  final String fullName;

  /// The assigned role code.
  final String role;

  /// Whether the invitation token is valid.
  final bool valid;

  /// The expiration timestamp.
  final DateTime expiresAt;

  /// Creates an [InvitationDetailsDto].
  const InvitationDetailsDto({
    required this.id,
    required this.tenantId,
    required this.email,
    required this.fullName,
    required this.role,
    required this.valid,
    required this.expiresAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory InvitationDetailsDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'tenantId': final String tenantId,
      'email': final String email,
      'role': final String role,
      'expiresAt': final String expiresAtRaw,
    }) {
      return InvitationDetailsDto(
        id: id,
        tenantId: tenantId,
        email: email,
        fullName: json['fullName']?.toString() ?? email,
        role: role,
        valid: json['valid'] == true,
        expiresAt: DateTime.tryParse(expiresAtRaw) ?? DateTime.now(),
      );
    }

    throw const FormatException('Invalid or incomplete Invitation JSON.');
  }

  /// Converts this DTO into an [InvitationDetails] domain entity.
  InvitationDetails toDomain() {
    return InvitationDetails(
      id: id,
      tenantId: tenantId,
      email: email,
      fullName: fullName,
      role: role,
      valid: valid,
      expiresAt: expiresAt,
    );
  }
}
