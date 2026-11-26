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
}
