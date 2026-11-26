/// Global API configuration and DriveOS endpoint paths routed via Kong.
class ApiConstants {
  ApiConstants._();

  /// Configurable API Gateway base URL.
  ///
  /// Defaults to Android emulator host `http://10.0.2.2:8080` and can be
  /// overridden at build time with `--dart-define=API_BASE_URL=...`.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  /// Default timeout duration for HTTP requests.
  static const Duration requestTimeout = Duration(seconds: 30);

  // IAM (erp-auth-service)
  static const String authLogin = '/api/v1/auth/login';
  static const String authRefresh = '/api/v1/auth/refresh';
  static const String authLogout = '/api/v1/auth/logout';
  static const String authForgotPassword = '/api/v1/auth/forgot-password';
  static const String authResetPassword = '/api/v1/auth/reset-password';
  static const String authSessions = '/api/v1/authentication/sessions';
  static const String authGoogle = '/api/v1/authentication/sessions/google';
  static const String authOtpSend = '/api/v1/authentication/otp/send';
  static const String authOtpVerify = '/api/v1/authentication/otp/verify';
  static const String authRegistrations = '/api/v1/authentication/registrations';
  static const String authInvitationsAccept =
      '/api/v1/authentication/invitations/accept';
  static const String users = '/api/v1/users';
  static const String usersMe = '/api/v1/users/me';

  /// Returns the invitation lookup endpoint for [token].
  static String authInvitationByToken(String token) =>
      '/api/v1/authentication/invitations/$token';

  /// Returns the user endpoint for [userId].
  static String userById(String userId) => '/api/v1/users/$userId';

  /// Returns the email update endpoint for [userId].
  static String userEmail(String userId) => '/api/v1/users/$userId/email';

  /// Returns the password update endpoint for [userId].
  static String userPassword(String userId) => '/api/v1/users/$userId/password';

  /// Returns the avatar upload endpoint for [userId].
  static String userAvatar(String userId) => '/api/v1/users/$userId/avatar';

  // Tenant & Profiles (erp-tenant-service)
  static const String workshops = '/api/v1/workshops';
  static const String branches = '/api/v1/branches';
  static const String profilesMe = '/api/v1/profiles/me';
  static const String profilesRoles = '/api/v1/profiles/roles';

  /// Returns the branch endpoint for [branchId].
  static String branchById(String branchId) => '/api/v1/branches/$branchId';

  // Fleet (erp-fleet-service)
  static const String appointments = '/api/v1/appointments';
  static const String vehicles = '/api/v1/vehicles';

  // Work Orders (erp-work-order-service)
  static const String workOrders = '/api/v1/work-orders';
  static const String services = '/api/v1/services';

  // Inventory (erp-inventory-service)
  static const String inventoryProducts = '/api/v1/inventory/products';

  // Billing (erp-billing-service)
  static const String quotes = '/api/v1/quotes';
  static const String vouchers = '/api/v1/vouchers';

  // Analytics (erp-analytics-service)
  static String branchAnalyticsSummary(String branchId) =>
      '/api/v1/analytics/branches/$branchId/summary';
}
