import 'package:mobile_application_driveos/features/analytics/domain/model/entities/branch_and_network_analytics.dart';
import 'package:mobile_application_driveos/features/analytics/domain/model/entities/role_analytics_summary.dart';

/// Output port defining executive, branch, network, and role-scoped
/// analytics queries.
abstract interface class AnalyticsRepository {
  /// Fetches the executive summary for the active tenant.
  Future<TenantAnalyticsSummary> getTenantSummary();

  /// Fetches revenue trend points for [interval] (`monthly` or `weekly`).
  Future<List<RevenueTrendPoint>> getRevenueTrend({
    String interval = 'monthly',
    String? startDate,
    String? endDate,
  });

  /// Fetches consolidated KPIs for [branchId].
  Future<BranchAnalyticsSummary> getBranchSummary(String branchId);

  /// Fetches daily financial snapshots for [branchId].
  Future<List<BranchFinancialSnapshot>> getBranchFinancial({
    required String branchId,
    String? startDate,
    String? endDate,
  });

  /// Fetches the consolidated network summary across all branches.
  Future<NetworkAnalyticsSummary> getNetworkSummary();

  /// Fetches the personal dashboard summary for the authenticated customer.
  Future<CustomerAnalyticsSummary> getCustomerSummary();

  /// Fetches the personal operational summary for the authenticated employee.
  Future<EmployeeAnalyticsSummary> getEmployeeSummary();
}
