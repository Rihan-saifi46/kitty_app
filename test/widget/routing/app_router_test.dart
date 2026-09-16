import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/app/kitty_app.dart';
import 'package:kitty_app/core/providers/auth_state_provider.dart';
import 'package:kitty_app/core/routing/app_router.dart';

void main() {
  group('AppRouter Declarative Navigation & Auth Guards Tests', () {
    testWidgets('Unauthenticated user is redirected to /auth/login when accessing protected /home', (WidgetTester tester) async {
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

      // Verify that Login Screen is rendered
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('Authenticated user accessing root navigates to protected shell and renders Home Screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appAuthStateProvider.overrideWith(
              () => _TestAuthNotifier(
                const AppAuthState.authenticated(
                  token: 'valid_jwt_token',
                  userName: 'Rihan',
                ),
              ),
            ),
          ],
          child: const KittyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Home Screen and Bottom Navigation are rendered
      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.text('My Kitty'), findsOneWidget);
      expect(find.text('Passbook'), findsOneWidget);
      expect(find.text('Offers'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Bottom navigation switches tabs smoothly within StatefulShellRoute', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appAuthStateProvider.overrideWith(
              () => _TestAuthNotifier(
                const AppAuthState.authenticated(
                  token: 'valid_jwt_token',
                  userName: 'Rihan',
                ),
              ),
            ),
          ],
          child: const KittyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Initially on Home
      expect(find.text('Home Screen'), findsOneWidget);

      // Switch to Tab 1 ('My Kitty')
      await tester.tap(find.text('My Kitty'));
      await tester.pumpAndSettle();
      expect(find.text('My Kitty Scheme'), findsOneWidget);

      // Switch to Tab 2 ('Passbook')
      await tester.tap(find.text('Passbook'));
      await tester.pumpAndSettle();
      expect(find.text('Passbook Ledger'), findsOneWidget);

      // Switch to Tab 3 ('Offers')
      await tester.tap(find.text('Offers'));
      await tester.pumpAndSettle();
      expect(find.text('Kitty Offers & Plans'), findsOneWidget);

      // Switch to Tab 4 ('Settings')
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Patron Settings'), findsOneWidget);
    });

    testWidgets('Unrecognized route renders 404 NotFoundScreen without crashing', (WidgetTester tester) async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          appAuthStateProvider.overrideWith(
            () => _TestAuthNotifier(
              const AppAuthState.authenticated(token: 'valid_jwt_token'),
            ),
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
