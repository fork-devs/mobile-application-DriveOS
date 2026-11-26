import 'package:mobile_application_driveos/features/analytics/domain/analytics_domain.dart';

/// Use case that retrieves executive, branch, network, and role-scoped
/// analytics summaries.
class GetAnalytics {
  final AnalyticsRepository _repository;

  /// Creates a [GetAnalytics] use case.
  const GetAnalytics(this._repository);

  /// Fetches the executive summary for the active tenant.
  Future<TenantAnalyticsSummary> tenantSummary() =>
      _repository.getTenantSummary();

  /// Fetches revenue trend points for [interval].
  Future<List<RevenueTrendPoint>> revenueTrend({
    String interval = 'monthly',
    String? startDate,
    String? endDate,
  }) {
    return _repository.getRevenueTrend(
      interval: interval,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Fetches consolidated KPIs for [branchId].
  Future<BranchAnalyticsSummary> branchSummary(String branchId) =>
      _repository.getBranchSummary(branchId);

  /// Fetches daily financial snapshots for [branchId].
  Future<List<BranchFinancialSnapshot>> branchFinancial({
    required String branchId,
    String? startDate,
    String? endDate,
  }) {
    return _repository.getBranchFinancial(
      branchId: branchId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Fetches the consolidated network summary.
  Future<NetworkAnalyticsSummary> networkSummary() =>
      _repository.getNetworkSummary();

  /// Fetches the personal dashboard summary for the authenticated customer.
  Future<CustomerAnalyticsSummary> customerSummary() =>
      _repository.getCustomerSummary();

  /// Fetches the personal operational summary for the authenticated employee.
  Future<EmployeeAnalyticsSummary> employeeSummary() =>
      _repository.getEmployeeSummary();
}
