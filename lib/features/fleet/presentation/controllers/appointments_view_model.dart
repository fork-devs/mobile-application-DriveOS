import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event_bus.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/fleet/application/fleet_application.dart';
import 'package:mobile_application_driveos/features/fleet/domain/fleet_domain.dart';

/// Presentation ViewModel managing workshop appointments and lifecycle
/// transitions.
class AppointmentsViewModel extends ChangeNotifier {
  final GetAppointments _getAppointments;
  final CreateAppointment _createAppointment;
  final ManageAppointmentLifecycle _lifecycle;
  final SessionStorage _sessionStorage;
  final DomainEventBus? _eventBus;
  StreamSubscription<ActiveBranchChangedEvent>? _branchSubscription;

  /// Creates an [AppointmentsViewModel].
  AppointmentsViewModel({
    required this._getAppointments,
    required this._createAppointment,
    required this._lifecycle,
    required this._sessionStorage,
    this._eventBus,
  }) {
    _branchSubscription = _eventBus
        ?.on<ActiveBranchChangedEvent>()
        .listen((_) => loadAppointments());
  }

  /// Whether appointments are currently loading.
  bool isLoading = false;

  /// Latest error message, if any.
  String? errorMessage;

  /// Active status filter (`null` shows all appointments).
  String? statusFilter;

  /// Loaded appointments for the active branch and filter.
  List<Appointment> appointments = const [];

  /// Active branch identifier from [SessionStorage].
  String get activeBranchId => _sessionStorage.activeBranchId ?? '';

  /// Updates [statusFilter] and reloads appointments.
  Future<void> filterByStatus(String? status) {
    if (statusFilter == status) return Future.value();
    statusFilter = status;
    return loadAppointments();
  }

  /// Loads appointments for [branchId] (or [activeBranchId]).
  Future<void> loadAppointments([String? branchId]) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final targetBranch = branchId ?? activeBranchId;
      appointments = await _getAppointments(
        branchId: targetBranch.isEmpty ? null : targetBranch,
        status: statusFilter,
      );
      isLoading = false;
      notifyListeners();
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  /// Schedules a new appointment and prepends it to [appointments].
  Future<bool> scheduleAppointment({
    required String customerId,
    required String vehicleId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    String? notes,
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
      final created = await _createAppointment(
        branchId: activeBranchId,
        customerId: customerId,
        vehicleId: vehicleId,
        scheduledStart: scheduledStart,
        scheduledEnd: scheduledEnd,
        notes: notes,
      );
      appointments = [created, ...appointments];
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

  /// Confirms [appointmentId].
  Future<void> confirm(String appointmentId) =>
      _mutate(() => _lifecycle.confirm(appointmentId));

  /// Records check-in for [appointmentId].
  Future<void> checkIn(String appointmentId) =>
      _mutate(() => _lifecycle.checkIn(appointmentId));

  /// Marks [appointmentId] as completed.
  Future<void> complete(String appointmentId) =>
      _mutate(() => _lifecycle.complete(appointmentId));

  /// Cancels [appointmentId].
  Future<void> cancelAppointment(String appointmentId, {String? reason}) =>
      _mutate(() => _lifecycle.cancel(appointmentId, reason: reason));

  Future<void> _mutate(Future<Appointment> Function() action) async {
    try {
      final updated = await action();
      appointments =
          appointments.map((a) => a.id == updated.id ? updated : a).toList();
      notifyListeners();
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _branchSubscription?.cancel();
    super.dispose();
  }
}
