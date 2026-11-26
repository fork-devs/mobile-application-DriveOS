import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';

/// Wire DTO representing a [WorkOrderItem].
class WorkOrderItemDto {
  /// Spare part identifier.
  final String sparePartId;

  /// Part quantity.
  final int quantity;

  /// Labor price.
  final double laborPrice;

  /// Creates a [WorkOrderItemDto].
  const WorkOrderItemDto({
    required this.sparePartId,
    required this.quantity,
    required this.laborPrice,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory WorkOrderItemDto.fromJson(Map<String, dynamic> json) {
    if (json case {'sparePartId': final String sparePartId}) {
      return WorkOrderItemDto(
        sparePartId: sparePartId,
        quantity: (json['quantity'] as num?)?.toInt() ?? 1,
        laborPrice: (json['laborPrice'] as num?)?.toDouble() ?? 0.0,
      );
    }
    throw const FormatException('Invalid or incomplete WorkOrderItem JSON.');
  }

  /// Converts this DTO into a [WorkOrderItem] domain entity.
  WorkOrderItem toDomain() => WorkOrderItem(
        sparePartId: sparePartId,
        quantity: quantity,
        laborPrice: laborPrice,
      );
}

/// Wire DTO representing a [WorkOrderHistoryEntry].
class WorkOrderHistoryEntryDto {
  /// Previous status.
  final String from;

  /// New status.
  final String to;

  /// User identifier.
  final String changedBy;

  /// Timestamp of the transition.
  final DateTime changedAt;

  /// Creates a [WorkOrderHistoryEntryDto].
  const WorkOrderHistoryEntryDto({
    required this.from,
    required this.to,
    required this.changedBy,
    required this.changedAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory WorkOrderHistoryEntryDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'from': final String from,
      'to': final String to,
      'changedAt': final String changedAtRaw,
    }) {
      return WorkOrderHistoryEntryDto(
        from: from,
        to: to,
        changedBy: json['changedBy']?.toString() ?? '',
        changedAt: DateTime.tryParse(changedAtRaw) ?? DateTime.now(),
      );
    }
    throw const FormatException(
      'Invalid or incomplete WorkOrderHistoryEntry JSON.',
    );
  }

  /// Converts this DTO into a [WorkOrderHistoryEntry] domain entity.
  WorkOrderHistoryEntry toDomain() => WorkOrderHistoryEntry(
        from: from,
        to: to,
        changedBy: changedBy,
        changedAt: changedAt,
      );
}

/// Wire DTO representing a `WorkOrder` summary or detail response.
class WorkOrderDto {
  /// Work order identifier.
  final String orderId;

  /// Human-readable number.
  final String number;

  /// Lifecycle status.
  final String status;

  /// Tenant identifier.
  final String? tenantId;

  /// Customer identifier.
  final String? customerId;

  /// Vehicle identifier.
  final String? vehicleId;

  /// Branch identifier.
  final String? branchId;

  /// Assigned mechanic identifier.
  final String? mechanicId;

  /// Diagnosis text.
  final String? diagnosis;

  /// Opened timestamp.
  final DateTime? openedAt;

  /// Closed timestamp.
  final DateTime? closedAt;

  /// Attached items.
  final List<WorkOrderItemDto> items;

  /// Transition history.
  final List<WorkOrderHistoryEntryDto> history;

  /// Creates a [WorkOrderDto].
  const WorkOrderDto({
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

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory WorkOrderDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'orderId': final String orderId,
      'number': final String number,
      'status': final String status,
    }) {
      final rawItems = json['items'];
      final items = rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(WorkOrderItemDto.fromJson)
                .toList()
          : const <WorkOrderItemDto>[];

      final rawHistory = json['history'];
      final history = rawHistory is List
          ? rawHistory
                .whereType<Map<String, dynamic>>()
                .map(WorkOrderHistoryEntryDto.fromJson)
                .toList()
          : const <WorkOrderHistoryEntryDto>[];

      return WorkOrderDto(
        orderId: orderId,
        number: number,
        status: status,
        tenantId: json['tenantId']?.toString(),
        customerId: json['customerId']?.toString(),
        vehicleId: json['vehicleId']?.toString(),
        branchId: json['branchId']?.toString(),
        mechanicId: json['mechanicId']?.toString(),
        diagnosis: json['diagnosis']?.toString(),
        openedAt: json['openedAt'] != null
            ? DateTime.tryParse(json['openedAt'].toString())
            : null,
        closedAt: json['closedAt'] != null
            ? DateTime.tryParse(json['closedAt'].toString())
            : null,
        items: items,
        history: history,
      );
    }
    throw const FormatException('Invalid or incomplete WorkOrder JSON.');
  }

