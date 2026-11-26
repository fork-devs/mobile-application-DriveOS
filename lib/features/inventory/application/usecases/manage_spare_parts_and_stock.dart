import 'package:mobile_application_driveos/features/inventory/domain/inventory_domain.dart';

/// Use case that manages master spare parts and stock movements/reservations.
class ManageSparePartsAndStock {
  final InventoryRepository _repository;

  /// Creates a [ManageSparePartsAndStock] use case.
  const ManageSparePartsAndStock(this._repository);

  /// Registers a master spare part.
  Future<SparePart> createSparePart({
    required String sku,
    required String description,
    required int minStock,
  }) {
    return _repository.createSparePart(
      sku: sku.trim().toUpperCase(),
      description: description.trim(),
      minStock: minStock,
    );
  }

  /// Lists all spare parts in the tenant.
  Future<List<SparePart>> listSpareParts() => _repository.getSpareParts();

  /// Fetches a spare part by [sparePartId].
  Future<SparePart> getSparePartById(String sparePartId) =>
      _repository.getSparePartById(sparePartId);

  /// Records a manual stock movement (`IN`, `OUT`, `ADJUSTMENT`).
  Future<StockMovement> recordMovement({
    required String sparePartId,
    required String branchId,
    required String movementType,
    required int quantity,
    double? unitCost,
    String? referenceId,
    String? idempotencyKey,
  }) {
    return _repository.recordStockMovement(
      sparePartId: sparePartId,
      branchId: branchId,
      movementType: movementType.trim().toUpperCase(),
      quantity: quantity,
      unitCost: unitCost,
      referenceId: referenceId,
      idempotencyKey: idempotencyKey,
    );
  }

  /// Reserves stock for a work order.
  Future<StockMovement> reserve({
    required String sparePartId,
    required String branchId,
    required int quantity,
    required String workOrderId,
    String? idempotencyKey,
  }) {
    return _repository.reserveStock(
      sparePartId: sparePartId,
      branchId: branchId,
      quantity: quantity,
      workOrderId: workOrderId,
      idempotencyKey: idempotencyKey,
    );
  }

  /// Commits a previously reserved stock quantity.
  Future<StockMovement> commit({
    required String sparePartId,
    required String branchId,
    required int quantity,
    required String workOrderId,
    String? idempotencyKey,
  }) {
    return _repository.commitStock(
      sparePartId: sparePartId,
      branchId: branchId,
      quantity: quantity,
      workOrderId: workOrderId,
      idempotencyKey: idempotencyKey,
    );
  }

  /// Releases a previously reserved stock quantity.
  Future<StockMovement> release({
    required String sparePartId,
    required String branchId,
    required int quantity,
    required String workOrderId,
    String? idempotencyKey,
  }) {
    return _repository.releaseStock(
      sparePartId: sparePartId,
      branchId: branchId,
      quantity: quantity,
      workOrderId: workOrderId,
      idempotencyKey: idempotencyKey,
    );
  }

  /// Returns the current stock balance for [sparePartId] at [branchId].
  Future<StockBalance> getBalance({
    required String sparePartId,
    required String branchId,
  }) {
    return _repository.getStockBalance(
      sparePartId: sparePartId,
      branchId: branchId,
    );
  }
}
