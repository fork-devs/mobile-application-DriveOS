import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/fleet/application/fleet_application.dart';
import 'package:mobile_application_driveos/features/fleet/domain/fleet_domain.dart';
import 'package:mobile_application_driveos/features/fleet/presentation/controllers/appointments_view_model.dart';
import 'package:mobile_application_driveos/features/fleet/presentation/views/appointments_page.dart';

class _FakeFleetRepository implements FleetRepository {
  @override
  Future<List<Appointment>> getAppointments({
    String? branchId,
    String? customerId,
    String? vehicleId,
    String? status,
  }) async =>
      [
        Appointment(
          id: 'appt-1',
          branchId: branchId ?? 'br-1',
          customerId: 'cust-1',
          vehicleId: 'veh-1',
          scheduledStart: DateTime(2026, 11, 26, 10, 0),
          scheduledEnd: DateTime(2026, 11, 26, 11, 0),
          status: status ?? 'SCHEDULED',
          notes: '60,000 km maintenance',
        ),
      ];

  @override
  Future<Appointment> confirmAppointment(String appointmentId) async =>
      Appointment(
        id: appointmentId,
        branchId: 'br-1',
        customerId: 'cust-1',
        vehicleId: 'veh-1',
        scheduledStart: DateTime(2026, 11, 26, 10, 0),
        scheduledEnd: DateTime(2026, 11, 26, 11, 0),
        status: 'CONFIRMED',
        notes: '60,000 km maintenance',
      );

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
  testWidgets('AppointmentsPage renders agenda and confirms appointment',
      (tester) async {
    final repo = _FakeFleetRepository();
    final vm = AppointmentsViewModel(
      getAppointments: GetAppointments(repo),
      createAppointment: CreateAppointment(repo),
      lifecycle: ManageAppointmentLifecycle(repo),
      sessionStorage: _FakeSessionStorage(),
    );

    await tester.pumpWidget(_wrapWithApp(AppointmentsPage(viewModel: vm)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('appointment_card_appt-1')), findsOneWidget);
    expect(find.text('60,000 km maintenance'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(find.text('CONFIRMED'), findsOneWidget);
  });
}
