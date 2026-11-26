import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_toast.dart';
import 'package:mobile_application_driveos/features/auth/presentation/controllers/forgot_password_view_model.dart';
import 'package:mobile_application_driveos/features/auth/presentation/widgets/auth_scaffold.dart';

/// Two-step password recovery and reset screen.
class ForgotPasswordPage extends StatefulWidget {
  /// ViewModel coordinating password recovery and reset confirmation.
  final ForgotPasswordViewModel viewModel;

  /// Creates a [ForgotPasswordPage].
  const ForgotPasswordPage({super.key, required this.viewModel});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _tenantController = TextEditingController();
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _tenantController.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSendEmail() async {
    widget.viewModel.clearError();
    if (!_formKey.currentState!.validate()) return;
    await widget.viewModel.sendRecoveryEmail(
      email: _emailController.text,
      tenantId: _tenantController.text,
    );
  }

  Future<void> _handleResetPassword() async {
    widget.viewModel.clearError();
    if (!_formKey.currentState!.validate()) return;

    final success = await widget.viewModel.resetPassword(
      token: _tokenController.text,
      newPassword: _newPasswordController.text,
    );

    if (success && mounted) {
      final loc = AppLocalizations.of(context);
      DriveOSToast.show(
        context,
        loc.translate('forgot_success_msg'),
        type: DriveOSToastType.success,
      );
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final vm = widget.viewModel;
        final isStepOne = vm.step == ForgotPasswordStep.requestEmail;

        return AuthScaffold(
          title: loc.translate('forgot_title'),
          subtitle: isStepOne
              ? loc.translate('forgot_step1_subtitle')
              : loc.translate('forgot_step2_subtitle'),
          showBackButton: true,
          showLogo: false,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (vm.errorMessage != null)
                  AuthErrorBanner(message: vm.errorMessage!),
                if (isStepOne) ...[
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
                    key: const Key('forgot_email_input'),
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
                    loc.translate('tenant_id'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: DriveOSColors.graphiteText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('forgot_tenant_input'),
                    controller: _tenantController,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleSendEmail(),
                    decoration: authInputDecoration(
                      hintText: loc.translate('tenant_id_hint'),
                      prefixIcon: Icons.apartment_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.translate('tenant_id_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),
                  AuthPrimaryButton(
                    key: const Key('forgot_send_btn'),
                    label: loc.translate('send_recovery_code'),
                    isLoading: vm.isLoading,
                    onPressed: _handleSendEmail,
                  ),
                ] else ...[
                  Text(
                    loc.translate('recovery_token'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: DriveOSColors.graphiteText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('forgot_token_input'),
                    controller: _tokenController,
                    textInputAction: TextInputAction.next,
                    decoration: authInputDecoration(
                      hintText: loc.translate('recovery_token_hint'),
                      prefixIcon: Icons.vpn_key_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.translate('recovery_token_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.translate('new_password'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: DriveOSColors.graphiteText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('forgot_new_password_input'),
                    controller: _newPasswordController,
                    obscureText: vm.obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleResetPassword(),
                    decoration: authInputDecoration(
                      hintText: loc.translate('password_hint'),
                      prefixIcon: Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
                        icon: Icon(
                          vm.obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                        ),
                        onPressed: vm.togglePasswordVisibility,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return loc.translate('password_min_length');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),
                  AuthPrimaryButton(
                    key: const Key('forgot_reset_btn'),
                    label: loc.translate('reset_password_action'),
                    isLoading: vm.isLoading,
                    onPressed: _handleResetPassword,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
