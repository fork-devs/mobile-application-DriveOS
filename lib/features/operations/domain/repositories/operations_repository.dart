import 'package:mobile_application_driveos/features/operations/domain/model/entities/work_order.dart';
import 'package:mobile_application_driveos/features/operations/domain/model/entities/work_order_task.dart';

/// Output port defining work orders, tasks, supplements, evidences, and
/// workshop services operations.
abstract interface class OperationsRepository {
  // Work Orders
  /// Opens a new work order.
  Future<WorkOrder> openWorkOrder({
    required String customerId,
    required String vehicleId,
    required String branchId,
    String? mechanicId,
    required String diagnosis,
  });

  /// Lists work orders in the tenant, optionally filtered by [status].
  Future<List<WorkOrder>> getWorkOrders({String? status});

  /// Lists work orders belonging to the authenticated customer (`/me`).
  Future<List<WorkOrder>> getMyWorkOrders();

  /// Fetches full work order details by [orderId].
  Future<WorkOrder> getWorkOrderById(String orderId);

  /// Updates diagnostic summary, diagnosis, or intake mileage.
  Future<WorkOrder> updateWorkOrder({
    required String orderId,
    String? diagnosticSummary,
    required String diagnosis,
    int? mileageIn,
  });

  /// Deletes a work order by [orderId].
  Future<void> deleteWorkOrder(String orderId);

  /// Adds spare parts and labor items to [orderId], returning created IDs.
  Future<List<String>> addWorkOrderItems({
    required String orderId,
    required List<WorkOrderItem> items,
  });

  /// Transitions [orderId] to [destination] status.
  Future<WorkOrderTransitionResult> transitionWorkOrder({
    required String orderId,
    required String destination,
  });

  /// Marks [orderId] as completed.
  Future<WorkOrderTransitionResult> completeWorkOrder(String orderId);

  /// Moves [orderId] to quoted status.
  Future<WorkOrderTransitionResult> quoteWorkOrder(String orderId);

  /// Approves [orderId] for execution.
  Future<WorkOrderTransitionResult> approveWorkOrder(String orderId);

  /// Rejects [orderId].
  Future<WorkOrderTransitionResult> rejectWorkOrder(String orderId);

  /// Cancels [orderId].
  Future<WorkOrderTransitionResult> cancelWorkOrder(String orderId);

  // Tasks
  /// Lists all tasks for [workOrderId].
  Future<List<WorkOrderTask>> getWorkOrderTasks(String workOrderId);

  /// Creates a new task inside [workOrderId].
  Future<WorkOrderTask> createWorkOrderTask({
    required String workOrderId,
    required String serviceId,
    required String description,
    List<String> evidenceImages = const [],
  });

  /// Updates an existing task inside [workOrderId].
  Future<WorkOrderTask> updateWorkOrderTask({
    required String workOrderId,
    required String taskId,
    required String serviceId,
    String? assignedMechanicId,
    required String description,
    List<String> evidenceImages = const [],
  });

  /// Deletes [taskId] from [workOrderId].
  Future<void> deleteWorkOrderTask({
    required String workOrderId,
    required String taskId,
  });

  /// Assigns [mechanicId] to [taskId].
  Future<WorkOrderTask> assignMechanicToTask({
    required String taskId,
    required String mechanicId,
  });

  /// Starts execution of [taskId].
  Future<WorkOrderTask> startTask(String taskId);

  /// Completes execution of [taskId].
  Future<WorkOrderTask> completeTask(String taskId);

  /// Reopens a completed [taskId].
  Future<WorkOrderTask> reopenTask(String taskId);

  /// Adds or proposes a product/spare part on [taskId].
  Future<TaskProduct> addTaskProduct({
    required String taskId,
    required String productId,
    required int quantity,
    required double unitPrice,
  });

  /// Updates the quantity of [productId] on [taskId].
  Future<TaskProduct> updateTaskProductQuantity({
    required String taskId,
    required String productId,
    required int quantity,
  });

  /// Removes [productId] from [taskId].
  Future<void> deleteTaskProduct({
    required String taskId,
    required String productId,
  });

  /// Uploads photographic evidence at [filePath] for [taskId].
  Future<WorkOrderTask> uploadTaskEvidence({
    required String workOrderId,
    required String taskId,
    required String filePath,
  });

  // Supplements & Evidences
  /// Sends pending supervisor-checked supplements on [orderId] to the customer.
  Future<List<TaskProduct>> sendSupplementsToCustomer(String orderId);

  /// Approves pending supplements on [orderId].
  Future<List<TaskProduct>> approveSupplements(String orderId);

  /// Rejects pending supplements on [orderId].
  Future<List<TaskProduct>> rejectSupplements(String orderId);

  /// Uploads an immutable vehicle evidence photo to [orderId].
  Future<WorkOrderEvidence> uploadWorkOrderEvidence({
    required String orderId,
    required String filePath,
    String stage = 'RECEPTION',
    String? caption,
  });

  /// Lists the chronological evidence timeline for [orderId].
  Future<List<WorkOrderEvidence>> getWorkOrderEvidences(String orderId);

  // Workshop Services
  /// Creates a service in the catalog for [branchId].
  Future<WorkshopService> createService({
    required String branchId,
    required String name,
    required double price,
  });

  /// Lists catalog services for [branchId].
  Future<List<WorkshopService>> getServicesByBranch(String branchId);

  /// Updates an existing catalog service.
  Future<WorkshopService> updateService({
    required String serviceId,
    required String name,
    required double price,
  });

  /// Deletes a catalog service by [serviceId].
  Future<void> deleteService(String serviceId);
}
