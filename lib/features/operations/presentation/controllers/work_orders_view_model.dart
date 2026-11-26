import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event_bus.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/operations/application/operations_application.dart';
import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';

/// Presentation ViewModel managing the workshop work orders list and filter
/// tabs.
class WorkOrdersViewModel extends ChangeNotifier {
  final ManageWorkOrders _manageWorkOrders;
  final SessionStorage _sessionStorage;
  final DomainEventBus? _eventBus;
  StreamSubscription<ActiveBranchChangedEvent>? _branchSubscription;

  /// Creates a [WorkOrdersViewModel].
  WorkOrdersViewModel({
    required this._manageWorkOrders,
    required this._sessionStorage,
    this._eventBus,
  }) {
    _branchSubscription =
        _eventBus?.on<ActiveBranchChangedEvent>().listen((_) => loadOrders());
  }

  /// Whether orders are currently loading.
  bool isLoading = false;

  /// Latest error message, if any.
  String? errorMessage;

  /// Active status filter (`null` means all statuses).
  String? statusFilter;

  /// Loaded work orders matching the current filter.
  List<WorkOrder> orders = const [];

  /// Active branch identifier from [SessionStorage].
  String get activeBranchId => _sessionStorage.activeBranchId ?? '';

  /// Active branch display name from [SessionStorage].
  String get activeBranchName =>
      _sessionStorage.activeBranchName ?? 'DriveOS Branch';

  /// Loads initial orders.
  Future<void> init() => loadOrders();

  /// Updates [statusFilter] and reloads orders.
  Future<void> setFilter(String? status) {
    if (statusFilter == status) return Future.value();
    statusFilter = status;
    return loadOrders();
  }

  /// Fetches work orders from [ManageWorkOrders].
  Future<void> loadOrders() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      orders = await _manageWorkOrders.list(status: statusFilter);
      isLoading = false;
      notifyListeners();
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  /// Opens a new work order and prepends it to [orders].
  Future<bool> openOrder({
    required String customerId,
    required String vehicleId,
    required String diagnosis,
    String? mechanicId,
  }) async {
    if (activeBranchId.isEmpty) {
      errorMessage = 'Please select an active branch first.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final created = await _manageWorkOrders.open(
        customerId: customerId,
        vehicleId: vehicleId,
        branchId: activeBranchId,
        mechanicId: mechanicId,
        diagnosis: diagnosis,
      );
      orders = [created, ...orders];
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _branchSubscription?.cancel();
    super.dispose();
  }
}
