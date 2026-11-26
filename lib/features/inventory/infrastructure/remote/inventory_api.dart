import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/inventory/infrastructure/remote/dtos/inventory_dto.dart';

/// HTTP client for `erp-inventory-service` products, batches, spare parts,
/// and stock endpoints.
class InventoryApi {
  final ApiClient _apiClient;

  /// Creates an [InventoryApi] backed by [_apiClient].
  const InventoryApi(this._apiClient);

  /// Creates a new product in [branchId].
  Future<InventoryProductDto> createProduct({
    required String branchId,
    required String category,
    required String name,
    required String sku,
    String? description,
    required double salePrice,
    required int minimumStock,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.inventoryProducts,
      body: {
        'branchId': branchId,
        'category': category,
        'name': name,
        'sku': sku,
        'description': ?description,
        'salePrice': salePrice,
        'minimumStock': minimumStock,
      },
    );
    return InventoryProductDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists products for [branchId] with optional filters.
  Future<List<InventoryProductDto>> getProductsByBranch({
    required String branchId,
    String? category,
    bool? lowStockOnly,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.inventoryProducts,
      queryParameters: {
        'branchId': branchId,
        'category': ?category,
        if (lowStockOnly != null) 'lowStockOnly': lowStockOnly.toString(),
      },
    );
    final list = response as List<dynamic>;
    return list
        .map(
          (item) => InventoryProductDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Fetches a product by [productId].
  Future<InventoryProductDto> getProductById(String productId) async {
    final response = await _apiClient.get(
      ApiConstants.inventoryProductById(productId),
    );
    return InventoryProductDto.fromJson(response as Map<String, dynamic>);
  }

  /// Updates an existing product.
  Future<InventoryProductDto> updateProduct({
    required String productId,
    required String category,
    required String name,
    String? description,
    required double salePrice,
    required int minimumStock,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.inventoryProductById(productId),
      body: {
        'category': category,
        'name': name,
        'description': ?description,
        'salePrice': salePrice,
        'minimumStock': minimumStock,
      },
    );
    return InventoryProductDto.fromJson(response as Map<String, dynamic>);
  }

  /// Adds a FIFO purchase batch to [productId].
  Future<ProductBatchDto> addProductBatch({
    required String productId,
    required String batchNumber,
    required int quantity,
    required double purchasePrice,
    DateTime? expirationDate,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.inventoryProductBatches(productId),
      body: {
        'batchNumber': batchNumber,
        'quantity': quantity,
        'purchasePrice': purchasePrice,
        if (expirationDate != null)
          'expirationDate': expirationDate.toUtc().toIso8601String(),
      },
    );
    return ProductBatchDto.fromJson(response as Map<String, dynamic>);
  }

  /// Uploads a photo at [filePath] for [productId].
  Future<InventoryProductDto> uploadProductImage({
    required String productId,
    required String filePath,
  }) async {
    final response = await _apiClient.multipartPost(
      ApiConstants.inventoryProductImage(productId),
      filePath: filePath,
    );
    return InventoryProductDto.fromJson(response as Map<String, dynamic>);
  }

  /// Deletes [productId].
  Future<void> deleteProduct(String productId) async {
    await _apiClient.delete(ApiConstants.inventoryProductById(productId));
  }

  /// Registers a master spare part.
  Future<SparePartDto> createSparePart({
    required String sku,
    required String description,
    required int minStock,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.inventorySpareParts,
      body: {
        'sku': sku,
        'description': description,
        'minStock': minStock,
      },
    );
    return SparePartDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists all spare parts in the tenant.
  Future<List<SparePartDto>> getSpareParts() async {
    final response = await _apiClient.get(ApiConstants.inventorySpareParts);
    final list = response as List<dynamic>;
    return list
        .map((item) => SparePartDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetches a spare part by [sparePartId].
  Future<SparePartDto> getSparePartById(String sparePartId) async {
    final response = await _apiClient.get(
      ApiConstants.inventorySparePartById(sparePartId),
    );
    return SparePartDto.fromJson(response as Map<String, dynamic>);
  }

  /// Records a manual stock movement.
  Future<StockMovementDto> recordStockMovement({
    required String sparePartId,
    required String branchId,
    required String movementType,
    required int quantity,
    double? unitCost,
    String? referenceId,
    String? idempotencyKey,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.inventoryStockMovements,
      body: {
        'sparePartId': sparePartId,
        'branchId': branchId,
        'movementType': movementType,
        'quantity': quantity,
        'unitCost': ?unitCost,
        'referenceId': ?referenceId,
        'idempotencyKey': ?idempotencyKey,
      },
    );
    return StockMovementDto.fromJson(response as Map<String, dynamic>);
  }

  /// Reserves stock for [workOrderId].
  Future<StockMovementDto> reserveStock({
    required String sparePartId,
    required String branchId,
    required int quantity,
    required String workOrderId,
    String? idempotencyKey,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.inventoryStockReserve,
      body: {
        'sparePartId': sparePartId,
        'branchId': branchId,
        'quantity': quantity,
        'workOrderId': workOrderId,
        'idempotencyKey': ?idempotencyKey,
      },
    );
    return StockMovementDto.fromJson(response as Map<String, dynamic>);
  }

  /// Commits reserved stock for [workOrderId].
  Future<StockMovementDto> commitStock({
    required String sparePartId,
    required String branchId,
    required int quantity,
    required String workOrderId,
    String? idempotencyKey,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.inventoryStockCommit,
      body: {
        'sparePartId': sparePartId,
        'branchId': branchId,
        'quantity': quantity,
        'workOrderId': workOrderId,
        'idempotencyKey': ?idempotencyKey,
      },
    );
    return StockMovementDto.fromJson(response as Map<String, dynamic>);
  }

  /// Releases reserved stock for [workOrderId].
  Future<StockMovementDto> releaseStock({
    required String sparePartId,
    required String branchId,
    required int quantity,
    required String workOrderId,
    String? idempotencyKey,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.inventoryStockRelease,
      body: {
        'sparePartId': sparePartId,
        'branchId': branchId,
        'quantity': quantity,
        'workOrderId': workOrderId,
        'idempotencyKey': ?idempotencyKey,
      },
    );
    return StockMovementDto.fromJson(response as Map<String, dynamic>);
  }

  /// Fetches the current stock balance for [sparePartId] at [branchId].
  Future<StockBalanceDto> getStockBalance({
    required String sparePartId,
    required String branchId,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.inventoryStockBalance(sparePartId, branchId),
    );
    return StockBalanceDto.fromJson(response as Map<String, dynamic>);
  }
}
