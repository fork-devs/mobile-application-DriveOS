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
  static const String plans = '/api/v1/plans';
  static const String workshops = '/api/v1/workshops';
  static const String branches = '/api/v1/branches';
  static const String owners = '/api/v1/owners';
  static const String employees = '/api/v1/employees';
  static const String profiles = '/api/v1/profiles';
  static const String profilesMe = '/api/v1/profiles/me';
  static const String profilesMeImage = '/api/v1/profiles/me/image';
  static const String profilesMeImageUpload = '/api/v1/profiles/me/image/upload';
  static const String profilesRoles = '/api/v1/profiles/roles';

  /// Returns the workshop endpoint for [workshopId].
  static String workshopById(String workshopId) =>
      '/api/v1/workshops/$workshopId';

  /// Returns the branch endpoint for [branchId].
  static String branchById(String branchId) => '/api/v1/branches/$branchId';

  /// Returns the branch banner upload endpoint for [branchId].
  static String branchBanner(String branchId) =>
      '/api/v1/branches/$branchId/banner';

  /// Returns the branch subscription creation endpoint for [branchId].
  static String branchSubscriptions(String branchId) =>
      '/api/v1/branches/$branchId/subscriptions';

  /// Returns the branch subscription cancellation endpoint for [branchId].
  static String branchSubscription(String branchId) =>
      '/api/v1/branches/$branchId/subscription';

  /// Returns the owner profile endpoint for [ownerId].
  static String ownerById(String ownerId) => '/api/v1/owners/$ownerId';

  /// Returns the employee profile endpoint for [employeeId].
  static String employeeById(String employeeId) =>
      '/api/v1/employees/$employeeId';

  // Fleet (erp-fleet-service)
  static const String appointments = '/api/v1/appointments';
  static const String customers = '/api/v1/customers';
  static const String vehicles = '/api/v1/vehicles';
  static const String customerRegistrations = '/api/v1/customer-registrations';
  static const String employeeRegistrations = '/api/v1/employee-registrations';
  static const String employeeRegistrationRequestJoin =
      '/api/v1/employee-registrations/request-join';

  /// Returns the appointment endpoint for [appointmentId].
  static String appointmentById(String appointmentId) =>
      '/api/v1/appointments/$appointmentId';

  /// Returns the appointment confirm endpoint for [appointmentId].
  static String appointmentConfirm(String appointmentId) =>
      '/api/v1/appointments/$appointmentId/confirm';

  /// Returns the appointment check-in endpoint for [appointmentId].
  static String appointmentCheckIn(String appointmentId) =>
      '/api/v1/appointments/$appointmentId/check-in';

  /// Returns the appointment complete endpoint for [appointmentId].
  static String appointmentComplete(String appointmentId) =>
      '/api/v1/appointments/$appointmentId/complete';

  /// Returns the appointment cancel endpoint for [appointmentId].
  static String appointmentCancel(String appointmentId) =>
      '/api/v1/appointments/$appointmentId/cancel';

  /// Returns the customer endpoint for [customerId].
  static String customerById(String customerId) =>
      '/api/v1/customers/$customerId';

  /// Returns the customer validation endpoint for [customerId].
  static String customerValidate(String customerId) =>
      '/api/v1/customers/$customerId/validate';

  /// Returns the vehicles endpoint scoped to [customerId].
  static String customerVehicles(String customerId) =>
      '/api/v1/customers/$customerId/vehicles';

  /// Returns the vehicle endpoint for [vehicleId].
  static String vehicleById(String vehicleId) => '/api/v1/vehicles/$vehicleId';

  /// Returns the vehicles endpoint filtered by [customerId].
  static String vehiclesByCustomer(String customerId) =>
      '/api/v1/vehicles/customer/$customerId';

  /// Returns the vehicle validation endpoint for [vehicleId].
  static String vehicleValidate(String vehicleId) =>
      '/api/v1/vehicles/$vehicleId/validate';

  /// Returns the vehicle image upload endpoint for [vehicleId].
  static String vehicleImage(String vehicleId) =>
      '/api/v1/vehicles/$vehicleId/image';

  /// Returns the customer registration endpoint for [registrationId].
  static String customerRegistrationById(String registrationId) =>
      '/api/v1/customer-registrations/$registrationId';

  /// Returns the employee registration endpoint for [registrationId].
  static String employeeRegistrationById(String registrationId) =>
      '/api/v1/employee-registrations/$registrationId';

  /// Returns the employee registration approval endpoint for [registrationId].
  static String employeeRegistrationApprove(String registrationId) =>
      '/api/v1/employee-registrations/$registrationId/approve';

  /// Returns the employee registration rejection endpoint for [registrationId].
  static String employeeRegistrationReject(String registrationId) =>
      '/api/v1/employee-registrations/$registrationId/reject';

  /// Returns the career history endpoint for [employeeId] in [branchId].
  static String branchEmployeeHistory(String branchId, String employeeId) =>
      '/api/v1/branches/$branchId/employees/$employeeId/history';

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
