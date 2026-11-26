import 'package:flutter/material.dart';
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
          builder: (context, state) => const _PlaceholderScreen(
            title: 'Select Branch',
            subtitle: 'Core bounded context pending implementation.',
          ),
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) => const _PlaceholderScreen(
            title: 'DriveOS Workshop',
            subtitle: 'Workshop shell pending implementation.',
          ),
        ),
        GoRoute(
          path: '/customer',
          builder: (context, state) => const _PlaceholderScreen(
            title: 'DriveOS Customer',
            subtitle: 'Customer portal pending implementation.',
          ),
        ),
      ],
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;

  const _PlaceholderScreen({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
