import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/features/coin_rates/presentation/screens/coin_rates_screen.dart';

void main() {
  group('CoinRatesScreen Widget Tests', () {
    testWidgets('Renders Gold & Silver tabs, 1g to 5g coin cards, and custom weight with Karat selector', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CoinRatesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check Gold / Silver tabs
      expect(find.text('Gold Coins'), findsOneWidget);
      expect(find.text('Silver Coins'), findsOneWidget);

      // Verify presence of 1g to 5g coin cards
      expect(find.text('1 gm Gold Coin'), findsOneWidget);
      expect(find.text('2 gm Gold Coin'), findsOneWidget);
      expect(find.text('3 gm Gold Coin'), findsOneWidget);
      expect(find.text('4 gm Gold Coin'), findsOneWidget);
      expect(find.text('5 gm Gold Coin'), findsOneWidget);

      // Verify Karat selector is visible for Gold
      expect(find.text('Select Gold Purity / Karat:'), findsOneWidget);
      expect(find.text('24K (999 Purity)'), findsWidgets);

      // Switch to Silver Coins
      await tester.tap(find.text('Silver Coins'));
      await tester.pumpAndSettle();

      // Verify 1g to 5g silver coins
      expect(find.text('1 gm Silver Coin'), findsOneWidget);
      expect(find.text('5 gm Silver Coin'), findsOneWidget);

      // Karat selector should NOT be shown for Silver
      expect(find.text('Select Gold Purity / Karat:'), findsNothing);
    });
  });
}
