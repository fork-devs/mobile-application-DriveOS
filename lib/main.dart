import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/routing/app_router.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';

/// Application entry point for DriveOS Mobile.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();

  final sessionStorage = getIt<SessionStorage>();
  await sessionStorage.initialize();

  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
  appLocaleNotifier.value = AppLocalizations.resolveInitialLocale(
    sessionStorage.savedLocale,
    systemLocale,
  );

  final router = AppRouter.create(sessionStorage);
  runApp(DriveOSApp(router: router));
}

/// Root widget configuring Material 3 theming, localization, and routing.
class DriveOSApp extends StatelessWidget {
  /// The declarative router controlling application navigation.
  final GoRouter router;

  /// Creates a [DriveOSApp] with the given [router].
  const DriveOSApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    const textTheme = TextTheme();
    const materialTheme = MaterialTheme(textTheme);

    return ValueListenableBuilder<Locale>(
      valueListenable: appLocaleNotifier,
      builder: (context, activeLocale, _) {
        return MaterialApp.router(
          title: 'DriveOS Workshop',
          debugShowCheckedModeBanner: false,
          theme: materialTheme.light(),
          darkTheme: materialTheme.dark(),
          themeMode: ThemeMode.light,
          locale: activeLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        );
      },
    );
  }
}
