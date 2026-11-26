import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/core/application/core_application.dart';
import 'package:mobile_application_driveos/features/core/domain/core_domain.dart';
import 'package:mobile_application_driveos/features/core/presentation/controllers/branch_selection_view_model.dart';
import 'package:mobile_application_driveos/features/core/presentation/views/branch_selection_page.dart';
import 'package:mobile_application_driveos/features/core/presentation/widgets/branch_map_view.dart';

class _FakeCoreRepository implements CoreRepository {
  String? selectedBranchId;

  @override
  Future<List<Workshop>> getWorkshopsByOwner(String ownerId) async => const [
        Workshop(
          id: 'ws-1',
          ownerId: 'owner-1',
          businessName: 'DriveOS Motors SAC',
          brandName: 'DriveOS Motors',
          taxId: '20123456789',
          mileageIntervalConfig: 5000,
        ),
      ];

  @override
  Future<List<Branch>> getBranchesByWorkshop(String workshopId) async => const [
        Branch(
          id: 'br-1',
          workshopId: 'ws-1',
          code: 'SUC-01',
          name: 'Miraflores HQ',
          address: 'Av. Pardo 450',
          phone: '+51 999 111 222',
        ),
        Branch(
          id: 'br-2',
          workshopId: 'ws-1',
          code: 'SUC-02',
          name: 'Surco Annex',
          address: 'Av. Caminos del Inca 200',
          phone: '+51 999 333 444',
        ),
      ];

  @override
  Future<void> selectActiveBranch({
    required String branchId,
    required String branchName,
    String? workshopId,
  }) async {
    selectedBranchId = branchId;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSessionStorage extends SessionStorage {
  @override
  String? get userId => 'owner-1';

  @override
  String? get activeBranchId => null;
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
  testWidgets('BranchSelectionPage renders branches in list mode',
      (tester) async {
    final repo = _FakeCoreRepository();
    final vm = BranchSelectionViewModel(
      getWorkshopsByOwner: GetWorkshopsByOwner(repo),
      getBranchesByWorkshop: GetBranchesByWorkshop(repo),
      createBranch: CreateBranch(repo),
      updateBranch: UpdateBranch(repo),
      uploadBranchBanner: UploadBranchBanner(repo),
      selectActiveBranch: SelectActiveBranch(repo),
      sessionStorage: _FakeSessionStorage(),
    );

    await tester.pumpWidget(
      _wrapWithApp(
        BranchSelectionPage(
          viewModel: vm,
          initialShowMap: false,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byKey(const Key('branch_card_SUC-01')), findsOneWidget);
    expect(find.text('Miraflores HQ'), findsOneWidget);
    expect(find.byKey(const Key('btn_enter_branch_SUC-01')), findsOneWidget);
  });

  testWidgets('BranchMapView shows empty state when no branches have coordinates',
      (tester) async {
    await tester.pumpWidget(
      _wrapWithApp(
        Scaffold(
          body: BranchMapView(
            branches: const [
              Branch(
                id: 'br-1',
                workshopId: 'ws-1',
                code: 'SUC-01',
                name: 'Miraflores HQ',
                address: 'Av. Pardo 450',
                phone: '+51 999 111 222',
              ),
            ],
            onEnterBranch: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('No branches with coordinates'), findsOneWidget);
  });
}
