import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/auth_success_placeholder_screen.dart';
import '../../features/auth/presentation/screens/login_placeholder_screen.dart';
import '../../features/auth/presentation/screens/otp_placeholder_screen.dart';
import '../../features/auth/presentation/screens/phone_placeholder_screen.dart';
import '../../features/checkout/presentation/screens/checkout_placeholder_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_placeholder_screen.dart';
import '../../features/home/presentation/screens/home_placeholder_screen.dart';
import '../../features/kyc/presentation/screens/kyc_placeholder_screen.dart';
import '../../features/notifications/presentation/screens/notifications_placeholder_screen.dart';
import '../../features/offers/presentation/screens/offers_placeholder_screen.dart';
import '../../features/passbook/presentation/screens/passbook_placeholder_screen.dart';
import '../../features/payment_gateway/presentation/screens/gokwik_placeholder_screen.dart';
import '../../features/receipt/presentation/screens/receipt_placeholder_screen.dart';
import '../../features/settings/presentation/screens/settings_placeholder_screen.dart';
import '../../features/splash/presentation/screens/splash_placeholder_screen.dart';
import '../../shared/screens/not_found_screen.dart';
import '../../shared/widgets/navigation/app_shell_scaffold.dart';
import '../providers/auth_state_provider.dart';
import 'route_names.dart';
import 'route_paths.dart';
import 'route_transitions.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _dashboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final GlobalKey<NavigatorState> _passbookNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'passbook');
final GlobalKey<NavigatorState> _offersNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'offers');
final GlobalKey<NavigatorState> _settingsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'settings');

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
      final bool isSplashRoute = location == RoutePaths.splash;

      // 1. App Booting: Allow splash screen while verifying session
      if (auth.isInitial) {
        return isSplashRoute ? null : RoutePaths.splash;
      }

      // 2. Unauthenticated User: Redirect protected routes & splash to login
      if (auth.isUnauthenticated) {
        if (isAuthRoute) {
          return null; // Allow public auth routes
        }
        return RoutePaths.login;
      }

      // 3. Authenticated User: Redirect auth & splash routes to home
      if (auth.isAuthenticated) {
        if (location == RoutePaths.authSuccess) {
          return null; // Allow welcome / biometric post-auth step
        }
        if (isAuthRoute || isSplashRoute) {
          return RoutePaths.home;
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
        path: RoutePaths.splash,
        name: AppRoute.splash.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.fadeTransitionPage(
            key: state.pageKey,
            child: const SplashPlaceholderScreen(),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.login,
        name: AppRoute.login.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.fadeTransitionPage(
            key: state.pageKey,
            child: const LoginPlaceholderScreen(),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.phone,
        name: AppRoute.phone.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const PhonePlaceholderScreen(),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.otp,
        name: AppRoute.otp.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const OtpPlaceholderScreen(),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.authSuccess,
        name: AppRoute.authSuccess.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.fadeTransitionPage(
            key: state.pageKey,
            child: const AuthSuccessPlaceholderScreen(),
          );
        },
      ),

      // =======================================================================
      // 2. PROTECTED APPLICATION SHELL (STATEFUL TABS)
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
          // Branch 0: Home
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.home,
                name: AppRoute.home.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return RouteTransitions.fadeTransitionPage(
                    key: state.pageKey,
                    child: const HomePlaceholderScreen(),
                  );
                },
              ),
            ],
          ),

          // Branch 1: My Kitty Scheme
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.dashboard,
                name: AppRoute.dashboard.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return RouteTransitions.fadeTransitionPage(
                    key: state.pageKey,
                    child: const DashboardPlaceholderScreen(),
                  );
                },
              ),
            ],
          ),

          // Branch 2: Passbook Ledger
          StatefulShellBranch(
            navigatorKey: _passbookNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.passbook,
                name: AppRoute.passbook.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return RouteTransitions.fadeTransitionPage(
                    key: state.pageKey,
                    child: const PassbookPlaceholderScreen(),
                  );
                },
              ),
            ],
          ),

          // Branch 3: Offers & Plans
          StatefulShellBranch(
            navigatorKey: _offersNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.offers,
                name: AppRoute.offers.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return RouteTransitions.fadeTransitionPage(
                    key: state.pageKey,
                    child: const OffersPlaceholderScreen(),
                  );
                },
              ),
            ],
          ),

          // Branch 4: Settings & Security
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.settings,
                name: AppRoute.settings.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return RouteTransitions.fadeTransitionPage(
                    key: state.pageKey,
                    child: const SettingsPlaceholderScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      // =======================================================================
      // 3. PROTECTED TOP-LEVEL STACK & MODAL ROUTES
      // =======================================================================
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.notifications,
        name: AppRoute.notifications.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromRightPage(
            key: state.pageKey,
            child: const NotificationsPlaceholderScreen(),
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
            child: const KycPlaceholderScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.checkout,
        name: AppRoute.checkout.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.slideFromBottomPage(
            key: state.pageKey,
            child: const CheckoutPlaceholderScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.receipt,
        name: AppRoute.receipt.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String receiptId = state.pathParameters['id'] ?? 'REC-UNKNOWN';
          return RouteTransitions.slideFromBottomPage(
            key: state.pageKey,
            child: ReceiptPlaceholderScreen(receiptId: receiptId),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RoutePaths.gokwikGateway,
        name: AppRoute.gokwikGateway.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return RouteTransitions.fadeTransitionPage(
            key: state.pageKey,
            child: const GokwikPlaceholderScreen(),
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
