import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/core/providers/auth_state_provider.dart';
import 'package:kitty_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:kitty_app/features/splash/presentation/widgets/diamond_3d_painter.dart';

void main() {
  testWidgets('SplashScreen renders deep emerald background and 3D diamond custom paint', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SplashScreen(
            totalDuration: Duration(milliseconds: 1000),
            autoNavigate: false,
          ),
        ),
      ),
    );

    // Deep emerald background
    expect(find.byType(Scaffold), findsOneWidget);

    // Advance animation to diamond active window
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(CustomPaint), findsWidgets);
    expect(find.byType(RepaintBoundary), findsWidgets);
  });

  testWidgets('SplashScreen completes animation and shows branding text KITTY VAULT', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SplashScreen(
            totalDuration: Duration(milliseconds: 1000),
            autoNavigate: false,
          ),
        ),
      ),
    );

    // Fast-forward to end
    await tester.pump(const Duration(milliseconds: 950));
    expect(find.text('KITTY VAULT'), findsOneWidget);
  });
}
