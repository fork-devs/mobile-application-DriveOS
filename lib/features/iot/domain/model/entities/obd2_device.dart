/// Represents an OBD2 hardware dongle registered to a workshop branch.
class Obd2Device {
  /// The unique device identifier.
  final String id;

  /// The branch identifier owning this device.
  final String branchId;

  /// The IEEE 802 MAC address of the dongle.
  final String macAddress;

  /// Current availability status (`AVAILABLE` or `LINKED`).
  final String status;

  /// Creates an [Obd2Device].
  const Obd2Device({
    required this.id,
    required this.branchId,
    required this.macAddress,
    required this.status,
  });
}

/// Represents an active or historical link between an [Obd2Device] and a
/// vehicle.
class Obd2DeviceRegistration {
  /// The registration identifier.
  final String id;

  /// The OBD2 device identifier.
  final String obd2DeviceId;

  /// The branch identifier.
  final String branchId;

  /// The linked vehicle identifier.
  final String vehicleId;

  /// Registration status (`ACTIVE` or `INACTIVE`).
  final String status;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates an [Obd2DeviceRegistration].
  const Obd2DeviceRegistration({
    required this.id,
    required this.obd2DeviceId,
    required this.branchId,
    required this.vehicleId,
    required this.status,
    this.createdAt,
  });
}
