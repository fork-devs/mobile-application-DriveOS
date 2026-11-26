import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/inventory/application/inventory_application.dart';
import 'package:mobile_application_driveos/features/inventory/domain/inventory_domain.dart';
import 'package:mobile_application_driveos/features/inventory/presentation/controllers/inventory_view_model.dart';
import 'package:mobile_application_driveos/features/inventory/presentation/views/inventory_page.dart';

class _FakeInventoryRepository implements InventoryRepository {
  @override
  Future<List<InventoryProduct>> getProductsByBranch({
    required String branchId,
    String? category,
    bool? lowStockOnly,
  }) async =>
      const [
        InventoryProduct(
          id: 'prod-1',
          branchId: 'br-1',
          category: 'LUBRICANTES',
          name: 'Synthetic Oil 5W-30',
          sku: 'OIL-5W30',
          salePrice: 48.50,
          minimumStock: 5,
          currentStock: 2,
          lowStockAlert: true,
        ),
        InventoryProduct(
          id: 'prod-2',
          branchId: 'br-1',
          category: 'FILTROS',
          name: 'Air Filter Pro',
          sku: 'FLT-101',
          salePrice: 32.00,
          minimumStock: 4,
          currentStock: 12,
          lowStockAlert: false,
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
  testWidgets('InventoryPage renders products and filters by search query',
      (tester) async {
    final repo = _FakeInventoryRepository();
    final vm = InventoryViewModel(
      manageProducts: ManageInventoryProducts(repo),
      sessionStorage: _FakeSessionStorage(),
    );

    await tester.pumpWidget(_wrapWithApp(InventoryPage(viewModel: vm)));
    await tester.pumpAndSettle();

    expect(find.text('Synthetic Oil 5W-30'), findsOneWidget);
    expect(find.text('Air Filter Pro'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('inventory_search_input')),
      'FLT-101',
    );
    await tester.pumpAndSettle();

    expect(find.text('Synthetic Oil 5W-30'), findsNothing);
    expect(find.text('Air Filter Pro'), findsOneWidget);
  });
}
