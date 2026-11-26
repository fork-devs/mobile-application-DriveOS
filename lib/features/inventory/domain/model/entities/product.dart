/// Represents a FIFO stock batch for an [InventoryProduct].
class ProductBatch {
  /// The unique batch identifier.
  final String id;

  /// The supplier or internal batch number.
  final String batchNumber;

  /// Initial quantity received in this batch.
  final int quantity;

  /// Remaining available quantity in this batch.
  final int remainingQuantity;

  /// Unit purchase cost.
  final double purchasePrice;

  /// Optional expiration timestamp.
  final DateTime? expirationDate;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [ProductBatch].
  const ProductBatch({
    required this.id,
    required this.batchNumber,
    required this.quantity,
    required this.remainingQuantity,
    required this.purchasePrice,
    this.expirationDate,
    this.createdAt,
  });
}

/// Represents a catalog product stocked in a workshop branch.
class InventoryProduct {
  /// The unique product identifier.
  final String id;

  /// The branch identifier where this product is stocked.
  final String branchId;

  /// The product category (e.g. `LUBRICANTES`).
  final String category;

  /// The product display name.
  final String name;

  /// The Stock Keeping Unit (SKU) code.
  final String sku;

  /// Optional product description.
  final String? description;

  /// Unit sale price.
  final double salePrice;

  /// Minimum stock threshold before triggering a low-stock alert.
  final int minimumStock;

  /// Current available stock quantity.
  final int currentStock;

  /// Whether [currentStock] is at or below [minimumStock].
  final bool lowStockAlert;

  /// Optional product image URL.
  final String? imageUrl;

  /// Stock batches associated with this product.
  final List<ProductBatch> batches;

  /// Creates an [InventoryProduct].
  const InventoryProduct({
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
}
