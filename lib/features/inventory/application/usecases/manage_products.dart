import 'package:mobile_application_driveos/features/inventory/domain/inventory_domain.dart';

/// Use case that manages branch inventory products and FIFO purchase batches.
class ManageInventoryProducts {
  final InventoryRepository _repository;

  /// Creates a [ManageInventoryProducts] use case.
  const ManageInventoryProducts(this._repository);

  /// Creates a new catalog product in [branchId].
  Future<InventoryProduct> create({
    required String branchId,
    required String category,
    required String name,
    required String sku,
    String? description,
    required double salePrice,
    required int minimumStock,
  }) {
    return _repository.createProduct(
      branchId: branchId,
      category: category.trim().toUpperCase(),
      name: name.trim(),
      sku: sku.trim().toUpperCase(),
      description: description?.trim(),
      salePrice: salePrice,
      minimumStock: minimumStock,
    );
  }

  /// Lists products for [branchId] with optional [category] and [lowStockOnly]
  /// filters.
  Future<List<InventoryProduct>> listByBranch({
    required String branchId,
    String? category,
    bool? lowStockOnly,
  }) {
    return _repository.getProductsByBranch(
      branchId: branchId,
      category: category?.trim().toUpperCase(),
      lowStockOnly: lowStockOnly,
    );
  }

  /// Fetches a product by [productId].
  Future<InventoryProduct> getById(String productId) =>
      _repository.getProductById(productId);

  /// Updates an existing product identified by [productId].
  Future<InventoryProduct> update({
    required String productId,
    required String category,
    required String name,
    String? description,
    required double salePrice,
    required int minimumStock,
  }) {
    return _repository.updateProduct(
      productId: productId,
      category: category.trim().toUpperCase(),
      name: name.trim(),
      description: description?.trim(),
      salePrice: salePrice,
      minimumStock: minimumStock,
    );
  }

  /// Adds a FIFO purchase batch to [productId].
  Future<ProductBatch> addBatch({
    required String productId,
    required String batchNumber,
    required int quantity,
    required double purchasePrice,
    DateTime? expirationDate,
  }) {
    return _repository.addProductBatch(
      productId: productId,
      batchNumber: batchNumber.trim().toUpperCase(),
      quantity: quantity,
      purchasePrice: purchasePrice,
      expirationDate: expirationDate,
    );
  }

  /// Uploads a photo at [filePath] for [productId].
  Future<InventoryProduct> uploadImage({
    required String productId,
    required String filePath,
  }) {
    return _repository.uploadProductImage(
      productId: productId,
      filePath: filePath,
    );
  }

  /// Deletes [productId].
  Future<void> delete(String productId) => _repository.deleteProduct(productId);
}
