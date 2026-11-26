import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/remote/service_api.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/remote/work_order_api.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/remote/work_order_task_api.dart';

/// Concrete [OperationsRepository] backed by `erp-work-order-service` APIs.
class OperationsRepositoryImpl implements OperationsRepository {
  final WorkOrderApi _workOrderApi;
  final WorkOrderTaskApi _taskApi;
  final ServiceApi _serviceApi;

  /// Creates an [OperationsRepositoryImpl].
  const OperationsRepositoryImpl({
    required this._workOrderApi,
    required this._taskApi,
    required this._serviceApi,
  });

  @override
  Future<WorkOrder> openWorkOrder({
    required String customerId,
    required String vehicleId,
    required String branchId,
    String? mechanicId,
    required String diagnosis,
  }) async {
    final dto = await _workOrderApi.openWorkOrder(
      customerId: customerId,
      vehicleId: vehicleId,
      branchId: branchId,
      mechanicId: mechanicId,
      diagnosis: diagnosis,
    );
    return dto.toDomain();
  }

  @override
  Future<List<WorkOrder>> getWorkOrders({String? status}) async {
    final dtos = await _workOrderApi.getWorkOrders(status: status);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<WorkOrder>> getMyWorkOrders() async {
    final dtos = await _workOrderApi.getMyWorkOrders();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<WorkOrder> getWorkOrderById(String orderId) async {
    final dto = await _workOrderApi.getWorkOrderById(orderId);
    return dto.toDomain();
  }

  @override
  Future<WorkOrder> updateWorkOrder({
    required String orderId,
    String? diagnosticSummary,
    required String diagnosis,
    int? mileageIn,
  }) async {
    final dto = await _workOrderApi.updateWorkOrder(
      orderId: orderId,
      diagnosticSummary: diagnosticSummary,
      diagnosis: diagnosis,
      mileageIn: mileageIn,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deleteWorkOrder(String orderId) =>
      _workOrderApi.deleteWorkOrder(orderId);

  @override
  Future<List<String>> addWorkOrderItems({
    required String orderId,
    required List<WorkOrderItem> items,
  }) =>
      _workOrderApi.addWorkOrderItems(orderId: orderId, items: items);

  @override
  Future<WorkOrderTransitionResult> transitionWorkOrder({
    required String orderId,
    required String destination,
  }) async {
    final dto = await _workOrderApi.transitionWorkOrder(
      orderId: orderId,
      destination: destination,
    );
    return dto.toDomain();
  }

  @override
  Future<WorkOrderTransitionResult> completeWorkOrder(String orderId) async {
    final dto = await _workOrderApi.completeWorkOrder(orderId);
    return dto.toDomain();
  }

  @override
  Future<WorkOrderTransitionResult> quoteWorkOrder(String orderId) async {
    final dto = await _workOrderApi.quoteWorkOrder(orderId);
    return dto.toDomain();
  }

  @override
  Future<WorkOrderTransitionResult> approveWorkOrder(String orderId) async {
    final dto = await _workOrderApi.approveWorkOrder(orderId);
    return dto.toDomain();
  }

  @override
  Future<WorkOrderTransitionResult> rejectWorkOrder(String orderId) async {
    final dto = await _workOrderApi.rejectWorkOrder(orderId);
    return dto.toDomain();
  }

  @override
  Future<WorkOrderTransitionResult> cancelWorkOrder(String orderId) async {
    final dto = await _workOrderApi.cancelWorkOrder(orderId);
    return dto.toDomain();
  }

  @override
  Future<List<WorkOrderTask>> getWorkOrderTasks(String workOrderId) async {
    final dtos = await _taskApi.getWorkOrderTasks(workOrderId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<WorkOrderTask> createWorkOrderTask({
    required String workOrderId,
    required String serviceId,
    required String description,
    List<String> evidenceImages = const [],
  }) async {
    final dto = await _taskApi.createWorkOrderTask(
      workOrderId: workOrderId,
      serviceId: serviceId,
      description: description,
      evidenceImages: evidenceImages,
    );
    return dto.toDomain();
  }

  @override
  Future<WorkOrderTask> updateWorkOrderTask({
    required String workOrderId,
    required String taskId,
    required String serviceId,
    String? assignedMechanicId,
    required String description,
    List<String> evidenceImages = const [],
  }) async {
    final dto = await _taskApi.updateWorkOrderTask(
      workOrderId: workOrderId,
      taskId: taskId,
      serviceId: serviceId,
      assignedMechanicId: assignedMechanicId,
      description: description,
      evidenceImages: evidenceImages,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deleteWorkOrderTask({
    required String workOrderId,
    required String taskId,
  }) =>
      _taskApi.deleteWorkOrderTask(
        workOrderId: workOrderId,
        taskId: taskId,
      );

  @override
  Future<WorkOrderTask> assignMechanicToTask({
    required String taskId,
    required String mechanicId,
  }) async {
    final dto = await _taskApi.assignMechanicToTask(
      taskId: taskId,
      mechanicId: mechanicId,
    );
    return dto.toDomain();
  }

  @override
  Future<WorkOrderTask> startTask(String taskId) async {
    final dto = await _taskApi.startTask(taskId);
    return dto.toDomain();
  }

  @override
  Future<WorkOrderTask> completeTask(String taskId) async {
    final dto = await _taskApi.completeTask(taskId);
    return dto.toDomain();
  }

  @override
  Future<WorkOrderTask> reopenTask(String taskId) async {
    final dto = await _taskApi.reopenTask(taskId);
    return dto.toDomain();
  }

  @override
  Future<TaskProduct> addTaskProduct({
    required String taskId,
    required String productId,
    required int quantity,
    required double unitPrice,
  }) async {
    final dto = await _taskApi.addTaskProduct(
      taskId: taskId,
      productId: productId,
      quantity: quantity,
      unitPrice: unitPrice,
    );
    return dto.toDomain();
  }

  @override
  Future<TaskProduct> updateTaskProductQuantity({
    required String taskId,
    required String productId,
    required int quantity,
  }) async {
    final dto = await _taskApi.updateTaskProductQuantity(
      taskId: taskId,
      productId: productId,
      quantity: quantity,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deleteTaskProduct({
    required String taskId,
    required String productId,
  }) =>
      _taskApi.deleteTaskProduct(taskId: taskId, productId: productId);

  @override
  Future<WorkOrderTask> uploadTaskEvidence({
    required String workOrderId,
    required String taskId,
    required String filePath,
  }) async {
    final dto = await _taskApi.uploadTaskEvidence(
      workOrderId: workOrderId,
      taskId: taskId,
      filePath: filePath,
    );
    return dto.toDomain();
  }

  @override
  Future<List<TaskProduct>> sendSupplementsToCustomer(String orderId) async {
    final dtos = await _workOrderApi.sendSupplementsToCustomer(orderId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<TaskProduct>> approveSupplements(String orderId) async {
    final dtos = await _workOrderApi.approveSupplements(orderId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<TaskProduct>> rejectSupplements(String orderId) async {
    final dtos = await _workOrderApi.rejectSupplements(orderId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<WorkOrderEvidence> uploadWorkOrderEvidence({
    required String orderId,
    required String filePath,
    String stage = 'RECEPTION',
    String? caption,
  }) async {
    final dto = await _workOrderApi.uploadWorkOrderEvidence(
      orderId: orderId,
      filePath: filePath,
      stage: stage,
      caption: caption,
    );
    return dto.toDomain();
  }

  @override
  Future<List<WorkOrderEvidence>> getWorkOrderEvidences(String orderId) async {
    final dtos = await _workOrderApi.getWorkOrderEvidences(orderId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<WorkshopService> createService({
    required String branchId,
    required String name,
    required double price,
  }) async {
    final dto = await _serviceApi.createService(
      branchId: branchId,
      name: name,
      price: price,
    );
    return dto.toDomain();
  }

  @override
  Future<List<WorkshopService>> getServicesByBranch(String branchId) async {
    final dtos = await _serviceApi.getServicesByBranch(branchId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<WorkshopService> updateService({
    required String serviceId,
    required String name,
    required double price,
  }) async {
    final dto = await _serviceApi.updateService(
      serviceId: serviceId,
      name: name,
      price: price,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deleteService(String serviceId) =>
      _serviceApi.deleteService(serviceId);
}
