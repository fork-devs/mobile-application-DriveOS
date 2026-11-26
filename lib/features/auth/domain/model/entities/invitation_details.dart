/// Represents an invitation issued to onboard a workshop user.
class InvitationDetails {
  /// The invitation identifier.
  final String id;

  /// The target tenant identifier.
  final String tenantId;

  /// The invited user's email address.
  final String email;

  /// The invited user's full name.
  final String fullName;

  /// The role code that will be assigned upon acceptance.
  final String role;

  /// Whether the invitation token is still valid.
  final bool valid;

  /// The expiration timestamp of the invitation.
  final DateTime expiresAt;

  /// Creates an [InvitationDetails].
  const InvitationDetails({
    required this.id,
    required this.tenantId,
    required this.email,
    required this.fullName,
    required this.role,
    required this.valid,
    required this.expiresAt,
  });
}
