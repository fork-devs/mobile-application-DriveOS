import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event_bus.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/iot/application/iot_application.dart';
import 'package:mobile_application_driveos/features/iot/domain/iot_domain.dart';

/// Presentation ViewModel managing branch OBD2 devices, active vehicle
/// registrations, and DTC telemetry alerts.
class TelemetryViewModel extends ChangeNotifier {
  final ManageObd2Devices _manageDevices;
  final ManageTelemetryAndDiagnostics _manageTelemetry;
  final SessionStorage _sessionStorage;
  final DomainEventBus? _eventBus;
  StreamSubscription<ActiveBranchChangedEvent>? _branchSubscription;

  /// Creates a [TelemetryViewModel].
  TelemetryViewModel({
    required this._manageDevices,
    required this._manageTelemetry,
    required this._sessionStorage,
    this._eventBus,
  }) {
    _branchSubscription =
        _eventBus?.on<ActiveBranchChangedEvent>().listen((_) => loadTelemetry());
  }

  /// Whether telemetry data is currently loading.
  bool isLoading = false;

  /// Latest error message, if any.
  String? errorMessage;

  /// Active severity filter (`null`, `CRITICAL`, `HIGH`, `WARNING`, `LOW`).
  String? severityFilter;

  /// OBD2 hardware devices registered in the active branch.
  List<Obd2Device> devices = const [];

  /// Active vehicle-to-OBD2 registrations in the active branch.
  List<Obd2DeviceRegistration> registrations = const [];

  /// DTC alerts aggregated across registered vehicles.
  List<DtcAlert> dtcAlerts = const [];

  /// Active branch identifier from [SessionStorage].
  String get activeBranchId => _sessionStorage.activeBranchId ?? '';

  /// Updates [severityFilter] and reloads telemetry.
  Future<void> filterBySeverity(String? severity) {
    if (severityFilter == severity) return Future.value();
    severityFilter = severity;
    return loadTelemetry();
  }

  /// Loads OBD2 devices, active registrations, and DTC alerts for [branchId].
  Future<void> loadTelemetry([String? branchId]) async {
    final targetBranch = branchId ?? activeBranchId;
    if (targetBranch.isEmpty) {
      devices = const [];
      registrations = const [];
      dtcAlerts = const [];
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final devicesFuture = _manageDevices.listDevices(branchId: targetBranch);
      final regsFuture = _manageDevices.listRegistrations(
        branchId: targetBranch,
        status: 'ACTIVE',
      );
      final results = await Future.wait([devicesFuture, regsFuture]);
      devices = results[0] as List<Obd2Device>;
      registrations = results[1] as List<Obd2DeviceRegistration>;

      final vehicleIds = registrations.map((r) => r.vehicleId).toSet();
      if (vehicleIds.isEmpty) {
        dtcAlerts = const [];
      } else {
        final alertLists = await Future.wait(
          vehicleIds.map(
            (vehicleId) => _manageTelemetry
                .getVehicleDtcAlerts(
                  vehicleId: vehicleId,
                  severity: severityFilter,
                )
                .catchError((_) => <DtcAlert>[]),
          ),
        );
        dtcAlerts = alertLists.expand((list) => list).toList();
      }

      isLoading = false;
      notifyListeners();
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  /// Registers a new OBD2 dongle with [macAddress] in the active branch.
  Future<bool> registerDevice(String macAddress) async {
    if (activeBranchId.isEmpty) {
      errorMessage = 'Please select an active branch first.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final created = await _manageDevices.createDevice(
        branchId: activeBranchId,
        macAddress: macAddress,
      );
      devices = [created, ...devices];
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
