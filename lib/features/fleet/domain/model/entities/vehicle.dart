/// Represents a vehicle belonging to a [Customer].
class Vehicle {
  /// The unique vehicle identifier.
  final String id;

  /// The owning tenant identifier.
  final String tenantId;

  /// The owner customer identifier.
  final String customerId;

  /// The vehicle license plate number.
  final String plate;

  /// The vehicle manufacturer brand.
  final String brand;

  /// The vehicle model name.
  final String model;

  /// The manufacturing year.
  final int year;

  /// The Vehicle Identification Number (VIN).
  final String vin;

  /// The plate/VIN validation status (`PENDING`, `VALIDATED`, etc.).
  final String validationStatus;

  /// The vehicle status (`ACTIVE`, `INACTIVE`).
  final String status;

  /// Optional vehicle photo URL.
  final String? imageUrl;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [Vehicle].
  const Vehicle({
    required this.id,
    required this.tenantId,
    required this.customerId,
    required this.plate,
    required this.brand,
    required this.model,
    required this.year,
    required this.vin,
    required this.validationStatus,
    required this.status,
    this.imageUrl,
    this.createdAt,
  });
}
