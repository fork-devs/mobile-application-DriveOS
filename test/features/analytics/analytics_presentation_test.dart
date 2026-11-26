import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/analytics/application/analytics_application.dart';
import 'package:mobile_application_driveos/features/analytics/domain/analytics_domain.dart';
import 'package:mobile_application_driveos/features/analytics/presentation/controllers/dashboard_view_model.dart';
import 'package:mobile_application_driveos/features/analytics/presentation/controllers/employee_dashboard_view_model.dart';
import 'package:mobile_application_driveos/features/analytics/presentation/views/dashboard_page.dart';
import 'package:mobile_application_driveos/features/analytics/presentation/views/employee_dashboard_page.dart';

class _FakeAnalyticsRepository implements AnalyticsRepository {
  @override
  Future<BranchAnalyticsSummary> getBranchSummary(String branchId) async =>
      const BranchAnalyticsSummary(
        branchId: 'br-1',
        totalRevenue: 12500,
        completedWorkOrdersCount: 18,
        totalAppointmentsCount: 9,
        lowStockAlertsCount: 3,
        dtcAlertsCount: 2,
      );

  @override
  Future<TenantAnalyticsSummary> getTenantSummary() async =>
      const TenantAnalyticsSummary(
        tenantId: 't-1',
        totalRevenue: 12500,
        activeWorkOrders: 5,
        completedWorkOrders: 18,
        totalAlerts: 2,
      );

  @override
  Future<List<RevenueTrendPoint>> getRevenueTrend({
    String interval = 'monthly',
    String? startDate,
    String? endDate,
  }) async =>
      const [
        RevenueTrendPoint(
          period: '2026-11',
          grossRevenue: 12500,
          partsCost: 3000,
          laborCost: 2500,
          grossMarginPercentage: 56,
        ),
      ];

  @override
  Future<EmployeeAnalyticsSummary> getEmployeeSummary() async =>
      const EmployeeAnalyticsSummary(
        employeeId: 'emp-1',
        branchIds: ['br-1'],
        assignedWorkOrdersCount: 4,
        pendingTasksCount: 6,
        completedTasksCount: 11,
        activeDtcAlertsCount: 1,
        assignedWorkOrders: [
          {
            'number': 'WO-2026-0099',
            'status': 'IN_PROGRESS',
            'diagnosis': 'Alternator voltage check',
          },
        ],
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSessionStorage extends SessionStorage {
  @override
  String? get activeBranchId => 'br-1';

  @override
  String? get activeBranchName => 'Miraflores HQ';
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
  testWidgets('DashboardPage renders KPIs, DTC banner, and revenue trend',
      (tester) async {
    final repo = _FakeAnalyticsRepository();
    final vm = DashboardViewModel(
      getAnalytics: GetAnalytics(repo),
      sessionStorage: _FakeSessionStorage(),
    );

    await tester.pumpWidget(_wrapWithApp(DashboardPage(viewModel: vm)));
    await tester.pumpAndSettle();

    expect(find.text('Miraflores HQ'), findsOneWidget);
    expect(find.text('S/ 12500'), findsOneWidget);
    expect(find.text('18'), findsOneWidget);
    expect(find.text('Active DTC Alerts (2)'), findsOneWidget);
    expect(find.text('2026-11'), findsOneWidget);
  });

  testWidgets('EmployeeDashboardPage renders personal KPIs and assigned orders',
      (tester) async {
    final repo = _FakeAnalyticsRepository();
    final vm = EmployeeDashboardViewModel(
      getAnalytics: GetAnalytics(repo),
      sessionStorage: _FakeSessionStorage(),
    );

    await tester.pumpWidget(_wrapWithApp(EmployeeDashboardPage(viewModel: vm)));
    await tester.pumpAndSettle();

    expect(find.text('4'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('11'), findsOneWidget);
    expect(find.text('WO-2026-0099'), findsOneWidget);
  });
}
