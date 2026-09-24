import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/core/theme/app_theme.dart';
import 'package:kitty_app/shared/widgets/navigation/app_bottom_nav_bar.dart';

void main() {
  group('AppBottomNavBar Widget Tests', () {
    testWidgets('Renders all 4 luxury tabs and responds to tap', (WidgetTester tester) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: 1, // 'Coin Rates' selected
              onTap: (int index) {
                tappedIndex = index;
              },
            ),
            body: const Center(child: Text('Tab Body')),
          ),
        ),
      );

      // Verify all 4 tab labels are present
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Coin Rates'), findsOneWidget);
      expect(find.text('Jewellery'), findsOneWidget);
      expect(find.text('Calculator'), findsOneWidget);

      // Verify KYC and Menu are removed from bottom navigation
      expect(find.text('KYC'), findsNothing);
      expect(find.text('Menu'), findsNothing);

      // Tap on Tab 1 ('Coin Rates')
      await tester.tap(find.text('Coin Rates'));
      await tester.pump();
      expect(tappedIndex, equals(1));

      // Tap on Tab 2 ('Jewellery')
      await tester.tap(find.text('Jewellery'));
      await tester.pump();
      expect(tappedIndex, equals(2));

      // Tap on Tab 3 ('Calculator')
      await tester.tap(find.text('Calculator'));
      await tester.pump();
      expect(tappedIndex, equals(3));

      // Tap on Tab 0 ('Home')
      await tester.tap(find.text('Home'));
      await tester.pump();
      expect(tappedIndex, equals(0));
    });
  });
}
