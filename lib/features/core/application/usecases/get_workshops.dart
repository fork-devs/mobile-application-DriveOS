import 'package:mobile_application_driveos/features/core/domain/core_domain.dart';

/// Use case that lists workshops belonging to an owner.
class GetWorkshopsByOwner {
  final CoreRepository _repository;

  /// Creates a [GetWorkshopsByOwner] use case.
  const GetWorkshopsByOwner(this._repository);

  /// Returns all workshops owned by [ownerId].
  Future<List<Workshop>> call(String ownerId) =>
      _repository.getWorkshopsByOwner(ownerId);
}

/// Use case that retrieves a workshop by its identifier.
class GetWorkshopById {
  final CoreRepository _repository;

  /// Creates a [GetWorkshopById] use case.
  const GetWorkshopById(this._repository);

  /// Returns the [Workshop] matching [workshopId].
  Future<Workshop> call(String workshopId) =>
      _repository.getWorkshopById(workshopId);
}

/// Use case that creates a new workshop.
class CreateWorkshop {
  final CoreRepository _repository;

  /// Creates a [CreateWorkshop] use case.
  const CreateWorkshop(this._repository);

  /// Creates a workshop for [ownerId] with the provided commercial details.
  Future<Workshop> call({
    required String ownerId,
    required String businessName,
    required String brandName,
    required String taxId,
    int mileageIntervalConfig = 5000,
  }) {
    return _repository.createWorkshop(
      ownerId: ownerId,
      businessName: businessName.trim(),
      brandName: brandName.trim(),
      taxId: taxId.trim(),
      mileageIntervalConfig: mileageIntervalConfig,
    );
  }
}

/// Use case that updates an existing workshop.
class UpdateWorkshop {
  final CoreRepository _repository;

  /// Creates an [UpdateWorkshop] use case.
  const UpdateWorkshop(this._repository);

  /// Updates [workshopId] with the provided commercial details.
  Future<Workshop> call({
    required String workshopId,
    required String businessName,
    required String brandName,
    required String taxId,
    int mileageIntervalConfig = 5000,
  }) {
    return _repository.updateWorkshop(
      workshopId: workshopId,
      businessName: businessName.trim(),
      brandName: brandName.trim(),
      taxId: taxId.trim(),
      mileageIntervalConfig: mileageIntervalConfig,
    );
  }
}
