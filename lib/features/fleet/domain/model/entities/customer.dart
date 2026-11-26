/// Represents a workshop customer registered within a tenant.
class Customer {
  /// The unique customer identifier.
  final String id;

  /// The owning tenant identifier.
  final String tenantId;

  /// The customer's full name.
  final String fullName;

  /// The customer's email address.
  final String email;

  /// The customer's contact phone number.
  final String phone;

  /// The identity document type (e.g. `DNI`, `RUC`).
  final String docType;

  /// The identity document number.
  final String docNumber;

  /// The identity validation status (`PENDING`, `VALIDATED`, etc.).
  final String validationStatus;

  /// The customer account status (`ACTIVE`, `INACTIVE`).
  final String status;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [Customer].
  const Customer({
    required this.id,
    required this.tenantId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.docType,
    required this.docNumber,
    required this.validationStatus,
    required this.status,
    this.createdAt,
  });
}
