import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstraction over key-value persistence for [SessionStorage].
abstract interface class KeyValueStore {
  /// Reads the value associated with [key], or `null` if absent.
  Future<String?> read(String key);

  /// Writes [value] for [key].
  Future<void> write(String key, String value);

  /// Deletes the entry for [key].
  Future<void> delete(String key);

  /// Reads all stored key-value pairs.
  Future<Map<String, String>> readAll();
}

/// [KeyValueStore] implementation backed by [FlutterSecureStorage].
class SecureKeyValueStore implements KeyValueStore {
  final FlutterSecureStorage _storage;

  /// Creates a [SecureKeyValueStore] with an optional [storage] instance.
  SecureKeyValueStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<Map<String, String>> readAll() => _storage.readAll();
}

/// Manages authenticated session tokens, tenant context, and active branch.
class SessionStorage {
  final KeyValueStore _store;

  String? _accessToken;
  String? _refreshToken;
  String? _userId;
  String? _tenantId;
  String? _email;
  String? _fullName;
  List<String> _roles = [];
  String? _activeWorkshopId;
  String? _activeBranchId;
  String? _activeBranchName;
  String? _savedLocale;

  /// Creates a [SessionStorage] backed by [store].
  SessionStorage({KeyValueStore? store})
      : _store = store ?? SecureKeyValueStore();

  static const String _keyAccessToken = 'auth_access_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keyUserId = 'auth_user_id';
  static const String _keyTenantId = 'auth_tenant_id';
  static const String _keyEmail = 'auth_email';
  static const String _keyFullName = 'auth_full_name';
  static const String _keyRoles = 'auth_roles';
  static const String _keyWorkshopId = 'auth_workshop_id';
  static const String _keyBranchId = 'auth_branch_id';
  static const String _keyBranchName = 'auth_branch_name';
  static const String _keySavedLocale = 'app_saved_locale';

  /// Loads persisted session fields into the in-memory cache.
  Future<void> initialize() async {
    try {
      final values = await _store.readAll();
      _accessToken = values[_keyAccessToken];
      _refreshToken = values[_keyRefreshToken];
      _userId = values[_keyUserId];
      _tenantId = values[_keyTenantId];
      _email = values[_keyEmail];
      _fullName = values[_keyFullName];
      final rawRoles = values[_keyRoles];
      if (rawRoles != null && rawRoles.isNotEmpty) {
        _roles = (jsonDecode(rawRoles) as List<dynamic>).cast<String>();
      }
      _activeWorkshopId = values[_keyWorkshopId];
      _activeBranchId = values[_keyBranchId];
      _activeBranchName = values[_keyBranchName];
      _savedLocale = values[_keySavedLocale];
    } catch (_) {
      // Keep in-memory state if secure storage is unavailable in tests.
    }
  }

  Future<void> _persist(String key, String? value) async {
    try {
      if (value == null) {
        await _store.delete(key);
      } else {
        await _store.write(key, value);
      }
    } catch (_) {
      // In-memory cache remains authoritative for the active run.
    }
  }

  /// Returns the cached access token, if any.
  Future<String?> getAccessToken() async => _accessToken;

  /// Returns the cached refresh token, if any.
  Future<String?> getRefreshToken() async => _refreshToken;

  /// Returns the active branch identifier, if any.
  Future<String?> getActiveBranchId() async => _activeBranchId;

  /// Returns the active branch display name, if any.
  Future<String?> getActiveBranchName() async => _activeBranchName;

  /// The authenticated user identifier.
  String? get userId => _userId;

  /// The active tenant identifier.
  String? get tenantId => _tenantId;

  /// The authenticated user's email address.
  String? get email => _email;

  /// The authenticated user's full name.
  String? get fullName => _fullName;

  /// An unmodifiable list of the user's assigned roles.
  List<String> get roles => List.unmodifiable(_roles);

  /// The active workshop identifier.
  String? get activeWorkshopId => _activeWorkshopId;

  /// The active branch identifier.
  String? get activeBranchId => _activeBranchId;

  /// The active branch display name.
  String? get activeBranchName => _activeBranchName;

  /// The user's preferred locale language code, if saved.
  String? get savedLocale => _savedLocale;

  /// Whether a non-empty access token is present.
  bool get isAuthenticated =>
      _accessToken != null && _accessToken!.isNotEmpty;

  /// Whether an active branch has been selected.
  bool get hasActiveBranch =>
      _activeBranchId != null && _activeBranchId!.isNotEmpty;

  /// Persists the complete authenticated session payload.
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String tenantId,
    required String email,
    required String fullName,
    required List<String> roles,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _userId = userId;
    _tenantId = tenantId;
    _email = email;
    _fullName = fullName;
    _roles = List<String>.from(roles);

    await Future.wait([
      _persist(_keyAccessToken, accessToken),
      _persist(_keyRefreshToken, refreshToken),
      _persist(_keyUserId, userId),
      _persist(_keyTenantId, tenantId),
      _persist(_keyEmail, email),
      _persist(_keyFullName, fullName),
      _persist(_keyRoles, jsonEncode(_roles)),
    ]);
  }

  /// Updates only the access and refresh tokens after a token rotation.
  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await Future.wait([
      _persist(_keyAccessToken, accessToken),
      _persist(_keyRefreshToken, refreshToken),
    ]);
  }

  /// Persists the active workshop and branch selection.
  Future<void> saveActiveBranch({
    required String branchId,
    required String branchName,
    String? workshopId,
  }) async {
    _activeBranchId = branchId;
    _activeBranchName = branchName;
    if (workshopId != null) {
      _activeWorkshopId = workshopId;
    }

    await Future.wait([
      _persist(_keyBranchId, branchId),
      _persist(_keyBranchName, branchName),
      if (workshopId != null) _persist(_keyWorkshopId, workshopId),
    ]);
  }

  /// Persists the user's preferred [languageCode].
  Future<void> saveLocale(String languageCode) async {
    _savedLocale = languageCode;
    await _persist(_keySavedLocale, languageCode);
  }

  /// Clears all authentication and branch state while keeping [savedLocale].
  Future<void> clearSession() async {
    _accessToken = null;
    _refreshToken = null;
    _userId = null;
    _tenantId = null;
    _email = null;
    _fullName = null;
    _roles = [];
    _activeWorkshopId = null;
    _activeBranchId = null;
    _activeBranchName = null;

    await Future.wait([
      _persist(_keyAccessToken, null),
      _persist(_keyRefreshToken, null),
      _persist(_keyUserId, null),
      _persist(_keyTenantId, null),
      _persist(_keyEmail, null),
      _persist(_keyFullName, null),
      _persist(_keyRoles, null),
      _persist(_keyWorkshopId, null),
      _persist(_keyBranchId, null),
      _persist(_keyBranchName, null),
    ]);
  }
}
