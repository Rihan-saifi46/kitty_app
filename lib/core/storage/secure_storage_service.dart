import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_constants.dart';

/// Bank-grade secure storage service wrapping [FlutterSecureStorage].
///
/// Uses Android KeyStore with hardware encryption and iOS KeyChain.
class SecureStorageService {
  SecureStorageService({
    FlutterSecureStorage? storage,
  }) : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                resetOnError: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  final FlutterSecureStorage _storage;

  // ---------------------------------------------------------------------------
  // JWT Token Management (Frozen Contract v1.0 - Single 30-Day Token)
  // ---------------------------------------------------------------------------

  /// Persist the authentication JWT token.
  Future<void> saveToken(String token) async {
    await write(key: AppConstants.jwtStorageKey, value: token);
  }

  /// Retrieve the active JWT token, or null if unauthenticated.
  Future<String?> getToken() async {
    return read(key: AppConstants.jwtStorageKey);
  }

  /// Check whether a valid JWT token exists in storage.
  Future<bool> hasToken() async {
    final String? token = await getToken();
    return token != null && token.trim().isNotEmpty;
  }

  /// Remove JWT token on logout or session expiration.
  Future<void> deleteToken() async {
    await delete(key: AppConstants.jwtStorageKey);
  }

  // ---------------------------------------------------------------------------
  // User Session & Profile Cache
  // ---------------------------------------------------------------------------

  /// Cache serialized user profile JSON.
  Future<void> saveUserData(String jsonString) async {
    await write(key: AppConstants.userSessionStorageKey, value: jsonString);
  }

  /// Retrieve cached user profile JSON.
  Future<String?> getUserData() async {
    return read(key: AppConstants.userSessionStorageKey);
  }

  /// Clear all authentication, token, and user session cache data.
  Future<void> clearSession() async {
    await Future.wait<void>(<Future<void>>[
      delete(key: AppConstants.jwtStorageKey),
      delete(key: AppConstants.userSessionStorageKey),
    ]);
  }

  // ---------------------------------------------------------------------------
  // Generic Key-Value Secure Operations
  // ---------------------------------------------------------------------------

  /// Write string value to secure storage.
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Read string value from secure storage.
  Future<String?> read({required String key}) async {
    return _storage.read(key: key);
  }

  /// Delete single key from secure storage.
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Wipe all keys from secure storage.
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
