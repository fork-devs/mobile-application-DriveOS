import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';

/// Use case that opens, retrieves, updates, and deletes work orders.
class ManageWorkOrders {
  final OperationsRepository _repository;

  /// Creates a [ManageWorkOrders] use case.
  const ManageWorkOrders(this._repository);

  /// Opens a new work order.
  Future<WorkOrder> open({
    required String customerId,
    required String vehicleId,
    required String branchId,
    String? mechanicId,
    required String diagnosis,
  }) {
    return _repository.openWorkOrder(
      customerId: customerId,
      vehicleId: vehicleId,
      branchId: branchId,
      mechanicId: mechanicId,
      diagnosis: diagnosis.trim(),
    );
  }

  /// Lists work orders, optionally filtered by [status].
  Future<List<WorkOrder>> list({String? status}) =>
      _repository.getWorkOrders(status: status);

  /// Lists work orders belonging to the authenticated customer.
  Future<List<WorkOrder>> listMine() => _repository.getMyWorkOrders();

  /// Fetches full work order details for [orderId].
  Future<WorkOrder> getById(String orderId) =>
      _repository.getWorkOrderById(orderId);

  /// Updates diagnostic metadata for [orderId].
  Future<WorkOrder> update({
    required String orderId,
    String? diagnosticSummary,
    required String diagnosis,
    int? mileageIn,
  }) {
    return _repository.updateWorkOrder(
      orderId: orderId,
      diagnosticSummary: diagnosticSummary?.trim(),
      diagnosis: diagnosis.trim(),
      mileageIn: mileageIn,
    );
  }

  /// Deletes [orderId].
  Future<void> delete(String orderId) => _repository.deleteWorkOrder(orderId);

  /// Attaches [items] to [orderId].
  Future<List<String>> addItems({
    required String orderId,
    required List<WorkOrderItem> items,
  }) {
    return _repository.addWorkOrderItems(orderId: orderId, items: items);
  }

  /// Transitions [orderId] to [destination].
  Future<WorkOrderTransitionResult> transition({
    required String orderId,
    required String destination,
  }) {
    return _repository.transitionWorkOrder(
      orderId: orderId,
      destination: destination.trim().toUpperCase(),
    );
  }

  /// Marks [orderId] as completed.
  Future<WorkOrderTransitionResult> complete(String orderId) =>
      _repository.completeWorkOrder(orderId);

  /// Moves [orderId] to quoted status.
  Future<WorkOrderTransitionResult> quote(String orderId) =>
      _repository.quoteWorkOrder(orderId);

  /// Approves [orderId].
  Future<WorkOrderTransitionResult> approve(String orderId) =>
      _repository.approveWorkOrder(orderId);

  /// Rejects [orderId].
  Future<WorkOrderTransitionResult> reject(String orderId) =>
      _repository.rejectWorkOrder(orderId);

  /// Cancels [orderId].
  Future<WorkOrderTransitionResult> cancel(String orderId) =>
      _repository.cancelWorkOrder(orderId);
}
