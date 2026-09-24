import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kitty_app/core/mock/mock_engine_config.dart';
import 'package:kitty_app/core/providers/auth_state_provider.dart';
import 'package:kitty_app/core/providers/repository_providers.dart';
import 'package:kitty_app/core/theme/app_theme.dart';
import 'package:kitty_app/features/menu/presentation/screens/menu_screen.dart';

void main() {
  group('MenuScreen Widget Tests', () {
    testWidgets('Renders all 3-lines drawer items and concierge footer', (WidgetTester tester) async {
      final GoRouter dummyRouter = GoRouter(
        initialLocation: '/menu',
        routes: <RouteBase>[
          GoRoute(
            path: '/menu',
            builder: (BuildContext context, GoRouterState state) => const MenuScreen(),
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
            mockEngineConfigProvider.overrideWithValue(
              MockEngineConfig(latency: MockLatency.instant),
            ),
            appAuthStateProvider.overrideWith(
              () => _FakeAuthNotifier(
                const AppAuthState.authenticated(
                  token: 'test_token',
                  userName: 'Rihan',
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
      await tester.pumpAndSettle();

      // Check Patron card
      expect(find.text('Rihan'), findsOneWidget);
      expect(find.text('+91 98765 43210'), findsOneWidget);
      expect(find.text('Tier 1 Verified Member'), findsOneWidget);

      // Check Navigation items matching 3-line drawer
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('My Kitty Scheme'), findsOneWidget);
      expect(find.text('Passbook Ledger'), findsOneWidget);
      expect(find.text('Kitty Offers & Plans'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('KYC Compliance'), findsOneWidget);
      expect(find.text('Settings & Security'), findsOneWidget);
      expect(find.text('Log Out of Account'), findsOneWidget);

      // Check VIP Concierge footer
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
