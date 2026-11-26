import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/remote/dtos/core_dto.dart';

/// HTTP client for `erp-tenant-service` branch and subscription endpoints.
class BranchApi {
  final ApiClient _apiClient;

  /// Creates a [BranchApi] backed by [_apiClient].
  const BranchApi(this._apiClient);

  /// Lists all branches belonging to [workshopId].
  Future<List<BranchDto>> getBranchesByWorkshop(String workshopId) async {
    final response = await _apiClient.get(
      ApiConstants.branches,
      queryParameters: {'workshopId': workshopId},
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => BranchDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetches a single branch by [branchId].
  Future<BranchDto> getBranchById(String branchId) async {
    final response = await _apiClient.get(ApiConstants.branchById(branchId));
    return BranchDto.fromJson(response as Map<String, dynamic>);
  }

  /// Creates a new branch under [workshopId].
  Future<BranchDto> createBranch({
    required String workshopId,
    required String code,
    required String name,
    required String address,
    required String phone,
    double? latitude,
    double? longitude,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.branches,
      body: {
        'workshopId': workshopId,
        'code': code,
        'name': name,
        'address': address,
        'phone': phone,
        'latitude': ?latitude,
        'longitude': ?longitude,
      },
    );
    return BranchDto.fromJson(response as Map<String, dynamic>);
  }

  /// Updates an existing branch.
  Future<BranchDto> updateBranch({
    required String branchId,
    required String code,
    required String name,
    required String address,
    required String phone,
    double? latitude,
    double? longitude,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.branchById(branchId),
      body: {
        'code': code,
        'name': name,
        'address': address,
        'phone': phone,
        'latitude': ?latitude,
        'longitude': ?longitude,
      },
    );
    return BranchDto.fromJson(response as Map<String, dynamic>);
  }

  /// Uploads a binary banner image for [branchId].
  Future<BranchDto> uploadBranchBanner({
    required String branchId,
    required String filePath,
  }) async {
    final response = await _apiClient.multipartPost(
      ApiConstants.branchBanner(branchId),
      filePath: filePath,
    );
    return BranchDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists available subscription plans.
  Future<List<SubscriptionPlanDto>> getPlans() async {
    final response = await _apiClient.get(ApiConstants.plans);
    final list = response as List<dynamic>;
    return list
        .map(
          (item) => SubscriptionPlanDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Assigns a subscription plan to [branchId].
  Future<BranchSubscriptionDto> assignBranchSubscription({
    required String branchId,
    required String planId,
    required String billingCycle,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.branchSubscriptions(branchId),
      body: {
        'planId': planId,
        'billingCycle': billingCycle,
      },
    );
    return BranchSubscriptionDto.fromJson(response as Map<String, dynamic>);
  }

  /// Cancels the active subscription for [branchId].
  Future<void> cancelBranchSubscription(String branchId) async {
    await _apiClient.delete(ApiConstants.branchSubscription(branchId));
  }
}
