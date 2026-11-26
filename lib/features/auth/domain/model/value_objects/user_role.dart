/// Represents the user roles recognized by the IAM domain.
enum UserRole {
  /// Workshop administrator (`WORKSHOP_ADMIN`).
  workshopAdmin('WORKSHOP_ADMIN'),

  /// Workshop technician (`TECHNICIAN`).
  technician('TECHNICIAN'),

  /// End customer (`CUSTOMER`).
  customer('CUSTOMER'),

  /// Any role outside the mobile-supported set.
  unknown('UNKNOWN');

  /// The canonical wire code of this role.
  final String code;

  const UserRole(this.code);

  /// Parses a wire [rawRole] string into a [UserRole].
  static UserRole fromCode(String rawRole) {
    final normalized = rawRole
        .trim()
        .toUpperCase()
        .replaceFirst('ROLE_', '');
    return switch (normalized) {
      'WORKSHOP_ADMIN' => UserRole.workshopAdmin,
      'TECHNICIAN' => UserRole.technician,
      'CUSTOMER' => UserRole.customer,
      _ => UserRole.unknown,
    };
  }

  /// Whether this role is permitted to access DriveOS Mobile.
  bool get isMobileSupported => this != UserRole.unknown;
}
