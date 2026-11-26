import 'package:get_it/get_it.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event_bus.dart';
import 'package:mobile_application_driveos/core/infrastructure/event/stream_domain_event_bus.dart';
import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/auth/application/auth_application.dart';
import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';
import 'package:mobile_application_driveos/features/auth/infrastructure/remote/auth_api.dart';
import 'package:mobile_application_driveos/features/auth/infrastructure/remote/user_api.dart';
import 'package:mobile_application_driveos/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:mobile_application_driveos/features/core/application/core_application.dart';
import 'package:mobile_application_driveos/features/core/domain/core_domain.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/remote/branch_api.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/remote/profile_api.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/remote/workshop_api.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/repositories/core_repository_impl.dart';
import 'package:mobile_application_driveos/features/fleet/application/fleet_application.dart';
import 'package:mobile_application_driveos/features/fleet/domain/fleet_domain.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/remote/appointment_api.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/remote/customer_vehicle_api.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/remote/registration_api.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/repositories/fleet_repository_impl.dart';
import 'package:mobile_application_driveos/features/inventory/application/inventory_application.dart';
import 'package:mobile_application_driveos/features/inventory/domain/inventory_domain.dart';
import 'package:mobile_application_driveos/features/inventory/infrastructure/remote/inventory_api.dart';
import 'package:mobile_application_driveos/features/inventory/infrastructure/repositories/inventory_repository_impl.dart';
import 'package:mobile_application_driveos/features/billing/application/billing_application.dart';
import 'package:mobile_application_driveos/features/billing/domain/billing_domain.dart';
import 'package:mobile_application_driveos/features/billing/infrastructure/remote/billing_api.dart';
import 'package:mobile_application_driveos/features/billing/infrastructure/repositories/billing_repository_impl.dart';
import 'package:mobile_application_driveos/features/iot/application/iot_application.dart';
import 'package:mobile_application_driveos/features/iot/domain/iot_domain.dart';
import 'package:mobile_application_driveos/features/iot/infrastructure/remote/iot_api.dart';
import 'package:mobile_application_driveos/features/iot/infrastructure/repositories/iot_repository_impl.dart';
import 'package:mobile_application_driveos/features/analytics/application/analytics_application.dart';
import 'package:mobile_application_driveos/features/analytics/domain/analytics_domain.dart';
import 'package:mobile_application_driveos/features/analytics/infrastructure/remote/analytics_api.dart';
import 'package:mobile_application_driveos/features/analytics/infrastructure/repositories/analytics_repository_impl.dart';
import 'package:mobile_application_driveos/features/shared/application/shared_application.dart';
import 'package:mobile_application_driveos/features/shared/domain/shared_domain.dart';
import 'package:mobile_application_driveos/features/shared/infrastructure/remote/shared_api.dart';
import 'package:mobile_application_driveos/features/shared/infrastructure/repositories/shared_repository_impl.dart';
import 'package:mobile_application_driveos/features/operations/application/operations_application.dart';
import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/remote/service_api.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/remote/work_order_api.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/remote/work_order_task_api.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/repositories/operations_repository_impl.dart';

/// Global [GetIt] service locator instance for DriveOS Mobile.
final GetIt getIt = GetIt.instance;

