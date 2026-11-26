import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_application_driveos/core/auth/mobile_role_scope.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/features/billing/application/billing_application.dart';
import 'package:mobile_application_driveos/features/billing/domain/billing_domain.dart';
import 'package:mobile_application_driveos/features/customer/presentation/controllers/customer_home_view_model.dart';
import 'package:mobile_application_driveos/features/customer/presentation/views/customer_home_page.dart';
import 'package:mobile_application_driveos/features/main/presentation/main_page.dart';
import 'package:mobile_application_driveos/features/operations/application/operations_application.dart';
import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';

class _FakeOperationsRepo implements OperationsRepository {
  @override
  Future<List<WorkOrder>> getMyWorkOrders() async => const [
        WorkOrder(
          orderId: 'wo-1',
          number: 'WO-2026-0001',
          status: 'IN_PROGRESS',
          diagnosis: 'Brake pad inspection',
        ),
      ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeBillingRepo implements BillingRepository {
  @override
  Future<List<Quote>> getMyQuotes() async => const [
        Quote(
          id: 'q-1',
          workOrderId: 'wo-1',
          branchId: 'br-1',
          subtotalAmount: 150,
          discountPercentage: 0,
          totalAmount: 150,
          status: 'PENDING',
        ),
      ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
  testWidgets('MainPage shows 5 destinations for workshopAdmin',
      (tester) async {
    await tester.pumpWidget(
      _wrapWithApp(
        const MainPage(
          roleScope: MobileRoleScope.workshopAdmin,
          overridePages: [
            Center(child: Text('Tab 0')),
            Center(child: Text('Tab 1')),
            Center(child: Text('Tab 2')),
            Center(child: Text('Tab 3')),
            Center(child: Text('Tab 4')),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('main_navigation_bar')), findsOneWidget);
    expect(find.byKey(const Key('nav_dashboard')), findsOneWidget);
    expect(find.byKey(const Key('nav_inventory')), findsOneWidget);
    expect(find.byKey(const Key('nav_telemetry')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav_orders')));
    await tester.pumpAndSettle();
    expect(find.text('Tab 1'), findsOneWidget);
  });

  testWidgets('MainPage shows 3 destinations for technician', (tester) async {
    await tester.pumpWidget(
      _wrapWithApp(
        const MainPage(
          roleScope: MobileRoleScope.technician,
          overridePages: [
            Center(child: Text('Tech 0')),
            Center(child: Text('Tech 1')),
            Center(child: Text('Tech 2')),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('nav_dashboard')), findsOneWidget);
    expect(find.byKey(const Key('nav_orders')), findsOneWidget);
    expect(find.byKey(const Key('nav_telemetry')), findsOneWidget);
    expect(find.byKey(const Key('nav_inventory')), findsNothing);
  });

  testWidgets('CustomerHomePage loads orders and quotes tabs', (tester) async {
    final vm = CustomerHomeViewModel(
      manageWorkOrders: ManageWorkOrders(_FakeOperationsRepo()),
      manageQuotes: ManageQuotes(_FakeBillingRepo()),
    );

    await tester.pumpWidget(_wrapWithApp(CustomerHomePage(viewModel: vm)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('customer_navigation_bar')), findsOneWidget);

    await tester.tap(find.byKey(const Key('customer_nav_orders')));
    await tester.pumpAndSettle();
    expect(find.text('WO-2026-0001'), findsOneWidget);

    await tester.tap(find.byKey(const Key('customer_nav_quotes')));
    await tester.pumpAndSettle();
    expect(find.text('S/ 150.00'), findsOneWidget);
  });
}
