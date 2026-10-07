import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/auth_success_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_choice_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/phone_screen.dart';
import '../../features/auth/presentation/screens/register_profile_screen.dart';
import '../../features/checkout/domain/entities/payment_order_entity.dart';
import '../../features/calculator/presentation/screens/calculator_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/coin_rates/presentation/screens/coin_rates_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/jewellery/presentation/screens/jewellery_screen.dart';
import '../../features/kyc/presentation/screens/kyc_screen.dart';
import '../../features/live_rates/presentation/screens/live_rates_screen.dart';
import '../../features/menu/presentation/screens/menu_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/offers/presentation/screens/offers_screen.dart';
import '../../features/offers/presentation/screens/booking_screen.dart';
import '../../features/offers/presentation/screens/review_plan_screen.dart';
import '../../features/checkout/presentation/screens/cash_pickup_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/passbook/presentation/screens/passbook_screen.dart';
import '../../features/passbook/domain/entities/passbook_entry_entity.dart';
import '../../features/payment_gateway/presentation/screens/gokwik_gateway_screen.dart';
import '../../features/receipt/domain/entities/receipt_entity.dart';
import '../../features/receipt/presentation/screens/receipt_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../shared/screens/not_found_screen.dart';
import '../../shared/widgets/navigation/app_shell_scaffold.dart';
import '../providers/auth_state_provider.dart';
import 'route_names.dart';
import 'route_paths.dart';
import 'route_transitions.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _offersNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'offers');
final GlobalKey<NavigatorState> _dashboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final GlobalKey<NavigatorState> _liveRatesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'liveRates');
final GlobalKey<NavigatorState> _calculatorNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'calculator');

