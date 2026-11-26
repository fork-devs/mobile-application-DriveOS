import 'package:mobile_application_driveos/features/iot/domain/iot_domain.dart';

/// Use case that retrieves vehicle diagnostics, telemetry snapshots, and
/// DTC alerts, and controls the telemetry simulator.
class ManageTelemetryAndDiagnostics {
  final IotRepository _repository;

  /// Creates a [ManageTelemetryAndDiagnostics] use case.
  const ManageTelemetryAndDiagnostics(this._repository);

  /// Fetches real-time health diagnostics for [vehicleId].
  Future<VehicleDiagnostics> getDiagnostics(String vehicleId) =>
      _repository.getVehicleDiagnostics(vehicleId);

  /// Lists telemetry snapshots for [vehicleId].
  Future<List<TelemetrySnapshot>> getVehicleSnapshots({
    required String vehicleId,
    int page = 0,
    int size = 20,
  }) {
    return _repository.getVehicleTelemetrySnapshots(
      vehicleId: vehicleId,
      page: page,
      size: size,
    );
  }

  /// Lists DTC alerts for [vehicleId].
  Future<List<DtcAlert>> getVehicleDtcAlerts({
    required String vehicleId,
    int page = 0,
    int size = 20,
    String? severity,
  }) {
    return _repository.getVehicleDtcAlerts(
      vehicleId: vehicleId,
      page: page,
      size: size,
      severity: severity,
    );
  }

  /// Fetches the latest telemetry snapshot for [deviceId].
  Future<TelemetrySnapshot> getLatestDeviceSnapshot(String deviceId) =>
      _repository.getLatestDeviceSnapshot(deviceId);

  /// Lists telemetry snapshots for [deviceId].
  Future<List<TelemetrySnapshot>> getDeviceSnapshots({
    required String deviceId,
    int page = 0,
    int size = 20,
  }) {
    return _repository.getDeviceTelemetrySnapshots(
      deviceId: deviceId,
      page: page,
      size: size,
    );
  }

  /// Lists telemetry snapshots for [registrationId].
  Future<List<TelemetrySnapshot>> getRegistrationSnapshots({
    required String registrationId,
    int page = 0,
    int size = 20,
  }) {
    return _repository.getRegistrationTelemetrySnapshots(
      registrationId: registrationId,
      page: page,
      size: size,
    );
  }

  /// Lists DTC alerts for [registrationId].
  Future<List<DtcAlert>> getRegistrationDtcAlerts({
    required String registrationId,
    int page = 0,
    int size = 20,
  }) {
    return _repository.getRegistrationDtcAlerts(
      registrationId: registrationId,
      page: page,
      size: size,
    );
  }

  /// Starts a continuous telemetry simulation.
  Future<SimulatorStatus> startSimulation({
    required String scenario,
    required String emissionMode,
    required String branchId,
    int vehiclesCount = 10,
    int ratePerSec = 20,
    int durationSeconds = 120,
  }) {
    return _repository.startSimulation(
      scenario: scenario.trim().toUpperCase(),
      emissionMode: emissionMode.trim().toUpperCase(),
      branchId: branchId,
      vehiclesCount: vehiclesCount,
      ratePerSec: ratePerSec,
      durationSeconds: durationSeconds,
    );
  }

  /// Stops any running telemetry simulation.
  Future<void> stopSimulation() => _repository.stopSimulation();

  /// Fetches the current telemetry simulator status.
  Future<SimulatorStatus> getSimulatorStatus() =>
      _repository.getSimulatorStatus();
}
