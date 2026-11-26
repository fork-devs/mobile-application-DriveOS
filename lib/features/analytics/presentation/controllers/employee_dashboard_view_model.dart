import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event_bus.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/analytics/application/analytics_application.dart';
import 'package:mobile_application_driveos/features/analytics/domain/analytics_domain.dart';

/// Presentation ViewModel powering the technician personal operational
/// dashboard.
class EmployeeDashboardViewModel extends ChangeNotifier {
  final GetAnalytics _getAnalytics;
  final SessionStorage _sessionStorage;
  final DomainEventBus? _eventBus;
  StreamSubscription<ActiveBranchChangedEvent>? _branchSubscription;

  /// Creates an [EmployeeDashboardViewModel].
  EmployeeDashboardViewModel({
    required this._getAnalytics,
    required this._sessionStorage,
    this._eventBus,
  }) {
    _branchSubscription =
        _eventBus?.on<ActiveBranchChangedEvent>().listen((_) => refresh());
  }

  /// Whether personal operational KPIs are currently loading.
  bool isLoading = false;

  /// Latest error message, if any.
  String? error;

  /// Personal operational summary for the signed-in technician.
  EmployeeAnalyticsSummary? summary;

  /// Active branch display name from [SessionStorage].
  String get activeBranchName =>
      _sessionStorage.activeBranchName ?? 'DriveOS Branch';

  /// Loads initial employee dashboard data.
  Future<void> init() => refresh();

  /// Refreshes the personal operational summary.
  Future<void> refresh() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      summary = await _getAnalytics.employeeSummary();
      isLoading = false;
      notifyListeners();
    } catch (err) {
      error = err.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _branchSubscription?.cancel();
    super.dispose();
  }
}
