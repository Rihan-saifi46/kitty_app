import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/features/jewellery/presentation/screens/jewellery_screen.dart';

void main() {
  group('JewelleryScreen Widget Tests', () {
    testWidgets('Renders Gold & Diamond dropdowns and category options', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: JewelleryScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check Header
      expect(find.text('FINE JEWELLERY CATALOG'), findsOneWidget);
      expect(find.text('Handcrafted Collections'), findsOneWidget);

      // Check Dropdown titles
      expect(find.text('Gold Jewellery'), findsOneWidget);
      expect(find.text('Diamond Jewellery'), findsOneWidget);

      // Check Category Options
      expect(find.text('Rings'), findsWidgets);
      expect(find.text('Pendants'), findsWidgets);
      expect(find.text('Necklace'), findsWidgets);
      expect(find.text('Earrings'), findsWidgets);
      expect(find.text('Bangles'), findsWidgets);
      expect(find.text('Bracelets'), findsWidgets);

      // Check initial Gold Rings displayed
      expect(find.text('Royal Mayura Filigree Ring'), findsOneWidget);

      // Switch to Diamond Jewellery
      await tester.tap(find.text('Diamond Jewellery'));
      await tester.pumpAndSettle();

      // Verify Diamond item appears
      expect(find.text('Celestial Solitaire Halo Ring'), findsOneWidget);
    });
  });
}
