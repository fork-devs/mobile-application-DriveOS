/// Represents the personal dashboard summary for an authenticated customer.
class CustomerAnalyticsSummary {
  /// The customer identifier.
  final String customerId;

  /// Number of active vehicles owned by the customer.
  final int activeVehiclesCount;

  /// Number of active DTC alerts across the customer's vehicles.
  final int activeDtcAlertsCount;

  /// Number of upcoming appointments.
  final int upcomingAppointmentsCount;

  /// Number of active work orders.
  final int activeWorkOrdersCount;

  /// Number of pending quotes awaiting approval or payment.
  final int pendingQuotesCount;

  /// Raw upcoming appointment summaries.
  final List<Map<String, dynamic>> upcomingAppointments;

  /// Raw active work order summaries.
  final List<Map<String, dynamic>> activeWorkOrders;

  /// Raw pending quote summaries.
  final List<Map<String, dynamic>> pendingQuotes;

  /// Creates a [CustomerAnalyticsSummary].
  const CustomerAnalyticsSummary({
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
}

/// Represents the personal operational summary for an authenticated employee.
class EmployeeAnalyticsSummary {
  /// The employee identifier.
  final String employeeId;

  /// Identifiers of branches assigned to the employee.
  final List<String> branchIds;

  /// Number of assigned work orders.
  final int assignedWorkOrdersCount;

  /// Number of pending tasks.
  final int pendingTasksCount;

  /// Number of completed tasks.
  final int completedTasksCount;

  /// Number of active DTC alerts across assigned vehicles.
  final int activeDtcAlertsCount;

  /// Raw assigned work order summaries.
  final List<Map<String, dynamic>> assignedWorkOrders;

  /// Creates an [EmployeeAnalyticsSummary].
  const EmployeeAnalyticsSummary({
    required this.employeeId,
    this.branchIds = const [],
    required this.assignedWorkOrdersCount,
    required this.pendingTasksCount,
    required this.completedTasksCount,
    required this.activeDtcAlertsCount,
    this.assignedWorkOrders = const [],
  });
}
