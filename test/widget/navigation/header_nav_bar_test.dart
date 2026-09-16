import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/core/theme/app_theme.dart';
import 'package:kitty_app/shared/widgets/navigation/header_nav_bar.dart';

void main() {
  group('HeaderNavBar Widget Tests', () {
    testWidgets('Renders brand title, gold ticker, and action buttons', (WidgetTester tester) async {
      bool menuTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            appBar: HeaderNavBar(
              onMenuPressed: () {
                menuTapped = true;
              },
              unreadNotificationsCount: 3,
              goldRate24k: 7550.00,
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      // Verify brand title text
      expect(find.text('SWASTIK'), findsOneWidget);
      expect(find.text('JEWELLERS'), findsOneWidget);

      // Verify live gold ticker pill
      expect(find.text('24K: ₹7550/g'), findsOneWidget);

      // Verify unread notifications badge count
      expect(find.text('3'), findsOneWidget);

      // Tap hamburger menu button
      final Finder menuBtn = find.byTooltip('Open Menu');
      expect(menuBtn, findsOneWidget);
      await tester.tap(menuBtn);
      expect(menuTapped, isTrue);
    });
  });
}
