import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/features/auth/presentation/screens/login_screen.dart';
import 'package:kitty_app/features/auth/presentation/screens/register_profile_screen.dart';

void main() {
  group('RegisterProfileScreen & Profile Step Widget Tests', () {
    testWidgets('RegisterProfileScreen renders header, inputs, and submit button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Complete Your Profile'), findsOneWidget);
      expect(
        find.text('Personalize your Kitty Vault passbook & legal bullion certificates'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('input_profile_name')), findsOneWidget);
      expect(find.byKey(const Key('input_profile_email')), findsOneWidget);
      expect(find.byKey(const Key('input_profile_city')), findsOneWidget);
      expect(find.byKey(const Key('btn_profile_submit')), findsOneWidget);
      expect(find.text('Complete Profile & Enter Vault'), findsOneWidget);
    });

    testWidgets('RegisterProfileScreen validates empty name and invalid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Clear the name input
      await tester.enterText(find.byKey(const Key('input_profile_name')), '');
      await tester.enterText(find.byKey(const Key('input_profile_email')), 'invalid-email');
      await tester.pump();

      // Tap submit
      await tester.tap(find.byKey(const Key('btn_profile_submit')));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('LoginScreen initialStep: LoginStep.profile renders personal details and saves',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(initialStep: LoginStep.profile),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 850));

      expect(find.text('Complete Your Profile'), findsOneWidget);
      expect(find.text('Personal Details'), findsOneWidget);
      expect(find.text('Save & Enter Vault'), findsOneWidget);

      // Enter details
      await tester.enterText(find.byKey(const Key('input_profile_name')), 'Aarav Patel');
      await tester.enterText(find.byKey(const Key('input_profile_email')), 'aarav@swastikjewel.com');
      await tester.pump();

      // Submit
      await tester.tap(find.text('Save & Enter Vault'));
      await tester.pumpAndSettle();

      // Should transition to success step
      expect(find.textContaining('Welcome Back'), findsOneWidget);
      expect(find.text('Enter Kitty Vault'), findsOneWidget);
    });
  });
}
