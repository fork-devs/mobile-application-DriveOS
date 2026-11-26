/// Represents a spare part or product attached to a [WorkOrderTask].
class TaskProduct {
  /// The task product line identifier.
  final String id;

  /// The inventory product identifier.
  final String productId;

  /// The requested or reserved quantity.
  final int quantity;

  /// The unit price of the product.
  final double unitPrice;

  /// The computed line total (`quantity * unitPrice`).
  final double totalAmount;

  /// Approval state (`PENDING_SUPERVISOR_CHECK`, `SENT_TO_CUSTOMER`,
  /// `CUSTOMER_APPROVED`, `CUSTOMER_REJECTED`).
  final String approvalStatus;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [TaskProduct].
  const TaskProduct({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.approvalStatus,
    this.createdAt,
  });
}

/// Represents an executable task inside a work order.
class WorkOrderTask {
  /// The unique task identifier.
  final String id;

  /// The parent work order identifier.
  final String workOrderId;

  /// The associated workshop service identifier.
  final String serviceId;

  /// The assigned mechanic identifier, if assigned.
  final String? assignedMechanicId;

  /// Task description.
  final String description;

  /// Task execution status (`PENDING`, `DOING`, `COMPLETED`).
  final String status;

  /// URLs of photographic evidence attached to the task.
  final List<String> evidenceImages;

  /// Timestamp when execution started.
  final DateTime? startedAt;

  /// Timestamp when execution completed.
  final DateTime? completedAt;

  /// Products/parts associated with this task.
  final List<TaskProduct> products;

  /// Total amount for this task.
  final double totalAmount;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [WorkOrderTask].
  const WorkOrderTask({
    required this.id,
    required this.workOrderId,
    required this.serviceId,
    this.assignedMechanicId,
    required this.description,
    required this.status,
    this.evidenceImages = const [],
    this.startedAt,
    this.completedAt,
    this.products = const [],
    this.totalAmount = 0.0,
    this.createdAt,
  });
}

/// Represents an immutable photographic evidence entry on a work order.
class WorkOrderEvidence {
  /// The evidence identifier.
  final String id;

  /// The parent work order identifier.
  final String workOrderId;

  /// Lifecycle stage (`RECEPTION`, `DIAGNOSIS`, `REPAIR`, `DELIVERY`).
  final String stage;

  /// The cloud media identifier.
  final String mediaId;

  /// The public image URL.
  final String imageUrl;

  /// Optional caption describing the photo.
  final String? caption;

  /// The user identifier of the uploader.
  final String uploadedBy;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Whether the evidence entry is immutable.
  final bool immutable;

  /// Creates a [WorkOrderEvidence].
  const WorkOrderEvidence({
    required this.id,
    required this.workOrderId,
    required this.stage,
    required this.mediaId,
    required this.imageUrl,
    this.caption,
    required this.uploadedBy,
    required this.createdAt,
    this.immutable = true,
  });
}

/// Represents a workshop service offered by a branch.
class WorkshopService {
  /// The unique service identifier.
  final String id;

  /// The branch identifier where this service is offered.
  final String branchId;

  /// The service display name.
  final String name;

  /// The base price of the service.
  final double price;

  /// Creates a [WorkshopService].
  const WorkshopService({
    required this.id,
    required this.branchId,
    required this.name,
    required this.price,
  });
}
