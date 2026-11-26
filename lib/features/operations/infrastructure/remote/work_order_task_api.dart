import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/remote/dtos/operations_dto.dart';

/// HTTP client for `erp-work-order-service` work order tasks and products.
class WorkOrderTaskApi {
  final ApiClient _apiClient;

  /// Creates a [WorkOrderTaskApi] backed by [_apiClient].
  const WorkOrderTaskApi(this._apiClient);

  /// Lists all tasks for [workOrderId].
  Future<List<WorkOrderTaskDto>> getWorkOrderTasks(String workOrderId) async {
    final response = await _apiClient.get(
      ApiConstants.workOrderTasks(workOrderId),
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => WorkOrderTaskDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Creates a task inside [workOrderId].
  Future<WorkOrderTaskDto> createWorkOrderTask({
    required String workOrderId,
    required String serviceId,
    required String description,
    List<String> evidenceImages = const [],
  }) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderTasks(workOrderId),
      body: {
        'serviceId': serviceId,
        'description': description,
        'evidenceImages': evidenceImages,
      },
    );
    return WorkOrderTaskDto.fromJson(response as Map<String, dynamic>);
  }

  /// Updates an existing task inside [workOrderId].
  Future<WorkOrderTaskDto> updateWorkOrderTask({
    required String workOrderId,
    required String taskId,
    required String serviceId,
    String? assignedMechanicId,
    required String description,
    List<String> evidenceImages = const [],
  }) async {
    final response = await _apiClient.put(
      ApiConstants.workOrderTaskById(workOrderId, taskId),
      body: {
        'serviceId': serviceId,
        'assignedMechanicId': ?assignedMechanicId,
        'description': description,
        'evidenceImages': evidenceImages,
      },
    );
    return WorkOrderTaskDto.fromJson(response as Map<String, dynamic>);
  }

  /// Deletes [taskId] from [workOrderId].
  Future<void> deleteWorkOrderTask({
    required String workOrderId,
    required String taskId,
  }) async {
    await _apiClient.delete(
      ApiConstants.workOrderTaskById(workOrderId, taskId),
    );
  }

  /// Assigns [mechanicId] to [taskId].
  Future<WorkOrderTaskDto> assignMechanicToTask({
    required String taskId,
    required String mechanicId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderTaskAssignMechanic(taskId),
      body: {'mechanicId': mechanicId},
    );
    return WorkOrderTaskDto.fromJson(response as Map<String, dynamic>);
  }

  /// Starts execution of [taskId].
  Future<WorkOrderTaskDto> startTask(String taskId) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderTaskStart(taskId),
    );
    return WorkOrderTaskDto.fromJson(response as Map<String, dynamic>);
  }

  /// Completes execution of [taskId].
  Future<WorkOrderTaskDto> completeTask(String taskId) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderTaskComplete(taskId),
    );
    return WorkOrderTaskDto.fromJson(response as Map<String, dynamic>);
  }

  /// Reopens a completed [taskId].
  Future<WorkOrderTaskDto> reopenTask(String taskId) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderTaskReopen(taskId),
    );
    return WorkOrderTaskDto.fromJson(response as Map<String, dynamic>);
  }

  /// Adds or proposes a spare part on [taskId].
  Future<TaskProductDto> addTaskProduct({
    required String taskId,
    required String productId,
    required int quantity,
    required double unitPrice,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderTaskProducts(taskId),
      body: {
        'productId': productId,
        'quantity': quantity,
        'unitPrice': unitPrice,
      },
    );
    return TaskProductDto.fromJson(response as Map<String, dynamic>);
  }

  /// Updates the quantity of [productId] on [taskId].
  Future<TaskProductDto> updateTaskProductQuantity({
    required String taskId,
    required String productId,
    required int quantity,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.workOrderTaskProductById(taskId, productId),
      body: {'quantity': quantity},
    );
    return TaskProductDto.fromJson(response as Map<String, dynamic>);
  }

  /// Removes [productId] from [taskId].
  Future<void> deleteTaskProduct({
    required String taskId,
    required String productId,
  }) async {
    await _apiClient.delete(
      ApiConstants.workOrderTaskProductById(taskId, productId),
    );
  }

  /// Uploads photographic evidence at [filePath] for [taskId].
  Future<WorkOrderTaskDto> uploadTaskEvidence({
    required String workOrderId,
    required String taskId,
    required String filePath,
  }) async {
    final response = await _apiClient.multipartPost(
      ApiConstants.workOrderTaskEvidence(workOrderId, taskId),
      filePath: filePath,
    );
    return WorkOrderTaskDto.fromJson(response as Map<String, dynamic>);
  }
}
