import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitty_app/core/mock/mock_engine_config.dart';
import 'package:kitty_app/core/providers/auth_state_provider.dart';
import 'package:kitty_app/core/providers/repository_providers.dart';
import 'package:kitty_app/features/dashboard/data/repositories/mock_dashboard_repository.dart';
import 'package:kitty_app/features/home/data/repositories/mock_gold_rate_repository.dart';
import 'package:kitty_app/features/home/data/repositories/mock_product_repository.dart';
import 'package:kitty_app/features/home/presentation/providers/home_controller.dart';
import 'package:kitty_app/features/home/presentation/providers/home_state.dart';
import 'package:kitty_app/features/home/presentation/screens/home_screen.dart';
import 'package:kitty_app/features/home/presentation/widgets/home_active_kitty_card.dart';
import 'package:kitty_app/features/home/presentation/widgets/home_curated_product_grid.dart';
import 'package:kitty_app/features/home/presentation/widgets/home_store_video_section.dart';
import 'package:kitty_app/features/home/presentation/widgets/home_editorial_banner.dart';
import 'package:kitty_app/features/home/presentation/widgets/home_gold_rate_strip.dart';
import 'package:kitty_app/features/home/presentation/widgets/home_greeting_bar.dart';
import 'package:kitty_app/features/home/presentation/widgets/home_kyc_reminder_banner.dart';
import 'package:kitty_app/features/home/presentation/widgets/home_offers_carousel.dart';
import 'package:kitty_app/features/offers/data/repositories/mock_scheme_repository.dart';
import 'package:kitty_app/shared/widgets/feedback/kitty_error_state.dart';

void main() {
  late MockEngineConfig instantConfig;

  setUp(() {
    instantConfig = MockEngineConfig(latency: MockLatency.instant);
  });

  Widget createSubject({
    AppAuthState authState = const AppAuthState.authenticated(
      token: 'mock_jwt_token',
      userName: 'Rihan Saifi',
      isKycVerified: true,
    ),
  }) {
    return ProviderScope(
      overrides: [
        mockEngineConfigProvider.overrideWithValue(instantConfig),
        appAuthStateProvider.overrideWith(
          () => FakeAppAuthNotifier(authState),
        ),
        goldRateRepositoryProvider.overrideWithValue(
          MockGoldRateRepository(engineConfig: instantConfig),
        ),
        productRepositoryProvider.overrideWithValue(
          MockProductRepository(engineConfig: instantConfig),
        ),
        schemeRepositoryProvider.overrideWithValue(
          MockSchemeRepository(engineConfig: instantConfig),
        ),
        dashboardRepositoryProvider.overrideWithValue(
          MockDashboardRepository(engineConfig: instantConfig),
        ),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('1. Fully renders loaded Home screen with all sections', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createSubject());
      await tester.pumpAndSettle();

      // Top Sections - Greeting Bar removed per user design request
      expect(find.byType(HomeGreetingBar), findsNothing);
      expect(find.text('ROYAL CLUB'), findsNothing);

      expect(find.byType(HomeActiveKittyCard), findsOneWidget);
      expect(find.text('ACTIVE JEWEL PLAN'), findsOneWidget);
      expect(find.text('SEE ACTIVE SCHEME'), findsOneWidget);
      expect(find.text('PAY INSTALLMENT'), findsNothing);

      expect(find.byType(HomeOffersCarousel), findsOneWidget);

      // Video section is placed directly below Kitty Scheme Banners
      expect(find.byType(HomeStoreVideoSection), findsOneWidget);
      expect(find.text('Experience Swastik'), findsOneWidget);

      // Shop by Category is removed per design request
      expect(find.text('SHOP BY CATEGORY'), findsNothing);

      expect(find.byType(HomeCuratedProductGrid), findsOneWidget);
      expect(find.text('CURATED FOR YOU'), findsOneWidget);

      // Scroll to view bottom sections
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -1200));
      await tester.pumpAndSettle();

      expect(find.byType(HomeEditorialBanner), findsOneWidget);
      expect(find.text('The Everyday Gold Edit'), findsOneWidget);

      expect(find.byType(HomeGoldRateStrip), findsOneWidget);
      expect(find.text("TODAY'S GOLD RATE (PER G)"), findsOneWidget);
      expect(find.text('100% BIS'), findsOneWidget);
    });

    testWidgets('2. Displays KYC reminder banner when user is not verified', (WidgetTester tester) async {
      await tester.pumpWidget(createSubject(
        authState: const AppAuthState.authenticated(
          token: 'mock_jwt',
          userName: 'Rihan Saifi',
          isKycVerified: false,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(HomeKycReminderBanner), findsOneWidget);
      expect(find.text('Statutory KYC Pending'), findsOneWidget);
      expect(find.text('VERIFY'), findsOneWidget);
    });

    testWidgets('3. Store video section renders with play toggle', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createSubject());
      await tester.pumpAndSettle();

      expect(find.byType(HomeStoreVideoSection), findsOneWidget);
      expect(find.text('Experience Swastik'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsWidgets);
    });

    testWidgets('4. Displays Error state and retry button when error occurs', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mockEngineConfigProvider.overrideWithValue(instantConfig),
            appAuthStateProvider.overrideWith(
              () => FakeAppAuthNotifier(const AppAuthState.authenticated(token: 'jwt')),
            ),
            homeControllerProvider.overrideWith(
              () => FakeErrorHomeController(),
            ),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KittyErrorState), findsOneWidget);
      expect(find.text('Unable to Load Home'), findsOneWidget);
      expect(find.text('TRY AGAIN'), findsOneWidget);
    });
  });
}

class FakeAppAuthNotifier extends AppAuthNotifier {
  FakeAppAuthNotifier(this.initialState);
  final AppAuthState initialState;

  @override
  AppAuthState build() => initialState;
}

class FakeErrorHomeController extends HomeController {
  @override
  HomeState build() {
    return const HomeState(
      status: HomeStatus.error,
      errorMessage: 'Network connection error.',
    );
  }
}
