import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/core/mock/mock_engine_config.dart';
import 'package:kitty_app/core/providers/repository_providers.dart';
import 'package:kitty_app/features/calculator/presentation/screens/calculator_screen.dart';
import 'package:kitty_app/features/offers/data/repositories/mock_scheme_repository.dart';
import 'package:kitty_app/features/offers/presentation/widgets/start_kitty_flow_sheet.dart';

void main() {
  group('Gold Valuation Calculator Conversion Flow Tests (Phase 11)', () {
    late MockSchemeRepository mockSchemeRepo;

    setUp(() {
      mockSchemeRepo = MockSchemeRepository(
        engineConfig: MockEngineConfig(latency: MockLatency.instant),
      );
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          schemeRepositoryProvider.overrideWithValue(mockSchemeRepo),
        ],
        child: const MaterialApp(
          home: CalculatorScreen(),
        ),
      );
    }

    testWidgets('1. CTA is hidden initially when no inputs are entered',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('btn_calculator_start_kitty')), findsNothing);
      expect(find.text('VALUATION SUMMARY'), findsNothing);
    });

    testWidgets('2. Entering weight computes 3-decimal valuation and renders Start Kitty CTA',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter 5.482 grams
      final weightField = find.byType(TextField).first;
      await tester.enterText(weightField, '5.482');
      await tester.pumpAndSettle();

      // Valuation Summary is displayed
      expect(find.text('VALUATION SUMMARY'), findsOneWidget);
      expect(find.text('5.482 g'), findsOneWidget);
      expect(find.text('24K (999)'), findsWidgets);

      // CTA button appears with calculated budget
      expect(find.byKey(const Key('btn_calculator_start_kitty')), findsOneWidget);
      expect(find.textContaining('Start Kitty with this Budget'), findsOneWidget);
    });

    testWidgets('3. Quick weight preset selection triggers conversion CTA immediately',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap 5g preset chip
      await tester.tap(find.text('5g'));
      await tester.pumpAndSettle();

      expect(find.text('5.000 g'), findsOneWidget);
      expect(find.byKey(const Key('btn_calculator_start_kitty')), findsOneWidget);
    });

    testWidgets('4. Tapping Start Kitty CTA opens StartKittyFlowSheet with pre-filled budget',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Select 5g
      await tester.tap(find.text('5g'));
      await tester.pumpAndSettle();

      // Tap CTA
      await tester.ensureVisible(find.byKey(const Key('btn_calculator_start_kitty')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('btn_calculator_start_kitty')));
      await tester.pumpAndSettle();

      // StartKittyFlowSheet is opened
      expect(find.byType(StartKittyFlowSheet), findsOneWidget);
      expect(find.byKey(const Key('start_kitty_calculation_context_banner')), findsOneWidget);
      expect(find.textContaining('5.000g 24K (999)'), findsOneWidget);
    });

    testWidgets('5. Closing or navigating back preserves calculation state on CalculatorScreen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Select 6g
      await tester.tap(find.text('6g'));
      await tester.pumpAndSettle();

      // Open flow
      await tester.ensureVisible(find.byKey(const Key('btn_calculator_start_kitty')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('btn_calculator_start_kitty')));
      await tester.pumpAndSettle();

      expect(find.byType(StartKittyFlowSheet), findsOneWidget);

      // Close bottom sheet
      await tester.tap(find.byKey(const Key('start_kitty_close_btn')));
      await tester.pumpAndSettle();

      // Flow closed, Calculator still shows 6.000 g
      expect(find.byType(StartKittyFlowSheet), findsNothing);
      expect(find.text('6.000 g'), findsOneWidget);
      expect(find.byKey(const Key('btn_calculator_start_kitty')), findsOneWidget);
    });
  });
}
