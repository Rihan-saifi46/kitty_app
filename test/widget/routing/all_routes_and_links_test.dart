import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kitty_app/app/kitty_app.dart';
import 'package:kitty_app/core/providers/auth_state_provider.dart';

void main() {
  group('Comprehensive Route & Link Verification Test Suite', () {
    testWidgets('1. Auth Flow: Login -> Phone -> OTP -> Success -> Dashboard', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appAuthStateProvider.overrideWith(
              () => _TestAuthNotifier(const AppAuthState.unauthenticated()),
            ),
          ],
          child: const KittyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // 1a. Start on Login Screen
      expect(find.text('Login Screen'), findsOneWidget);

      // 1b. Tap 'Enter Mobile Number (View 1)' -> /auth/phone
      await tester.tap(find.text('Enter Mobile Number (View 1)'));
      await tester.pumpAndSettle();
      expect(find.text('Phone Input View'), findsOneWidget);

      // 1c. Tap 'Proceed to OTP Verification (View 2)' -> /auth/otp
      await tester.tap(find.text('Proceed to OTP Verification (View 2)'));
      await tester.pumpAndSettle();
      expect(find.text('OTP Verification View'), findsOneWidget);

      // 1d. Tap 'Verify OTP & Enter App' -> Authenticates and pushes /auth/success
      await tester.tap(find.text('Verify OTP & Enter App'));
      await tester.pumpAndSettle();
      expect(find.text('Authentication Success'), findsOneWidget);

      // 1e. Tap 'Continue to Swastik Vault' -> Navigates to /home
      await tester.tap(find.text('Continue to Swastik Vault'));
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
      expect(find.text('Login Screen'), findsOneWidget);
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
