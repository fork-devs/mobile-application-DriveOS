import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event_bus.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/analytics/application/analytics_application.dart';
import 'package:mobile_application_driveos/features/analytics/domain/analytics_domain.dart';
import 'package:mobile_application_driveos/features/core/domain/events/core_events.dart';

/// Presentation ViewModel powering the workshop administrator dashboard.
class DashboardViewModel extends ChangeNotifier {
  final GetAnalytics _getAnalytics;
  final SessionStorage _sessionStorage;
  final DomainEventBus? _eventBus;
  StreamSubscription<ActiveBranchChangedEvent>? _branchSubscription;

  /// Creates a [DashboardViewModel].
  DashboardViewModel({
    required this._getAnalytics,
    required this._sessionStorage,
    DomainEventBus? eventBus,
  }) : _eventBus = eventBus {
    _branchSubscription =
        _eventBus?.on<ActiveBranchChangedEvent>().listen((_) => refresh());
  }

  /// Whether analytics data is currently loading.
  bool isLoading = false;

  /// Latest error message, if any.
  String? error;

  /// Consolidated KPI summary for the active branch.
  BranchAnalyticsSummary? branchSummary;

  /// Global tenant KPI summary, if available.
  TenantAnalyticsSummary? tenantSummary;

  /// Revenue trend points for the active workshop.
  List<RevenueTrendPoint> revenueTrend = const [];

  /// Active branch display name from [SessionStorage].
  String get activeBranchName =>
      _sessionStorage.activeBranchName ?? 'DriveOS Branch';

  /// Loads initial dashboard KPIs.
  Future<void> init() => refresh();

  /// Refreshes branch summary, tenant summary, and revenue trend.
  Future<void> refresh() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final branchId = _sessionStorage.activeBranchId;
      final branchFuture = (branchId != null && branchId.isNotEmpty)
          ? _getAnalytics
              .branchSummary(branchId)
              .then<BranchAnalyticsSummary?>((v) => v)
              .catchError((_) => null)
          : Future<BranchAnalyticsSummary?>.value(null);

      final tenantFuture = _getAnalytics
          .tenantSummary()
          .then<TenantAnalyticsSummary?>((v) => v)
          .catchError((_) => null);

      final trendFuture = _getAnalytics
          .revenueTrend()
          .catchError((_) => <RevenueTrendPoint>[]);

      final results = await Future.wait([
        branchFuture,
        tenantFuture,
        trendFuture,
      ]);

      branchSummary = results[0] as BranchAnalyticsSummary?;
      tenantSummary = results[1] as TenantAnalyticsSummary?;
      revenueTrend = results[2] as List<RevenueTrendPoint>;
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
