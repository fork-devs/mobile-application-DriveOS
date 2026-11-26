import 'package:mobile_application_driveos/features/analytics/domain/analytics_domain.dart';
import 'package:mobile_application_driveos/features/analytics/infrastructure/remote/analytics_api.dart';

/// Concrete [AnalyticsRepository] backed by `erp-analytics-service`.
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsApi _analyticsApi;

  /// Creates an [AnalyticsRepositoryImpl].
  const AnalyticsRepositoryImpl({required this._analyticsApi});

  @override
  Future<TenantAnalyticsSummary> getTenantSummary() async {
    final dto = await _analyticsApi.getTenantSummary();
    return dto.toDomain();
  }

  @override
  Future<List<RevenueTrendPoint>> getRevenueTrend({
    String interval = 'monthly',
    String? startDate,
    String? endDate,
  }) async {
    final dtos = await _analyticsApi.getRevenueTrend(
      interval: interval,
      startDate: startDate,
      endDate: endDate,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<BranchAnalyticsSummary> getBranchSummary(String branchId) async {
    final dto = await _analyticsApi.getBranchSummary(branchId);
    return dto.toDomain();
  }

  @override
  Future<List<BranchFinancialSnapshot>> getBranchFinancial({
    required String branchId,
    String? startDate,
    String? endDate,
  }) async {
    final dtos = await _analyticsApi.getBranchFinancial(
      branchId: branchId,
      startDate: startDate,
      endDate: endDate,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<NetworkAnalyticsSummary> getNetworkSummary() async {
    final dto = await _analyticsApi.getNetworkSummary();
    return dto.toDomain();
  }

  @override
  Future<CustomerAnalyticsSummary> getCustomerSummary() async {
    final dto = await _analyticsApi.getCustomerSummary();
    return dto.toDomain();
  }

  @override
  Future<EmployeeAnalyticsSummary> getEmployeeSummary() async {
    final dto = await _analyticsApi.getEmployeeSummary();
    return dto.toDomain();
  }
}
