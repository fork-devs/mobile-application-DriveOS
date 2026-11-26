/// Represents an item (spare part and labor cost) attached to a [WorkOrder].
class WorkOrderItem {
  /// The spare part product identifier.
  final String sparePartId;

  /// The quantity of parts used.
  final int quantity;

  /// The labor price associated with this item.
  final double laborPrice;

  /// Creates a [WorkOrderItem].
  const WorkOrderItem({
    required this.sparePartId,
    required this.quantity,
    required this.laborPrice,
  });
}

/// Represents a status transition record in a [WorkOrder] history.
class WorkOrderHistoryEntry {
  /// The previous status before the transition.
  final String from;

  /// The resulting status after the transition.
  final String to;

  /// The identifier of the user who triggered the transition.
  final String changedBy;

  /// The timestamp when the transition occurred.
  final DateTime changedAt;

  /// Creates a [WorkOrderHistoryEntry].
  const WorkOrderHistoryEntry({
    required this.from,
    required this.to,
    required this.changedBy,
    required this.changedAt,
  });
}

/// Represents a work order summary or detail record.
class WorkOrder {
  /// The unique work order identifier.
  final String orderId;

  /// The human-readable work order number (e.g. `WO-2026-0001`).
  final String number;

  /// The current lifecycle status (`OPEN`, `IN_PROGRESS`, `COMPLETED`, etc.).
  final String status;

  /// The owning tenant identifier, if returned.
  final String? tenantId;

  /// The customer identifier.
  final String? customerId;

  /// The vehicle identifier.
  final String? vehicleId;

  /// The workshop branch identifier.
  final String? branchId;

  /// The assigned lead mechanic identifier.
  final String? mechanicId;

  /// Initial or updated diagnosis description.
  final String? diagnosis;

  /// Timestamp when the work order was opened.
  final DateTime? openedAt;

  /// Timestamp when the work order was closed, if applicable.
  final DateTime? closedAt;

  /// Spare-part and labor items attached directly to the work order.
  final List<WorkOrderItem> items;

  /// Chronological state transition history.
  final List<WorkOrderHistoryEntry> history;

  /// Creates a [WorkOrder].
  const WorkOrder({
    required this.orderId,
    required this.number,
    required this.status,
    this.tenantId,
    this.customerId,
    this.vehicleId,
    this.branchId,
    this.mechanicId,
    this.diagnosis,
    this.openedAt,
    this.closedAt,
    this.items = const [],
    this.history = const [],
  });
}

/// Represents the outcome of a work order state transition.
class WorkOrderTransitionResult {
  /// The work order identifier.
  final String orderId;

  /// The new work order status.
  final String status;

  /// The previous status before the transition.
  final String origin;

  /// Closure timestamp if the transition closed the order.
  final DateTime? closedAt;

  /// Creates a [WorkOrderTransitionResult].
  const WorkOrderTransitionResult({
    required this.orderId,
    required this.status,
    required this.origin,
    this.closedAt,
  });
}
