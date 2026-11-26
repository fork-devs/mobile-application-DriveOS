import 'package:mobile_application_driveos/features/iot/domain/iot_domain.dart';
import 'package:mobile_application_driveos/features/iot/infrastructure/remote/iot_api.dart';

/// Concrete [IotRepository] backed by DriveOS IoT microservices.
class IotRepositoryImpl implements IotRepository {
  final IotApi _iotApi;

  /// Creates an [IotRepositoryImpl].
  const IotRepositoryImpl({required this._iotApi});

  @override
  Future<Obd2Device> createDevice({
    required String branchId,
    required String macAddress,
  }) async {
    final dto = await _iotApi.createDevice(
      branchId: branchId,
      macAddress: macAddress,
    );
    return dto.toDomain();
  }

  @override
  Future<List<Obd2Device>> getDevices({String? branchId, String? status}) async {
    final dtos = await _iotApi.getDevices(branchId: branchId, status: status);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Obd2Device> getDeviceById(String deviceId) async {
    final dto = await _iotApi.getDeviceById(deviceId);
    return dto.toDomain();
  }

  @override
  Future<Obd2Device> updateDevice({
    required String deviceId,
    required String macAddress,
  }) async {
    final dto = await _iotApi.updateDevice(
      deviceId: deviceId,
      macAddress: macAddress,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deleteDevice(String deviceId) => _iotApi.deleteDevice(deviceId);

  @override
  Future<Obd2DeviceRegistration> createRegistration({
    required String obd2DeviceId,
    required String branchId,
    required String vehicleId,
  }) async {
    final dto = await _iotApi.createRegistration(
      obd2DeviceId: obd2DeviceId,
      branchId: branchId,
      vehicleId: vehicleId,
    );
    return dto.toDomain();
  }

  @override
  Future<List<Obd2DeviceRegistration>> getRegistrations({
    String? branchId,
    String? status,
  }) async {
    final dtos = await _iotApi.getRegistrations(
      branchId: branchId,
      status: status,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Obd2DeviceRegistration> updateRegistrationStatus({
    required String registrationId,
    required String status,
  }) async {
    final dto = await _iotApi.updateRegistrationStatus(
      registrationId: registrationId,
      status: status,
    );
    return dto.toDomain();
  }

  @override
  Future<VehicleDiagnostics> getVehicleDiagnostics(String vehicleId) async {
    final dto = await _iotApi.getVehicleDiagnostics(vehicleId);
    return dto.toDomain();
  }

  @override
  Future<List<TelemetrySnapshot>> getVehicleTelemetrySnapshots({
    required String vehicleId,
    int page = 0,
    int size = 20,
  }) async {
    final dtos = await _iotApi.getVehicleTelemetrySnapshots(
      vehicleId: vehicleId,
      page: page,
      size: size,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<DtcAlert>> getVehicleDtcAlerts({
    required String vehicleId,
    int page = 0,
    int size = 20,
    String? severity,
  }) async {
    final dtos = await _iotApi.getVehicleDtcAlerts(
      vehicleId: vehicleId,
      page: page,
      size: size,
      severity: severity,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<TelemetrySnapshot> getLatestDeviceSnapshot(String deviceId) async {
    final dto = await _iotApi.getLatestDeviceSnapshot(deviceId);
    return dto.toDomain();
  }

  @override
  Future<List<TelemetrySnapshot>> getDeviceTelemetrySnapshots({
    required String deviceId,
    int page = 0,
    int size = 20,
  }) async {
    final dtos = await _iotApi.getDeviceTelemetrySnapshots(
      deviceId: deviceId,
      page: page,
      size: size,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<TelemetrySnapshot>> getRegistrationTelemetrySnapshots({
    required String registrationId,
    int page = 0,
    int size = 20,
  }) async {
    final dtos = await _iotApi.getRegistrationTelemetrySnapshots(
      registrationId: registrationId,
      page: page,
      size: size,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<DtcAlert>> getRegistrationDtcAlerts({
    required String registrationId,
    int page = 0,
    int size = 20,
  }) async {
    final dtos = await _iotApi.getRegistrationDtcAlerts(
      registrationId: registrationId,
      page: page,
      size: size,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<SimulatorStatus> startSimulation({
    required String scenario,
    required String emissionMode,
    required String branchId,
    int vehiclesCount = 10,
    int ratePerSec = 20,
    int durationSeconds = 120,
  }) async {
    final dto = await _iotApi.startSimulation(
      scenario: scenario,
      emissionMode: emissionMode,
      branchId: branchId,
      vehiclesCount: vehiclesCount,
      ratePerSec: ratePerSec,
      durationSeconds: durationSeconds,
    );
    return dto.toDomain();
  }

  @override
  Future<void> stopSimulation() => _iotApi.stopSimulation();

  @override
  Future<SimulatorStatus> getSimulatorStatus() async {
    final dto = await _iotApi.getSimulatorStatus();
    return dto.toDomain();
  }
}
