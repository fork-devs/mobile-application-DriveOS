import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/features/auth/application/auth_application.dart';

/// Discrete steps in the password recovery flow.
enum ForgotPasswordStep {
  /// Step 1: Request a password recovery token via email.
  requestEmail,

  /// Step 2: Confirm the new password using the received token.
  resetWithToken,

  /// Step 3: Password reset completed.
  completed,
}

/// Presentation ViewModel managing the two-step password recovery workflow.
class ForgotPasswordViewModel extends ChangeNotifier {
  final ForgotPassword _forgotPassword;
  final ResetPassword _resetPassword;

  /// Creates a [ForgotPasswordViewModel].
  ForgotPasswordViewModel({
    required this._forgotPassword,
    required this._resetPassword,
  });

  /// Current active step in the recovery flow.
  ForgotPasswordStep step = ForgotPasswordStep.requestEmail;

  /// Whether an asynchronous recovery call is in progress.
  bool isLoading = false;

  /// Whether the new password field is obscured.
  bool obscurePassword = true;

  /// Latest validation or server error message, if any.
  String? errorMessage;

  /// Email address used to request the recovery token.
  String targetEmail = '';

  /// Tenant identifier carried into the reset confirmation call.
  String targetTenantId = '';

  /// Toggles visibility of the new password field.
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  /// Clears any active [errorMessage].
  void clearError() {
    if (errorMessage != null) {
      errorMessage = null;
      notifyListeners();
    }
  }

  /// Sends a password recovery email to [email] for [tenantId].
  Future<bool> sendRecoveryEmail({
    required String email,
    required String tenantId,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedTenant = tenantId.trim();
    if (trimmedEmail.isEmpty || !trimmedEmail.contains('@')) {
      errorMessage = 'Please enter a valid email address.';
      notifyListeners();
      return false;
    }
    if (trimmedTenant.isEmpty) {
      errorMessage = 'Please enter your workshop tenant ID.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _forgotPassword(email: trimmedEmail, tenantId: trimmedTenant);
      targetEmail = trimmedEmail;
      targetTenantId = trimmedTenant;
      step = ForgotPasswordStep.resetWithToken;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Resets the password using [token] and [newPassword].
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final trimmedToken = token.trim();
    if (trimmedToken.isEmpty || newPassword.length < 8) {
      errorMessage =
          'Provide a valid token and a password of at least 8 characters.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _resetPassword(
        token: trimmedToken,
        newPassword: newPassword,
        tenantId: targetTenantId,
      );
      step = ForgotPasswordStep.completed;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
