/// Represents a master spare part definition in the tenant catalog.
class SparePart {
  /// The unique spare part identifier.
  final String id;

  /// The owning tenant identifier.
  final String tenantId;

  /// The SKU code.
  final String sku;

  /// The spare part description.
  final String description;

  /// Minimum stock threshold.
  final int minStock;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [SparePart].
  const SparePart({
    required this.id,
    required this.tenantId,
    required this.sku,
    required this.description,
    required this.minStock,
    this.createdAt,
  });
}

/// Represents a stock movement or Saga reservation record.
class StockMovement {
  /// The movement identifier.
  final String id;

  /// The tenant identifier.
  final String tenantId;

  /// The spare part identifier.
  final String sparePartId;

  /// The branch identifier.
  final String branchId;

  /// Movement type (`IN`, `OUT`, `ADJUSTMENT`, `RESERVE`, `COMMIT`, `RELEASE`).
  final String movementType;

  /// Quantity moved or reserved.
  final int quantity;

  /// Optional reference identifier (e.g. work order ID).
  final String? referenceId;

  /// Optional idempotency key.
  final String? idempotencyKey;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [StockMovement].
  const StockMovement({
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
}

/// Represents the current stock balance for a spare part in a branch.
class StockBalance {
  /// The spare part identifier.
  final String sparePartId;

  /// The branch identifier.
  final String branchId;

  /// Total units received.
  final int totalIn;

  /// Total units consumed.
  final int totalOut;

  /// Total units currently reserved.
  final int totalReserved;

  /// Units available for new reservations or consumption.
  final int availableStock;

  /// Creates a [StockBalance].
  const StockBalance({
    required this.sparePartId,
    required this.branchId,
    required this.totalIn,
    required this.totalOut,
    required this.totalReserved,
    required this.availableStock,
  });
}