  /// Converts this DTO into a [WorkOrder] domain entity.
  WorkOrder toDomain() => WorkOrder(
        orderId: orderId,
        number: number,
        status: status,
        tenantId: tenantId,
        customerId: customerId,
        vehicleId: vehicleId,
        branchId: branchId,
        mechanicId: mechanicId,
        diagnosis: diagnosis,
        openedAt: openedAt,
        closedAt: closedAt,
        items: items.map((item) => item.toDomain()).toList(),
        history: history.map((entry) => entry.toDomain()).toList(),
      );
}

/// Wire DTO representing a `WorkOrderTransitionResponse`.
class WorkOrderTransitionResultDto {
  /// Work order identifier.
  final String orderId;

  /// New status.
  final String status;

  /// Previous status.
  final String origin;

  /// Closure timestamp, if closed.
  final DateTime? closedAt;

  /// Creates a [WorkOrderTransitionResultDto].
  const WorkOrderTransitionResultDto({
    required this.orderId,
    required this.status,
    required this.origin,
    this.closedAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory WorkOrderTransitionResultDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'orderId': final String orderId,
      'status': final String status,
    }) {
      return WorkOrderTransitionResultDto(
        orderId: orderId,
        status: status,
        origin: json['origin']?.toString() ?? '',
        closedAt: json['closedAt'] != null
            ? DateTime.tryParse(json['closedAt'].toString())
            : null,
      );
    }
    throw const FormatException(
      'Invalid or incomplete WorkOrderTransition JSON.',
    );
  }

  /// Converts this DTO into a [WorkOrderTransitionResult] domain entity.
  WorkOrderTransitionResult toDomain() => WorkOrderTransitionResult(
        orderId: orderId,
        status: status,
        origin: origin,
        closedAt: closedAt,
      );
}

/// Wire DTO representing a `TaskProductResponse`.
class TaskProductDto {
  /// Line identifier.
  final String id;

  /// Product identifier.
  final String productId;

  /// Quantity.
  final int quantity;

  /// Unit price.
  final double unitPrice;

  /// Total line amount.
  final double totalAmount;

  /// Approval status.
  final String approvalStatus;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [TaskProductDto].
  const TaskProductDto({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.approvalStatus,
    this.createdAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory TaskProductDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'productId': final String productId,
    }) {
      return TaskProductDto(
        id: id,
        productId: productId,
        quantity: (json['quantity'] as num?)?.toInt() ?? 1,
        unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
        approvalStatus:
            json['approvalStatus']?.toString() ?? 'PENDING_SUPERVISOR_CHECK',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );
    }
    throw const FormatException('Invalid or incomplete TaskProduct JSON.');
  }

  /// Converts this DTO into a [TaskProduct] domain entity.
  TaskProduct toDomain() => TaskProduct(
        id: id,
        productId: productId,
        quantity: quantity,
        unitPrice: unitPrice,
        totalAmount: totalAmount,
        approvalStatus: approvalStatus,
        createdAt: createdAt,
      );
}

/// Wire DTO representing a `TaskResponse`.
class WorkOrderTaskDto {
  /// Task identifier.
  final String id;

  /// Parent work order identifier.
  final String workOrderId;

  /// Associated service identifier.
  final String serviceId;

  /// Assigned mechanic identifier.
  final String? assignedMechanicId;

  /// Task description.
  final String description;

  /// Task status.
  final String status;

  /// Evidence image URLs.
  final List<String> evidenceImages;

  /// Start timestamp.
  final DateTime? startedAt;

  /// Completion timestamp.
  final DateTime? completedAt;

  /// Associated products.
  final List<TaskProductDto> products;

