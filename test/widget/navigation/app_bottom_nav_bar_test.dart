import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/core/theme/app_theme.dart';
import 'package:kitty_app/shared/widgets/navigation/app_bottom_nav_bar.dart';

void main() {
  group('AppBottomNavBar Widget Tests', () {
    testWidgets('Renders all 5 luxury tabs and responds to tap', (WidgetTester tester) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: 1, // 'My Kitty' selected
              onTap: (int index) {
                tappedIndex = index;
              },
            ),
            body: const Center(child: Text('Tab Body')),
          ),
        ),
      );

      // Verify all 5 tab labels are present
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('My Kitty'), findsOneWidget);
      expect(find.text('Passbook'), findsOneWidget);
      expect(find.text('Offers'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // Tap on Tab 3 ('Offers')
      await tester.tap(find.text('Offers'));
      await tester.pump();
      expect(tappedIndex, equals(3));

      // Tap on Tab 0 ('Home')
      await tester.tap(find.text('Home'));
      await tester.pump();
      expect(tappedIndex, equals(0));
    });
  });
}
