import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kitty_app/core/providers/auth_state_provider.dart';
import 'package:kitty_app/core/theme/app_theme.dart';
import 'package:kitty_app/shared/widgets/navigation/luxury_nav_drawer.dart';

void main() {
  group('LuxuryNavDrawer Widget Tests', () {
    testWidgets('Renders patron card, drawer navigation links, and concierge pill', (WidgetTester tester) async {
      final GoRouter dummyRouter = GoRouter(
        initialLocation: '/test',
        routes: <RouteBase>[
          GoRoute(
            path: '/test',
            builder: (BuildContext context, GoRouterState state) => Scaffold(
              drawer: const LuxuryNavDrawer(),
              body: Builder(
                builder: (BuildContext ctx) => ElevatedButton(
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/home',
            builder: (BuildContext context, GoRouterState state) => const Text('Home Screen'),
          ),
        ],
      );

      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appAuthStateProvider.overrideWith(
              () => _FakeAuthNotifier(
                const AppAuthState.authenticated(
                  token: 'test_token',
                  userName: 'Rihan Patron',
                  userPhone: '+91 98765 43210',
                  tier: 'Tier 1 Verified Member',
                ),
              ),
            ),
          ],
          child: MaterialApp.router(
            theme: AppTheme.darkTheme,
            routerConfig: dummyRouter,
          ),
        ),
      );

      // Open the drawer
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Verify Brand Header
      expect(find.text('SWASTIK VAULT'), findsOneWidget);

      // Verify Patron Profile Card
      expect(find.text('Rihan Patron'), findsOneWidget);
      expect(find.text('+91 98765 43210'), findsOneWidget);
      expect(find.text('Tier 1 Verified Member'), findsOneWidget);

      // Verify Navigation Links
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('My Kitty Scheme'), findsOneWidget);
      expect(find.text('Passbook Ledger'), findsOneWidget);
      expect(find.text('Kitty Offers & Plans'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('KYC Compliance'), findsOneWidget);
      expect(find.text('Settings & Security'), findsOneWidget);
      expect(find.text('Log Out of Account'), findsOneWidget);

      // Verify VIP Concierge Footer
      expect(find.text('Swastik VIP Concierge • 1800-SWASTIK'), findsOneWidget);
    });
  });
}

class _FakeAuthNotifier extends AppAuthNotifier {
  _FakeAuthNotifier(this._initialState);

  final AppAuthState _initialState;

  @override
  AppAuthState build() {
    return _initialState;
  }
}
