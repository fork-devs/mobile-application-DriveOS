import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';

/// Use case that manages work order tasks, mechanic assignments, and task
/// products.
class ManageWorkOrderTasks {
  final OperationsRepository _repository;

  /// Creates a [ManageWorkOrderTasks] use case.
  const ManageWorkOrderTasks(this._repository);

  /// Lists tasks belonging to [workOrderId].
  Future<List<WorkOrderTask>> list(String workOrderId) =>
      _repository.getWorkOrderTasks(workOrderId);

  /// Creates a new task inside [workOrderId].
  Future<WorkOrderTask> create({
    required String workOrderId,
    required String serviceId,
    required String description,
    List<String> evidenceImages = const [],
  }) {
    return _repository.createWorkOrderTask(
      workOrderId: workOrderId,
      serviceId: serviceId,
      description: description.trim(),
      evidenceImages: evidenceImages,
    );
  }

  /// Updates an existing task inside [workOrderId].
  Future<WorkOrderTask> update({
    required String workOrderId,
    required String taskId,
    required String serviceId,
    String? assignedMechanicId,
    required String description,
    List<String> evidenceImages = const [],
  }) {
    return _repository.updateWorkOrderTask(
      workOrderId: workOrderId,
      taskId: taskId,
      serviceId: serviceId,
      assignedMechanicId: assignedMechanicId,
      description: description.trim(),
      evidenceImages: evidenceImages,
    );
  }

  /// Deletes [taskId] from [workOrderId].
  Future<void> delete({
    required String workOrderId,
    required String taskId,
  }) {
    return _repository.deleteWorkOrderTask(
      workOrderId: workOrderId,
      taskId: taskId,
    );
  }

  /// Assigns [mechanicId] to [taskId].
  Future<WorkOrderTask> assignMechanic({
    required String taskId,
    required String mechanicId,
  }) {
    return _repository.assignMechanicToTask(
      taskId: taskId,
      mechanicId: mechanicId,
    );
  }

  /// Starts execution of [taskId].
  Future<WorkOrderTask> start(String taskId) => _repository.startTask(taskId);

  /// Completes execution of [taskId].
  Future<WorkOrderTask> complete(String taskId) =>
      _repository.completeTask(taskId);

  /// Reopens a completed [taskId].
  Future<WorkOrderTask> reopen(String taskId) => _repository.reopenTask(taskId);

  /// Adds or proposes a spare part on [taskId].
  Future<TaskProduct> addProduct({
    required String taskId,
    required String productId,
    required int quantity,
    required double unitPrice,
  }) {
    return _repository.addTaskProduct(
      taskId: taskId,
      productId: productId,
      quantity: quantity,
      unitPrice: unitPrice,
    );
  }

  /// Updates the quantity of [productId] on [taskId].
  Future<TaskProduct> updateProductQuantity({
    required String taskId,
    required String productId,
    required int quantity,
  }) {
    return _repository.updateTaskProductQuantity(
      taskId: taskId,
      productId: productId,
      quantity: quantity,
    );
  }

  /// Removes [productId] from [taskId].
  Future<void> deleteProduct({
    required String taskId,
    required String productId,
  }) {
    return _repository.deleteTaskProduct(
      taskId: taskId,
      productId: productId,
    );
  }

  /// Uploads photographic evidence at [filePath] for [taskId].
  Future<WorkOrderTask> uploadEvidence({
    required String workOrderId,
    required String taskId,
    required String filePath,
  }) {
    return _repository.uploadTaskEvidence(
      workOrderId: workOrderId,
      taskId: taskId,
      filePath: filePath,
    );
  }
}
