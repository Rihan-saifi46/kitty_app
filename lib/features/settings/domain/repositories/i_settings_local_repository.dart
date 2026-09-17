import '../entities/profile_entity.dart';

/// Pure domain contract for persisting and retrieving user device settings and preferences.
abstract interface class ISettingsLocalRepository {
  /// Loads all stored local preferences, populating defaults for unset values.
  Future<UserPreferencesEntity> getPreferences();

  /// Persists full user preferences entity to local secure storage.
  Future<void> savePreferences(UserPreferencesEntity preferences);

  /// Toggles biometric lock preference in local storage.
  Future<void> setBiometricEnabled(bool enabled);

  /// Toggles UPI AutoPay / e-Mandate preference in local storage.
  Future<void> setAutoPayEnabled(bool enabled);

  /// Persists selected theme mode ('system', 'dark', 'light').
  Future<void> setThemeMode(String themeMode);

  /// Persists chosen app language ('en', 'hi', etc.).
  Future<void> setLanguage(String language);

  /// Persists 4-digit local transaction MPIN.
  Future<void> setMpin(String mpin);

  /// Retrieves stored 4-digit MPIN, or null if unconfigured.
  Future<String?> getMpin();
}
