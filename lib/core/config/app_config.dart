import 'package:flutter/foundation.dart';
import 'app_constants.dart';
import 'app_environment.dart';

/// Centralized configuration service for Kitty App.
///
/// Supports `--dart-define` compile-time overrides:
/// - `ENVIRONMENT`: `mock`, `dev`, `staging`, `prod` (defaults to `prod` in release, `mock` in debug)
/// - `BASE_URL`: API root URI override
/// - `USE_MOCK_API`: Explicit boolean flag to force mock data (defaults to `false` in release)
class AppConfig {
  AppConfig._({
    required this.environment,
    required this.baseUrl,
    required this.useMockApi,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.sendTimeout,
  });

  /// Factory constructor initializing from environment or defaults.
  factory AppConfig({
    AppEnvironment? environment,
    String? baseUrl,
    bool? useMockApi,
  }) {
    // Determine release mode defaults
    const String defaultEnv = kReleaseMode ? 'prod' : 'mock';

    // Read from --dart-define or fallback
    const String envString = String.fromEnvironment('ENVIRONMENT', defaultValue: '');
    final String resolvedEnvString = envString.isNotEmpty ? envString : defaultEnv;

    const String baseUrlDefine = String.fromEnvironment('BASE_URL', defaultValue: '');
    const bool hasMockDefine = bool.hasEnvironment('USE_MOCK_API');
    const bool useMockApiDefine = bool.fromEnvironment('USE_MOCK_API', defaultValue: false);

    final AppEnvironment resolvedEnv = environment ?? AppEnvironment.fromString(resolvedEnvString);

    final String resolvedBaseUrl = baseUrl ??
        (baseUrlDefine.isNotEmpty
            ? baseUrlDefine
            : _resolveDefaultBaseUrl(resolvedEnv));

    final bool resolvedMock = useMockApi ??
        (hasMockDefine
            ? useMockApiDefine
            : (resolvedEnv.isMock || (!kReleaseMode && resolvedEnv == AppEnvironment.mock)));

    return AppConfig._(
      environment: resolvedEnv,
      baseUrl: resolvedBaseUrl,
      useMockApi: resolvedMock,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
    );
  }

  /// Active environment profile.
  final AppEnvironment environment;

  /// API base URL for network calls.
  final String baseUrl;

  /// Whether repositories should use offline mock fixtures.
  final bool useMockApi;

  /// HTTP connect timeout.
  final Duration connectTimeout;

  /// HTTP receive timeout.
  final Duration receiveTimeout;

  /// HTTP send timeout.
  final Duration sendTimeout;

  // ---------------------------------------------------------------------------
  // Global Singleton Instance
  // ---------------------------------------------------------------------------

  static AppConfig? _instance;

  /// Access global initialized config.
  static AppConfig get instance {
    _instance ??= AppConfig();
    return _instance!;
  }

  /// Initialize global config explicitly (e.g. in main.dart).
  static void initialize({
    AppEnvironment? environment,
    String? baseUrl,
    bool? useMockApi,
  }) {
    _instance = AppConfig(
      environment: environment,
      baseUrl: baseUrl,
      useMockApi: useMockApi,
    );
  }

  // ---------------------------------------------------------------------------
  // Internal Helpers
  // ---------------------------------------------------------------------------

  static String _resolveDefaultBaseUrl(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.mock:
        return 'https://mock.kittyapp.local';
      case AppEnvironment.dev:
        return 'http://10.0.2.2:5000'; // Android emulator localhost alias
      case AppEnvironment.staging:
        return 'https://staging-api.swastikjewel.com';
      case AppEnvironment.prod:
        return 'https://api.swastikjewel.com';
    }
  }

  @override
  String toString() {
    return 'AppConfig(env: ${environment.name}, baseUrl: $baseUrl, mock: $useMockApi)';
  }
}
