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
  static const String workOrdersMe = '/api/v1/work-orders/me';
  static const String services = '/api/v1/services';

  /// Returns the work order endpoint for [orderId].
  static String workOrderById(String orderId) => '/api/v1/work-orders/$orderId';

  /// Returns the work order items endpoint for [orderId].
  static String workOrderItems(String orderId) =>
      '/api/v1/work-orders/$orderId/items';

  /// Returns the work order transition endpoint for [orderId].
  static String workOrderTransition(String orderId) =>
      '/api/v1/work-orders/$orderId/transition';

  /// Returns the work order completion endpoint for [orderId].
  static String workOrderComplete(String orderId) =>
      '/api/v1/work-orders/$orderId/complete';

  /// Returns the work order quote endpoint for [orderId].
  static String workOrderQuote(String orderId) =>
      '/api/v1/work-orders/$orderId/quote';

  /// Returns the work order approval endpoint for [orderId].
  static String workOrderApprove(String orderId) =>
      '/api/v1/work-orders/$orderId/approve';

  /// Returns the work order rejection endpoint for [orderId].
  static String workOrderReject(String orderId) =>
      '/api/v1/work-orders/$orderId/reject';

  /// Returns the work order cancellation endpoint for [orderId].
  static String workOrderCancel(String orderId) =>
      '/api/v1/work-orders/$orderId/cancel';

  /// Returns the tasks endpoint for [workOrderId].
  static String workOrderTasks(String workOrderId) =>
      '/api/v1/work-orders/$workOrderId/tasks';

  /// Returns the task endpoint for [taskId] in [workOrderId].
  static String workOrderTaskById(String workOrderId, String taskId) =>
      '/api/v1/work-orders/$workOrderId/tasks/$taskId';

  /// Returns the task evidence upload endpoint.
  static String workOrderTaskEvidence(String workOrderId, String taskId) =>
      '/api/v1/work-orders/$workOrderId/tasks/$taskId/evidence';

  /// Returns the mechanic assignment endpoint for [taskId].
  static String workOrderTaskAssignMechanic(String taskId) =>
      '/api/v1/work-order-tasks/$taskId/assign-mechanic';

  /// Returns the task start endpoint for [taskId].
  static String workOrderTaskStart(String taskId) =>
      '/api/v1/work-order-tasks/$taskId/start';

  /// Returns the task complete endpoint for [taskId].
  static String workOrderTaskComplete(String taskId) =>
      '/api/v1/work-order-tasks/$taskId/complete';

  /// Returns the task reopen endpoint for [taskId].
  static String workOrderTaskReopen(String taskId) =>
      '/api/v1/work-order-tasks/$taskId/reopen';

  /// Returns the task products endpoint for [taskId].
  static String workOrderTaskProducts(String taskId) =>
      '/api/v1/work-order-tasks/$taskId/products';

  /// Returns the task product endpoint for [productId] on [taskId].
  static String workOrderTaskProductById(String taskId, String productId) =>
      '/api/v1/work-order-tasks/$taskId/products/$productId';

  /// Returns the supplements send-to-customer endpoint for [orderId].
  static String workOrderSupplementsSend(String orderId) =>
      '/api/v1/work-orders/$orderId/supplements/send-to-customer';

  /// Returns the supplements approval endpoint for [orderId].
  static String workOrderSupplementsApprove(String orderId) =>
      '/api/v1/work-orders/$orderId/supplements/approve';

  /// Returns the supplements rejection endpoint for [orderId].
  static String workOrderSupplementsReject(String orderId) =>
      '/api/v1/work-orders/$orderId/supplements/reject';

  /// Returns the work order evidences endpoint for [orderId].
  static String workOrderEvidences(String orderId) =>
      '/api/v1/work-orders/$orderId/evidences';

  /// Returns the workshop service endpoint for [serviceId].
  static String serviceById(String serviceId) => '/api/v1/services/$serviceId';

  // Inventory (erp-inventory-service)
  static const String inventoryProducts = '/api/v1/inventory/products';
  static const String inventorySpareParts = '/api/v1/inventory/spare-parts';
  static const String inventoryStockMovements =
      '/api/v1/inventory/stock/movements';
  static const String inventoryStockReserve = '/api/v1/inventory/stock/reserve';
  static const String inventoryStockCommit = '/api/v1/inventory/stock/commit';
  static const String inventoryStockRelease = '/api/v1/inventory/stock/release';

  /// Returns the inventory product endpoint for [productId].
  static String inventoryProductById(String productId) =>
      '/api/v1/inventory/products/$productId';

  /// Returns the inventory product batches endpoint for [productId].
  static String inventoryProductBatches(String productId) =>
      '/api/v1/inventory/products/$productId/batches';

  /// Returns the inventory product image upload endpoint for [productId].
  static String inventoryProductImage(String productId) =>
      '/api/v1/inventory/products/$productId/image';

  /// Returns the spare part endpoint for [sparePartId].
  static String inventorySparePartById(String sparePartId) =>
      '/api/v1/inventory/spare-parts/$sparePartId';

  /// Returns the stock balance endpoint for [sparePartId] in [branchId].
  static String inventoryStockBalance(String sparePartId, String branchId) =>
      '/api/v1/inventory/stock/balance/$sparePartId/branch/$branchId';

  // Billing (erp-billing-service)
  static const String quotes = '/api/v1/quotes';
  static const String quotesMe = '/api/v1/quotes/me';
  static const String checkouts = '/api/v1/checkouts';
  static const String checkoutsMercadoPago = '/api/v1/checkouts/mercadopago';
  static const String paymentSessions = '/api/v1/payments/sessions';
  static const String vouchers = '/api/v1/vouchers';

  /// Returns the quote endpoint for [quoteId].
  static String quoteById(String quoteId) => '/api/v1/quotes/$quoteId';

  /// Returns the quote sync endpoint for [quoteId].
  static String quoteSync(String quoteId) => '/api/v1/quotes/$quoteId/sync';

  /// Returns the quote approval endpoint for [quoteId].
  static String quoteApprove(String quoteId) =>
      '/api/v1/quotes/$quoteId/approvals';

  /// Returns the quote cancellation endpoint for [quoteId].
  static String quoteCancel(String quoteId) =>
      '/api/v1/quotes/$quoteId/cancellations';

  /// Returns the voucher endpoint for [voucherId].
  static String voucherById(String voucherId) => '/api/v1/vouchers/$voucherId';

  /// Returns the voucher payments endpoint for [voucherId].
  static String voucherPayments(String voucherId) =>
      '/api/v1/vouchers/$voucherId/payments';

  /// Returns the voucher payment endpoint for [paymentId] on [voucherId].
  static String voucherPaymentById(String voucherId, String paymentId) =>
      '/api/v1/vouchers/$voucherId/payments/$paymentId';

  // IoT & Telemetry (erp-iot-ingestion, erp-iot-processor, erp-iot-simulator)
  static const String obd2Devices = '/api/v1/obd2-devices';
  static const String obd2Registrations = '/api/v1/obd2-device-registrations';
  static const String simulatorStart = '/api/v1/simulator/start';
  static const String simulatorStop = '/api/v1/simulator/stop';
  static const String simulatorStatus = '/api/v1/simulator/status';

  /// Returns the OBD2 device endpoint for [deviceId].
  static String obd2DeviceById(String deviceId) =>
      '/api/v1/obd2-devices/$deviceId';

  /// Returns the OBD2 registration endpoint for [registrationId].
  static String obd2RegistrationById(String registrationId) =>
      '/api/v1/obd2-device-registrations/$registrationId';

  /// Returns the vehicle diagnostics endpoint for [vehicleId].
  static String vehicleDiagnostics(String vehicleId) =>
      '/api/v1/iot/diagnostics/$vehicleId';

  /// Returns the telemetry snapshots endpoint for [vehicleId].
  static String vehicleTelemetrySnapshots(String vehicleId) =>
      '/api/v1/vehicles/$vehicleId/telemetry-snapshots';

  /// Returns the DTC alerts endpoint for [vehicleId].
  static String vehicleDtcAlerts(String vehicleId) =>
      '/api/v1/vehicles/$vehicleId/dtc-alerts';

  /// Returns the latest telemetry snapshot endpoint for [deviceId].
  static String deviceLatestSnapshot(String deviceId) =>
      '/api/v1/obd2-devices/$deviceId/telemetry-snapshots/latest';

  /// Returns the telemetry snapshots endpoint for [deviceId].
  static String deviceTelemetrySnapshots(String deviceId) =>
      '/api/v1/obd2-devices/$deviceId/telemetry-snapshots';

  /// Returns the telemetry snapshots endpoint for [registrationId].
  static String registrationTelemetrySnapshots(String registrationId) =>
      '/api/v1/obd2-device-registrations/$registrationId/telemetry-snapshots';

  /// Returns the DTC alerts endpoint for [registrationId].
  static String registrationDtcAlerts(String registrationId) =>
      '/api/v1/obd2-device-registrations/$registrationId/dtc-alerts';

  // Analytics (erp-analytics-service)
  static const String analyticsSummary = '/api/v1/analytics/summary';
  static const String analyticsRevenueTrend =
      '/api/v1/analytics/revenue/trend';
  static const String analyticsNetworkSummary =
      '/api/v1/analytics/network/summary';
  static const String analyticsCustomerSummary =
      '/api/v1/analytics/me/customer-summary';
  static const String analyticsEmployeeSummary =
      '/api/v1/analytics/me/employee-summary';

  /// Returns the branch analytics summary endpoint for [branchId].
  static String branchAnalyticsSummary(String branchId) =>
      '/api/v1/analytics/branches/$branchId/summary';

  /// Returns the branch financial series endpoint for [branchId].
  static String branchAnalyticsFinancial(String branchId) =>
      '/api/v1/analytics/branches/$branchId/financial';
}
