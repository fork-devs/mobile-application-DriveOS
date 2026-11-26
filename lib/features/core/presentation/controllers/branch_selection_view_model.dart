import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/core/application/core_application.dart';
import 'package:mobile_application_driveos/features/core/domain/core_domain.dart';

/// Presentation ViewModel managing workshop branch discovery, CRUD, and
/// active branch selection.
class BranchSelectionViewModel extends ChangeNotifier {
  final GetWorkshopsByOwner _getWorkshopsByOwner;
  final GetBranchesByWorkshop _getBranchesByWorkshop;
  final CreateBranch _createBranch;
  final UpdateBranch _updateBranch;
  final UploadBranchBanner _uploadBranchBanner;
  final SelectActiveBranch _selectActiveBranch;
  final SessionStorage _sessionStorage;

  /// Creates a [BranchSelectionViewModel].
  BranchSelectionViewModel({
    required this._getWorkshopsByOwner,
    required this._getBranchesByWorkshop,
    required this._createBranch,
    required this._updateBranch,
    required this._uploadBranchBanner,
    required this._selectActiveBranch,
    required this._sessionStorage,
  });

  /// Whether branches are currently being fetched or updated.
  bool isLoading = false;

  /// Latest validation or server error message, if any.
  String? errorMessage;

  /// Active workshop identifier resolved for the current user.
  String? activeWorkshopId;

  /// Branches loaded for [activeWorkshopId].
  List<Branch> branches = [];

  /// Currently selected branch.
  Branch? selectedBranch;

  /// Loads the user's workshop and its branches from DriveOS Core.
  Future<void> loadBranches({String? workshopId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      var targetWorkshopId = workshopId ?? activeWorkshopId;
      if (targetWorkshopId == null || targetWorkshopId.isEmpty) {
        final ownerId = _sessionStorage.userId;
        if (ownerId != null && ownerId.isNotEmpty) {
          final workshops = await _getWorkshopsByOwner(ownerId);
          if (workshops.isNotEmpty) {
            targetWorkshopId = workshops.first.id;
          }
        }
      }

      activeWorkshopId = targetWorkshopId;
      if (targetWorkshopId != null && targetWorkshopId.isNotEmpty) {
        branches = await _getBranchesByWorkshop(targetWorkshopId);
      } else {
        branches = [];
      }

      final activeBranchId = _sessionStorage.activeBranchId;
      if (activeBranchId != null && branches.isNotEmpty) {
        selectedBranch = branches.cast<Branch?>().firstWhere(
              (b) => b?.id == activeBranchId,
              orElse: () => null,
            );
      }

      isLoading = false;
      notifyListeners();
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new branch under [workshopId] and optionally uploads [bannerFilePath].
  Future<bool> createBranch({
    required String workshopId,
    required String code,
    required String name,
    required String address,
    required String phone,
    String? bannerFilePath,
    double? latitude,
    double? longitude,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      var created = await _createBranch(
        workshopId: workshopId,
        code: code,
        name: name,
        address: address,
        phone: phone,
        latitude: latitude,
        longitude: longitude,
      );
      if (bannerFilePath != null && bannerFilePath.isNotEmpty) {
        created = await _uploadBranchBanner(
          branchId: created.id,
          filePath: bannerFilePath,
        );
      }
      branches = [...branches, created];
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Updates an existing branch and optionally uploads a new [bannerFilePath].
  Future<bool> updateBranch({
    required String branchId,
    required String code,
    required String name,
    required String address,
    required String phone,
    String? bannerFilePath,
    double? latitude,
    double? longitude,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      var updated = await _updateBranch(
        branchId: branchId,
        code: code,
        name: name,
        address: address,
        phone: phone,
        latitude: latitude,
        longitude: longitude,
      );
      if (bannerFilePath != null && bannerFilePath.isNotEmpty) {
        updated = await _uploadBranchBanner(
          branchId: branchId,
          filePath: bannerFilePath,
        );
      }
      branches = branches.map((b) => b.id == branchId ? updated : b).toList();
      if (selectedBranch?.id == branchId) {
        selectedBranch = updated;
      }
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Marks [branch] as the active workshop branch and emits an in-memory event.
  Future<bool> selectBranch(Branch branch) async {
    try {
      await _selectActiveBranch(
        branchId: branch.id,
        branchName: branch.name,
        workshopId: branch.workshopId,
      );
      selectedBranch = branch;
      notifyListeners();
      return true;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