  /// Task total amount.
  final double totalAmount;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [WorkOrderTaskDto].
  const WorkOrderTaskDto({
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

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory WorkOrderTaskDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'workOrderId': final String workOrderId,
      'serviceId': final String serviceId,
    }) {
      final rawImages = json['evidenceImages'];
      final images = rawImages is List
          ? rawImages.map((img) => img.toString()).toList()
          : const <String>[];

      final rawProducts = json['products'];
      final products = rawProducts is List
          ? rawProducts
                .whereType<Map<String, dynamic>>()
                .map(TaskProductDto.fromJson)
                .toList()
          : const <TaskProductDto>[];

      return WorkOrderTaskDto(
        id: id,
        workOrderId: workOrderId,
        serviceId: serviceId,
        assignedMechanicId: json['assignedMechanicId']?.toString(),
        description: json['description']?.toString() ?? '',
        status: json['status']?.toString() ?? 'PENDING',
        evidenceImages: images,
        startedAt: json['startedAt'] != null
            ? DateTime.tryParse(json['startedAt'].toString())
            : null,
        completedAt: json['completedAt'] != null
            ? DateTime.tryParse(json['completedAt'].toString())
            : null,
        products: products,
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );
    }
    throw const FormatException('Invalid or incomplete WorkOrderTask JSON.');
  }

  /// Converts this DTO into a [WorkOrderTask] domain entity.
  WorkOrderTask toDomain() => WorkOrderTask(
        id: id,
        workOrderId: workOrderId,
        serviceId: serviceId,
        assignedMechanicId: assignedMechanicId,
        description: description,
        status: status,
        evidenceImages: evidenceImages,
        startedAt: startedAt,
        completedAt: completedAt,
        products: products.map((product) => product.toDomain()).toList(),
        totalAmount: totalAmount,
        createdAt: createdAt,
      );
}

/// Wire DTO representing an `EvidenceResponse`.
class WorkOrderEvidenceDto {
  /// Evidence identifier.
  final String id;

  /// Parent work order identifier.
  final String workOrderId;

  /// Lifecycle stage.
  final String stage;

  /// Cloud media identifier.
  final String mediaId;

  /// Public image URL.
  final String imageUrl;

  /// Optional caption.
  final String? caption;

  /// Uploader user identifier.
  final String uploadedBy;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Whether the record is immutable.
  final bool immutable;

  /// Creates a [WorkOrderEvidenceDto].
  const WorkOrderEvidenceDto({
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

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory WorkOrderEvidenceDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'workOrderId': final String workOrderId,
      'imageUrl': final String imageUrl,
    }) {
      return WorkOrderEvidenceDto(
        id: id,
        workOrderId: workOrderId,
        stage: json['stage']?.toString() ?? 'RECEPTION',
        mediaId: json['mediaId']?.toString() ?? '',
        imageUrl: imageUrl,
        caption: json['caption']?.toString(),
        uploadedBy: json['uploadedBy']?.toString() ?? '',
        createdAt: json['createdAt'] != null
            ? (DateTime.tryParse(json['createdAt'].toString()) ??
                DateTime.now())
            : DateTime.now(),
        immutable: json['immutable'] != false,
      );
    }
    throw const FormatException(
      'Invalid or incomplete WorkOrderEvidence JSON.',
    );
  }

  /// Converts this DTO into a [WorkOrderEvidence] domain entity.
  WorkOrderEvidence toDomain() => WorkOrderEvidence(
        id: id,
        workOrderId: workOrderId,
        stage: stage,
        mediaId: mediaId,
        imageUrl: imageUrl,
        caption: caption,
        uploadedBy: uploadedBy,
        createdAt: createdAt,
        immutable: immutable,
      );
}

/// Wire DTO representing a `ServiceResponse`.
class WorkshopServiceDto {
  /// Service identifier.
  final String id;

  /// Branch identifier.
  final String branchId;

  /// Service name.
  final String name;

  /// Base price.
  final double price;

  /// Creates a [WorkshopServiceDto].
  const WorkshopServiceDto({
    required this.id,
    required this.branchId,
    required this.name,
    required this.price,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory WorkshopServiceDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'branchId': final String branchId,
      'name': final String name,
    }) {
      return WorkshopServiceDto(
        id: id,
        branchId: branchId,
        name: name,
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
      );
    }
    throw const FormatException('Invalid or incomplete WorkshopService JSON.');
  }

  /// Converts this DTO into a [WorkshopService] domain entity.
  WorkshopService toDomain() => WorkshopService(
        id: id,
        branchId: branchId,
        name: name,
        price: price,
      );
}
