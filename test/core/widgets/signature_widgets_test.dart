import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_kanban_tab_bar.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_liquid_button.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_page_header.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_pull_to_refresh.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_skeleton.dart';

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
  testWidgets('DriveOSPageHeader and DriveOSCollapsibleHeaderBody render cleanly',
      (tester) async {
    await tester.pumpWidget(
      _wrapWithApp(
        Scaffold(
          body: DriveOSCollapsibleHeaderBody(
            header: const DriveOSPageHeader(
              title: 'DriveOS Orders',
              subtitle: 'Miraflores HQ',
              badgeLabel: 'ADMIN',
            ),
            body: ListView(
              children: const [Text('Scrollable item')],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('DriveOS Orders'), findsOneWidget);
    expect(find.text('Miraflores HQ'), findsOneWidget);
    expect(find.text('ADMIN'), findsOneWidget);
  });

  testWidgets('DriveOSKanbanTabBar renders tabs and counts', (tester) async {
    await tester.pumpWidget(
      _wrapWithApp(
        DefaultTabController(
          length: 2,
          child: Builder(
            builder: (context) {
              final controller = DefaultTabController.of(context);
              return Scaffold(
                body: DriveOSKanbanTabBar(
                  controller: controller,
                  tabs: const [
                    DriveOSKanbanTabItem(label: 'All', count: 5),
                    DriveOSKanbanTabItem(label: 'Open'),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('All'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('DriveOSLiquidButton and DriveOSSkeletonCardList render',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrapWithApp(
        Scaffold(
          body: Column(
            children: [
              DriveOSLiquidButton(
                label: 'Enter',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => tapped = true,
              ),
              const Expanded(
                child: DriveOSPullToRefresh(
                  onRefresh: _noopRefresh,
                  child: DriveOSSkeletonCardList(itemCount: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Enter'));
    expect(tapped, isTrue);
    expect(find.byType(DriveOSSkeletonCardList), findsOneWidget);
  });
}

Future<void> _noopRefresh() async {}
