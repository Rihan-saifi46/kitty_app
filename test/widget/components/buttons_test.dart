import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/shared/widgets/buttons/kitty_ghost_button.dart';
import 'package:kitty_app/shared/widgets/buttons/kitty_icon_button.dart';
import 'package:kitty_app/shared/widgets/buttons/kitty_primary_button.dart';
import 'package:kitty_app/shared/widgets/buttons/kitty_secondary_button.dart';

void main() {
  group('KittyPrimaryButton Widget Tests', () {
    testWidgets('renders label in uppercase and responds to tap when enabled',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KittyPrimaryButton(
              label: 'Pay Next EMI',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('PAY NEXT EMI'), findsOneWidget);
      await tester.tap(find.byType(KittyPrimaryButton));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('does not trigger callback when isEnabled is false',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KittyPrimaryButton(
              label: 'Submit KYC',
              isEnabled: false,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(KittyPrimaryButton));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('renders CircularProgressIndicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KittyPrimaryButton(
              label: 'Verify OTP',
              isLoading: true,
              loadingLabel: 'Verifying...',
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('VERIFYING...'), findsOneWidget);
    });
  });

  group('KittySecondaryButton Widget Tests', () {
    testWidgets('renders label and icon and responds to tap',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KittySecondaryButton(
              label: 'View Receipt',
              icon: const Icon(Icons.receipt),
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('View Receipt'), findsOneWidget);
      expect(find.byIcon(Icons.receipt), findsOneWidget);

      await tester.tap(find.byType(KittySecondaryButton));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('displays spinner when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KittySecondaryButton(
              label: 'Processing',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('KittyGhostButton Widget Tests', () {
    testWidgets('renders link label and responds to tap',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KittyGhostButton(
              label: 'Resend OTP',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Resend OTP'), findsOneWidget);
      await tester.tap(find.text('Resend OTP'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });

  group('KittyIconButton Widget Tests', () {
    testWidgets('renders 40px circular action button with badge',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KittyIconButton(
              icon: const Icon(Icons.notifications),
              badgeCount: 5,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.notifications), findsOneWidget);
      expect(find.text('5'), findsOneWidget);

      await tester.tap(find.byType(KittyIconButton));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
