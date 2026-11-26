import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_empty_state.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_logo.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_primary_pill_button.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_tactile_card.dart';
import 'package:mobile_application_driveos/features/auth/application/auth_application.dart';
import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';
import 'package:mobile_application_driveos/features/auth/presentation/controllers/forgot_password_view_model.dart';
import 'package:mobile_application_driveos/features/auth/presentation/controllers/login_view_model.dart';
import 'package:mobile_application_driveos/features/auth/presentation/controllers/register_view_model.dart';
import 'package:mobile_application_driveos/features/auth/presentation/views/forgot_password_page.dart';
import 'package:mobile_application_driveos/features/auth/presentation/views/login_page.dart';
import 'package:mobile_application_driveos/features/auth/presentation/views/register_page.dart';

class _FakeAuthRepository implements AuthRepository {
  bool shouldFailLogin = false;

  @override
  Future<UserSession> loginWithPassword({
    required String email,
    required String password,
    String? tenantId,
  }) async {
    if (shouldFailLogin) {
      throw Exception('Invalid credentials');
    }
    return UserSession(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      tokenType: 'Bearer',
      expiresIn: 3600,
      userId: 'u-1',
      tenantId: tenantId ?? 'tenant-01',
      email: email,
      fullName: 'Test User',
      roles: const ['CUSTOMER'],
    );
  }

  @override
  Future<void> sendOtp({required String email}) async {}

  @override
  Future<void> verifyOtp({
    required String email,
    required String code,
  }) async {}

  @override
  Future<void> forgotPassword({
    required String email,
    required String tenantId,
  }) async {}

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String tenantId,
  }) async {}

  @override
  Future<void> logout() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _wrapWithApp(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: child,
  );
}

void main() {
  testWidgets('LoginPage renders fields and displays error on failed login',
      (tester) async {
    final repo = _FakeAuthRepository()..shouldFailLogin = true;
    final vm = LoginViewModel(loginWithPassword: LoginWithPassword(repo));

    await tester.pumpWidget(_wrapWithApp(LoginPage(viewModel: vm)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login_email_input')), findsOneWidget);
    expect(find.byKey(const Key('login_password_input')), findsOneWidget);
    expect(find.byKey(const Key('login_tenant_input')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('login_email_input')),
      'tech@driveos.app',
    );
    await tester.enterText(
      find.byKey(const Key('login_password_input')),
      'secret123',
    );
    await tester.ensureVisible(find.byKey(const Key('login_submit_btn')));
    await tester.tap(find.byKey(const Key('login_submit_btn')));
    await tester.pumpAndSettle();

    expect(find.text('Invalid credentials'), findsOneWidget);
  });

  testWidgets('RegisterPage advances through OTP verification steps',
      (tester) async {
    final repo = _FakeAuthRepository();
    final vm = RegisterViewModel(
      sendOtp: SendOtp(repo),
      verifyOtp: VerifyOtp(repo),
      registerAccount: RegisterAccount(repo),
    );

    await tester.pumpWidget(_wrapWithApp(RegisterPage(viewModel: vm)));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('register_email_input')),
      'customer@driveos.app',
    );
    await tester.tap(find.byKey(const Key('register_send_otp_btn')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('register_otp_input')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('register_otp_input')),
      '123456',
    );
    await tester.tap(find.byKey(const Key('register_verify_otp_btn')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('register_fullname_input')), findsOneWidget);
    expect(find.byKey(const Key('register_document_input')), findsOneWidget);
  });

  testWidgets('ForgotPasswordPage advances from email request to reset step',
      (tester) async {
    final repo = _FakeAuthRepository();
    final vm = ForgotPasswordViewModel(
      forgotPassword: ForgotPassword(repo),
      resetPassword: ResetPassword(repo),
    );

    await tester.pumpWidget(_wrapWithApp(ForgotPasswordPage(viewModel: vm)));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('forgot_email_input')),
      'owner@driveos.app',
    );
    await tester.enterText(
      find.byKey(const Key('forgot_tenant_input')),
      'tenant-01',
    );
    await tester.tap(find.byKey(const Key('forgot_send_btn')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('forgot_token_input')), findsOneWidget);
    expect(find.byKey(const Key('forgot_new_password_input')), findsOneWidget);
  });

  testWidgets('Shared DriveOS widgets render cleanly', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrapWithApp(
        Scaffold(
          body: Column(
            children: [
              const DriveOSLogo(size: LogoSize.medium),
              DriveOSTactileCard(
                onTap: () => tapped = true,
                child: const Text('Tactile'),
              ),
              DriveOSPrimaryPillButton(
                label: 'Continue',
                onPressed: () {},
              ),
              const DriveOSEmptyStateIcon(
                icon: Icons.directions_car_outlined,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tactile'));
    expect(tapped, isTrue);
    expect(find.text('Continue'), findsOneWidget);
  });
}
