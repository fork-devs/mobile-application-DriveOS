import 'package:mobile_application_driveos/features/inventory/domain/inventory_domain.dart';

/// Wire DTO representing a `ProductBatchResponse`.
class ProductBatchDto {
  /// Batch identifier.
  final String id;

  /// Batch number.
  final String batchNumber;

  /// Initial quantity.
  final int quantity;

  /// Remaining quantity.
  final int remainingQuantity;

  /// Purchase price.
  final double purchasePrice;

  /// Optional expiration timestamp.
  final DateTime? expirationDate;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [ProductBatchDto].
  const ProductBatchDto({
    required this.id,
    required this.batchNumber,
    required this.quantity,
    required this.remainingQuantity,
    required this.purchasePrice,
    this.expirationDate,
    this.createdAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory ProductBatchDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'batchNumber': final String batchNumber,
    }) {
      return ProductBatchDto(
        id: id,
        batchNumber: batchNumber,
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        remainingQuantity: (json['remainingQuantity'] as num?)?.toInt() ?? 0,
        purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.0,
        expirationDate: json['expirationDate'] != null
            ? DateTime.tryParse(json['expirationDate'].toString())
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );
    }
    throw const FormatException('Invalid or incomplete ProductBatch JSON.');
  }

  /// Converts this DTO into a [ProductBatch] domain entity.
  ProductBatch toDomain() => ProductBatch(
        id: id,
        batchNumber: batchNumber,
        quantity: quantity,
        remainingQuantity: remainingQuantity,
        purchasePrice: purchasePrice,
        expirationDate: expirationDate,
        createdAt: createdAt,
      );
}

/// Wire DTO representing a `ProductResponse`.
class InventoryProductDto {
  /// Product identifier.
  final String id;

  /// Branch identifier.
  final String branchId;

  /// Category code.
  final String category;

  /// Display name.
  final String name;

  /// SKU code.
  final String sku;

  /// Optional description.
  final String? description;

  /// Sale price.
  final double salePrice;

  /// Minimum stock threshold.
  final int minimumStock;

  /// Current stock quantity.
  final int currentStock;

  /// Low stock alert flag.
  final bool lowStockAlert;

  /// Optional image URL.
  final String? imageUrl;

  /// Associated batches.
  final List<ProductBatchDto> batches;

  /// Creates an [InventoryProductDto].
  const InventoryProductDto({
    required this.id,
    required this.branchId,
    required this.category,
    required this.name,
    required this.sku,
    this.description,
    required this.salePrice,
    required this.minimumStock,
    required this.currentStock,
    required this.lowStockAlert,
    this.imageUrl,
    this.batches = const [],
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory InventoryProductDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'branchId': final String branchId,
      'name': final String name,
      'sku': final String sku,
    }) {
      final rawBatches = json['batches'];
      final batches = rawBatches is List
          ? rawBatches
                .whereType<Map<String, dynamic>>()
                .map(ProductBatchDto.fromJson)
                .toList()
          : const <ProductBatchDto>[];

      return InventoryProductDto(
        id: id,
        branchId: branchId,
        category: json['category']?.toString() ?? '',
        name: name,
        sku: sku,
        description: json['description']?.toString(),
        salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
        minimumStock: (json['minimumStock'] as num?)?.toInt() ?? 0,
        currentStock: (json['currentStock'] as num?)?.toInt() ?? 0,
        lowStockAlert: json['lowStockAlert'] == true,
        imageUrl: json['imageUrl']?.toString(),
        batches: batches,
      );
    }
    throw const FormatException('Invalid or incomplete Product JSON.');
  }

  /// Converts this DTO into an [InventoryProduct] domain entity.
  InventoryProduct toDomain() => InventoryProduct(
        id: id,
        branchId: branchId,
        category: category,
        name: name,
        sku: sku,
        description: description,
        salePrice: salePrice,
        minimumStock: minimumStock,
        currentStock: currentStock,
        lowStockAlert: lowStockAlert,
        imageUrl: imageUrl,
        batches: batches.map((batch) => batch.toDomain()).toList(),
      );
}

/// Wire DTO representing a `SparePartResponse`.
class SparePartDto {
  /// Spare part identifier.
  final String id;

