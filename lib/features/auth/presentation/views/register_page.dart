import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_application_driveos/core/auth/mobile_role_scope.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/features/auth/presentation/controllers/register_view_model.dart';
import 'package:mobile_application_driveos/features/auth/presentation/widgets/auth_scaffold.dart';

/// Three-step DriveOS account sign-up screen with 6-digit OTP verification.
class RegisterPage extends StatefulWidget {
  /// ViewModel coordinating OTP verification and account creation.
  final RegisterViewModel viewModel;

  /// Creates a [RegisterPage].
  const RegisterPage({super.key, required this.viewModel});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _documentController = TextEditingController();
  final _tenantController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _fullNameController.dispose();
    _documentController.dispose();
    _tenantController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    widget.viewModel.clearError();
    if (!_formKey.currentState!.validate()) return;
    await widget.viewModel.sendOtp(_emailController.text);
  }

  Future<void> _handleVerifyOtp() async {
    widget.viewModel.clearError();
    if (!_formKey.currentState!.validate()) return;
    await widget.viewModel.verifyOtp(_otpController.text);
  }

  Future<void> _handleSignUp() async {
    widget.viewModel.clearError();
    if (!_formKey.currentState!.validate()) return;

    final success = await widget.viewModel.completeRegistration(
      fullName: _fullNameController.text,
      documentNumber: _documentController.text,
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
        final subtitle = switch (vm.step) {
          RegisterStep.enterEmail => loc.translate('register_step1_subtitle'),
          RegisterStep.verifyOtp => loc.translate('register_step2_subtitle'),
          RegisterStep.createPassword =>
            loc.translate('register_step3_subtitle'),
        };

        return AuthScaffold(
          title: loc.translate('register_title'),
          subtitle: subtitle,
          showBackButton: true,
          showLogo: false,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StepIndicator(currentStep: vm.step.index),
                const SizedBox(height: 20),
                if (vm.errorMessage != null)
                  AuthErrorBanner(message: vm.errorMessage!),
                if (vm.step == RegisterStep.enterEmail) ...[
                  _FieldLabel(loc.translate('email')),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('register_email_input'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
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
                  const SizedBox(height: 22),
                  AuthPrimaryButton(
                    key: const Key('register_send_otp_btn'),
                    label: loc.translate('send_otp'),
                    isLoading: vm.isLoading,
                    onPressed: _handleSendOtp,
                  ),
                ],
                if (vm.step == RegisterStep.verifyOtp) ...[
                  _FieldLabel(loc.translate('otp_code')),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('register_otp_input'),
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: authInputDecoration(
                      hintText: loc.translate('otp_hint'),
                      prefixIcon: Icons.pin_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length != 6) {
                        return loc.translate('otp_invalid');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthPrimaryButton(
                    key: const Key('register_verify_otp_btn'),
                    label: loc.translate('verify_code'),
                    isLoading: vm.isLoading,
                    onPressed: _handleVerifyOtp,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: vm.isLoading ? null : vm.backToEmailStep,
                    child: Text(loc.translate('change_email')),
                  ),
                ],
                if (vm.step == RegisterStep.createPassword) ...[
                  _FieldLabel(loc.translate('account_type')),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment<String>(
                        value: 'CUSTOMER',
                        label: Text(loc.translate('account_type_customer')),
                        icon: const Icon(Icons.person_outline_rounded),
                      ),
                      ButtonSegment<String>(
                        value: 'OWNER',
                        label: Text(loc.translate('account_type_owner')),
                        icon: const Icon(Icons.build_outlined),
                      ),
                    ],
                    selected: {vm.accountType},
                    onSelectionChanged: (selection) =>
                        vm.setAccountType(selection.first),
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(loc.translate('full_name')),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('register_fullname_input'),
                    controller: _fullNameController,
                    textInputAction: TextInputAction.next,
                    decoration: authInputDecoration(
                      hintText: loc.translate('full_name_hint'),
                      prefixIcon: Icons.badge_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.translate('full_name_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(loc.translate('document_number')),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('register_document_input'),
                    controller: _documentController,
                    textInputAction: TextInputAction.next,
                    decoration: authInputDecoration(
                      hintText: loc.translate('document_number_hint'),
                      prefixIcon: Icons.credit_card_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.translate('document_number_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(loc.translate('tenant_id')),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('register_tenant_input'),
                    controller: _tenantController,
                    textInputAction: TextInputAction.next,
                    decoration: authInputDecoration(
                      hintText: loc.translate('tenant_id_hint'),
                      prefixIcon: Icons.apartment_outlined,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(loc.translate('password')),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('register_password_input'),
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
                  const SizedBox(height: 16),
                  _FieldLabel(loc.translate('confirm_password')),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('register_confirm_password_input'),
                    controller: _confirmPasswordController,
                    obscureText: vm.obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleSignUp(),
                    decoration: authInputDecoration(
                      hintText: loc.translate('confirm_password_hint'),
                      prefixIcon: Icons.lock_outline_rounded,
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return loc.translate('passwords_do_not_match');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),
                  AuthPrimaryButton(
                    key: const Key('register_complete_btn'),
                    label: loc.translate('complete_registration'),
                    isLoading: vm.isLoading,
                    onPressed: _handleSignUp,
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: DriveOSColors.graphiteText,
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        final active = index <= currentStep;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
            decoration: BoxDecoration(
              color: active
                  ? DriveOSColors.primaryBlue
                  : DriveOSColors.borderSlate,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
