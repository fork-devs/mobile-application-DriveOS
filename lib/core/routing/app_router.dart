import 'package:go_router/go_router.dart';
import 'package:mobile_application_driveos/core/auth/mobile_role_scope.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/auth/presentation/controllers/forgot_password_view_model.dart';
import 'package:mobile_application_driveos/features/auth/presentation/controllers/login_view_model.dart';
import 'package:mobile_application_driveos/features/auth/presentation/controllers/register_view_model.dart';
import 'package:mobile_application_driveos/features/auth/presentation/views/forgot_password_page.dart';
import 'package:mobile_application_driveos/features/auth/presentation/views/login_page.dart';
import 'package:mobile_application_driveos/features/auth/presentation/views/register_page.dart';
import 'package:mobile_application_driveos/features/core/presentation/views/branch_selection_page.dart';
import 'package:mobile_application_driveos/features/customer/presentation/views/customer_home_page.dart';
import 'package:mobile_application_driveos/features/main/presentation/main_page.dart';

/// Builds the declarative [GoRouter] configuration for DriveOS Mobile.
class AppRouter {
  AppRouter._();

  /// Creates the application [GoRouter] using [sessionStorage] for redirects.
  static GoRouter create(SessionStorage sessionStorage) {
    final initialLocation = RoleRouter.resolveInitialRoute(
      sessionStorage,
      preferActiveBranch: true,
    );

    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) =>
              LoginPage(viewModel: getIt<LoginViewModel>()),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) =>
              RegisterPage(viewModel: getIt<RegisterViewModel>()),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) =>
              ForgotPasswordPage(viewModel: getIt<ForgotPasswordViewModel>()),
        ),
        GoRoute(
          path: '/branches',
          builder: (context, state) => const BranchSelectionPage(),
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) => const MainPage(),
        ),
        GoRoute(
          path: '/customer',
          builder: (context, state) => const CustomerHomePage(),
        ),
      ],
    );
  }
}
