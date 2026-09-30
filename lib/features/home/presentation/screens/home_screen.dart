import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/feedback/kitty_error_state.dart';
import '../../../checkout/presentation/screens/checkout_screen.dart';
import '../../../dashboard/domain/entities/dashboard_summary_entity.dart';
import '../../../dashboard/presentation/providers/dashboard_controller.dart';
import '../../../dashboard/presentation/providers/dashboard_state.dart';
import '../../../offers/domain/entities/scheme_entity.dart';
import '../../domain/entities/home_data_entity.dart';
import '../providers/home_controller.dart';
import '../providers/home_state.dart';
import '../widgets/home_active_kitty_card.dart';
import '../widgets/home_footer.dart';
import '../widgets/home_gold_price_last_3_days.dart';
import '../widgets/home_jewellery_collections.dart';
import '../widgets/home_no_active_kitty_card.dart';
import '../widgets/home_offers_carousel.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/home_skeleton_loader.dart';
import '../widgets/home_today_gold_rates.dart';

/// Redesigned Kitty-First Home Screen for the Kitty App.
///
/// Follows the approved information hierarchy:
/// 1. Today's Gold Rates (24K, 22K, 18K, 14K with live badge & timestamp)
/// 2. Active Kitty Card (prominent next payment & Pay Now CTA) OR No Active Kitty Card
/// 3. Quick Actions (Start Kitty, Calculator, Jewellery)
/// 4. Special Kitty Privileges Carousel (Promotions & 11+1 Bonus)
/// 5. Curated Masterpieces (Circular jewellery collections)
/// 6. Gold Price — Last 3 Days (3-day history & price movement)
/// 7. Support / Concierge Footer
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeState homeState = ref.watch(homeControllerProvider);
    final DashboardState dashboardState = ref.watch(dashboardControllerProvider);

    // Show floating error notification if pull-to-refresh fails while data is already loaded
    ref.listen<HomeState>(homeControllerProvider, (previous, next) {
      if (next.status == HomeStatus.loaded &&
          next.errorMessage != null &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.statusErrorText,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    // 1. Loading State
    if (homeState.isLoading && homeState.data == null) {
      return const Scaffold(
        backgroundColor: AppColors.homeCanvasBg,
        body: SafeArea(child: HomeSkeletonLoader()),
      );
    }

    // 2. Error State (No cached data)
    if (homeState.isError && homeState.data == null) {
      return Scaffold(
        backgroundColor: AppColors.homeCanvasBg,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space24),
            child: KittyErrorState(
              title: 'Unable to Load Home',
              message: homeState.errorMessage ??
                  'Unable to load your kitty details and catalog. Please check your internet connection.',
              retryLabel: 'Try Again',
              isDarkSurface: false,
              onRetry: () {
                ref.read(homeControllerProvider.notifier).loadHomeData();
                ref.read(dashboardControllerProvider.notifier).loadDashboard();
              },
            ),
          ),
        ),
      );
    }

    final HomeDataEntity? data = homeState.data;
    if (data == null) {
      return const Scaffold(
        backgroundColor: AppColors.homeCanvasBg,
        body: SafeArea(child: HomeSkeletonLoader()),
      );
    }

    // Resolve active kitty from dashboardControllerProvider or homeDataEntity
    final DashboardSummaryEntity? activeKitty = (dashboardState.data?.hasActiveScheme == true)
        ? (dashboardState.selectedScheme ?? dashboardState.data)
        : data.activeKitty;

    return Scaffold(
      backgroundColor: AppColors.homeCanvasBg,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.homeBrandGold,
          backgroundColor: AppColors.homeNavbarBg,
          onRefresh: () async {
            await Future.wait<void>(<Future<void>>[
              ref.read(homeControllerProvider.notifier).refresh(),
              ref.read(dashboardControllerProvider.notifier).loadDashboard(refresh: true),
            ]);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: <Widget>[
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space8),
              ),

              // 1. TODAY'S GOLD RATES (24K, 22K, 18K, 14K Live Board)
              SliverToBoxAdapter(
                child: HomeTodayGoldRates(
                  goldRate: data.goldRate,
                  onTap: () => context.push(RoutePaths.liveRates),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space4),
              ),

              // Multi-Scheme Quick Switcher Header (if patron holds multiple active kitties)
              if (dashboardState.hasMultipleSchemes && activeKitty != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.space16,
                      right: AppSpacing.space16,
                      bottom: 4,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: List<Widget>.generate(
                          dashboardState.schemes.length,
                          (int idx) {
                            final DashboardSummaryEntity s = dashboardState.schemes[idx];
                            final bool isSel = idx == dashboardState.selectedSchemeIndex;
                            final int emi = s.customMonthlyEmi ?? 5000;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                key: Key('home_multi_scheme_chip_$idx'),
                                label: Text(
                                  'Kitty #${idx + 1} (${CurrencyFormatter.formatRupees(emi)}/mo)',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                    color: isSel ? Colors.black : AppColors.espressoCharcoal,
                                  ),
                                ),
                                selected: isSel,
                                selectedColor: AppColors.honeyGoldAccent,
                                backgroundColor: AppColors.surfaceCardBg,
                                onSelected: (_) {
                                  ref.read(dashboardControllerProvider.notifier).selectScheme(idx);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

              // 2. ACTIVE KITTY HERO CARD or NO ACTIVE KITTY ONBOARDING CARD
              SliverToBoxAdapter(
                child: activeKitty != null
                    ? HomeActiveKittyCard(
                        dashboard: activeKitty,
                        onPayTap: () {
                          context.push(
                            RoutePaths.checkout,
                            extra: CheckoutArgs(
                              membershipId: activeKitty.membershipId ?? 'mem_994411',
                              chitToken: activeKitty.chitToken ?? '#SW-042',
                              monthFor: activeKitty.nextInstallment?.month ?? 1,
                              amount: activeKitty.nextInstallment?.amount ??
                                  activeKitty.customMonthlyEmi ??
                                  5000,
                            ),
                          );
                        },
                        onSavingsHistoryTap: () => context.go(RoutePaths.passbook),
                        onCardTap: () => context.go(RoutePaths.dashboard),
                      )
                    : HomeNoActiveKittyCard(
                        onStartKittyTap: () => context.go(RoutePaths.offers),
                        onCalculateTap: () => context.go(RoutePaths.calculator),
                      ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space6),
              ),

              // 3. QUICK ACTIONS (Start Kitty, Calculator, Jewellery)
              SliverToBoxAdapter(
                child: HomeQuickActions(
                  actions: <QuickActionItem>[
                    QuickActionItem(
                      title: 'Start Kitty',
                      icon: Icons.savings_rounded,
                      subtitle: 'New Plan',
                      onTap: () => context.go(RoutePaths.offers),
                    ),
                    QuickActionItem(
                      title: 'Calculator',
                      icon: Icons.calculate_rounded,
                      subtitle: 'Gold Value',
                      onTap: () => context.go(RoutePaths.calculator),
                    ),
                    QuickActionItem(
                      title: 'Jewellery',
                      icon: Icons.diamond_rounded,
                      subtitle: 'Showroom',
                      onTap: () => context.go(RoutePaths.jewellery),
                    ),
                  ],
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space16),
              ),

              // 4. SPECIAL KITTY PRIVILEGES (Promotional Scheme Carousel)
              SliverToBoxAdapter(
                child: HomeOffersCarousel(
                  schemes: data.schemes,
                  onViewAllTap: () => context.go(RoutePaths.offers),
                  onSchemeTap: (SchemeEntity scheme) => context.go(RoutePaths.offers),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space20),
              ),

              // 5. CURATED MASTERPIECES (Circular Jewellery Collections)
              SliverToBoxAdapter(
                child: HomeJewelleryCollections(
                  onCategoryTap: (String category) => context.go(RoutePaths.jewellery),
                  onViewAllTap: () => context.go(RoutePaths.jewellery),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space20),
              ),

              // 6. GOLD PRICE — LAST 3 DAYS (Concise 3-day history)
              SliverToBoxAdapter(
                child: HomeGoldPriceLast3Days(
                  goldRate: data.goldRate,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space12),
              ),

              // 7. CLEAN LUXURY FOOTER (Concierge, About Us, Policies)
              const SliverToBoxAdapter(
                child: HomeFooter(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space48),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
