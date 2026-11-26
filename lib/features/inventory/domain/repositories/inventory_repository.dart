import 'package:mobile_application_driveos/features/inventory/domain/model/entities/product.dart';
import 'package:mobile_application_driveos/features/inventory/domain/model/entities/spare_part_and_stock.dart';

/// Output port defining product catalog, batch, spare part, and stock
/// operations.
abstract interface class InventoryRepository {
  // Products & Batches
  /// Creates a new product in [branchId].
  Future<InventoryProduct> createProduct({
    required String branchId,
    required String category,
    required String name,
    required String sku,
    String? description,
    required double salePrice,
    required int minimumStock,
  });

  /// Lists products for [branchId], optionally filtered by [category] or
  /// [lowStockOnly].
  Future<List<InventoryProduct>> getProductsByBranch({
    required String branchId,
    String? category,
    bool? lowStockOnly,
  });

  /// Fetches a product by [productId].
  Future<InventoryProduct> getProductById(String productId);

  /// Updates an existing product identified by [productId].
  Future<InventoryProduct> updateProduct({
    required String productId,
    required String category,
    required String name,
    String? description,
    required double salePrice,
    required int minimumStock,
  });

  /// Adds a new FIFO purchase batch to [productId].
  Future<ProductBatch> addProductBatch({
    required String productId,
    required String batchNumber,
    required int quantity,
    required double purchasePrice,
    DateTime? expirationDate,
  });

  /// Uploads a photo at [filePath] for [productId].
  Future<InventoryProduct> uploadProductImage({
    required String productId,
    required String filePath,
  });

  /// Deletes a product by [productId].
  Future<void> deleteProduct(String productId);

  // Spare Parts
  /// Registers a master spare part in the tenant catalog.
  Future<SparePart> createSparePart({
    required String sku,
    required String description,
    required int minStock,
  });

  /// Lists all spare parts in the active tenant.
  Future<List<SparePart>> getSpareParts();

  /// Fetches a spare part by [sparePartId].
  Future<SparePart> getSparePartById(String sparePartId);

  // Stock Movements & Saga Reservations
  /// Records a manual stock movement (`IN`, `OUT`, `ADJUSTMENT`).
  Future<StockMovement> recordStockMovement({
    required String sparePartId,
    required String branchId,
    required String movementType,
    required int quantity,
    double? unitCost,
    String? referenceId,
    String? idempotencyKey,
  });

  /// Reserves stock for a work order.
  Future<StockMovement> reserveStock({
    required String sparePartId,
    required String branchId,
    required int quantity,
    required String workOrderId,
    String? idempotencyKey,
  });

  /// Commits a previously reserved stock quantity.
  Future<StockMovement> commitStock({
    required String sparePartId,
    required String branchId,
    required int quantity,
    required String workOrderId,
    String? idempotencyKey,
  });

  /// Releases a previously reserved stock quantity.
  Future<StockMovement> releaseStock({
    required String sparePartId,
    required String branchId,
    required int quantity,
    required String workOrderId,
    String? idempotencyKey,
  });

  /// Fetches the current stock balance for [sparePartId] at [branchId].
  Future<StockBalance> getStockBalance({
    required String sparePartId,
    required String branchId,
  });
}
