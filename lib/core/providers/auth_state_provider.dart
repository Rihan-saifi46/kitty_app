import 'dart:async';
import 'dart:convert';
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
    this.userEmail = 'rihan@swastikjewel.com',
    this.userDob = '15/08/1995',
    this.tier = 'Tier 1 Verified Member',
    this.isKycVerified = true,
    this.isOnboarded = true,
    this.hasSkippedKyc = false,
    this.photoPath,
  });

  const AppAuthState.initial() : this(status: AuthStatus.initial);

  const AppAuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);

  const AppAuthState.authenticated({
    required String token,
    String userName = 'Rihan',
    String userPhone = '+91 98765 43210',
    String userEmail = 'rihan@swastikjewel.com',
    String userDob = '15/08/1995',
    String tier = 'Tier 1 Verified Member',
    bool isKycVerified = true,
    bool isOnboarded = true,
    bool hasSkippedKyc = false,
    String? photoPath,
  }) : this(
          status: AuthStatus.authenticated,
          token: token,
          userName: userName,
          userPhone: userPhone,
          userEmail: userEmail,
          userDob: userDob,
          tier: tier,
          isKycVerified: isKycVerified,
          isOnboarded: isOnboarded,
          hasSkippedKyc: hasSkippedKyc,
          photoPath: photoPath,
        );

  final AuthStatus status;
  final String? token;
  final String userName;
  final String userPhone;
  final String userEmail;
  final String userDob;
  final String tier;
  final bool isKycVerified;
  final bool isOnboarded;
  final bool hasSkippedKyc;
  final String? photoPath;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isInitial => status == AuthStatus.initial;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  AppAuthState copyWith({
    AuthStatus? status,
    String? token,
    String? userName,
    String? userPhone,
    String? userEmail,
    String? userDob,
    String? tier,
    bool? isKycVerified,
    bool? isOnboarded,
    bool? hasSkippedKyc,
    String? photoPath,
  }) {
    return AppAuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      userEmail: userEmail ?? this.userEmail,
      userDob: userDob ?? this.userDob,
      tier: tier ?? this.tier,
      isKycVerified: isKycVerified ?? this.isKycVerified,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      hasSkippedKyc: hasSkippedKyc ?? this.hasSkippedKyc,
      photoPath: photoPath ?? this.photoPath,
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
        other.userEmail == userEmail &&
        other.userDob == userDob &&
        other.tier == tier &&
        other.isKycVerified == isKycVerified &&
        other.isOnboarded == isOnboarded &&
        other.hasSkippedKyc == hasSkippedKyc &&
        other.photoPath == photoPath;
  }

  @override
  int get hashCode => Object.hash(
        status,
        token,
        userName,
        userPhone,
        userEmail,
        userDob,
        tier,
        isKycVerified,
        isOnboarded,
        hasSkippedKyc,
        photoPath,
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
        String userName = 'Rihan';
        String userPhone = '+91 98765 43210';
        String userEmail = 'rihan@swastikjewel.com';
        String userDob = '15/08/1995';
        String tier = 'Tier 1 Verified Member';
        bool isKyc = true;
        bool isOnboarded = true;
        bool hasSkippedKyc = false;

        String? photoPath;

        final String? userJson = await _storage.getUserData();
        if (userJson != null && userJson.trim().isNotEmpty) {
          try {
            final Map<String, dynamic> data = jsonDecode(userJson) as Map<String, dynamic>;
            if (data['name'] is String && (data['name'] as String).isNotEmpty) {
              userName = data['name'] as String;
            }
            if (data['phone'] is String && (data['phone'] as String).isNotEmpty) {
              userPhone = data['phone'] as String;
            }
            if (data['email'] is String && (data['email'] as String).isNotEmpty) {
              userEmail = data['email'] as String;
            }
            if (data['dob'] is String && (data['dob'] as String).isNotEmpty) {
              userDob = data['dob'] as String;
            }
            if (data['tier'] is String && (data['tier'] as String).isNotEmpty) {
              tier = data['tier'] as String;
            }
            if (data['photoPath'] is String && (data['photoPath'] as String).isNotEmpty) {
              photoPath = data['photoPath'] as String;
            }
            if (data['isOnboarded'] is bool) {
              isOnboarded = data['isOnboarded'] as bool;
            }
            if (data['hasSkippedKyc'] is bool) {
              hasSkippedKyc = data['hasSkippedKyc'] as bool;
            }
            if (data['kyc'] is Map<String, dynamic>) {
              final Map<String, dynamic> kyc = data['kyc'] as Map<String, dynamic>;
              isKyc = kyc['isVerified'] == true || kyc['status'] == 'VERIFIED';
            }
          } catch (_) {}
        }

        state = AppAuthState.authenticated(
          token: token,
          userName: userName,
          userPhone: userPhone,
          userEmail: userEmail,
          userDob: userDob,
          tier: tier,
          isKycVerified: isKyc,
          isOnboarded: isOnboarded,
          hasSkippedKyc: hasSkippedKyc,
          photoPath: photoPath,
        );
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
    String userEmail = 'rihan@swastikjewel.com',
    String userDob = '',
    String tier = 'Tier 1 Verified Member',
    bool isKycVerified = true,
    bool isOnboarded = true,
  }) async {
    await _storage.saveToken(token);
    state = AppAuthState.authenticated(
      token: token,
      userName: userName,
      userPhone: userPhone,
      userEmail: userEmail,
      userDob: userDob,
      tier: tier,
      isKycVerified: isKycVerified,
      isOnboarded: isOnboarded,
    );
  }

  /// Updates user profile details (Name, Email, Phone, DOB, City, Photo) and persists them in SecureStorage.
  Future<void> updateProfile({
    required String userName,
    String? userEmail,
    String? userPhone,
    String? userDob,
    String? city,
    String? photoPath,
    bool? isOnboarded,
  }) async {
    final String currentPhone = (userPhone != null && userPhone.isNotEmpty)
        ? userPhone
        : state.userPhone;
    final String currentEmail = (userEmail != null && userEmail.isNotEmpty)
        ? userEmail
        : state.userEmail;
    final String currentDob = (userDob != null && userDob.isNotEmpty)
        ? userDob
        : state.userDob;
    final String? currentPhotoPath = photoPath ?? state.photoPath;
    final bool currentOnboarded = isOnboarded ?? state.isOnboarded;

    state = state.copyWith(
      userName: userName,
      userPhone: currentPhone,
      userEmail: currentEmail,
      userDob: currentDob,
      photoPath: currentPhotoPath,
      isOnboarded: currentOnboarded,
    );

    // Persist to SecureStorage safely
    try {
      final Map<String, dynamic> userData = <String, dynamic>{
        'name': userName,
        'email': currentEmail,
        'phone': currentPhone,
        'dob': currentDob,
        'city': city ?? '',
        'tier': state.tier,
        'photoPath': currentPhotoPath ?? '',
        'isOnboarded': currentOnboarded,
        'kyc': <String, dynamic>{
          'isVerified': state.isKycVerified,
          'status': state.isKycVerified ? 'VERIFIED' : 'PENDING',
        },
      };
      await _storage.saveUserData(jsonEncode(userData)).timeout(
            const Duration(milliseconds: 200),
            onTimeout: () {},
          );
    } catch (_) {}
  }

  /// Marks KYC as complete and finishes user onboarding.
  Future<void> completeKyc() async {
    state = state.copyWith(
      isKycVerified: true,
      isOnboarded: true,
      hasSkippedKyc: false,
    );

    try {
      final String? userJson = await _storage.getUserData();
      Map<String, dynamic> userData = <String, dynamic>{};
      if (userJson != null && userJson.trim().isNotEmpty) {
        try {
          userData = jsonDecode(userJson) as Map<String, dynamic>;
        } catch (_) {}
      }
      userData['isOnboarded'] = true;
      userData['hasSkippedKyc'] = false;
      userData['kyc'] = <String, dynamic>{
        'isVerified': true,
        'status': 'VERIFIED',
      };
      await _storage.saveUserData(jsonEncode(userData));
    } catch (_) {}
  }

  /// Allows the patron to skip KYC for now to explore gold schemes & jewellery,
  /// preserving their pending statutory compliance status.
  Future<void> skipKyc() async {
    state = state.copyWith(
      hasSkippedKyc: true,
      isOnboarded: true,
    );

    try {
      final String? userJson = await _storage.getUserData();
      Map<String, dynamic> userData = <String, dynamic>{};
      if (userJson != null && userJson.trim().isNotEmpty) {
        try {
          userData = jsonDecode(userJson) as Map<String, dynamic>;
        } catch (_) {}
      }
      userData['isOnboarded'] = true;
      userData['hasSkippedKyc'] = true;
      await _storage.saveUserData(jsonEncode(userData));
    } catch (_) {}
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
