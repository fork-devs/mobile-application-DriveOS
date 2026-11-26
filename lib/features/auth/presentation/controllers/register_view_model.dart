import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/features/auth/application/auth_application.dart';
import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';

/// Discrete steps in the DriveOS account registration flow.
enum RegisterStep {
  /// Step 1: Enter email and request a 6-digit OTP code.
  enterEmail,

  /// Step 2: Verify the 6-digit OTP code sent to the email.
  verifyOtp,

  /// Step 3: Complete profile details and choose a password.
  createPassword,
}

/// Presentation ViewModel orchestrating OTP verification and account creation.
class RegisterViewModel extends ChangeNotifier {
  final SendOtp _sendOtp;
  final VerifyOtp _verifyOtp;
  final RegisterAccount _registerAccount;

  /// Creates a [RegisterViewModel].
  RegisterViewModel({
    required this._sendOtp,
    required this._verifyOtp,
    required this._registerAccount,
  });

  /// Current active step in the registration flow.
  RegisterStep step = RegisterStep.enterEmail;

  /// Whether an asynchronous auth call is currently running.
  bool isLoading = false;

  /// Whether password fields are obscured.
  bool obscurePassword = true;

  /// Selected account type (`CUSTOMER` or `OWNER`).
  String accountType = 'CUSTOMER';

  /// Latest validation or backend error message, if any.
  String? errorMessage;

  /// Email address carried across registration steps.
  String verifiedEmail = '';

  /// Session returned after successful registration.
  UserSession? createdSession;

  /// Toggles password visibility in step 3.
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  /// Updates the selected [accountType] (`CUSTOMER` or `OWNER`).
  void setAccountType(String value) {
    final normalized = value.trim().toUpperCase();
    if (accountType == normalized) return;
    accountType = normalized;
    notifyListeners();
  }

  /// Clears any active [errorMessage].
  void clearError() {
    if (errorMessage != null) {
      errorMessage = null;
      notifyListeners();
    }
  }

  /// Returns to the email entry step so the user can edit their address.
  void backToEmailStep() {
    step = RegisterStep.enterEmail;
    errorMessage = null;
    notifyListeners();
  }

  /// Sends a 6-digit OTP verification code to [email].
  Future<bool> sendOtp(String email) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty || !trimmed.contains('@')) {
      errorMessage = 'Please enter a valid email address.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _sendOtp(email: trimmed);
      verifiedEmail = trimmed;
      step = RegisterStep.verifyOtp;
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

  /// Verifies the 6-digit OTP [code] for [verifiedEmail].
  Future<bool> verifyOtp(String code) async {
    final trimmedCode = code.trim();
    if (trimmedCode.length != 6) {
      errorMessage = 'Please enter the 6-digit verification code.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _verifyOtp(email: verifiedEmail, code: trimmedCode);
      step = RegisterStep.createPassword;
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

  /// Completes registration with profile details and [password].
  Future<bool> completeRegistration({
    required String fullName,
    required String documentNumber,
    required String password,
    String? tenantId,
  }) async {
    if (fullName.trim().isEmpty || documentNumber.trim().isEmpty) {
      errorMessage = 'Please complete your name and document number.';
      notifyListeners();
      return false;
    }
    if (password.length < 8) {
      errorMessage = 'Password must be at least 8 characters.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      createdSession = await _registerAccount(
        email: verifiedEmail,
        password: password,
        fullName: fullName,
        documentNumber: documentNumber,
        accountType: accountType,
        tenantId: tenantId,
      );
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
