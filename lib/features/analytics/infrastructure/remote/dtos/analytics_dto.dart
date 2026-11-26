import 'package:mobile_application_driveos/features/analytics/domain/analytics_domain.dart';

/// Wire DTO representing a [TenantAnalyticsSummary].
class TenantAnalyticsSummaryDto {
  /// Tenant identifier.
  final String tenantId;

  /// Total revenue.
  final double totalRevenue;

  /// Active work orders count.
  final int activeWorkOrders;

  /// Completed work orders count.
  final int completedWorkOrders;

  /// Total alerts count.
  final int totalAlerts;

  /// Creates a [TenantAnalyticsSummaryDto].
  const TenantAnalyticsSummaryDto({
    required this.tenantId,
    required this.totalRevenue,
    required this.activeWorkOrders,
    required this.completedWorkOrders,
    required this.totalAlerts,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory TenantAnalyticsSummaryDto.fromJson(Map<String, dynamic> json) {
    if (json case {'tenant_id': final String tenantId}) {
      return TenantAnalyticsSummaryDto(
        tenantId: tenantId,
        totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
        activeWorkOrders: (json['active_work_orders'] as num?)?.toInt() ?? 0,
        completedWorkOrders:
            (json['completed_work_orders'] as num?)?.toInt() ?? 0,
        totalAlerts: (json['total_alerts'] as num?)?.toInt() ?? 0,
      );
    }
    throw const FormatException(
      'Invalid or incomplete TenantAnalyticsSummary JSON.',
    );
  }

  /// Converts this DTO into a [TenantAnalyticsSummary] domain entity.
  TenantAnalyticsSummary toDomain() => TenantAnalyticsSummary(
        tenantId: tenantId,
        totalRevenue: totalRevenue,
        activeWorkOrders: activeWorkOrders,
        completedWorkOrders: completedWorkOrders,
        totalAlerts: totalAlerts,
      );
}

/// Wire DTO representing a [RevenueTrendPoint].
class RevenueTrendPointDto {
  /// Period label.
  final String period;

  /// Gross revenue.
  final double grossRevenue;

  /// Parts cost.
  final double partsCost;

  /// Labor cost.
  final double laborCost;

  /// Gross margin percentage.
  final double grossMarginPercentage;

  /// Creates a [RevenueTrendPointDto].
  const RevenueTrendPointDto({
    required this.period,
    required this.grossRevenue,
    required this.partsCost,
    required this.laborCost,
    required this.grossMarginPercentage,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory RevenueTrendPointDto.fromJson(Map<String, dynamic> json) {
    if (json case {'period': final String period}) {
      return RevenueTrendPointDto(
        period: period,
        grossRevenue: (json['gross_revenue'] as num?)?.toDouble() ?? 0.0,
        partsCost: (json['parts_cost'] as num?)?.toDouble() ?? 0.0,
        laborCost: (json['labor_cost'] as num?)?.toDouble() ?? 0.0,
        grossMarginPercentage:
            (json['gross_margin_percentage'] as num?)?.toDouble() ?? 0.0,
      );
    }
    throw const FormatException('Invalid or incomplete RevenueTrendPoint JSON.');
  }

  /// Converts this DTO into a [RevenueTrendPoint] domain entity.
  RevenueTrendPoint toDomain() => RevenueTrendPoint(
        period: period,
        grossRevenue: grossRevenue,
        partsCost: partsCost,
        laborCost: laborCost,
        grossMarginPercentage: grossMarginPercentage,
      );
}

/// Wire DTO representing a [BranchAnalyticsSummary].
class BranchAnalyticsSummaryDto {
  /// Branch identifier.
  final String branchId;

  /// Total revenue.
  final double totalRevenue;

  /// Completed work orders count.
  final int completedWorkOrdersCount;

  /// Total appointments count.
  final int totalAppointmentsCount;

  /// Low stock alerts count.
  final int lowStockAlertsCount;

  /// DTC alerts count.
  final int dtcAlertsCount;

  /// Creates a [BranchAnalyticsSummaryDto].
  const BranchAnalyticsSummaryDto({
    required this.branchId,
    required this.totalRevenue,
    required this.completedWorkOrdersCount,
    required this.totalAppointmentsCount,
    required this.lowStockAlertsCount,
    required this.dtcAlertsCount,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory BranchAnalyticsSummaryDto.fromJson(Map<String, dynamic> json) {
    if (json case {'branchId': final String branchId}) {
      return BranchAnalyticsSummaryDto(
        branchId: branchId,
        totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
        completedWorkOrdersCount:
            (json['completedWorkOrdersCount'] as num?)?.toInt() ?? 0,
        totalAppointmentsCount:
            (json['totalAppointmentsCount'] as num?)?.toInt() ?? 0,
        lowStockAlertsCount:
            (json['lowStockAlertsCount'] as num?)?.toInt() ?? 0,
        dtcAlertsCount: (json['dtcAlertsCount'] as num?)?.toInt() ?? 0,
      );
    }
    throw const FormatException(
      'Invalid or incomplete BranchAnalyticsSummary JSON.',
    );
  }

  /// Converts this DTO into a [BranchAnalyticsSummary] domain entity.
  BranchAnalyticsSummary toDomain() => BranchAnalyticsSummary(
        branchId: branchId,
        totalRevenue: totalRevenue,
        completedWorkOrdersCount: completedWorkOrdersCount,
        totalAppointmentsCount: totalAppointmentsCount,
        lowStockAlertsCount: lowStockAlertsCount,
        dtcAlertsCount: dtcAlertsCount,
      );
}

/// Wire DTO representing a [BranchFinancialSnapshot].
class BranchFinancialSnapshotDto {
  /// Snapshot identifier.
  final String id;

  /// Branch identifier.
  final String branchId;

  /// Snapshot date.
  final String snapshotDate;

  /// Total revenue.
  final double totalRevenue;

  /// Completed work orders count.
  final int completedWorkOrdersCount;

  /// Total appointments count.
  final int totalAppointmentsCount;

  /// Low stock alerts count.
  final int lowStockAlertsCount;

  /// DTC alerts count.
  final int dtcAlertsCount;

  /// Creates a [BranchFinancialSnapshotDto].
  const BranchFinancialSnapshotDto({
    required this.id,
    required this.branchId,
    required this.snapshotDate,
    required this.totalRevenue,
    required this.completedWorkOrdersCount,
    required this.totalAppointmentsCount,
    required this.lowStockAlertsCount,
    required this.dtcAlertsCount,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory BranchFinancialSnapshotDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'branchId': final String branchId,
      'snapshotDate': final String snapshotDate,
    }) {
      return BranchFinancialSnapshotDto(
        id: id,
        branchId: branchId,
        snapshotDate: snapshotDate,
        totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
        completedWorkOrdersCount:
            (json['completedWorkOrdersCount'] as num?)?.toInt() ?? 0,
        totalAppointmentsCount:
            (json['totalAppointmentsCount'] as num?)?.toInt() ?? 0,
        lowStockAlertsCount:
            (json['lowStockAlertsCount'] as num?)?.toInt() ?? 0,
        dtcAlertsCount: (json['dtcAlertsCount'] as num?)?.toInt() ?? 0,
      );
    }
    throw const FormatException(
      'Invalid or incomplete BranchFinancialSnapshot JSON.',
    );
  }

  /// Converts this DTO into a [BranchFinancialSnapshot] domain entity.
  BranchFinancialSnapshot toDomain() => BranchFinancialSnapshot(
        id: id,
        branchId: branchId,
        snapshotDate: snapshotDate,
        totalRevenue: totalRevenue,
        completedWorkOrdersCount: completedWorkOrdersCount,
        totalAppointmentsCount: totalAppointmentsCount,
        lowStockAlertsCount: lowStockAlertsCount,
        dtcAlertsCount: dtcAlertsCount,
      );
}

/// Wire DTO representing a [NetworkAnalyticsSummary].
class NetworkAnalyticsSummaryDto {
  /// Active branches count.
  final int totalActiveBranchesCount;

  /// Total network revenue.
  final double totalNetworkRevenue;

  /// Completed work orders count.
  final int totalNetworkCompletedWorkOrders;

  /// Total appointments count.
  final int totalNetworkAppointments;

  /// Total DTC alerts count.
  final int totalNetworkDtcAlerts;

  /// Creates a [NetworkAnalyticsSummaryDto].
  const NetworkAnalyticsSummaryDto({
    required this.totalActiveBranchesCount,
    required this.totalNetworkRevenue,
    required this.totalNetworkCompletedWorkOrders,
    required this.totalNetworkAppointments,
    required this.totalNetworkDtcAlerts,
  });

  /// Deserializes [json] from `/analytics/network/summary`.
  factory NetworkAnalyticsSummaryDto.fromJson(Map<String, dynamic> json) {
    return NetworkAnalyticsSummaryDto(
      totalActiveBranchesCount:
          (json['totalActiveBranchesCount'] as num?)?.toInt() ?? 0,
      totalNetworkRevenue:
          (json['totalNetworkRevenue'] as num?)?.toDouble() ?? 0.0,
      totalNetworkCompletedWorkOrders:
          (json['totalNetworkCompletedWorkOrders'] as num?)?.toInt() ?? 0,
      totalNetworkAppointments:
          (json['totalNetworkAppointments'] as num?)?.toInt() ?? 0,
      totalNetworkDtcAlerts:
          (json['totalNetworkDtcAlerts'] as num?)?.toInt() ?? 0,
    );
  }

  /// Converts this DTO into a [NetworkAnalyticsSummary] domain entity.
  NetworkAnalyticsSummary toDomain() => NetworkAnalyticsSummary(
        totalActiveBranchesCount: totalActiveBranchesCount,
        totalNetworkRevenue: totalNetworkRevenue,
        totalNetworkCompletedWorkOrders: totalNetworkCompletedWorkOrders,
        totalNetworkAppointments: totalNetworkAppointments,
        totalNetworkDtcAlerts: totalNetworkDtcAlerts,
      );
}

/// Wire DTO representing a [CustomerAnalyticsSummary].
class CustomerAnalyticsSummaryDto {
  /// Customer identifier.
  final String customerId;

  /// Active vehicles count.
  final int activeVehiclesCount;

  /// Active DTC alerts count.
  final int activeDtcAlertsCount;

  /// Upcoming appointments count.
  final int upcomingAppointmentsCount;

  /// Active work orders count.
  final int activeWorkOrdersCount;

  /// Pending quotes count.
  final int pendingQuotesCount;

  /// Upcoming appointments payload.
  final List<Map<String, dynamic>> upcomingAppointments;

  /// Active work orders payload.
  final List<Map<String, dynamic>> activeWorkOrders;

  /// Pending quotes payload.
  final List<Map<String, dynamic>> pendingQuotes;

  /// Creates a [CustomerAnalyticsSummaryDto].
  const CustomerAnalyticsSummaryDto({
    required this.customerId,
    required this.activeVehiclesCount,
    required this.activeDtcAlertsCount,
    required this.upcomingAppointmentsCount,
    required this.activeWorkOrdersCount,
    required this.pendingQuotesCount,
    this.upcomingAppointments = const [],
    this.activeWorkOrders = const [],
    this.pendingQuotes = const [],
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory CustomerAnalyticsSummaryDto.fromJson(Map<String, dynamic> json) {
    if (json case {'customerId': final String customerId}) {
      return CustomerAnalyticsSummaryDto(
        customerId: customerId,
        activeVehiclesCount:
            (json['activeVehiclesCount'] as num?)?.toInt() ?? 0,
        activeDtcAlertsCount:
            (json['activeDtcAlertsCount'] as num?)?.toInt() ?? 0,
        upcomingAppointmentsCount:
            (json['upcomingAppointmentsCount'] as num?)?.toInt() ?? 0,
        activeWorkOrdersCount:
            (json['activeWorkOrdersCount'] as num?)?.toInt() ?? 0,
        pendingQuotesCount:
            (json['pendingQuotesCount'] as num?)?.toInt() ?? 0,
        upcomingAppointments: _castMapList(json['upcomingAppointments']),
        activeWorkOrders: _castMapList(json['activeWorkOrders']),
        pendingQuotes: _castMapList(json['pendingQuotes']),
      );
    }
    throw const FormatException(
      'Invalid or incomplete CustomerAnalyticsSummary JSON.',
    );
  }

  /// Converts this DTO into a [CustomerAnalyticsSummary] domain entity.
  CustomerAnalyticsSummary toDomain() => CustomerAnalyticsSummary(
        customerId: customerId,
        activeVehiclesCount: activeVehiclesCount,
        activeDtcAlertsCount: activeDtcAlertsCount,
        upcomingAppointmentsCount: upcomingAppointmentsCount,
        activeWorkOrdersCount: activeWorkOrdersCount,
        pendingQuotesCount: pendingQuotesCount,
        upcomingAppointments: upcomingAppointments,
        activeWorkOrders: activeWorkOrders,
        pendingQuotes: pendingQuotes,
      );
}

/// Wire DTO representing an [EmployeeAnalyticsSummary].
class EmployeeAnalyticsSummaryDto {
  /// Employee identifier.
  final String employeeId;

  /// Assigned branch identifiers.
  final List<String> branchIds;

  /// Assigned work orders count.
  final int assignedWorkOrdersCount;

  /// Pending tasks count.
  final int pendingTasksCount;

  /// Completed tasks count.
  final int completedTasksCount;

  /// Active DTC alerts count.
  final int activeDtcAlertsCount;

  /// Assigned work orders payload.
  final List<Map<String, dynamic>> assignedWorkOrders;

  /// Creates an [EmployeeAnalyticsSummaryDto].
  const EmployeeAnalyticsSummaryDto({
    required this.employeeId,
    this.branchIds = const [],
    required this.assignedWorkOrdersCount,
    required this.pendingTasksCount,
    required this.completedTasksCount,
    required this.activeDtcAlertsCount,
    this.assignedWorkOrders = const [],
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory EmployeeAnalyticsSummaryDto.fromJson(Map<String, dynamic> json) {
    if (json case {'employeeId': final String employeeId}) {
      final rawBranches = json['branchIds'];
      return EmployeeAnalyticsSummaryDto(
        employeeId: employeeId,
        branchIds: rawBranches is List
            ? rawBranches.map((id) => id.toString()).toList()
            : const <String>[],
        assignedWorkOrdersCount:
            (json['assignedWorkOrdersCount'] as num?)?.toInt() ?? 0,
        pendingTasksCount: (json['pendingTasksCount'] as num?)?.toInt() ?? 0,
        completedTasksCount:
            (json['completedTasksCount'] as num?)?.toInt() ?? 0,
        activeDtcAlertsCount:
            (json['activeDtcAlertsCount'] as num?)?.toInt() ?? 0,
        assignedWorkOrders: _castMapList(json['assignedWorkOrders']),
      );
    }
    throw const FormatException(
      'Invalid or incomplete EmployeeAnalyticsSummary JSON.',
    );
  }

  /// Converts this DTO into an [EmployeeAnalyticsSummary] domain entity.
  EmployeeAnalyticsSummary toDomain() => EmployeeAnalyticsSummary(
        employeeId: employeeId,
        branchIds: branchIds,
        assignedWorkOrdersCount: assignedWorkOrdersCount,
        pendingTasksCount: pendingTasksCount,
        completedTasksCount: completedTasksCount,
        activeDtcAlertsCount: activeDtcAlertsCount,
        assignedWorkOrders: assignedWorkOrders,
      );
}

List<Map<String, dynamic>> _castMapList(dynamic raw) {
  if (raw is! List) return const [];
  return raw.whereType<Map<String, dynamic>>().toList();
}
