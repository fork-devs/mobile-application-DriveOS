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
      'auth_tagline': 'Intelligent automotive workshop operations',
      'login_title': 'Welcome back',
      'login_subtitle': 'Sign in to manage your workshop or track your vehicle.',
      'email': 'Email',
      'email_hint': 'name@workshop.com',
      'email_required': 'Please enter your email address.',
      'email_invalid': 'Enter a valid email address.',
      'password': 'Password',
      'password_hint': 'Enter your password',
      'password_required': 'Please enter your password.',
      'password_min_length': 'Password must be at least 8 characters.',
      'confirm_password': 'Confirm password',
      'confirm_password_hint': 'Repeat your password',
      'passwords_do_not_match': 'Passwords do not match.',
      'tenant_id': 'Workshop / Tenant ID',
      'tenant_id_hint': 'Optional for customer accounts',
      'tenant_id_required': 'Please enter your workshop tenant ID.',
      'forgot_password': 'Forgot password?',
      'sign_in': 'Sign In',
      'no_account': 'Don\'t have an account?',
      'create_account': 'Create account',
      'register_title': 'Create account',
      'register_step1_subtitle': 'Verify your email address to get started.',
      'register_step2_subtitle': 'Enter the 6-digit code sent to your email.',
      'register_step3_subtitle': 'Complete your profile and choose a password.',
      'send_otp': 'Send verification code',
      'otp_code': 'Verification code',
      'otp_hint': '6-digit code',
      'otp_invalid': 'Enter the 6-digit verification code.',
      'verify_code': 'Verify code',
      'change_email': 'Change email',
      'full_name': 'Full name',
      'full_name_hint': 'e.g. Alex Rivera',
      'full_name_required': 'Please enter your full name.',
      'document_number': 'Document number',
      'document_number_hint': 'National ID or tax ID',
      'document_number_required': 'Please enter your document number.',
      'account_type': 'Account type',
      'account_type_customer': 'Customer',
      'account_type_owner': 'Workshop Owner',
      'complete_registration': 'Create account',
      'forgot_title': 'Reset password',
      'forgot_step1_subtitle': 'Enter your email and workshop ID to receive a recovery token.',
      'forgot_step2_subtitle': 'Enter the recovery token and your new password.',
      'send_recovery_code': 'Send recovery email',
      'recovery_token': 'Recovery token',
      'recovery_token_hint': 'Paste token from email',
      'recovery_token_required': 'Please enter the recovery token.',
      'new_password': 'New password',
      'reset_password_action': 'Update password',
      'forgot_success_msg': 'Your password has been updated. You can now sign in.',
      'select_branch': 'Select Branch',
      'branches_subtitle': 'Choose a workshop branch to operate.',
      'map_view': 'Map',
      'list_view': 'List',
      'new_branch': 'New branch',
      'edit_branch': 'Edit branch',
      'enter_branch': 'Enter branch',
      'no_branches': 'No branches registered yet',
      'no_branches_subtitle': 'Create your first workshop branch to begin.',
      'no_geolocated_branches': 'No branches with coordinates',
      'no_geolocated_branches_subtitle': 'Add latitude and longitude to view branches on the map.',
      'branch_code': 'Branch code',
      'branch_name': 'Branch name',
      'branch_address': 'Address',
      'branch_phone': 'Phone',
      'pick_location': 'Pick location on map',
      'location_selected': 'Location selected',
      'confirm_location': 'Confirm location',
      'tap_map_to_place_pin': 'Tap anywhere on the map to place the branch pin.',
      'dashboard_tab': 'Dashboard',
      'orders_tab': 'Orders',
      'appointments_tab': 'Agenda',
      'inventory_tab': 'Inventory',
      'telemetry_tab': 'Telemetry',
      'customer_home_tab': 'Summary',
      'customer_vehicles_tab': 'Vehicles',
      'customer_orders_tab': 'Orders',
      'customer_payments_tab': 'Quotes',
      'customer_portal_title': 'My Garage',
      'customer_active_orders': 'Active Orders',
      'customer_pending_quotes': 'Pending Quotes',
      'customer_my_vehicles': 'My Vehicles',
      'customer_no_vehicles': 'No vehicles registered yet',
      'customer_no_orders': 'No work orders yet',
      'customer_no_quotes': 'No pending quotes',
      'approve_quote': 'Approve',
      'reject_quote': 'Reject',
      'sign_out': 'Sign out',
      'switch_branch': 'Switch branch',
      'total_revenue': 'Total revenue',
      'completed_orders': 'Completed orders',
      'appointments_count': 'Appointments',
      'low_stock_alerts': 'Low stock',
      'dtc_alerts_title': 'Active DTC Alerts',
      'dtc_alerts_subtitle': 'Vehicles require telemetry diagnostics review.',
      'view_details': 'View details',
      'revenue_trend': 'Revenue trend',
      'quick_actions': 'Quick actions',
      'my_summary': 'My Summary',
      'assigned_orders': 'Assigned orders',
      'pending_tasks': 'Pending tasks',
      'completed_tasks': 'Completed tasks',
      'assigned_work_orders_title': 'Assigned Work Orders',
      'no_assigned_orders': 'No work orders assigned right now',
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
      'auth_tagline': 'Operación inteligente para talleres automotrices',
      'login_title': 'Bienvenido de nuevo',
      'login_subtitle': 'Inicia sesión para gestionar tu taller o seguir tu vehículo.',
      'email': 'Correo electrónico',
      'email_hint': 'nombre@taller.com',
      'email_required': 'Ingresa tu correo electrónico.',
      'email_invalid': 'Ingresa un correo electrónico válido.',
      'password': 'Contraseña',
      'password_hint': 'Ingresa tu contraseña',
      'password_required': 'Ingresa tu contraseña.',
      'password_min_length': 'La contraseña debe tener al menos 8 caracteres.',
      'confirm_password': 'Confirmar contraseña',
      'confirm_password_hint': 'Repite tu contraseña',
      'passwords_do_not_match': 'Las contraseñas no coinciden.',
      'tenant_id': 'ID de Taller / Tenant',
      'tenant_id_hint': 'Opcional para cuentas de cliente',
      'tenant_id_required': 'Ingresa el ID de tu taller.',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'sign_in': 'Iniciar sesión',
      'no_account': '¿No tienes una cuenta?',
      'create_account': 'Crear cuenta',
      'register_title': 'Crear cuenta',
      'register_step1_subtitle': 'Verifica tu correo electrónico para comenzar.',
      'register_step2_subtitle': 'Ingresa el código de 6 dígitos enviado a tu correo.',
      'register_step3_subtitle': 'Completa tu perfil y elige una contraseña.',
      'send_otp': 'Enviar código de verificación',
      'otp_code': 'Código de verificación',
      'otp_hint': 'Código de 6 dígitos',
      'otp_invalid': 'Ingresa el código de 6 dígitos.',
      'verify_code': 'Verificar código',
      'change_email': 'Cambiar correo',
      'full_name': 'Nombre completo',
      'full_name_hint': 'Ej. Alex Rivera',
      'full_name_required': 'Ingresa tu nombre completo.',
      'document_number': 'Número de documento',
      'document_number_hint': 'DNI, RUC o identificación',
      'document_number_required': 'Ingresa tu número de documento.',
      'account_type': 'Tipo de cuenta',
      'account_type_customer': 'Cliente',
      'account_type_owner': 'Dueño de taller',
      'complete_registration': 'Crear cuenta',
      'forgot_title': 'Restablecer contraseña',
      'forgot_step1_subtitle': 'Ingresa tu correo y el ID del taller para recibir un token.',
      'forgot_step2_subtitle': 'Ingresa el token de recuperación y tu nueva contraseña.',
      'send_recovery_code': 'Enviar correo de recuperación',
      'recovery_token': 'Token de recuperación',
      'recovery_token_hint': 'Pega el token del correo',
      'recovery_token_required': 'Ingresa el token de recuperación.',
      'new_password': 'Nueva contraseña',
      'reset_password_action': 'Actualizar contraseña',
      'forgot_success_msg': 'Tu contraseña ha sido actualizada. Ya puedes iniciar sesión.',
      'select_branch': 'Seleccionar Sucursal',
      'branches_subtitle': 'Elige una sucursal del taller para operar.',
      'map_view': 'Mapa',
      'list_view': 'Lista',
      'new_branch': 'Nueva sucursal',
      'edit_branch': 'Editar sucursal',
      'enter_branch': 'Ingresar a sucursal',
      'no_branches': 'Aún no hay sucursales registradas',
      'no_branches_subtitle': 'Crea tu primera sucursal para comenzar.',
      'no_geolocated_branches': 'Sin sucursales geolocalizadas',
      'no_geolocated_branches_subtitle': 'Agrega latitud y longitud para ver las sucursales en el mapa.',
      'branch_code': 'Código de sucursal',
      'branch_name': 'Nombre de sucursal',
      'branch_address': 'Dirección',
      'branch_phone': 'Teléfono',
      'pick_location': 'Ubicar en el mapa',
      'location_selected': 'Ubicación seleccionada',
      'confirm_location': 'Confirmar ubicación',
      'tap_map_to_place_pin': 'Toca cualquier punto del mapa para colocar el pin.',
      'dashboard_tab': 'Inicio',
      'orders_tab': 'Órdenes',
      'appointments_tab': 'Agenda',
      'inventory_tab': 'Inventario',
      'telemetry_tab': 'Telemetría',
      'customer_home_tab': 'Resumen',
      'customer_vehicles_tab': 'Vehículos',
      'customer_orders_tab': 'Órdenes',
      'customer_payments_tab': 'Cotizaciones',
      'customer_portal_title': 'Mi Garaje',
      'customer_active_orders': 'Órdenes Activas',
      'customer_pending_quotes': 'Cotizaciones Pendientes',
      'customer_my_vehicles': 'Mis Vehículos',
      'customer_no_vehicles': 'Aún no tienes vehículos registrados',
      'customer_no_orders': 'Aún no tienes órdenes de trabajo',
      'customer_no_quotes': 'Sin cotizaciones pendientes',
      'approve_quote': 'Aprobar',
      'reject_quote': 'Rechazar',
      'sign_out': 'Cerrar sesión',
      'switch_branch': 'Cambiar sucursal',
      'total_revenue': 'Ingresos totales',
      'completed_orders': 'Órdenes completadas',
      'appointments_count': 'Citas',
      'low_stock_alerts': 'Stock bajo',
      'dtc_alerts_title': 'Alertas DTC Activas',
      'dtc_alerts_subtitle': 'Hay vehículos que requieren revisión de telemetría.',
      'view_details': 'Ver detalle',
      'revenue_trend': 'Tendencia de ingresos',
      'quick_actions': 'Acciones rápidas',
      'my_summary': 'Mi Resumen',
      'assigned_orders': 'Órdenes asignadas',
      'pending_tasks': 'Tareas pendientes',
      'completed_tasks': 'Tareas completadas',
      'assigned_work_orders_title': 'Órdenes de Trabajo Asignadas',
      'no_assigned_orders': 'Sin órdenes de trabajo asignadas',
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
