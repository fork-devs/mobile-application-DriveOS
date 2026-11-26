import 'package:mobile_application_driveos/features/inventory/domain/inventory_domain.dart';
import 'package:mobile_application_driveos/features/inventory/infrastructure/remote/inventory_api.dart';

/// Concrete [InventoryRepository] backed by `erp-inventory-service` APIs.
class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryApi _inventoryApi;

  /// Creates an [InventoryRepositoryImpl].
  const InventoryRepositoryImpl({required this._inventoryApi});

  @override
  Future<InventoryProduct> createProduct({
    required String branchId,
    required String category,
    required String name,
    required String sku,
    String? description,
    required double salePrice,
    required int minimumStock,
  }) async {
    final dto = await _inventoryApi.createProduct(
      branchId: branchId,
      category: category,
      name: name,
      sku: sku,
      description: description,
      salePrice: salePrice,
      minimumStock: minimumStock,
    );
    return dto.toDomain();
  }

  @override
  Future<List<InventoryProduct>> getProductsByBranch({
    required String branchId,
    String? category,
    bool? lowStockOnly,
  }) async {
    final dtos = await _inventoryApi.getProductsByBranch(
      branchId: branchId,
      category: category,
      lowStockOnly: lowStockOnly,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<InventoryProduct> getProductById(String productId) async {
    final dto = await _inventoryApi.getProductById(productId);
    return dto.toDomain();
  }

  @override
  Future<InventoryProduct> updateProduct({
    required String productId,
    required String category,
    required String name,
    String? description,
    required double salePrice,
    required int minimumStock,
  }) async {
    final dto = await _inventoryApi.updateProduct(
      productId: productId,
      category: category,
      name: name,
      description: description,
      salePrice: salePrice,
      minimumStock: minimumStock,
    );
    return dto.toDomain();
  }

  @override
  Future<ProductBatch> addProductBatch({
    required String productId,
    required String batchNumber,
    required int quantity,
    required double purchasePrice,
    DateTime? expirationDate,
  }) async {
    final dto = await _inventoryApi.addProductBatch(
      productId: productId,
      batchNumber: batchNumber,
      quantity: quantity,
      purchasePrice: purchasePrice,
      expirationDate: expirationDate,
    );
    return dto.toDomain();
  }

  @override
  Future<InventoryProduct> uploadProductImage({
    required String productId,
    required String filePath,
  }) async {
    final dto = await _inventoryApi.uploadProductImage(
      productId: productId,
      filePath: filePath,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deleteProduct(String productId) =>
      _inventoryApi.deleteProduct(productId);

  @override
  Future<SparePart> createSparePart({
    required String sku,
    required String description,
    required int minStock,
  }) async {
    final dto = await _inventoryApi.createSparePart(
      sku: sku,
      description: description,
      minStock: minStock,
    );
    return dto.toDomain();
  }

  @override
  Future<List<SparePart>> getSpareParts() async {
    final dtos = await _inventoryApi.getSpareParts();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<SparePart> getSparePartById(String sparePartId) async {
    final dto = await _inventoryApi.getSparePartById(sparePartId);
    return dto.toDomain();
  }

  @override
  Future<StockMovement> recordStockMovement({
    required String sparePartId,
    required String branchId,
    required String movementType,
    required int quantity,
    double? unitCost,
    String? referenceId,
    String? idempotencyKey,
  }) async {
    final dto = await _inventoryApi.recordStockMovement(
      sparePartId: sparePartId,
      branchId: branchId,
      movementType: movementType,
      quantity: quantity,
      unitCost: unitCost,
      referenceId: referenceId,
      idempotencyKey: idempotencyKey,
    );
    return dto.toDomain();
  }

  @override
  Future<StockMovement> reserveStock({
    required String sparePartId,
    required String branchId,
    required int quantity,
    required String workOrderId,
    String? idempotencyKey,
  }) async {
    final dto = await _inventoryApi.reserveStock(
      sparePartId: sparePartId,
      branchId: branchId,
      quantity: quantity,
      workOrderId: workOrderId,
      idempotencyKey: idempotencyKey,
    );
    return dto.toDomain();
  }

  @override
  Future<StockMovement> commitStock({
    required String sparePartId,
    required String branchId,
    required int quantity,
    required String workOrderId,
    String? idempotencyKey,
  }) async {
    final dto = await _inventoryApi.commitStock(
      sparePartId: sparePartId,
      branchId: branchId,
      quantity: quantity,
      workOrderId: workOrderId,
      idempotencyKey: idempotencyKey,
    );
    return dto.toDomain();
  }

  @override
  Future<StockMovement> releaseStock({
    required String sparePartId,
    required String branchId,
    required int quantity,
    required String workOrderId,
    String? idempotencyKey,
  }) async {
    final dto = await _inventoryApi.releaseStock(
      sparePartId: sparePartId,
      branchId: branchId,
      quantity: quantity,
      workOrderId: workOrderId,
      idempotencyKey: idempotencyKey,
    );
    return dto.toDomain();
  }

  @override
  Future<StockBalance> getStockBalance({
    required String sparePartId,
    required String branchId,
  }) async {
    final dto = await _inventoryApi.getStockBalance(
      sparePartId: sparePartId,
      branchId: branchId,
    );
    return dto.toDomain();
  }
}
