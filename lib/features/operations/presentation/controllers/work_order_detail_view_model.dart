import 'package:flutter/foundation.dart';
import 'package:mobile_application_driveos/features/operations/application/operations_application.dart';
import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';

/// Presentation ViewModel managing a single work order's tasks, transitions,
/// and evidence timeline.
class WorkOrderDetailViewModel extends ChangeNotifier {
  final ManageWorkOrders _manageWorkOrders;
  final ManageWorkOrderTasks _manageTasks;
  final ManageEvidencesAndSupplements? _manageEvidences;

  /// Creates a [WorkOrderDetailViewModel].
  WorkOrderDetailViewModel({
    required this._manageWorkOrders,
    required this._manageTasks,
    this._manageEvidences,
  });

  /// Whether work order details are loading.
  bool isLoading = false;

  /// Latest error message, if any.
  String? errorMessage;

  /// Loaded work order aggregate.
  WorkOrder? order;

  /// Tasks attached to [order].
  List<WorkOrderTask> tasks = const [];

  /// Chronological photographic evidence timeline for [order].
  List<WorkOrderEvidence> evidences = const [];

  /// Loads work order details, tasks, and evidences for [workOrderId].
  Future<void> loadOrder(String workOrderId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final orderFuture = _manageWorkOrders.getById(workOrderId);
      final tasksFuture = _manageTasks.list(workOrderId);
      final evidencesFuture = _manageEvidences != null
          ? _manageEvidences
              .listEvidences(workOrderId)
              .catchError((_) => <WorkOrderEvidence>[])
          : Future.value(<WorkOrderEvidence>[]);

      final results =
          await Future.wait([orderFuture, tasksFuture, evidencesFuture]);
      order = results[0] as WorkOrder;
      tasks = results[1] as List<WorkOrderTask>;
      evidences = results[2] as List<WorkOrderEvidence>;
      isLoading = false;
      notifyListeners();
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a task inside the active work order.
  Future<bool> addTask({
    required String serviceId,
    required String description,
  }) async {
    final currentOrder = order;
    if (currentOrder == null) return false;

    try {
      final created = await _manageTasks.create(
        workOrderId: currentOrder.orderId,
        serviceId: serviceId,
        description: description,
      );
      tasks = [...tasks, created];
      notifyListeners();
      return true;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Starts [taskId].
  Future<void> startTask(String taskId) =>
      _mutateTask(() => _manageTasks.start(taskId));

  /// Completes [taskId].
  Future<void> completeTask(String taskId) =>
      _mutateTask(() => _manageTasks.complete(taskId));

  /// Reopens [taskId].
  Future<void> reopenTask(String taskId) =>
      _mutateTask(() => _manageTasks.reopen(taskId));

  Future<void> _mutateTask(Future<WorkOrderTask> Function() action) async {
    try {
      final updated = await action();
      tasks = tasks.map((t) => t.id == updated.id ? updated : t).toList();
      notifyListeners();
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  /// Marks the active work order as completed.
  Future<bool> completeWorkOrder() async {
    final currentOrder = order;
    if (currentOrder == null) return false;
    try {
      await _manageWorkOrders.complete(currentOrder.orderId);
      await loadOrder(currentOrder.orderId);
      return true;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
