import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kitty_app/app/kitty_app.dart';
import 'package:kitty_app/core/providers/auth_state_provider.dart';
import 'package:kitty_app/core/providers/core_providers.dart';
import 'package:kitty_app/core/providers/repository_providers.dart';
import 'package:kitty_app/core/storage/secure_storage_service.dart';
import 'package:kitty_app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:kitty_app/shared/widgets/inputs/kitty_otp_input.dart';

class _FakeSecureStorageService extends SecureStorageService {
  final Map<String, String> _map = <String, String>{};

  @override
  Future<void> write({required String key, required String value}) async {
    _map[key] = value;
  }

  @override
  Future<String?> read({required String key}) async {
    return _map[key];
  }

  @override
  Future<void> delete({required String key}) async {
    _map.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _map.clear();
  }
}

void main() {
  group('Comprehensive Route & Link Verification Test Suite', () {
    testWidgets('1. Auth Flow: Login -> Phone -> OTP -> Success -> Dashboard', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final _FakeSecureStorageService fakeStorage = _FakeSecureStorageService();
      final MockAuthRepository mockAuth = MockAuthRepository(storageService: fakeStorage);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuth),
            secureStorageServiceProvider.overrideWithValue(fakeStorage),
            appAuthStateProvider.overrideWith(
              () => _TestAuthNotifier(const AppAuthState.unauthenticated()),
            ),
          ],
          child: const KittyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // 1a. Start on Login Screen
      expect(find.text('Sign in to continue'), findsOneWidget);

      // 1b. Tap 'Continue with Mobile' -> /auth/phone
      await tester.tap(find.text('Continue with Mobile'));
      await tester.pumpAndSettle();
      expect(find.text('Enter your mobile number'), findsOneWidget);

      // 1c. Enter phone and tap 'Continue' -> /auth/otp
      await tester.enterText(find.byType(TextField), '9876543210');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Verify your number'), findsOneWidget);

      // 1d. Enter OTP '123456' -> Authenticates and pushes /auth/success
      final Finder otpFinder = find.byType(KittyOtpInput);
      expect(otpFinder, findsOneWidget);
      final KittyOtpInputState otpState = tester.state(otpFinder);
      otpState.setOtp('123456');
      await tester.pumpAndSettle();
      expect(find.textContaining('Welcome Back'), findsOneWidget);

      // 1e. Tap 'Enter Kitty Vault' -> Navigates to /home
      await tester.tap(find.text('Enter Kitty Vault'));
      await tester.pumpAndSettle();
      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('2. 5 Shell Bottom Tabs switch smoothly and preserve state', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appAuthStateProvider.overrideWith(
              () => _TestAuthNotifier(
                const AppAuthState.authenticated(
                  token: 'test_token',
                  userName: 'Rihan',
                ),
              ),
            ),
          ],
          child: const KittyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Tab 0: Home Tab
      expect(find.text('Home Screen'), findsOneWidget);

      // Tab 1: Switch to My Kitty Tab
      await tester.tap(find.text('My Kitty'));
      await tester.pumpAndSettle();
      expect(find.text('My Kitty Scheme'), findsOneWidget);

      // Tab 2: Switch to Passbook Tab
      await tester.tap(find.text('Passbook'));
      await tester.pumpAndSettle();
      expect(find.text('Passbook Ledger'), findsOneWidget);

      // Tab 3: Switch to Offers Tab
      await tester.tap(find.text('Offers'));
      await tester.pumpAndSettle();
      expect(find.text('Kitty Offers & Plans'), findsOneWidget);

      // Tab 4: Switch to Settings Tab
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Patron Settings'), findsOneWidget);

      // Return to Home Tab
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('3. In-screen Navigation Links: Home -> Dashboard -> Checkout -> Gokwik', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appAuthStateProvider.overrideWith(
              () => _TestAuthNotifier(
                const AppAuthState.authenticated(
                  token: 'test_token',
                  userName: 'Rihan',
                ),
              ),
            ),
          ],
          child: const KittyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Home: Tap 'View Active Scheme Pass' -> Dashboard
      await tester.tap(find.text('View Active Scheme Pass'));
      await tester.pumpAndSettle();
      expect(find.text('My Kitty Scheme'), findsOneWidget);

      // Dashboard: Tap 'Pay Next EMI' -> Checkout modal
      await tester.tap(find.text('Pay Next EMI (₹5,000)'));
      await tester.pumpAndSettle();
      expect(find.text('Payment Checkout'), findsOneWidget);

      // Checkout: Tap 'Open GoKwik Gateway Host' -> Gokwik WebView host
      await tester.tap(find.text('Open GoKwik Gateway Host'));
      await tester.pumpAndSettle();
      expect(find.text('GoKwik Gateway Host'), findsOneWidget);

      // Gokwik: Tap 'Simulate Successful Return -> /dashboard'
      await tester.tap(find.text('Simulate Successful Return -> /dashboard'));
      await tester.pumpAndSettle();
      expect(find.text('My Kitty Scheme'), findsOneWidget);
    });

    testWidgets('4. Header Navigation: Bell Icon opens Notifications', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appAuthStateProvider.overrideWith(
              () => _TestAuthNotifier(
                const AppAuthState.authenticated(
                  token: 'test_token',
                  userName: 'Rihan',
                ),
              ),
            ),
          ],
          child: const KittyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the Bell Icon button in Header
      await tester.tap(find.byTooltip('Notifications'));
      await tester.pumpAndSettle();
      expect(find.text('Notifications Center'), findsOneWidget);
    });

    testWidgets('5. Luxury Drawer Links: KYC and Logout', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appAuthStateProvider.overrideWith(
              () => _TestAuthNotifier(
                const AppAuthState.authenticated(
                  token: 'test_token',
                  userName: 'Rihan',
                ),
              ),
            ),
          ],
          child: const KittyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Open Drawer via Menu Button
      await tester.tap(find.byTooltip('Open Menu'));
      await tester.pumpAndSettle();
      expect(find.text('SWASTIK VAULT'), findsOneWidget);

      // Tap 'KYC Compliance' link
      await tester.tap(find.text('KYC Compliance'));
      await tester.pumpAndSettle();
      expect(find.text('Statutory KYC Verification'), findsOneWidget);

      // Tap 'Back to Home' on KYC screen
      await tester.tap(find.text('Back to Home'));
      await tester.pumpAndSettle();
      expect(find.text('Home Screen'), findsOneWidget);

      // Open Drawer again to test Logout
      await tester.tap(find.byTooltip('Open Menu'));
      await tester.pumpAndSettle();

      // Tap 'Log Out of Account'
      await tester.tap(find.text('Log Out of Account'));
      await tester.pumpAndSettle();

      // Confirm Logout Dialog
      expect(find.text('Log Out of Account?'), findsOneWidget);
      await tester.tap(find.text('Log Out'));
      await tester.pumpAndSettle();

      // Successfully redirected to Login
      expect(find.text('Sign in to continue'), findsOneWidget);
    });

    testWidgets('6. Unknown Route renders 404 and recovers back to Home', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appAuthStateProvider.overrideWith(
              () => _TestAuthNotifier(
                const AppAuthState.authenticated(
                  token: 'test_token',
                  userName: 'Rihan',
                ),
              ),
            ),
          ],
          child: const KittyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to an invalid unregistered path
      final BuildContext ctx = tester.element(find.byType(Scaffold).first);
      GoRouter.of(ctx).go('/unregistered/invalid/path');
      await tester.pumpAndSettle();

      // Verify 404 Screen
      expect(find.text('404 — Page Not Found'), findsOneWidget);

      // Tap 'Return to Safety' button
      await tester.tap(find.text('Return to Safety'));
      await tester.pumpAndSettle();

      // Successfully recovered to Home Screen
      expect(find.text('Home Screen'), findsOneWidget);
    });
  });
}

class _TestAuthNotifier extends AppAuthNotifier {
  _TestAuthNotifier(this._initialState);

  final AppAuthState _initialState;

  @override
  AppAuthState build() {
    return _initialState;
  }

  @override
  Future<void> setAuthenticated({
    required String token,
    String userName = 'Rihan',
    String userPhone = '+91 98765 43210',
  }) async {
    state = AppAuthState.authenticated(
      token: token,
      userName: userName,
      userPhone: userPhone,
    );
  }

  @override
  Future<void> logout() async {
    state = const AppAuthState.unauthenticated();
  }
}
