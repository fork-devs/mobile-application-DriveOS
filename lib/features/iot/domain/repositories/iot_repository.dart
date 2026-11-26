import 'package:mobile_application_driveos/features/iot/domain/model/entities/obd2_device.dart';
import 'package:mobile_application_driveos/features/iot/domain/model/entities/telemetry_and_diagnostics.dart';

/// Output port defining OBD2 devices, registrations, telemetry queries,
/// diagnostics, and simulator controls.
abstract interface class IotRepository {
  // OBD2 Devices
  /// Registers a new OBD2 dongle for [branchId] with [macAddress].
  Future<Obd2Device> createDevice({
    required String branchId,
    required String macAddress,
  });

  /// Lists OBD2 devices filtered optionally by [branchId] and [status].
  Future<List<Obd2Device>> getDevices({String? branchId, String? status});

  /// Fetches an OBD2 device by [deviceId].
  Future<Obd2Device> getDeviceById(String deviceId);

  /// Updates the [macAddress] of [deviceId].
  Future<Obd2Device> updateDevice({
    required String deviceId,
    required String macAddress,
  });

  /// Deletes an OBD2 device by [deviceId].
  Future<void> deleteDevice(String deviceId);

  // OBD2 Device Registrations
  /// Links [obd2DeviceId] to [vehicleId] at [branchId].
  Future<Obd2DeviceRegistration> createRegistration({
    required String obd2DeviceId,
    required String branchId,
    required String vehicleId,
  });

  /// Lists OBD2 device registrations filtered optionally.
  Future<List<Obd2DeviceRegistration>> getRegistrations({
    String? branchId,
    String? status,
  });

  /// Updates the [status] (`ACTIVE` or `INACTIVE`) of [registrationId].
  Future<Obd2DeviceRegistration> updateRegistrationStatus({
    required String registrationId,
    required String status,
  });

  // Diagnostics & Telemetry Queries
  /// Fetches real-time health diagnostics for [vehicleId].
  Future<VehicleDiagnostics> getVehicleDiagnostics(String vehicleId);

  /// Lists paginated telemetry snapshots for [vehicleId].
  Future<List<TelemetrySnapshot>> getVehicleTelemetrySnapshots({
    required String vehicleId,
    int page = 0,
    int size = 20,
  });

  /// Lists paginated DTC alerts for [vehicleId].
  Future<List<DtcAlert>> getVehicleDtcAlerts({
    required String vehicleId,
    int page = 0,
    int size = 20,
    String? severity,
  });

  /// Fetches the latest telemetry snapshot reported by [deviceId].
  Future<TelemetrySnapshot> getLatestDeviceSnapshot(String deviceId);

  /// Lists paginated telemetry snapshots for [deviceId].
  Future<List<TelemetrySnapshot>> getDeviceTelemetrySnapshots({
    required String deviceId,
    int page = 0,
    int size = 20,
  });

  /// Lists paginated telemetry snapshots for [registrationId].
  Future<List<TelemetrySnapshot>> getRegistrationTelemetrySnapshots({
    required String registrationId,
    int page = 0,
    int size = 20,
  });

  /// Lists paginated DTC alerts for [registrationId].
  Future<List<DtcAlert>> getRegistrationDtcAlerts({
    required String registrationId,
    int page = 0,
    int size = 20,
  });

  // Telemetry Simulator
  /// Starts a continuous telemetry simulation.
  Future<SimulatorStatus> startSimulation({
    required String scenario,
    required String emissionMode,
    required String branchId,
    int vehiclesCount = 10,
    int ratePerSec = 20,
    int durationSeconds = 120,
  });

  /// Stops any active telemetry simulation.
  Future<void> stopSimulation();

  /// Fetches the current telemetry simulator status.
  Future<SimulatorStatus> getSimulatorStatus();
}
