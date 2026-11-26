/// Represents a customer affiliation to a workshop branch.
class CustomerRegistration {
  /// The unique registration identifier.
  final String id;

  /// The branch identifier.
  final String branchId;

  /// The customer identifier.
  final String customerId;

  /// The affiliation status (`ACTIVE`, `INACTIVE`).
  final String status;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [CustomerRegistration].
  const CustomerRegistration({
    required this.id,
    required this.branchId,
    required this.customerId,
    required this.status,
    this.createdAt,
  });
}

/// Represents an employee onboarding or affiliation to a workshop branch.
class EmployeeRegistration {
  /// The unique registration identifier.
  final String id;

  /// The employee profile identifier.
  final String employeeId;

  /// The branch identifier.
  final String branchId;

  /// The specialty code (e.g. `ENGINE_DIAGNOSTICS`).
  final String speciality;

  /// The human-readable specialty name.
  final String specialityName;

  /// The assigned monthly salary.
  final double salary;

  /// The assigned role code (e.g. `TECHNICIAN`).
  final String role;

  /// The registration status (`PENDING`, `APPROVED`, `REJECTED`).
  final String status;

  /// Optional reason provided if rejected.
  final String? rejectionReason;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Approval timestamp, if approved.
  final DateTime? approvedAt;

  /// Creates an [EmployeeRegistration].
  const EmployeeRegistration({
    required this.id,
    required this.employeeId,
    required this.branchId,
    required this.speciality,
    required this.specialityName,
    required this.salary,
    required this.role,
    required this.status,
    this.rejectionReason,
    this.createdAt,
    this.approvedAt,
  });
}

/// Represents a historical career change for an employee in a branch.
class StaffCareerHistoryEntry {
  /// The history entry identifier.
  final String id;

  /// The employee profile identifier.
  final String employeeId;

  /// The branch identifier.
  final String branchId;

  /// The specialty code at the time of the change.
  final String speciality;

  /// The specialty display name at the time of the change.
  final String specialityName;

  /// The salary at the time of the change.
  final double salary;

  /// The role code at the time of the change.
  final String role;

  /// The registration status at the time of the change.
  final String status;

  /// The timestamp when this change was recorded.
  final DateTime changedAt;

  /// Optional reason describing the career change.
  final String? changeReason;

  /// Creates a [StaffCareerHistoryEntry].
  const StaffCareerHistoryEntry({
    required this.id,
    required this.employeeId,
    required this.branchId,
    required this.speciality,
    required this.specialityName,
    required this.salary,
    required this.role,
    required this.status,
    required this.changedAt,
    this.changeReason,
  });
}
