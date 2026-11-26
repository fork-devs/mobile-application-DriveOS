/// Represents an authenticated DriveOS user account.
class UserAccount {
  /// The unique user identifier.
  final String id;

  /// The tenant identifier that owns this user.
  final String tenantId;

  /// The user's primary email address.
  final String email;

  /// The user's display full name.
  final String fullName;

  /// Whether multi-factor authentication is enabled.
  final bool mfaEnabled;

  /// The canonical role codes assigned to this user.
  final List<String> roles;

  /// The account creation timestamp, if provided.
  final DateTime? createdAt;

  /// The optional profile avatar URL.
  final String? avatarUrl;

  /// Creates a [UserAccount].
  const UserAccount({
    required this.id,
    required this.tenantId,
    required this.email,
    required this.fullName,
    required this.mfaEnabled,
    required this.roles,
    this.createdAt,
    this.avatarUrl,
  });
}
