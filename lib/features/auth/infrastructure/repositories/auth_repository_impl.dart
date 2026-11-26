import 'dart:async';

import 'package:mobile_application_driveos/core/domain/event/domain_event.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event_bus.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/auth/domain/auth_domain.dart';
import 'package:mobile_application_driveos/features/auth/infrastructure/remote/auth_api.dart';
import 'package:mobile_application_driveos/features/auth/infrastructure/remote/user_api.dart';

/// Concrete [AuthRepository] coordinating remote IAM APIs, [SessionStorage],
/// and [DomainEventBus] notifications.
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;
  final UserApi _userApi;
  final SessionStorage _sessionStorage;
  final DomainEventBus _eventBus;
  StreamSubscription<SessionExpiredEvent>? _sessionExpiredSub;

  /// Creates an [AuthRepositoryImpl].
  AuthRepositoryImpl({
    required this._authApi,
    required this._userApi,
    required this._sessionStorage,
    required this._eventBus,
  }) {
    _sessionExpiredSub = _eventBus.on<SessionExpiredEvent>().listen((_) {
      _sessionStorage.clearSession();
    });
  }

  Future<UserSession> _persistAndEmitLogin(UserSession session) async {
    await _sessionStorage.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      userId: session.userId,
      tenantId: session.tenantId,
      email: session.email,
      fullName: session.fullName,
      roles: session.roles,
    );

    _eventBus.emit(
      UserLoggedInEvent(
        userId: session.userId,
        tenantId: session.tenantId,
        email: session.email,
        fullName: session.fullName,
        roles: session.roles,
      ),
    );

    return session;
  }

  @override
  Future<UserSession> loginWithPassword({
    required String email,
    required String password,
    String? tenantId,
  }) async {
    final dto = await _authApi.loginWithPassword(
      email: email,
      password: password,
      tenantId: tenantId,
    );
    return _persistAndEmitLogin(dto.toDomain());
  }

  @override
  Future<UserSession> loginWithGoogle({
    required String idToken,
    String? tenantId,
  }) async {
    final dto = await _authApi.loginWithGoogle(
      idToken: idToken,
      tenantId: tenantId,
    );
    return _persistAndEmitLogin(dto.toDomain());
  }

  @override
  Future<UserSession> refreshSession({
    required String refreshToken,
    required String tenantId,
  }) async {
    final dto = await _authApi.refreshSession(
      refreshToken: refreshToken,
      tenantId: tenantId,
    );
    final session = dto.toDomain();
    await _sessionStorage.updateTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    return session;
  }

  @override
  Future<void> logout() async {
    final currentUserId = _sessionStorage.userId;
    final refreshToken = await _sessionStorage.getRefreshToken();
    final tenantId = _sessionStorage.tenantId;

    if (refreshToken != null &&
        refreshToken.isNotEmpty &&
        tenantId != null &&
        tenantId.isNotEmpty) {
      try {
        await _authApi.logout(
          refreshToken: refreshToken,
          tenantId: tenantId,
        );
      } catch (_) {
        // Local session cleanup must still proceed if the server is unreachable.
      }
    }

    await _sessionStorage.clearSession();
    _eventBus.emit(
      UserLoggedOutEvent(
        userId: currentUserId,
        reason: 'User signed out',
      ),
    );
  }

  @override
  Future<void> sendOtp({required String email}) =>
      _authApi.sendOtp(email: email);

  @override
  Future<void> verifyOtp({
    required String email,
    required String code,
  }) =>
      _authApi.verifyOtp(email: email, code: code);

  @override
  Future<UserSession> registerAccount({
    required String email,
    required String password,
    required String fullName,
    required String documentNumber,
    required String accountType,
    String? tenantId,
  }) async {
    final dto = await _authApi.registerAccount(
      email: email,
      password: password,
      fullName: fullName,
      documentNumber: documentNumber,
      accountType: accountType,
      tenantId: tenantId,
    );
    return _persistAndEmitLogin(dto.toDomain());
  }

  @override
  Future<void> forgotPassword({
    required String email,
    required String tenantId,
  }) =>
      _authApi.forgotPassword(email: email, tenantId: tenantId);

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String tenantId,
  }) =>
      _authApi.resetPassword(
        token: token,
        newPassword: newPassword,
        tenantId: tenantId,
      );

  @override
  Future<InvitationDetails> getInvitationDetails(String token) async {
    final dto = await _authApi.getInvitationDetails(token);
    return dto.toDomain();
  }

  @override
  Future<UserSession> acceptInvitation({
    required String token,
    required String password,
  }) async {
    final dto = await _authApi.acceptInvitation(
      token: token,
      password: password,
    );
    return _persistAndEmitLogin(dto.toDomain());
  }

  @override
  Future<UserAccount> getCurrentUser() async {
    final dto = await _userApi.getCurrentUser();
    return dto.toDomain();
  }

  @override
  Future<UserSession> updateEmail({
    required String userId,
    required String email,
  }) async {
    final dto = await _userApi.updateEmail(userId: userId, email: email);
    return _persistAndEmitLogin(dto.toDomain());
  }

  @override
  Future<void> updatePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) =>
      _userApi.updatePassword(
        userId: userId,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

  @override
  Future<UserAccount> uploadAvatar({
    required String userId,
    required String filePath,
  }) async {
    final dto = await _userApi.uploadAvatar(
      userId: userId,
      filePath: filePath,
    );
    return dto.toDomain();
  }

  /// Releases the internal [SessionExpiredEvent] stream subscription.
  Future<void> dispose() async {
    await _sessionExpiredSub?.cancel();
  }
}
