import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_application_driveos/core/auth/mobile_role_scope.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/features/auth/presentation/controllers/login_view_model.dart';
import 'package:mobile_application_driveos/features/auth/presentation/widgets/auth_scaffold.dart';

/// Email and password sign-in screen for DriveOS Mobile.
class LoginPage extends StatefulWidget {
  /// ViewModel coordinating sign-in state and validation.
  final LoginViewModel viewModel;

  /// Creates a [LoginPage].
  const LoginPage({super.key, required this.viewModel});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tenantController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tenantController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    widget.viewModel.clearError();
    if (!_formKey.currentState!.validate()) return;

    final success = await widget.viewModel.login(
      email: _emailController.text,
      password: _passwordController.text,
      tenantId: _tenantController.text,
    );

    if (success && mounted) {
      final destination = RoleRouter.resolveInitialRoute(
        getIt<SessionStorage>(),
        preferActiveBranch: true,
      );
      context.go(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final vm = widget.viewModel;

        return AuthScaffold(
          title: loc.translate('login_title'),
          subtitle: loc.translate('login_subtitle'),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (vm.errorMessage != null)
                  AuthErrorBanner(message: vm.errorMessage!),
                Text(
                  loc.translate('email'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: DriveOSColors.graphiteText,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  key: const Key('login_email_input'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  decoration: authInputDecoration(
                    hintText: loc.translate('email_hint'),
                    prefixIcon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return loc.translate('email_required');
                    }
                    if (!value.contains('@')) {
                      return loc.translate('email_invalid');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  loc.translate('password'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: DriveOSColors.graphiteText,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  key: const Key('login_password_input'),
                  controller: _passwordController,
                  obscureText: vm.obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: authInputDecoration(
                    hintText: loc.translate('password_hint'),
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        vm.obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: DriveOSColors.graphiteText
                            .withValues(alpha: 0.55),
                      ),
                      onPressed: vm.togglePasswordVisibility,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.translate('password_required');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  loc.translate('tenant_id'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: DriveOSColors.graphiteText,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  key: const Key('login_tenant_input'),
                  controller: _tenantController,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleLogin(),
                  decoration: authInputDecoration(
                    hintText: loc.translate('tenant_id_hint'),
                    prefixIcon: Icons.apartment_outlined,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed:
                        vm.isLoading ? null : () => context.push('/forgot-password'),
                    style: TextButton.styleFrom(
                      foregroundColor: DriveOSColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                    ),
                    child: Text(
                      loc.translate('forgot_password'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AuthPrimaryButton(
                  key: const Key('login_submit_btn'),
                  label: loc.translate('sign_in'),
                  isLoading: vm.isLoading,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 22),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      loc.translate('no_account'),
                      style: TextStyle(
                        fontSize: 13.5,
                        color: DriveOSColors.graphiteText
                            .withValues(alpha: 0.65),
                      ),
                    ),
                    TextButton(
                      onPressed:
                          vm.isLoading ? null : () => context.push('/register'),
                      style: TextButton.styleFrom(
                        foregroundColor: DriveOSColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                      child: Text(
                        loc.translate('create_account'),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
