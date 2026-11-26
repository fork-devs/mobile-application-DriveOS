import 'package:mobile_application_driveos/core/domain/event/domain_event.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event_bus.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/core/domain/core_domain.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/remote/branch_api.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/remote/profile_api.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/remote/workshop_api.dart';

/// Concrete [CoreRepository] coordinating tenant APIs, [SessionStorage],
/// and [DomainEventBus] events.
class CoreRepositoryImpl implements CoreRepository {
  final WorkshopApi _workshopApi;
  final BranchApi _branchApi;
  final ProfileApi _profileApi;
  final SessionStorage _sessionStorage;
  final DomainEventBus _eventBus;

  /// Creates a [CoreRepositoryImpl].
  const CoreRepositoryImpl({
    required this._workshopApi,
    required this._branchApi,
    required this._profileApi,
    required this._sessionStorage,
    required this._eventBus,
  });

  @override
  Future<List<Workshop>> getWorkshopsByOwner(String ownerId) async {
    final dtos = await _workshopApi.getWorkshopsByOwner(ownerId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Workshop> getWorkshopById(String workshopId) async {
    final dto = await _workshopApi.getWorkshopById(workshopId);
    return dto.toDomain();
  }

  @override
  Future<Workshop> createWorkshop({
    required String ownerId,
    required String businessName,
    required String brandName,
    required String taxId,
    int mileageIntervalConfig = 5000,
  }) async {
    final dto = await _workshopApi.createWorkshop(
      ownerId: ownerId,
      businessName: businessName,
      brandName: brandName,
      taxId: taxId,
      mileageIntervalConfig: mileageIntervalConfig,
    );
    return dto.toDomain();
  }

  @override
  Future<Workshop> updateWorkshop({
    required String workshopId,
    required String businessName,
    required String brandName,
    required String taxId,
    int mileageIntervalConfig = 5000,
  }) async {
    final dto = await _workshopApi.updateWorkshop(
      workshopId: workshopId,
      businessName: businessName,
      brandName: brandName,
      taxId: taxId,
      mileageIntervalConfig: mileageIntervalConfig,
    );
    return dto.toDomain();
  }

  @override
  Future<List<Branch>> getBranchesByWorkshop(String workshopId) async {
    final dtos = await _branchApi.getBranchesByWorkshop(workshopId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Branch> getBranchById(String branchId) async {
    final dto = await _branchApi.getBranchById(branchId);
    return dto.toDomain();
  }

  @override
  Future<Branch> createBranch({
    required String workshopId,
    required String code,
    required String name,
    required String address,
    required String phone,
    double? latitude,
    double? longitude,
  }) async {
    final dto = await _branchApi.createBranch(
      workshopId: workshopId,
      code: code,
      name: name,
      address: address,
      phone: phone,
      latitude: latitude,
      longitude: longitude,
    );
    return dto.toDomain();
  }

  @override
  Future<Branch> updateBranch({
    required String branchId,
    required String code,
    required String name,
    required String address,
    required String phone,
    double? latitude,
    double? longitude,
  }) async {
    final dto = await _branchApi.updateBranch(
      branchId: branchId,
      code: code,
      name: name,
      address: address,
      phone: phone,
      latitude: latitude,
      longitude: longitude,
    );
    return dto.toDomain();
  }

  @override
  Future<Branch> uploadBranchBanner({
    required String branchId,
    required String filePath,
  }) async {
    final dto = await _branchApi.uploadBranchBanner(
      branchId: branchId,
      filePath: filePath,
    );
    return dto.toDomain();
  }

  @override
  Future<void> selectActiveBranch({
    required String branchId,
    required String branchName,
    String? workshopId,
  }) async {
    await _sessionStorage.saveActiveBranch(
      branchId: branchId,
      branchName: branchName,
      workshopId: workshopId,
    );
    _eventBus.emit(
      ActiveBranchChangedEvent(
        branchId: branchId,
        branchName: branchName,
      ),
    );
  }

  @override
  Future<List<SubscriptionPlan>> getPlans() async {
    final dtos = await _branchApi.getPlans();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<BranchSubscription> assignBranchSubscription({
    required String branchId,
    required String planId,
    required String billingCycle,
  }) async {
    final dto = await _branchApi.assignBranchSubscription(
      branchId: branchId,
      planId: planId,
      billingCycle: billingCycle,
    );
    return dto.toDomain();
  }

  @override
  Future<void> cancelBranchSubscription(String branchId) =>
      _branchApi.cancelBranchSubscription(branchId);

  @override
  Future<UserProfileContext> getMyProfileContext() async {
    final dto = await _profileApi.getMyProfileContext();
    return dto.toDomain();
  }

  @override
  Future<UserProfileContext> updateMyProfileImage(
    String profileImageUrl,
  ) async {
    final dto = await _profileApi.updateMyProfileImage(profileImageUrl);
    return dto.toDomain();
  }

  @override
  Future<UserProfileContext> uploadMyProfileImage(String filePath) async {
    final dto = await _profileApi.uploadMyProfileImage(filePath);
    return dto.toDomain();
  }

  @override
  Future<UnifiedProfileLookup> lookupProfileByDocument(
    String documentNumber,
  ) async {
    final dto = await _profileApi.lookupProfileByDocument(documentNumber);
    return dto.toDomain();
  }

  @override
  Future<OwnerProfile> createOwnerProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  }) async {
    final dto = await _profileApi.createOwnerProfile(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      documentType: documentType,
      documentNumber: documentNumber,
      phone: phone,
    );
    return dto.toDomain();
  }

  @override
  Future<OwnerProfile> updateOwnerProfile({
    required String ownerId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  }) async {
    final dto = await _profileApi.updateOwnerProfile(
      ownerId: ownerId,
      firstName: firstName,
      lastName: lastName,
      documentType: documentType,
      documentNumber: documentNumber,
      phone: phone,
    );
    return dto.toDomain();
  }

  @override
  Future<EmployeeProfile> createEmployeeProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  }) async {
    final dto = await _profileApi.createEmployeeProfile(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      documentType: documentType,
      documentNumber: documentNumber,
      phone: phone,
    );
    return dto.toDomain();
  }

  @override
  Future<EmployeeProfile> updateEmployeeProfile({
    required String employeeId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  }) async {
    final dto = await _profileApi.updateEmployeeProfile(
      employeeId: employeeId,
      firstName: firstName,
      lastName: lastName,
      documentType: documentType,
      documentNumber: documentNumber,
      phone: phone,
    );
    return dto.toDomain();
  }
}
