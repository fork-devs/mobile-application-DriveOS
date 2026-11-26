import 'package:mobile_application_driveos/features/iot/domain/iot_domain.dart';

/// Use case that manages OBD2 hardware devices and vehicle registrations.
class ManageObd2Devices {
  final IotRepository _repository;

  /// Creates a [ManageObd2Devices] use case.
  const ManageObd2Devices(this._repository);

  /// Registers a new OBD2 dongle for [branchId].
  Future<Obd2Device> createDevice({
    required String branchId,
    required String macAddress,
  }) {
    return _repository.createDevice(
      branchId: branchId,
      macAddress: macAddress.trim().toUpperCase(),
    );
  }

  /// Lists OBD2 devices with optional [branchId] and [status] filters.
  Future<List<Obd2Device>> listDevices({String? branchId, String? status}) =>
      _repository.getDevices(branchId: branchId, status: status);

  /// Fetches an OBD2 device by [deviceId].
  Future<Obd2Device> getDeviceById(String deviceId) =>
      _repository.getDeviceById(deviceId);

  /// Updates the [macAddress] of [deviceId].
  Future<Obd2Device> updateDevice({
    required String deviceId,
    required String macAddress,
  }) {
    return _repository.updateDevice(
      deviceId: deviceId,
      macAddress: macAddress.trim().toUpperCase(),
    );
  }

  /// Deletes [deviceId].
  Future<void> deleteDevice(String deviceId) =>
      _repository.deleteDevice(deviceId);

  /// Links [obd2DeviceId] to [vehicleId] at [branchId].
  Future<Obd2DeviceRegistration> linkDevice({
    required String obd2DeviceId,
    required String branchId,
    required String vehicleId,
  }) {
    return _repository.createRegistration(
      obd2DeviceId: obd2DeviceId,
      branchId: branchId,
      vehicleId: vehicleId,
    );
  }

  /// Lists OBD2 registrations with optional filters.
  Future<List<Obd2DeviceRegistration>> listRegistrations({
    String? branchId,
    String? status,
  }) {
    return _repository.getRegistrations(branchId: branchId, status: status);
  }

  /// Updates the [status] (`ACTIVE` or `INACTIVE`) of [registrationId].
  Future<Obd2DeviceRegistration> updateRegistrationStatus({
    required String registrationId,
    required String status,
  }) {
    return _repository.updateRegistrationStatus(
      registrationId: registrationId,
      status: status.trim().toUpperCase(),
    );
  }
}
