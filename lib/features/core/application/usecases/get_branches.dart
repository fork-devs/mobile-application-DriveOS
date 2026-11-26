import 'package:mobile_application_driveos/features/core/domain/core_domain.dart';

/// Use case that lists branches belonging to a workshop.
class GetBranchesByWorkshop {
  final CoreRepository _repository;

  /// Creates a [GetBranchesByWorkshop] use case.
  const GetBranchesByWorkshop(this._repository);

  /// Returns all branches for [workshopId].
  Future<List<Branch>> call(String workshopId) =>
      _repository.getBranchesByWorkshop(workshopId);
}

/// Use case that fetches a single branch by identifier.
class GetBranchById {
  final CoreRepository _repository;

  /// Creates a [GetBranchById] use case.
  const GetBranchById(this._repository);

  /// Returns the [Branch] matching [branchId].
  Future<Branch> call(String branchId) =>
      _repository.getBranchById(branchId);
}

/// Use case that creates a new workshop branch.
class CreateBranch {
  final CoreRepository _repository;

  /// Creates a [CreateBranch] use case.
  const CreateBranch(this._repository);

  /// Creates a branch under [workshopId].
  Future<Branch> call({
    required String workshopId,
    required String code,
    required String name,
    required String address,
    required String phone,
    double? latitude,
    double? longitude,
  }) {
    return _repository.createBranch(
      workshopId: workshopId,
      code: code.trim(),
      name: name.trim(),
      address: address.trim(),
      phone: phone.trim(),
      latitude: latitude,
      longitude: longitude,
    );
  }
}

/// Use case that updates an existing workshop branch.
class UpdateBranch {
  final CoreRepository _repository;

  /// Creates an [UpdateBranch] use case.
  const UpdateBranch(this._repository);

  /// Updates the branch identified by [branchId].
  Future<Branch> call({
    required String branchId,
    required String code,
    required String name,
    required String address,
    required String phone,
    double? latitude,
    double? longitude,
  }) {
    return _repository.updateBranch(
      branchId: branchId,
      code: code.trim(),
      name: name.trim(),
      address: address.trim(),
      phone: phone.trim(),
      latitude: latitude,
      longitude: longitude,
    );
  }
}

/// Use case that uploads a banner image for a branch.
class UploadBranchBanner {
  final CoreRepository _repository;

  /// Creates an [UploadBranchBanner] use case.
  const UploadBranchBanner(this._repository);

  /// Uploads [filePath] as the banner for [branchId].
  Future<Branch> call({
    required String branchId,
    required String filePath,
  }) {
    return _repository.uploadBranchBanner(
      branchId: branchId,
      filePath: filePath,
    );
  }
}

/// Use case that selects the active workshop branch and notifies siblings.
class SelectActiveBranch {
  final CoreRepository _repository;

  /// Creates a [SelectActiveBranch] use case.
  const SelectActiveBranch(this._repository);

  /// Persists [branchId] and [branchName] and emits `ActiveBranchChangedEvent`.
  Future<void> call({
    required String branchId,
    required String branchName,
    String? workshopId,
  }) {
    return _repository.selectActiveBranch(
      branchId: branchId,
      branchName: branchName,
      workshopId: workshopId,
    );
  }
}
