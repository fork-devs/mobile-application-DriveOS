import 'package:mobile_application_driveos/features/fleet/domain/fleet_domain.dart';

/// Use case that registers a new vehicle for a customer.
class CreateVehicle {
  final FleetRepository _repository;

  /// Creates a [CreateVehicle] use case.
  const CreateVehicle(this._repository);

  /// Registers a vehicle owned by [customerId].
  Future<Vehicle> call({
    required String customerId,
    required String plate,
    required String brand,
    required String model,
    required int year,
    required String vin,
  }) {
    return _repository.createVehicle(
      customerId: customerId,
      plate: plate.trim().toUpperCase(),
      brand: brand.trim(),
      model: model.trim(),
      year: year,
      vin: vin.trim().toUpperCase(),
    );
  }
}

/// Use case that retrieves vehicles for a tenant or customer.
class GetVehicles {
  final FleetRepository _repository;

  /// Creates a [GetVehicles] use case.
  const GetVehicles(this._repository);

  /// Lists all vehicles in the active tenant.
  Future<List<Vehicle>> call() => _repository.getVehicles();

  /// Fetches a vehicle by [vehicleId].
  Future<Vehicle> byId(String vehicleId) =>
      _repository.getVehicleById(vehicleId);

  /// Lists vehicles belonging to [customerId].
  Future<List<Vehicle>> byCustomer(String customerId) =>
      _repository.getVehiclesByCustomer(customerId);
}

/// Use case that updates, deletes, validates, or uploads images for vehicles.
class ManageVehicle {
  final FleetRepository _repository;

  /// Creates a [ManageVehicle] use case.
  const ManageVehicle(this._repository);

  /// Updates [vehicleId] metadata.
  Future<Vehicle> update({
    required String vehicleId,
    required String brand,
    required String model,
    required int year,
    required String vin,
  }) {
    return _repository.updateVehicle(
      vehicleId: vehicleId,
      brand: brand.trim(),
      model: model.trim(),
      year: year,
      vin: vin.trim().toUpperCase(),
    );
  }

  /// Deletes [vehicleId].
  Future<void> delete(String vehicleId) =>
      _repository.deleteVehicle(vehicleId);

  /// Triggers plate/VIN revalidation for [vehicleId].
  Future<void> validate(String vehicleId) =>
      _repository.validateVehicle(vehicleId);

  /// Uploads a photo at [filePath] for [vehicleId].
  Future<Vehicle> uploadImage({
    required String vehicleId,
    required String filePath,
  }) {
    return _repository.uploadVehicleImage(
      vehicleId: vehicleId,
      filePath: filePath,
    );
  }
}
