import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_application_driveos/core/auth/mobile_role_scope.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/operations/application/operations_application.dart';
import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';
import 'package:mobile_application_driveos/features/operations/presentation/controllers/work_order_detail_view_model.dart';
import 'package:mobile_application_driveos/features/operations/presentation/controllers/work_orders_view_model.dart';
import 'package:mobile_application_driveos/features/operations/presentation/views/work_order_detail_page.dart';
import 'package:mobile_application_driveos/features/operations/presentation/views/work_orders_page.dart';

class _FakeOperationsRepository implements OperationsRepository {
  @override
  Future<List<WorkOrder>> getWorkOrders({String? status}) async => [
        WorkOrder(
          orderId: 'wo-1',
          number: 'WO-2026-0001',
          status: status ?? 'OPEN',
          diagnosis: 'Timing belt replacement',
        ),
      ];

  @override
  Future<WorkOrder> getWorkOrderById(String orderId) async => const WorkOrder(
        orderId: 'wo-1',
        number: 'WO-2026-0001',
        status: 'IN_PROGRESS',
        diagnosis: 'Timing belt replacement',
      );

  @override
  Future<List<WorkOrderTask>> getWorkOrderTasks(String workOrderId) async =>
      const [
        WorkOrderTask(
          id: 'task-1',
          workOrderId: 'wo-1',
          serviceId: 'srv-1',
          description: 'Remove old timing belt',
          status: 'PENDING',
        ),
      ];

  @override
  Future<List<WorkOrderEvidence>> getWorkOrderEvidences(
    String workOrderId,
  ) async =>
      const [];

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
  testWidgets('WorkOrdersPage renders work orders and admin FAB',
      (tester) async {
    final repo = _FakeOperationsRepository();
    final vm = WorkOrdersViewModel(
      manageWorkOrders: ManageWorkOrders(repo),
      sessionStorage: _FakeSessionStorage(),
    );

    await tester.pumpWidget(
      _wrapWithApp(
        WorkOrdersPage(
          viewModel: vm,
          roleScope: MobileRoleScope.workshopAdmin,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('WO-2026-0001'), findsOneWidget);
    expect(find.text('Timing belt replacement'), findsOneWidget);
    expect(find.byKey(const Key('fab_new_work_order')), findsOneWidget);
  });

  testWidgets('WorkOrderDetailPage renders order summary and tasks',
      (tester) async {
    final repo = _FakeOperationsRepository();
    final vm = WorkOrderDetailViewModel(
      manageWorkOrders: ManageWorkOrders(repo),
      manageTasks: ManageWorkOrderTasks(repo),
      manageEvidences: ManageEvidencesAndSupplements(repo),
    );

    await tester.pumpWidget(
      _wrapWithApp(
        WorkOrderDetailPage(
          workOrderId: 'wo-1',
          viewModel: vm,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('WO-2026-0001'), findsNWidgets(2));
    expect(find.text('Remove old timing belt'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
  });
}
