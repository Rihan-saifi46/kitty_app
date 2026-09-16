import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage_service.dart';
import 'core_providers.dart';

/// Status enumeration for application authentication state.
enum AuthStatus {
  /// App is booting; verifying local token in SecureStorage.
  initial,

  /// User is verified with an active 30-day JWT Bearer token.
  authenticated,

  /// No valid JWT exists in SecureStorage.
  unauthenticated,
}

/// Immutable state representation of the user's authentication and session.
@immutable
class AppAuthState {
  const AppAuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.userName = 'Rihan',
    this.userPhone = '+91 98765 43210',
    this.tier = 'Tier 1 Verified Member',
    this.isKycVerified = true,
  });

  const AppAuthState.initial() : this(status: AuthStatus.initial);

  const AppAuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);

  const AppAuthState.authenticated({
    required String token,
    String userName = 'Rihan',
    String userPhone = '+91 98765 43210',
    String tier = 'Tier 1 Verified Member',
    bool isKycVerified = true,
  }) : this(
          status: AuthStatus.authenticated,
          token: token,
          userName: userName,
          userPhone: userPhone,
          tier: tier,
          isKycVerified: isKycVerified,
        );

  final AuthStatus status;
  final String? token;
  final String userName;
  final String userPhone;
  final String tier;
  final bool isKycVerified;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isInitial => status == AuthStatus.initial;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  AppAuthState copyWith({
    AuthStatus? status,
    String? token,
    String? userName,
    String? userPhone,
    String? tier,
    bool? isKycVerified,
  }) {
    return AppAuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      tier: tier ?? this.tier,
      isKycVerified: isKycVerified ?? this.isKycVerified,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppAuthState &&
        other.status == status &&
        other.token == token &&
        other.userName == userName &&
        other.userPhone == userPhone &&
        other.tier == tier &&
        other.isKycVerified == isKycVerified;
  }

  @override
  int get hashCode => Object.hash(
        status,
        token,
        userName,
        userPhone,
        tier,
        isKycVerified,
      );
}

/// State notifier managing session authentication state.
class AppAuthNotifier extends Notifier<AppAuthState> {
  late final SecureStorageService _storage;

  @override
  AppAuthState build() {
    _storage = ref.watch(secureStorageServiceProvider);
    // Asynchronously check stored token on initial build
    unawaited(checkAuthStatus());
    return const AppAuthState.initial();
  }

  /// Verifies whether an active token is stored in SecureStorage.
  Future<void> checkAuthStatus() async {
    try {
      final String? token = await _storage.getToken();
      if (token != null && token.trim().isNotEmpty) {
        state = AppAuthState.authenticated(token: token);
      } else {
        state = const AppAuthState.unauthenticated();
      }
    } catch (_) {
      state = const AppAuthState.unauthenticated();
    }
  }

  /// Sets session to authenticated and stores token in SecureStorage.
  Future<void> setAuthenticated({
    required String token,
    String userName = 'Rihan',
    String userPhone = '+91 98765 43210',
  }) async {
    await _storage.saveToken(token);
    state = AppAuthState.authenticated(
      token: token,
      userName: userName,
      userPhone: userPhone,
    );
  }

  /// Clears secure session and transitions state to unauthenticated.
  Future<void> logout() async {
    await _storage.clearSession();
    state = const AppAuthState.unauthenticated();
  }
}

/// Provider for application authentication state.
final NotifierProvider<AppAuthNotifier, AppAuthState> appAuthStateProvider =
    NotifierProvider<AppAuthNotifier, AppAuthState>(AppAuthNotifier.new);

/// A [ChangeNotifier] bridge that triggers GoRouter redirect re-evaluations
/// whenever [appAuthStateProvider] updates.
class AuthRouterListenable extends ChangeNotifier {
  AuthRouterListenable(Ref ref) {
    ref.listen<AppAuthState>(appAuthStateProvider, (AppAuthState? previous, AppAuthState next) {
      notifyListeners();
    });
  }
}

/// Provider for the [AuthRouterListenable] bridge.
final Provider<AuthRouterListenable> authRouterListenableProvider =
    Provider<AuthRouterListenable>((Ref ref) {
  return AuthRouterListenable(ref);
});