/// Provider exposing the configured GoRouter instance with reactive auth guards.
final Provider<GoRouter> routerProvider = Provider<GoRouter>((Ref ref) {
  final AuthRouterListenable authListenable = ref.watch(authRouterListenableProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: authListenable,
    debugLogDiagnostics: false,
    redirect: (BuildContext context, GoRouterState state) {
      final AppAuthState auth = ref.read(appAuthStateProvider);
      final String location = state.uri.path;

      final bool isAuthRoute = location.startsWith('/auth');
      final bool isSplashRoute = location == RoutePaths.splash || location == '/';

      // 1. Splash Screen & Root Entry: Allow luxury animation to complete
      if (isSplashRoute) {
        return null;
      }

      // 2. App Booting: Default to splash while initial state initializes
      if (auth.isInitial) {
        return RoutePaths.splash;
      }

      // 3. Unauthenticated User: Redirect protected routes to login
      if (auth.isUnauthenticated) {
        if (isAuthRoute) {
          return null; // Allow public auth routes
        }
        return RoutePaths.login;
      }

      // 4. Authenticated User: Route according to statutory KYC status
      if (auth.isAuthenticated) {
        if (location == RoutePaths.authSuccess ||
            location == RoutePaths.profile ||
            location == RoutePaths.postKycChoice) {
          return null; // Allow welcome / biometric post-auth step, profile registration, or choice screen
        }

        // Statutory KYC Guard: If KYC is not completed, redirect to KYC screen
        if (!auth.isKycVerified) {
          if (location == RoutePaths.kyc) {
            return null; // Allow KYC screen
          }
          return RoutePaths.kyc; // Enforce KYC verification
        }

        // Verified User: Redirect auth routes to Gold Plans (new landing page)
        if (isAuthRoute) {
          return RoutePaths.offers;
        }

        return null; // Allow protected destinations
      }

      return null;
    },
    routes: <RouteBase>[
      // =======================================================================
      // 1. PUBLIC & AUTHENTICATION STACK ROUTES
      // =======================================================================
      GoRoute(
        path: '/',
        name: AppRoute.splash.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.fadeTransitionPage(
            key: state.pageKey,
            child: const SplashScreen(),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.splash,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.fadeTransitionPage(
            key: state.pageKey,
            child: const SplashScreen(),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.login,
        name: AppRoute.login.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.fadeTransitionPage(
            key: state.pageKey,
            duration: const Duration(milliseconds: 150),
            child: const LoginScreen(),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.phone,
        name: AppRoute.phone.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const PhoneScreen(),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.otp,
        name: AppRoute.otp.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const OtpScreen(),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.profile,
        name: AppRoute.profile.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const RegisterProfileScreen(),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.authSuccess,
        name: AppRoute.authSuccess.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.fadeTransitionPage(
            key: state.pageKey,
            child: const AuthSuccessScreen(),
          );
        },
      ),

      // Redirect legacy /home path directly to Gold Plans (/offers)
      GoRoute(
        path: RoutePaths.home,
        redirect: (BuildContext context, GoRouterState state) => RoutePaths.offers,
      ),

      // =======================================================================
      // 2. PROTECTED APPLICATION SHELL (4 CANONICAL TABS)
      //    1. Gold Plans
      //    2. My Plan
      //    3. Live Rate
      //    4. Calculator
      // =======================================================================
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return AppShellScaffold(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          // Branch 0: Gold Plans (Primary Landing Page)
          StatefulShellBranch(
            navigatorKey: _offersNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.offers,
                name: AppRoute.offers.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return RouteTransitions.fadeTransitionPage(
                    key: state.pageKey,
                    child: const OffersScreen(),
                  );
                },
              ),
            ],
          ),

          // Branch 1: My Plan (Dashboard)
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.dashboard,
                name: AppRoute.dashboard.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return RouteTransitions.fadeTransitionPage(
                    key: state.pageKey,
                    child: const DashboardScreen(),
                  );
                },
              ),
            ],
          ),

          // Branch 2: Live Rate
          StatefulShellBranch(
            navigatorKey: _liveRatesNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.liveRates,
                name: AppRoute.liveRates.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return RouteTransitions.fadeTransitionPage(
                    key: state.pageKey,
                    child: const LiveRatesScreen(),
                  );
                },
              ),
            ],
          ),

          // Branch 3: Calculator (Dedicated Page)
          StatefulShellBranch(
            navigatorKey: _calculatorNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.calculator,
                name: AppRoute.calculator.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return RouteTransitions.fadeTransitionPage(
                    key: state.pageKey,
                    child: const CalculatorScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      // =======================================================================
      // 3. PROTECTED TOP-LEVEL STACK & SECONDARY ROUTES
      // =======================================================================
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.coinRates,
        name: AppRoute.coinRates.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final CoinMetal? initialMetal = state.extra is CoinMetal
              ? state.extra as CoinMetal
              : (state.uri.queryParameters['metal'] == 'silver' ? CoinMetal.silver : null);
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: CoinRatesScreen(initialMetal: initialMetal ?? CoinMetal.gold),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.jewellery,
        name: AppRoute.jewellery.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.fadeTransitionPage(
            key: state.pageKey,
            child: const JewelleryScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.passbook,
        name: AppRoute.passbook.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const PassbookScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.settings,
        name: AppRoute.settings.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const SettingsScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.menu,
        name: AppRoute.menu.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.fadeTransitionPage(
            key: state.pageKey,
            child: const MenuScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.orders,
        name: AppRoute.orders.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const OrdersScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.notifications,
        name: AppRoute.notifications.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const NotificationsScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.kyc,
        name: AppRoute.kyc.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const KycScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.postKycChoice,
        name: AppRoute.postKycChoice.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.fadeTransitionPage(
            key: state.pageKey,
            child: const OnboardingChoiceScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.checkout,
        name: AppRoute.checkout.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final CheckoutArgs? args = state.extra as CheckoutArgs?;
          return RouteTransitions.slideFromBottomPage(
            key: state.pageKey,
            child: CheckoutScreen(args: args),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.book,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const BookingScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.review,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const ReviewPlanScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.cashPickup,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const CashPickupScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.receipt,
        name: AppRoute.receipt.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String receiptId = state.pathParameters['id'] ?? 'REC-UNKNOWN';
          final Object? extra = state.extra;
          final PassbookEntryEntity? passbookEntry =
              extra is PassbookEntryEntity ? extra : null;
          final ReceiptEntity? receipt = extra is ReceiptEntity ? extra : null;

          return RouteTransitions.slideFromBottomPage(
            key: state.pageKey,
            child: ReceiptScreen(
              receiptId: receiptId,
              passbookEntry: passbookEntry,
              receipt: receipt,
            ),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.gokwikGateway,
        name: AppRoute.gokwikGateway.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final PaymentOrderEntity? order = state.extra as PaymentOrderEntity?;
          return RouteTransitions.fadeTransitionPage(
            key: state.pageKey,
            child: GokwikGatewayScreen(order: order),
          );
        },
      ),
    ],
    errorPageBuilder: (BuildContext context, GoRouterState state) {
      return RouteTransitions.fadeTransitionPage(
        key: state.pageKey,
        child: NotFoundScreen(requestedPath: state.uri.path),
      );
    },
  );
});
