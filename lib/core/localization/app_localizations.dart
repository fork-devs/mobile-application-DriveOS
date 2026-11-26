import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Global notifier controlling the active [Locale] across the application.
final ValueNotifier<Locale> appLocaleNotifier =
    ValueNotifier<Locale>(const Locale('en'));

/// Provides localized UI strings for DriveOS Mobile.
class AppLocalizations {
  /// The active locale for this localization instance.
  final Locale locale;

  /// Creates an [AppLocalizations] instance for [locale].
  AppLocalizations(this.locale);

  /// Returns the [AppLocalizations] for the nearest ancestor [BuildContext].
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  /// The [LocalizationsDelegate] for [AppLocalizations].
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// The list of locales supported by DriveOS Mobile.
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('en'),
    Locale('es', 'PE'),
    Locale('es'),
  ];

  /// Resolves the initial [Locale] from [savedLocale] or [systemLocale].
  static Locale resolveInitialLocale(String? savedLocale, Locale systemLocale) {
    if (savedLocale != null &&
        savedLocale.isNotEmpty &&
        ['es', 'en'].contains(savedLocale)) {
      return Locale(savedLocale);
    }
    if (['es', 'en'].contains(systemLocale.languageCode)) {
      return Locale(systemLocale.languageCode);
    }
    return const Locale('en');
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'DriveOS Workshop',
      'app_subtitle': 'Intelligent Automotive Workshop Management',
      'loading': 'Loading...',
      'error': 'Error',
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'refresh': 'Refresh',
      'close': 'Close',
      'retry': 'Retry',
    },
    'es': {
      'app_title': 'DriveOS Workshop',
      'app_subtitle': 'Gestión Inteligente de Talleres Automotrices',
      'loading': 'Cargando...',
      'error': 'Error',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'confirm': 'Confirmar',
      'refresh': 'Actualizar',
      'close': 'Cerrar',
      'retry': 'Reintentar',
    },
  };

  /// Translates [key] into the current [locale], falling back to English.
  String translate(String key) {
    final lang = _localizedValues.containsKey(locale.languageCode)
        ? locale.languageCode
        : 'en';
    return _localizedValues[lang]?[key] ?? _localizedValues['en']?[key] ?? key;
  }

  /// The localized application title.
  String get appTitle => translate('app_title');

  /// The localized application subtitle.
  String get appSubtitle => translate('app_subtitle');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
