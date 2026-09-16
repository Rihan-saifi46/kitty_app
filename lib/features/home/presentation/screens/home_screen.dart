import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/widgets/feedback/kitty_error_state.dart';
import '../../../offers/domain/entities/scheme_entity.dart';
import '../../domain/entities/home_data_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/home_controller.dart';
import '../providers/home_state.dart';
import '../widgets/home_active_kitty_card.dart';
import '../widgets/home_category_scroll.dart';
import '../widgets/home_curated_product_grid.dart';
import '../widgets/home_editorial_banner.dart';
import '../widgets/home_gold_rate_strip.dart';
import '../widgets/home_greeting_bar.dart';
import '../widgets/home_kyc_reminder_banner.dart';
import '../widgets/home_offers_carousel.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/home_skeleton_loader.dart';

/// Complete authenticated Home landing screen for the Kitty App.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeState homeState = ref.watch(homeControllerProvider);
    final AppAuthState authState = ref.watch(appAuthStateProvider);

    // 1. Loading State
    if (homeState.isLoading && homeState.data == null) {
      return const Scaffold(
        backgroundColor: AppColors.deepEmeraldBase,
        body: SafeArea(child: HomeSkeletonLoader()),
      );
    }

    // 2. Error State (No cached data)
    if (homeState.isError && homeState.data == null) {
      return Scaffold(
        backgroundColor: AppColors.deepEmeraldBase,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space24),
            child: KittyErrorState(
              title: 'Unable to Load Home',
              message: homeState.errorMessage ??
                  'Unable to load your kitty details and catalog. Please check your internet connection.',
              retryLabel: 'Try Again',
              isDarkSurface: true,
              onRetry: () => ref.read(homeControllerProvider.notifier).loadHomeData(),
            ),
          ),
        ),
      );
    }

    final HomeDataEntity? data = homeState.data;
    if (data == null) {
      return const Scaffold(
        backgroundColor: AppColors.deepEmeraldBase,
        body: SafeArea(child: HomeSkeletonLoader()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.deepEmeraldBase,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.goldPrimary,
          backgroundColor: AppColors.emeraldCard,
          onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: <Widget>[
              // 1. Patron Greeting Bar
              SliverToBoxAdapter(
                child: HomeGreetingBar(
                  userName: authState.userName.isNotEmpty ? authState.userName : 'Rihan Saifi',
                  tier: authState.tier,
                  onProfileTap: () => context.go(RoutePaths.settings),
                ),
              ),

              // 2. Statutory KYC Compliance Reminder (if not verified)
              if (!authState.isKycVerified)
                SliverToBoxAdapter(
                  child: HomeKycReminderBanner(
                    onVerifyTap: () => context.push(RoutePaths.kyc),
                  ),
                ),

              // 3. Quick Action Shortcuts
              SliverToBoxAdapter(
                child: HomeQuickActions(
                  actions: <QuickActionItem>[
                    QuickActionItem(
                      title: 'My Kitty',
                      icon: Icons.savings_outlined,
                      onTap: () => context.go(RoutePaths.dashboard),
                    ),
                    QuickActionItem(
                      title: 'Passbook',
                      icon: Icons.receipt_long_outlined,
                      onTap: () => context.go(RoutePaths.passbook),
                    ),
                    QuickActionItem(
                      title: 'Offers',
                      icon: Icons.local_offer_outlined,
                      onTap: () => context.go(RoutePaths.offers),
                    ),
                    QuickActionItem(
                      title: 'KYC',
                      icon: Icons.shield_outlined,
                      onTap: () => context.push(RoutePaths.kyc),
                    ),
                    QuickActionItem(
                      title: 'Concierge',
                      icon: Icons.support_agent_outlined,
                      onTap: () => context.go(RoutePaths.settings),
                    ),
                  ],
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space12),
              ),

              // 4. Active Kitty Plan Summary Card
              if (data.activeKitty != null)
                SliverToBoxAdapter(
                  child: HomeActiveKittyCard(
                    dashboard: data.activeKitty!,
                    onPayTap: () => context.push(RoutePaths.checkout),
                    onDetailsTap: () => context.go(RoutePaths.dashboard),
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space14),
              ),

              // 5. Exclusive Kitty Offers & Schemes Carousel
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

              // 6. Curated Collections / Shop By Category
              SliverToBoxAdapter(
                child: HomeCategoryScroll(
                  categories: data.categories,
                  selectedCategory: data.selectedCategory,
                  onCategorySelected: (String category) {
                    ref.read(homeControllerProvider.notifier).selectCategory(category);
                  },
                  onViewAllTap: () => context.go(RoutePaths.offers),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space16),
              ),

              // 7. Curated For You (2-Column Product Cards)
              SliverToBoxAdapter(
                child: HomeCuratedProductGrid(
                  products: data.filteredProducts,
                  onProductTap: (ProductEntity product) => context.go(RoutePaths.offers),
                  onViewAllTap: () => context.go(RoutePaths.offers),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space14),
              ),

              // 8. Editorial Collection Banner ("The Everyday Gold Edit")
              SliverToBoxAdapter(
                child: HomeEditorialBanner(
                  onExploreTap: () => context.go(RoutePaths.offers),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space10),
              ),

              // 9. Daily Gold Rate & BIS Hallmark Trust Strip
              SliverToBoxAdapter(
                child: HomeGoldRateStrip(
                  goldRate: data.goldRate,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
