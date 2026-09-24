import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/app/kitty_app.dart';
import 'package:kitty_app/core/mock/mock_engine_config.dart';
import 'package:kitty_app/core/providers/auth_state_provider.dart';
import 'package:kitty_app/core/providers/repository_providers.dart';
import 'package:kitty_app/core/routing/app_router.dart';
import 'package:kitty_app/features/dashboard/data/repositories/mock_dashboard_repository.dart';
import 'package:kitty_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:kitty_app/features/home/data/repositories/mock_gold_rate_repository.dart';
import 'package:kitty_app/features/home/data/repositories/mock_product_repository.dart';
import 'package:kitty_app/features/home/presentation/screens/home_screen.dart';
import 'package:kitty_app/features/home/presentation/widgets/home_active_kitty_card.dart';
import 'package:kitty_app/features/offers/data/repositories/mock_scheme_repository.dart';

void main() {
  group('AppRouter Declarative Navigation & Auth Guards Tests', () {
    late MockEngineConfig instantConfig;

    setUp(() {
      instantConfig = MockEngineConfig(latency: MockLatency.instant);
    });

    testWidgets('Unauthenticated user is redirected to Login screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mockEngineConfigProvider.overrideWithValue(instantConfig),
            appAuthStateProvider.overrideWith(
              () => _TestAuthNotifier(const AppAuthState.unauthenticated()),
            ),
          ],
          child: const KittyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Login Screen is displayed
      expect(find.text('Sign in to continue'), findsOneWidget);
    });

    testWidgets('Authenticated user accessing root navigates to protected shell and renders Home Screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mockEngineConfigProvider.overrideWithValue(instantConfig),
            appAuthStateProvider.overrideWith(
              () => _TestAuthNotifier(
                const AppAuthState.authenticated(
                  token: 'valid_jwt_token',
                  userName: 'Rihan',
                ),
              ),
            ),
            goldRateRepositoryProvider.overrideWithValue(
              MockGoldRateRepository(engineConfig: instantConfig),
            ),
            productRepositoryProvider.overrideWithValue(
              MockProductRepository(engineConfig: instantConfig),
            ),
            schemeRepositoryProvider.overrideWithValue(
              MockSchemeRepository(engineConfig: instantConfig),
            ),
            dashboardRepositoryProvider.overrideWithValue(
              MockDashboardRepository(engineConfig: instantConfig),
            ),
          ],
          child: const KittyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Home Screen and Active Kitty Plan are rendered
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(HomeActiveKittyCard), findsOneWidget);
      expect(find.text('ACTIVE JEWEL PLAN'), findsOneWidget);
    });

    testWidgets('Drawer navigation switches tabs smoothly within StatefulShellRoute', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mockEngineConfigProvider.overrideWithValue(instantConfig),
            appAuthStateProvider.overrideWith(
              () => _TestAuthNotifier(
                const AppAuthState.authenticated(
                  token: 'valid_jwt_token',
                  userName: 'Rihan',
                ),
              ),
            ),
            goldRateRepositoryProvider.overrideWithValue(
              MockGoldRateRepository(engineConfig: instantConfig),
            ),
            productRepositoryProvider.overrideWithValue(
              MockProductRepository(engineConfig: instantConfig),
            ),
            schemeRepositoryProvider.overrideWithValue(
              MockSchemeRepository(engineConfig: instantConfig),
            ),
            dashboardRepositoryProvider.overrideWithValue(
              MockDashboardRepository(engineConfig: instantConfig),
            ),
          ],
          child: const KittyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Initially on Home
      expect(find.byType(HomeScreen), findsOneWidget);

      // Switch to Tab 1 ('My Kitty Scheme') via Drawer
      await tester.tap(find.byTooltip('Open Menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('My Kitty Scheme'));
      await tester.pumpAndSettle();
      expect(find.byType(DashboardScreen), findsOneWidget);

      // Switch to Tab 2 ('Passbook Ledger') via Drawer
      await tester.tap(find.byTooltip('Open Menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Passbook Ledger'));
      await tester.pumpAndSettle();
      expect(find.text('Passbook Ledger'), findsWidgets);

      // Switch to Tab 3 ('Kitty Offers & Plans') via Drawer
      await tester.tap(find.byTooltip('Open Menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kitty Offers & Plans'));
      await tester.pumpAndSettle();
      expect(find.text('Kitty Offers & Plans'), findsWidgets);

      // Switch to Tab 4 ('Settings & Security') via Drawer
      await tester.tap(find.byTooltip('Open Menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings & Security'));
      await tester.pumpAndSettle();
      expect(find.text('Patron Settings'), findsOneWidget);
    });

    testWidgets('Unrecognized route renders 404 NotFoundScreen without crashing', (WidgetTester tester) async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          mockEngineConfigProvider.overrideWithValue(instantConfig),
          appAuthStateProvider.overrideWith(
            () => _TestAuthNotifier(
              const AppAuthState.authenticated(token: 'valid_jwt_token'),
            ),
          ),
          goldRateRepositoryProvider.overrideWithValue(
            MockGoldRateRepository(engineConfig: instantConfig),
          ),
          productRepositoryProvider.overrideWithValue(
            MockProductRepository(engineConfig: instantConfig),
          ),
          schemeRepositoryProvider.overrideWithValue(
            MockSchemeRepository(engineConfig: instantConfig),
          ),
          dashboardRepositoryProvider.overrideWithValue(
            MockDashboardRepository(engineConfig: instantConfig),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const KittyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to nonexistent route
      container.read(routerProvider).go('/nonexistent-404-test-path');
      await tester.pumpAndSettle();

      // Verify 404 Not Found Screen is displayed
      expect(find.text('404 — Page Not Found'), findsOneWidget);
      expect(find.text('Return to Safety'), findsOneWidget);
    });
  });
}

class _TestAuthNotifier extends AppAuthNotifier {
  _TestAuthNotifier(this._state);

  final AppAuthState _state;

  @override
  AppAuthState build() {
    return _state;
  }
}