  /// Tenant identifier.
  final String tenantId;

  /// SKU code.
  final String sku;

  /// Description.
  final String description;

  /// Minimum stock threshold.
  final int minStock;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [SparePartDto].
  const SparePartDto({
    required this.id,
    required this.tenantId,
    required this.sku,
    required this.description,
    required this.minStock,
    this.createdAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory SparePartDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'tenantId': final String tenantId,
      'sku': final String sku,
    }) {
      return SparePartDto(
        id: id,
        tenantId: tenantId,
        sku: sku,
        description: json['description']?.toString() ?? '',
        minStock: (json['minStock'] as num?)?.toInt() ?? 0,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );
    }
    throw const FormatException('Invalid or incomplete SparePart JSON.');
  }

  /// Converts this DTO into a [SparePart] domain entity.
  SparePart toDomain() => SparePart(
        id: id,
        tenantId: tenantId,
        sku: sku,
        description: description,
        minStock: minStock,
        createdAt: createdAt,
      );
}

/// Wire DTO representing a `StockMovementResponse`.
class StockMovementDto {
  /// Movement identifier.
  final String id;

  /// Tenant identifier.
  final String tenantId;

  /// Spare part identifier.
  final String sparePartId;

  /// Branch identifier.
  final String branchId;

  /// Movement type.
  final String movementType;

  /// Quantity.
  final int quantity;

  /// Optional reference identifier.
  final String? referenceId;

  /// Optional idempotency key.
  final String? idempotencyKey;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [StockMovementDto].
  const StockMovementDto({
    required this.id,
    required this.tenantId,
    required this.sparePartId,
    required this.branchId,
    required this.movementType,
    required this.quantity,
    this.referenceId,
    this.idempotencyKey,
    this.createdAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory StockMovementDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'tenantId': final String tenantId,
      'sparePartId': final String sparePartId,
      'branchId': final String branchId,
      'movementType': final String movementType,
    }) {
      return StockMovementDto(
        id: id,
        tenantId: tenantId,
        sparePartId: sparePartId,
        branchId: branchId,
        movementType: movementType,
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        referenceId: json['referenceId']?.toString(),
        idempotencyKey: json['idempotencyKey']?.toString(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );
    }
    throw const FormatException('Invalid or incomplete StockMovement JSON.');
  }

  /// Converts this DTO into a [StockMovement] domain entity.
  StockMovement toDomain() => StockMovement(
        id: id,
        tenantId: tenantId,
        sparePartId: sparePartId,
        branchId: branchId,
        movementType: movementType,
        quantity: quantity,
        referenceId: referenceId,
        idempotencyKey: idempotencyKey,
        createdAt: createdAt,
      );
}

/// Wire DTO representing a `StockBalanceResponse`.
class StockBalanceDto {
  /// Spare part identifier.
  final String sparePartId;

  /// Branch identifier.
  final String branchId;

  /// Total inbound units.
  final int totalIn;

  /// Total outbound units.
  final int totalOut;

  /// Total reserved units.
  final int totalReserved;

  /// Available units.
  final int availableStock;

  /// Creates a [StockBalanceDto].
  const StockBalanceDto({
    required this.sparePartId,
    required this.branchId,
    required this.totalIn,
    required this.totalOut,
    required this.totalReserved,
    required this.availableStock,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory StockBalanceDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'sparePartId': final String sparePartId,
      'branchId': final String branchId,
    }) {
      return StockBalanceDto(
        sparePartId: sparePartId,
        branchId: branchId,
        totalIn: (json['totalIn'] as num?)?.toInt() ?? 0,
        totalOut: (json['totalOut'] as num?)?.toInt() ?? 0,
        totalReserved: (json['totalReserved'] as num?)?.toInt() ?? 0,
        availableStock: (json['availableStock'] as num?)?.toInt() ?? 0,
      );
    }
    throw const FormatException('Invalid or incomplete StockBalance JSON.');
  }

  /// Converts this DTO into a [StockBalance] domain entity.
  StockBalance toDomain() => StockBalance(
        sparePartId: sparePartId,
        branchId: branchId,
        totalIn: totalIn,
        totalOut: totalOut,
        totalReserved: totalReserved,
        availableStock: availableStock,
      );
}
