/// Represents the global executive summary for a tenant.
class TenantAnalyticsSummary {
  /// The tenant identifier.
  final String tenantId;

  /// Total revenue across the tenant.
  final double totalRevenue;

  /// Number of currently active work orders.
  final int activeWorkOrders;

  /// Number of completed work orders.
  final int completedWorkOrders;

  /// Total active alerts.
  final int totalAlerts;

  /// Creates a [TenantAnalyticsSummary].
  const TenantAnalyticsSummary({
    required this.tenantId,
    required this.totalRevenue,
    required this.activeWorkOrders,
    required this.completedWorkOrders,
    required this.totalAlerts,
  });
}

/// Represents a revenue and cost period inside a trend series.
class RevenueTrendPoint {
  /// Period label (e.g. `2026-11`).
  final String period;

  /// Gross revenue for the period.
  final double grossRevenue;

  /// Spare parts cost for the period.
  final double partsCost;

  /// Labor cost for the period.
  final double laborCost;

  /// Gross margin percentage (`0.0` to `100.0`).
  final double grossMarginPercentage;

  /// Creates a [RevenueTrendPoint].
  const RevenueTrendPoint({
    required this.period,
    required this.grossRevenue,
    required this.partsCost,
    required this.laborCost,
    required this.grossMarginPercentage,
  });
}

/// Represents consolidated KPIs for a single workshop branch.
class BranchAnalyticsSummary {
  /// The branch identifier.
  final String branchId;

  /// Total revenue for the branch.
  final double totalRevenue;

  /// Completed work orders count.
  final int completedWorkOrdersCount;

  /// Total appointments count.
  final int totalAppointmentsCount;

  /// Low-stock alerts count.
  final int lowStockAlertsCount;

  /// Active DTC alerts count.
  final int dtcAlertsCount;

  /// Creates a [BranchAnalyticsSummary].
  const BranchAnalyticsSummary({
    required this.branchId,
    required this.totalRevenue,
    required this.completedWorkOrdersCount,
    required this.totalAppointmentsCount,
    required this.lowStockAlertsCount,
    required this.dtcAlertsCount,
  });
}

/// Represents a daily financial snapshot for a workshop branch.
class BranchFinancialSnapshot {
  /// Snapshot identifier.
  final String id;

  /// Branch identifier.
  final String branchId;

  /// Snapshot date (`YYYY-MM-DD`).
  final String snapshotDate;

  /// Total revenue for the day.
  final double totalRevenue;

  /// Completed work orders count.
  final int completedWorkOrdersCount;

  /// Total appointments count.
  final int totalAppointmentsCount;

  /// Low-stock alerts count.
  final int lowStockAlertsCount;

  /// DTC alerts count.
  final int dtcAlertsCount;

  /// Creates a [BranchFinancialSnapshot].
  const BranchFinancialSnapshot({
    required this.id,
    required this.branchId,
    required this.snapshotDate,
    required this.totalRevenue,
    required this.completedWorkOrdersCount,
    required this.totalAppointmentsCount,
    required this.lowStockAlertsCount,
    required this.dtcAlertsCount,
  });
}

/// Represents aggregated KPIs across all branches in a tenant network.
class NetworkAnalyticsSummary {
  /// Total active branches count.
  final int totalActiveBranchesCount;

  /// Total network revenue.
  final double totalNetworkRevenue;

  /// Total completed work orders across the network.
  final int totalNetworkCompletedWorkOrders;

  /// Total appointments across the network.
  final int totalNetworkAppointments;

  /// Total DTC alerts across the network.
  final int totalNetworkDtcAlerts;

  /// Creates a [NetworkAnalyticsSummary].
  const NetworkAnalyticsSummary({
    required this.totalActiveBranchesCount,
    required this.totalNetworkRevenue,
    required this.totalNetworkCompletedWorkOrders,
    required this.totalNetworkAppointments,
    required this.totalNetworkDtcAlerts,
  });
}
