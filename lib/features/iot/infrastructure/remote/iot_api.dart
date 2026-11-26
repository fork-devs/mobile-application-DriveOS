import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/iot/infrastructure/remote/dtos/iot_dto.dart';

/// HTTP client for `erp-iot-ingestion`, `erp-iot-processor`, and
/// `erp-iot-simulator`.
class IotApi {
  final ApiClient _apiClient;

  /// Creates an [IotApi] backed by [_apiClient].
  const IotApi(this._apiClient);

  /// Registers a new OBD2 dongle for [branchId].
  Future<Obd2DeviceDto> createDevice({
    required String branchId,
    required String macAddress,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.obd2Devices,
      body: {
        'branchId': branchId,
        'macAddress': macAddress,
      },
    );
    return Obd2DeviceDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists OBD2 devices with optional filters.
  Future<List<Obd2DeviceDto>> getDevices({
    String? branchId,
    String? status,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.obd2Devices,
      queryParameters: {
        'branchId': ?branchId,
        'status': ?status,
      },
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => Obd2DeviceDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetches an OBD2 device by [deviceId].
  Future<Obd2DeviceDto> getDeviceById(String deviceId) async {
    final response = await _apiClient.get(ApiConstants.obd2DeviceById(deviceId));
    return Obd2DeviceDto.fromJson(response as Map<String, dynamic>);
  }

  /// Updates the [macAddress] of [deviceId].
  Future<Obd2DeviceDto> updateDevice({
    required String deviceId,
    required String macAddress,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.obd2DeviceById(deviceId),
      body: {'macAddress': macAddress},
    );
    return Obd2DeviceDto.fromJson(response as Map<String, dynamic>);
  }

  /// Deletes [deviceId].
  Future<void> deleteDevice(String deviceId) async {
    await _apiClient.delete(ApiConstants.obd2DeviceById(deviceId));
  }

  /// Links [obd2DeviceId] to [vehicleId] at [branchId].
  Future<Obd2DeviceRegistrationDto> createRegistration({
    required String obd2DeviceId,
    required String branchId,
    required String vehicleId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.obd2Registrations,
      body: {
        'obd2DeviceId': obd2DeviceId,
        'branchId': branchId,
        'vehicleId': vehicleId,
      },
    );
    return Obd2DeviceRegistrationDto.fromJson(
      response as Map<String, dynamic>,
    );
  }

  /// Lists OBD2 device registrations with optional filters.
  Future<List<Obd2DeviceRegistrationDto>> getRegistrations({
    String? branchId,
    String? status,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.obd2Registrations,
      queryParameters: {
        'branchId': ?branchId,
        'status': ?status,
      },
    );
    final list = response as List<dynamic>;
    return list
        .map(
          (item) => Obd2DeviceRegistrationDto.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Updates the [status] of [registrationId].
  Future<Obd2DeviceRegistrationDto> updateRegistrationStatus({
    required String registrationId,
    required String status,
  }) async {
    final response = await _apiClient.patch(
      ApiConstants.obd2RegistrationById(registrationId),
      body: {'status': status},
    );
    return Obd2DeviceRegistrationDto.fromJson(
      response as Map<String, dynamic>,
    );
  }

  /// Fetches real-time diagnostics for [vehicleId].
  Future<VehicleDiagnosticsDto> getVehicleDiagnostics(String vehicleId) async {
    final response = await _apiClient.get(
      ApiConstants.vehicleDiagnostics(vehicleId),
    );
    return VehicleDiagnosticsDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists telemetry snapshots for [vehicleId].
  Future<List<TelemetrySnapshotDto>> getVehicleTelemetrySnapshots({
    required String vehicleId,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.vehicleTelemetrySnapshots(vehicleId),
      queryParameters: {'page': page.toString(), 'size': size.toString()},
    );
    final list = response as List<dynamic>;
    return list
        .map(
          (item) => TelemetrySnapshotDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Lists DTC alerts for [vehicleId].
  Future<List<DtcAlertDto>> getVehicleDtcAlerts({
    required String vehicleId,
    int page = 0,
    int size = 20,
    String? severity,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.vehicleDtcAlerts(vehicleId),
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
        'severity': ?severity,
      },
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => DtcAlertDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetches the latest telemetry snapshot for [deviceId].
  Future<TelemetrySnapshotDto> getLatestDeviceSnapshot(String deviceId) async {
    final response = await _apiClient.get(
      ApiConstants.deviceLatestSnapshot(deviceId),
    );
    return TelemetrySnapshotDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists telemetry snapshots for [deviceId].
  Future<List<TelemetrySnapshotDto>> getDeviceTelemetrySnapshots({
    required String deviceId,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.deviceTelemetrySnapshots(deviceId),
      queryParameters: {'page': page.toString(), 'size': size.toString()},
    );
    final list = response as List<dynamic>;
    return list
        .map(
          (item) => TelemetrySnapshotDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Lists telemetry snapshots for [registrationId].
  Future<List<TelemetrySnapshotDto>> getRegistrationTelemetrySnapshots({
    required String registrationId,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.registrationTelemetrySnapshots(registrationId),
      queryParameters: {'page': page.toString(), 'size': size.toString()},
    );
    final list = response as List<dynamic>;
    return list
        .map(
          (item) => TelemetrySnapshotDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Lists DTC alerts for [registrationId].
  Future<List<DtcAlertDto>> getRegistrationDtcAlerts({
    required String registrationId,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.registrationDtcAlerts(registrationId),
      queryParameters: {'page': page.toString(), 'size': size.toString()},
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => DtcAlertDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Starts a continuous telemetry simulation.
  Future<SimulatorStatusDto> startSimulation({
    required String scenario,
    required String emissionMode,
    required String branchId,
    int vehiclesCount = 10,
    int ratePerSec = 20,
    int durationSeconds = 120,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.simulatorStart,
      body: {
        'scenario': scenario,
        'emission_mode': emissionMode,
        'branch_id': branchId,
        'vehicles_count': vehiclesCount,
        'rate_per_sec': ratePerSec,
        'duration_seconds': durationSeconds,
      },
    );
    return SimulatorStatusDto.fromJson(response as Map<String, dynamic>);
  }

  /// Stops any active telemetry simulation.
  Future<void> stopSimulation() async {
    await _apiClient.post(ApiConstants.simulatorStop);
  }

  /// Fetches the current simulator status.
  Future<SimulatorStatusDto> getSimulatorStatus() async {
    final response = await _apiClient.get(ApiConstants.simulatorStatus);
    return SimulatorStatusDto.fromJson(response as Map<String, dynamic>);
  }
}
