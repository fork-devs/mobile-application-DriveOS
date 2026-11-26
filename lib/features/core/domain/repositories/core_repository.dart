import 'package:mobile_application_driveos/features/core/domain/model/entities/branch.dart';
import 'package:mobile_application_driveos/features/core/domain/model/entities/profile.dart';
import 'package:mobile_application_driveos/features/core/domain/model/entities/workshop.dart';

/// Output port defining workshop, branch, profile, and subscription operations.
abstract interface class CoreRepository {
  /// Lists workshops belonging to [ownerId].
  Future<List<Workshop>> getWorkshopsByOwner(String ownerId);

  /// Fetches a workshop by [workshopId].
  Future<Workshop> getWorkshopById(String workshopId);

  /// Creates a new workshop for [ownerId].
  Future<Workshop> createWorkshop({
    required String ownerId,
    required String businessName,
    required String brandName,
    required String taxId,
    int mileageIntervalConfig = 5000,
  });

  /// Updates an existing workshop identified by [workshopId].
  Future<Workshop> updateWorkshop({
    required String workshopId,
    required String businessName,
    required String brandName,
    required String taxId,
    int mileageIntervalConfig = 5000,
  });

  /// Lists all branches belonging to [workshopId].
  Future<List<Branch>> getBranchesByWorkshop(String workshopId);

  /// Fetches a branch by [branchId].
  Future<Branch> getBranchById(String branchId);

  /// Creates a new branch under [workshopId].
  Future<Branch> createBranch({
    required String workshopId,
    required String code,
    required String name,
    required String address,
    required String phone,
    double? latitude,
    double? longitude,
  });

  /// Updates an existing branch identified by [branchId].
  Future<Branch> updateBranch({
    required String branchId,
    required String code,
    required String name,
    required String address,
    required String phone,
    double? latitude,
    double? longitude,
  });

  /// Uploads a banner image at [filePath] for [branchId].
  Future<Branch> uploadBranchBanner({
    required String branchId,
    required String filePath,
  });

  /// Persists the active branch selection and emits `ActiveBranchChangedEvent`.
  Future<void> selectActiveBranch({
    required String branchId,
    required String branchName,
    String? workshopId,
  });

  /// Lists available subscription plans.
  Future<List<SubscriptionPlan>> getPlans();

  /// Assigns [planId] with [billingCycle] to [branchId].
  Future<BranchSubscription> assignBranchSubscription({
    required String branchId,
    required String planId,
    required String billingCycle,
  });

  /// Cancels the active subscription for [branchId].
  Future<void> cancelBranchSubscription(String branchId);

  /// Returns the authenticated user's unified profile context.
  Future<UserProfileContext> getMyProfileContext();

  /// Updates the authenticated user's profile image URL.
  Future<UserProfileContext> updateMyProfileImage(String profileImageUrl);

  /// Uploads a binary profile image at [filePath] for the authenticated user.
  Future<UserProfileContext> uploadMyProfileImage(String filePath);

  /// Looks up a unified profile by [documentNumber].
  Future<UnifiedProfileLookup> lookupProfileByDocument(String documentNumber);

  /// Creates an owner profile for [userId].
  Future<OwnerProfile> createOwnerProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  });

  /// Updates an owner profile identified by [ownerId].
  Future<OwnerProfile> updateOwnerProfile({
    required String ownerId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  });

  /// Creates an employee profile for [userId].
  Future<EmployeeProfile> createEmployeeProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  });

  /// Updates an employee profile identified by [employeeId].
  Future<EmployeeProfile> updateEmployeeProfile({
    required String employeeId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  });
}