/// Registers shared kernel services and bounded-context dependencies.
void setupDependencies() {
  // Shared Kernel
  if (!getIt.isRegistered<DomainEventBus>()) {
    getIt.registerLazySingleton<DomainEventBus>(() => StreamDomainEventBus());
  }

  if (!getIt.isRegistered<SessionStorage>()) {
    getIt.registerLazySingleton<SessionStorage>(() => SessionStorage());
  }

  if (!getIt.isRegistered<ApiClient>()) {
    getIt.registerLazySingleton<ApiClient>(
      () => ApiClient(
        sessionStorage: getIt<SessionStorage>(),
        eventBus: getIt<DomainEventBus>(),
      ),
    );
  }

  // IAM (auth) Bounded Context
  if (!getIt.isRegistered<AuthApi>()) {
    getIt.registerLazySingleton<AuthApi>(() => AuthApi(getIt<ApiClient>()));
  }

  if (!getIt.isRegistered<UserApi>()) {
    getIt.registerLazySingleton<UserApi>(() => UserApi(getIt<ApiClient>()));
  }

  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authApi: getIt<AuthApi>(),
        userApi: getIt<UserApi>(),
        sessionStorage: getIt<SessionStorage>(),
        eventBus: getIt<DomainEventBus>(),
      ),
    );
  }

  if (!getIt.isRegistered<LoginWithPassword>()) {
    getIt.registerLazySingleton<LoginWithPassword>(
      () => LoginWithPassword(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<LoginWithGoogle>()) {
    getIt.registerLazySingleton<LoginWithGoogle>(
      () => LoginWithGoogle(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<Logout>()) {
    getIt.registerLazySingleton<Logout>(
      () => Logout(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<SendOtp>()) {
    getIt.registerLazySingleton<SendOtp>(
      () => SendOtp(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<VerifyOtp>()) {
    getIt.registerLazySingleton<VerifyOtp>(
      () => VerifyOtp(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<RegisterAccount>()) {
    getIt.registerLazySingleton<RegisterAccount>(
      () => RegisterAccount(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<ForgotPassword>()) {
    getIt.registerLazySingleton<ForgotPassword>(
      () => ForgotPassword(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<ResetPassword>()) {
    getIt.registerLazySingleton<ResetPassword>(
      () => ResetPassword(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<GetInvitationDetails>()) {
    getIt.registerLazySingleton<GetInvitationDetails>(
      () => GetInvitationDetails(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<AcceptInvitation>()) {
    getIt.registerLazySingleton<AcceptInvitation>(
      () => AcceptInvitation(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<GetCurrentUser>()) {
    getIt.registerLazySingleton<GetCurrentUser>(
      () => GetCurrentUser(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateUserEmail>()) {
    getIt.registerLazySingleton<UpdateUserEmail>(
      () => UpdateUserEmail(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateUserPassword>()) {
    getIt.registerLazySingleton<UpdateUserPassword>(
      () => UpdateUserPassword(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<UploadUserAvatar>()) {
    getIt.registerLazySingleton<UploadUserAvatar>(
      () => UploadUserAvatar(getIt<AuthRepository>()),
    );
  }

  // Core (Tenant & Profiles) Bounded Context
  if (!getIt.isRegistered<WorkshopApi>()) {
    getIt.registerLazySingleton<WorkshopApi>(
      () => WorkshopApi(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<BranchApi>()) {
    getIt.registerLazySingleton<BranchApi>(
      () => BranchApi(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<ProfileApi>()) {
    getIt.registerLazySingleton<ProfileApi>(
      () => ProfileApi(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<CoreRepository>()) {
    getIt.registerLazySingleton<CoreRepository>(
      () => CoreRepositoryImpl(
        workshopApi: getIt<WorkshopApi>(),
        branchApi: getIt<BranchApi>(),
        profileApi: getIt<ProfileApi>(),
        sessionStorage: getIt<SessionStorage>(),
        eventBus: getIt<DomainEventBus>(),
      ),
    );
  }

  if (!getIt.isRegistered<GetWorkshopsByOwner>()) {
    getIt.registerLazySingleton<GetWorkshopsByOwner>(
      () => GetWorkshopsByOwner(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<GetWorkshopById>()) {
    getIt.registerLazySingleton<GetWorkshopById>(
      () => GetWorkshopById(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<CreateWorkshop>()) {
    getIt.registerLazySingleton<CreateWorkshop>(
      () => CreateWorkshop(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateWorkshop>()) {
    getIt.registerLazySingleton<UpdateWorkshop>(
      () => UpdateWorkshop(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<GetBranchesByWorkshop>()) {
    getIt.registerLazySingleton<GetBranchesByWorkshop>(
      () => GetBranchesByWorkshop(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<GetBranchById>()) {
    getIt.registerLazySingleton<GetBranchById>(
      () => GetBranchById(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<CreateBranch>()) {
    getIt.registerLazySingleton<CreateBranch>(
      () => CreateBranch(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateBranch>()) {
    getIt.registerLazySingleton<UpdateBranch>(
      () => UpdateBranch(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<UploadBranchBanner>()) {
    getIt.registerLazySingleton<UploadBranchBanner>(
      () => UploadBranchBanner(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<SelectActiveBranch>()) {
    getIt.registerLazySingleton<SelectActiveBranch>(
      () => SelectActiveBranch(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<GetPlans>()) {
    getIt.registerLazySingleton<GetPlans>(
      () => GetPlans(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<AssignBranchSubscription>()) {
    getIt.registerLazySingleton<AssignBranchSubscription>(
      () => AssignBranchSubscription(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<CancelBranchSubscription>()) {
    getIt.registerLazySingleton<CancelBranchSubscription>(
      () => CancelBranchSubscription(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<GetMyProfileContext>()) {
    getIt.registerLazySingleton<GetMyProfileContext>(
      () => GetMyProfileContext(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateMyProfileImage>()) {
    getIt.registerLazySingleton<UpdateMyProfileImage>(
      () => UpdateMyProfileImage(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<UploadMyProfileImage>()) {
    getIt.registerLazySingleton<UploadMyProfileImage>(
      () => UploadMyProfileImage(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<LookupProfileByDocument>()) {
    getIt.registerLazySingleton<LookupProfileByDocument>(
      () => LookupProfileByDocument(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<CreateOwnerProfile>()) {
    getIt.registerLazySingleton<CreateOwnerProfile>(
      () => CreateOwnerProfile(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateOwnerProfile>()) {
    getIt.registerLazySingleton<UpdateOwnerProfile>(
      () => UpdateOwnerProfile(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<CreateEmployeeProfile>()) {
    getIt.registerLazySingleton<CreateEmployeeProfile>(
      () => CreateEmployeeProfile(getIt<CoreRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateEmployeeProfile>()) {
    getIt.registerLazySingleton<UpdateEmployeeProfile>(
      () => UpdateEmployeeProfile(getIt<CoreRepository>()),
    );
  }

  // Fleet Bounded Context
  if (!getIt.isRegistered<AppointmentApi>()) {
    getIt.registerLazySingleton<AppointmentApi>(
      () => AppointmentApi(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<CustomerVehicleApi>()) {
    getIt.registerLazySingleton<CustomerVehicleApi>(
      () => CustomerVehicleApi(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<RegistrationApi>()) {
    getIt.registerLazySingleton<RegistrationApi>(
      () => RegistrationApi(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<FleetRepository>()) {
    getIt.registerLazySingleton<FleetRepository>(
      () => FleetRepositoryImpl(
        appointmentApi: getIt<AppointmentApi>(),
        customerVehicleApi: getIt<CustomerVehicleApi>(),
        registrationApi: getIt<RegistrationApi>(),
      ),
    );
  }

  if (!getIt.isRegistered<CreateAppointment>()) {
    getIt.registerLazySingleton<CreateAppointment>(
      () => CreateAppointment(getIt<FleetRepository>()),
    );
  }

  if (!getIt.isRegistered<GetAppointments>()) {
    getIt.registerLazySingleton<GetAppointments>(
      () => GetAppointments(getIt<FleetRepository>()),
    );
  }

  if (!getIt.isRegistered<GetAppointmentById>()) {
    getIt.registerLazySingleton<GetAppointmentById>(
      () => GetAppointmentById(getIt<FleetRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateAppointment>()) {
    getIt.registerLazySingleton<UpdateAppointment>(
      () => UpdateAppointment(getIt<FleetRepository>()),
    );
  }

  if (!getIt.isRegistered<ManageAppointmentLifecycle>()) {
    getIt.registerLazySingleton<ManageAppointmentLifecycle>(
      () => ManageAppointmentLifecycle(getIt<FleetRepository>()),
    );
  }

  if (!getIt.isRegistered<CreateCustomer>()) {
    getIt.registerLazySingleton<CreateCustomer>(
      () => CreateCustomer(getIt<FleetRepository>()),
    );
  }

  if (!getIt.isRegistered<GetCustomers>()) {
    getIt.registerLazySingleton<GetCustomers>(
      () => GetCustomers(getIt<FleetRepository>()),
    );
  }

  if (!getIt.isRegistered<ManageCustomer>()) {
    getIt.registerLazySingleton<ManageCustomer>(
      () => ManageCustomer(getIt<FleetRepository>()),
    );
  }

  if (!getIt.isRegistered<CreateVehicle>()) {
    getIt.registerLazySingleton<CreateVehicle>(
      () => CreateVehicle(getIt<FleetRepository>()),
    );
  }

  if (!getIt.isRegistered<GetVehicles>()) {
    getIt.registerLazySingleton<GetVehicles>(
      () => GetVehicles(getIt<FleetRepository>()),
    );
  }

  if (!getIt.isRegistered<ManageVehicle>()) {
    getIt.registerLazySingleton<ManageVehicle>(
      () => ManageVehicle(getIt<FleetRepository>()),
    );
  }

  if (!getIt.isRegistered<ManageCustomerRegistrations>()) {
    getIt.registerLazySingleton<ManageCustomerRegistrations>(
      () => ManageCustomerRegistrations(getIt<FleetRepository>()),
    );
  }

  if (!getIt.isRegistered<ManageEmployeeRegistrations>()) {
    getIt.registerLazySingleton<ManageEmployeeRegistrations>(
      () => ManageEmployeeRegistrations(getIt<FleetRepository>()),
    );
  }

  // Operations (Work Orders) Bounded Context
  if (!getIt.isRegistered<WorkOrderApi>()) {
    getIt.registerLazySingleton<WorkOrderApi>(
      () => WorkOrderApi(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<WorkOrderTaskApi>()) {
    getIt.registerLazySingleton<WorkOrderTaskApi>(
      () => WorkOrderTaskApi(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<ServiceApi>()) {
    getIt.registerLazySingleton<ServiceApi>(
      () => ServiceApi(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<OperationsRepository>()) {
    getIt.registerLazySingleton<OperationsRepository>(
      () => OperationsRepositoryImpl(
        workOrderApi: getIt<WorkOrderApi>(),
        taskApi: getIt<WorkOrderTaskApi>(),
        serviceApi: getIt<ServiceApi>(),
      ),
    );
  }

  if (!getIt.isRegistered<ManageWorkOrders>()) {
    getIt.registerLazySingleton<ManageWorkOrders>(
      () => ManageWorkOrders(getIt<OperationsRepository>()),
    );
  }

  if (!getIt.isRegistered<ManageWorkOrderTasks>()) {
    getIt.registerLazySingleton<ManageWorkOrderTasks>(
      () => ManageWorkOrderTasks(getIt<OperationsRepository>()),
    );
  }

  if (!getIt.isRegistered<ManageEvidencesAndSupplements>()) {
    getIt.registerLazySingleton<ManageEvidencesAndSupplements>(
      () => ManageEvidencesAndSupplements(getIt<OperationsRepository>()),
    );
  }

  if (!getIt.isRegistered<ManageWorkshopServices>()) {
    getIt.registerLazySingleton<ManageWorkshopServices>(
      () => ManageWorkshopServices(getIt<OperationsRepository>()),
    );
  }

  // Inventory Bounded Context
  if (!getIt.isRegistered<InventoryApi>()) {
    getIt.registerLazySingleton<InventoryApi>(
      () => InventoryApi(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<InventoryRepository>()) {
    getIt.registerLazySingleton<InventoryRepository>(
      () => InventoryRepositoryImpl(inventoryApi: getIt<InventoryApi>()),
    );
  }

  if (!getIt.isRegistered<ManageInventoryProducts>()) {
    getIt.registerLazySingleton<ManageInventoryProducts>(
      () => ManageInventoryProducts(getIt<InventoryRepository>()),
    );
  }

  if (!getIt.isRegistered<ManageSparePartsAndStock>()) {
    getIt.registerLazySingleton<ManageSparePartsAndStock>(
      () => ManageSparePartsAndStock(getIt<InventoryRepository>()),
    );
  }

  // Billing Bounded Context
  if (!getIt.isRegistered<BillingApi>()) {
    getIt.registerLazySingleton<BillingApi>(
      () => BillingApi(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<BillingRepository>()) {
    getIt.registerLazySingleton<BillingRepository>(
      () => BillingRepositoryImpl(billingApi: getIt<BillingApi>()),
    );
  }

  if (!getIt.isRegistered<ManageQuotes>()) {
    getIt.registerLazySingleton<ManageQuotes>(
      () => ManageQuotes(getIt<BillingRepository>()),
    );
  }

  if (!getIt.isRegistered<ManageCheckouts>()) {
    getIt.registerLazySingleton<ManageCheckouts>(
      () => ManageCheckouts(getIt<BillingRepository>()),
    );
  }

  if (!getIt.isRegistered<ManageVouchers>()) {
    getIt.registerLazySingleton<ManageVouchers>(
      () => ManageVouchers(getIt<BillingRepository>()),
    );
  }

  // IoT & Telemetry Bounded Context
  if (!getIt.isRegistered<IotApi>()) {
    getIt.registerLazySingleton<IotApi>(() => IotApi(getIt<ApiClient>()));
  }

  if (!getIt.isRegistered<IotRepository>()) {
    getIt.registerLazySingleton<IotRepository>(
      () => IotRepositoryImpl(iotApi: getIt<IotApi>()),
    );
  }

  if (!getIt.isRegistered<ManageObd2Devices>()) {
    getIt.registerLazySingleton<ManageObd2Devices>(
      () => ManageObd2Devices(getIt<IotRepository>()),
    );
  }

  if (!getIt.isRegistered<ManageTelemetryAndDiagnostics>()) {
    getIt.registerLazySingleton<ManageTelemetryAndDiagnostics>(
      () => ManageTelemetryAndDiagnostics(getIt<IotRepository>()),
    );
  }

  // Analytics Bounded Context
  if (!getIt.isRegistered<AnalyticsApi>()) {
    getIt.registerLazySingleton<AnalyticsApi>(
      () => AnalyticsApi(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<AnalyticsRepository>()) {
    getIt.registerLazySingleton<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl(analyticsApi: getIt<AnalyticsApi>()),
    );
  }

  if (!getIt.isRegistered<GetAnalytics>()) {
    getIt.registerLazySingleton<GetAnalytics>(
      () => GetAnalytics(getIt<AnalyticsRepository>()),
    );
  }

  // Shared Integration Hub Generic Subdomain
  if (!getIt.isRegistered<SharedApi>()) {
    getIt.registerLazySingleton<SharedApi>(
      () => SharedApi(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<SharedRepository>()) {
    getIt.registerLazySingleton<SharedRepository>(
      () => SharedRepositoryImpl(sharedApi: getIt<SharedApi>()),
    );
  }

  if (!getIt.isRegistered<ManageIdentityValidations>()) {
    getIt.registerLazySingleton<ManageIdentityValidations>(
      () => ManageIdentityValidations(getIt<SharedRepository>()),
    );
  }

  if (!getIt.isRegistered<ManageMediaAndHealth>()) {
    getIt.registerLazySingleton<ManageMediaAndHealth>(
      () => ManageMediaAndHealth(getIt<SharedRepository>()),
    );
  }
}
