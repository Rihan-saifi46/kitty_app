import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/shared/widgets/inputs/kitty_text_field.dart';

void main() {
  group('KittyTextField Widget Tests', () {
    testWidgets('enters text and triggers onChanged callback',
        (WidgetTester tester) async {
      String enteredValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KittyTextField(
              label: 'Full Name',
              hintText: 'Enter your name',
              onChanged: (String val) => enteredValue = val,
            ),
          ),
        ),
      );

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Enter your name'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Rajesh Sharma');
      await tester.pumpAndSettle();

      expect(enteredValue, equals('Rajesh Sharma'));
    });

    testWidgets('renders validation error text when errorText is provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KittyTextField(
              label: 'PAN Card',
              errorText: 'Invalid PAN Number format',
            ),
          ),
        ),
      );

      expect(find.text('Invalid PAN Number format'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('obscures text and toggles visibility on password field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KittyTextField(
              label: 'MPIN',
              isPassword: true,
            ),
          ),
        ),
      );

      final TextField textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);

      // Tap visibility toggle icon
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      final TextField visibleField = tester.widget<TextField>(find.byType(TextField));
      expect(visibleField.obscureText, isFalse);
    });

    testWidgets('clear button clears text when present',
        (WidgetTester tester) async {
      final TextEditingController controller =
          TextEditingController(text: 'Initial Text');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KittyTextField(
              controller: controller,
              showClearButton: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.cancel), findsOneWidget);

      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();

      expect(controller.text, isEmpty);
    });
  });
}
