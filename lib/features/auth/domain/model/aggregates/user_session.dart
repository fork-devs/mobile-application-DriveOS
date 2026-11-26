import 'package:mobile_application_driveos/features/auth/domain/model/value_objects/user_role.dart';

/// Aggregate root representing an authenticated user session in DriveOS.
class UserSession {
  /// The JWT access token.
  final String accessToken;

  /// The single-use refresh token.
  final String refreshToken;

  /// The token scheme (typically `Bearer`).
  final String tokenType;

  /// Token lifetime in seconds.
  final int expiresIn;

  /// The authenticated user identifier.
  final String userId;

  /// The tenant identifier for this session.
  final String tenantId;

  /// The authenticated user's email address.
  final String email;

  /// The authenticated user's full name.
  final String fullName;

  /// The raw role codes returned by the IAM service.
  final List<String> roles;

  /// Creates a [UserSession].
  const UserSession({
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

  /// Returns the parsed [UserRole] values for this session.
  List<UserRole> get parsedRoles => roles.map(UserRole.fromCode).toList();

  /// Whether at least one assigned role is supported on DriveOS Mobile.
  bool get hasMobileAccess =>
      parsedRoles.any((role) => role.isMobileSupported);
}
