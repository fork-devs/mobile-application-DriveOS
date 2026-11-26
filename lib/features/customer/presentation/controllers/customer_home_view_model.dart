import 'package:flutter/foundation.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/analytics/application/analytics_application.dart';
import 'package:mobile_application_driveos/features/analytics/domain/analytics_domain.dart';
import 'package:mobile_application_driveos/features/billing/application/billing_application.dart';
import 'package:mobile_application_driveos/features/billing/domain/billing_domain.dart';
import 'package:mobile_application_driveos/features/fleet/application/fleet_application.dart';
import 'package:mobile_application_driveos/features/fleet/domain/fleet_domain.dart';
import 'package:mobile_application_driveos/features/operations/application/operations_application.dart';
import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';

/// Presentation ViewModel managing the customer self-service portal.
class CustomerHomeViewModel extends ChangeNotifier {
  final ManageWorkOrders _manageWorkOrders;
  final ManageQuotes? _manageQuotes;
  final GetAnalytics? _getAnalytics;
  final GetVehicles? _getVehicles;
  final SessionStorage? _sessionStorage;

  /// Creates a [CustomerHomeViewModel].
  CustomerHomeViewModel({
    required this._manageWorkOrders,
    this._manageQuotes,
    this._getAnalytics,
    this._getVehicles,
    this._sessionStorage,
  });

  /// Whether portal data is currently loading.
  bool isLoading = false;

  /// Identifier of a quote currently being approved or rejected.
  String? busyQuoteId;

  /// Latest error message, if any.
  String? errorMessage;

  /// Customer executive KPI summary, if available.
  CustomerAnalyticsSummary? summary;

  /// Customer vehicles loaded from Fleet.
  List<Vehicle> vehicles = const [];

  /// Customer work orders loaded from Operations.
  List<WorkOrder> workOrders = const [];

  /// Customer quotes loaded from Billing.
  List<Quote> quotes = const [];

  /// Loads summary, work orders, quotes, and customer vehicles in parallel.
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final ordersFuture = _manageWorkOrders.listMine();
      final quotesFuture = _manageQuotes != null
          ? _manageQuotes.listMine().catchError((_) => <Quote>[])
          : Future.value(<Quote>[]);
      final summaryFuture = _getAnalytics != null
          ? _getAnalytics
              .customerSummary()
              .then<CustomerAnalyticsSummary?>((s) => s)
              .catchError((_) => null)
          : Future.value(null);

      final results =
          await Future.wait([ordersFuture, quotesFuture, summaryFuture]);
      workOrders = results[0] as List<WorkOrder>;
      quotes = results[1] as List<Quote>;
      summary = results[2] as CustomerAnalyticsSummary?;

      final customerId = summary?.customerId ?? _sessionStorage?.userId;
      if (_getVehicles != null &&
          customerId != null &&
          customerId.isNotEmpty) {
        vehicles = await _getVehicles
            .byCustomer(customerId)
            .catchError((_) => <Vehicle>[]);
      }

      isLoading = false;
      notifyListeners();
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  /// Approves [quoteId] and refreshes the customer's quotes.
  Future<bool> approveQuote(String quoteId) async {
    if (_manageQuotes == null) return false;
    busyQuoteId = quoteId;
    errorMessage = null;
    notifyListeners();

    try {
      final updated = await _manageQuotes.approve(quoteId);
      quotes = quotes.map((q) => q.id == quoteId ? updated : q).toList();
      busyQuoteId = null;
      notifyListeners();
      return true;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      busyQuoteId = null;
      notifyListeners();
      return false;
    }
  }

  /// Cancels/rejects [quoteId] and refreshes the customer's quotes.
  Future<bool> rejectQuote(String quoteId) async {
    if (_manageQuotes == null) return false;
    busyQuoteId = quoteId;
    errorMessage = null;
    notifyListeners();

    try {
      final updated = await _manageQuotes.cancel(quoteId);
      quotes = quotes.map((q) => q.id == quoteId ? updated : q).toList();
      busyQuoteId = null;
      notifyListeners();
      return true;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      busyQuoteId = null;
      notifyListeners();
      return false;
    }
  }
}
