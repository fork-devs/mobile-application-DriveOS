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
}
