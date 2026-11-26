import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';

/// Use case that manages the workshop service catalog for branches.
class ManageWorkshopServices {
  final OperationsRepository _repository;

  /// Creates a [ManageWorkshopServices] use case.
  const ManageWorkshopServices(this._repository);

  /// Creates a new catalog service for [branchId].
  Future<WorkshopService> create({
    required String branchId,
    required String name,
    required double price,
  }) {
    return _repository.createService(
      branchId: branchId,
      name: name.trim(),
      price: price,
    );
  }

  /// Lists all services offered by [branchId].
  Future<List<WorkshopService>> listByBranch(String branchId) =>
      _repository.getServicesByBranch(branchId);

  /// Updates an existing catalog service.
  Future<WorkshopService> update({
    required String serviceId,
    required String name,
    required double price,
  }) {
    return _repository.updateService(
      serviceId: serviceId,
      name: name.trim(),
      price: price,
    );
  }

  /// Deletes a catalog service by [serviceId].
  Future<void> delete(String serviceId) =>
      _repository.deleteService(serviceId);
}
