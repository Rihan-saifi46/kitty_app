import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/features/auth/presentation/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen renders brand header, Google button, OR divider, and Mobile trigger', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.text('Sign in to continue'), findsOneWidget);
    expect(find.text('Access your certified bullion vault & schemes'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('OR'), findsOneWidget);
    expect(find.text('Continue with Mobile'), findsOneWidget);
    expect(find.text('256-bit SSL Encrypted • RBI & PMLA Compliant'), findsOneWidget);
  });
}
