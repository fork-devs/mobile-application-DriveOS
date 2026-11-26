import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/iot/application/iot_application.dart';
import 'package:mobile_application_driveos/features/iot/domain/iot_domain.dart';
import 'package:mobile_application_driveos/features/iot/presentation/controllers/telemetry_view_model.dart';
import 'package:mobile_application_driveos/features/iot/presentation/views/telemetry_dashboard_page.dart';

class _FakeIotRepository implements IotRepository {
  @override
  Future<List<Obd2Device>> getDevices({
    String? branchId,
    String? status,
  }) async =>
      const [
        Obd2Device(
          id: 'dev-1',
          branchId: 'br-1',
          macAddress: 'AA:BB:CC:11:22:33',
          status: 'LINKED',
        ),
      ];

  @override
  Future<List<Obd2DeviceRegistration>> getRegistrations({
    String? branchId,
    String? status,
    String? vehicleId,
  }) async =>
      const [
        Obd2DeviceRegistration(
          id: 'reg-1',
          obd2DeviceId: 'dev-1',
          branchId: 'br-1',
          vehicleId: 'veh-1',
          status: 'ACTIVE',
        ),
      ];

  @override
  Future<List<DtcAlert>> getVehicleDtcAlerts({
    required String vehicleId,
    int page = 0,
    int size = 20,
    String? severity,
  }) async =>
      const [
        DtcAlert(
          id: 'dtc-1',
          vehicleId: 'veh-1',
          dtcCode: 'P0300',
          severity: 'CRITICAL',
          description: 'Random/Multiple Cylinder Misfire Detected',
        ),
      ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSessionStorage extends SessionStorage {
  @override
  String? get activeBranchId => 'br-1';
}

Widget _wrapWithApp(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: child,
  );
}

void main() {
  testWidgets('TelemetryDashboardPage renders devices, links, and DTC alerts',
      (tester) async {
    final repo = _FakeIotRepository();
    final vm = TelemetryViewModel(
      manageDevices: ManageObd2Devices(repo),
      manageTelemetry: ManageTelemetryAndDiagnostics(repo),
      sessionStorage: _FakeSessionStorage(),
    );

    await tester
        .pumpWidget(_wrapWithApp(TelemetryDashboardPage(viewModel: vm)));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsNWidgets(3));
    expect(find.text('P0300'), findsOneWidget);
    expect(
      find.text('Random/Multiple Cylinder Misfire Detected'),
      findsOneWidget,
    );
  });
}
