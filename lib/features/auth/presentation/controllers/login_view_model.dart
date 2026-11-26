import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/features/auth/application/auth_application.dart';
import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';

/// Presentation ViewModel that manages email/password sign-in state.
class LoginViewModel extends ChangeNotifier {
  final LoginWithPassword _loginWithPassword;

  /// Creates a [LoginViewModel] backed by [_loginWithPassword].
  LoginViewModel({required LoginWithPassword loginWithPassword})
      : _loginWithPassword = loginWithPassword;

  /// Whether an authentication request is currently in progress.
  bool isLoading = false;

  /// Whether the password input is obscured.
  bool obscurePassword = true;

  /// Latest validation or server error message, if any.
  String? errorMessage;

  /// Most recently authenticated user session.
  UserSession? currentSession;

  /// Toggles password visibility in the sign-in form.
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

  /// Attempts to sign in with [email], [password], and optional [tenantId].
  Future<bool> login({
    required String email,
    required String password,
    String? tenantId,
  }) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || password.isEmpty) {
      errorMessage = 'Please enter both email and password.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentSession = await _loginWithPassword(
        email: trimmedEmail,
        password: password,
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
