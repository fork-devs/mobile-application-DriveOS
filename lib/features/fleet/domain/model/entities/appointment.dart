/// Represents a scheduled workshop appointment for a customer vehicle.
class Appointment {
  /// The unique appointment identifier.
  final String id;

  /// The workshop branch identifier.
  final String branchId;

  /// The customer identifier.
  final String customerId;

  /// The vehicle identifier.
  final String vehicleId;

  /// The scheduled start timestamp.
  final DateTime scheduledStart;

  /// The scheduled end timestamp.
  final DateTime scheduledEnd;

  /// The current appointment status (`SCHEDULED`, `CONFIRMED`, `COMPLETED`,
  /// `CANCELLED`, etc.).
  final String status;

  /// Optional appointment notes.
  final String? notes;

  /// Optional reason provided when the appointment was cancelled.
  final String? cancellationReason;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Last update timestamp.
  final DateTime? updatedAt;

  /// Creates an [Appointment].
  const Appointment({
    required this.id,
    required this.branchId,
    required this.customerId,
    required this.vehicleId,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.status,
    this.notes,
    this.cancellationReason,
    this.createdAt,
    this.updatedAt,
  });
}
