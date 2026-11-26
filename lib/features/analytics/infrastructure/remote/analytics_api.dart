import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/analytics/infrastructure/remote/dtos/analytics_dto.dart';

/// HTTP client for `erp-analytics-service`.
class AnalyticsApi {
  final ApiClient _apiClient;

  /// Creates an [AnalyticsApi] backed by [_apiClient].
  const AnalyticsApi(this._apiClient);

  /// Fetches the executive summary for the active tenant.
  Future<TenantAnalyticsSummaryDto> getTenantSummary() async {
    final response = await _apiClient.get(ApiConstants.analyticsSummary);
    return TenantAnalyticsSummaryDto.fromJson(
      response as Map<String, dynamic>,
    );
  }

  /// Fetches revenue trend points for [interval].
  Future<List<RevenueTrendPointDto>> getRevenueTrend({
    String interval = 'monthly',
    String? startDate,
    String? endDate,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.analyticsRevenueTrend,
      queryParameters: {
        'interval': interval,
        'start_date': ?startDate,
        'end_date': ?endDate,
      },
    );
    final map = response as Map<String, dynamic>;
    final rawTrends = map['trends'] as List<dynamic>? ?? const [];
    return rawTrends
        .map(
          (item) => RevenueTrendPointDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Fetches consolidated KPIs for [branchId].
  Future<BranchAnalyticsSummaryDto> getBranchSummary(String branchId) async {
    final response = await _apiClient.get(
      ApiConstants.branchAnalyticsSummary(branchId),
    );
    return BranchAnalyticsSummaryDto.fromJson(
      response as Map<String, dynamic>,
    );
  }

  /// Fetches daily financial snapshots for [branchId].
  Future<List<BranchFinancialSnapshotDto>> getBranchFinancial({
    required String branchId,
    String? startDate,
    String? endDate,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.branchAnalyticsFinancial(branchId),
      queryParameters: {
        'startDate': ?startDate,
        'endDate': ?endDate,
      },
    );
    final list = response as List<dynamic>;
    return list
        .map(
          (item) => BranchFinancialSnapshotDto.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Fetches the consolidated network summary.
  Future<NetworkAnalyticsSummaryDto> getNetworkSummary() async {
    final response = await _apiClient.get(ApiConstants.analyticsNetworkSummary);
    return NetworkAnalyticsSummaryDto.fromJson(
      response as Map<String, dynamic>,
    );
  }

  /// Fetches the personal dashboard summary for the authenticated customer.
  Future<CustomerAnalyticsSummaryDto> getCustomerSummary() async {
    final response = await _apiClient.get(
      ApiConstants.analyticsCustomerSummary,
    );
    return CustomerAnalyticsSummaryDto.fromJson(
      response as Map<String, dynamic>,
    );
  }

  /// Fetches the personal operational summary for the authenticated employee.
  Future<EmployeeAnalyticsSummaryDto> getEmployeeSummary() async {
    final response = await _apiClient.get(
      ApiConstants.analyticsEmployeeSummary,
    );
    return EmployeeAnalyticsSummaryDto.fromJson(
      response as Map<String, dynamic>,
    );
  }
}
