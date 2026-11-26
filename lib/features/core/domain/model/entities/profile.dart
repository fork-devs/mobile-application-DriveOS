/// Represents a workshop owner profile.
class OwnerProfile {
  /// The unique owner profile identifier.
  final String id;

  /// The associated IAM user identifier, if available.
  final String? userId;

  /// The owner's first name.
  final String firstName;

  /// The owner's last name.
  final String lastName;

  /// The identity document type (e.g. `DNI`, `CE`, `RUC`).
  final String documentType;

  /// The identity document number.
  final String documentNumber;

  /// The owner's contact phone number.
  final String phone;

  /// The optional profile image URL.
  final String? profileImageUrl;

  /// Creates an [OwnerProfile].
  const OwnerProfile({
    required this.id,
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.documentType,
    required this.documentNumber,
    required this.phone,
    this.profileImageUrl,
  });
}

/// Represents a workshop employee profile.
class EmployeeProfile {
  /// The unique employee profile identifier.
  final String id;

  /// The associated IAM user identifier, if available.
  final String? userId;

  /// The employee's first name.
  final String firstName;

  /// The employee's last name.
  final String lastName;

  /// The identity document type.
  final String documentType;

  /// The identity document number.
  final String documentNumber;

  /// The employee's contact phone number.
  final String phone;

  /// The optional profile image URL.
  final String? profileImageUrl;

  /// Creates an [EmployeeProfile].
  const EmployeeProfile({
    required this.id,
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.documentType,
    required this.documentNumber,
    required this.phone,
    this.profileImageUrl,
  });
}

/// Represents the authenticated user's unified profile context (`/me`).
class UserProfileContext {
  /// The authenticated user identifier.
  final String userId;

  /// The assigned role codes.
  final List<String> roles;

  /// The owner profile, if the user holds one.
  final OwnerProfile? owner;

  /// The employee profile, if the user holds one.
  final EmployeeProfile? employee;

  /// The raw customer profile payload, if the user holds one.
  final Map<String, dynamic>? customer;

  /// Creates a [UserProfileContext].
  const UserProfileContext({
    required this.userId,
    required this.roles,
    this.owner,
    this.employee,
    this.customer,
  });
}

/// Represents a unified profile lookup result by document number.
class UnifiedProfileLookup {
  /// The resolved profile type (`OWNER` or `EMPLOYEE`).
  final String profileType;

  /// The associated IAM user identifier.
  final String userId;

  /// The person's first name.
  final String firstName;

  /// The person's last name.
  final String lastName;

  /// The identity document type.
  final String documentType;

  /// The identity document number.
  final String documentNumber;

  /// The contact phone number.
  final String phone;

  /// The employee profile identifier, if applicable.
  final String? employeeId;

  /// The owner profile identifier, if applicable.
  final String? ownerId;

  /// The roles assigned to this user.
  final List<String> roles;

  /// Creates a [UnifiedProfileLookup].
  const UnifiedProfileLookup({
    required this.profileType,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.documentType,
    required this.documentNumber,
    required this.phone,
    this.employeeId,
    this.ownerId,
    required this.roles,
  });
}
