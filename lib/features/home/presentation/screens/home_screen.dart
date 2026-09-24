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
import '../widgets/home_curated_product_grid.dart';
import '../widgets/home_editorial_banner.dart';
import '../widgets/home_gold_rate_strip.dart';
import '../widgets/home_kyc_reminder_banner.dart';
import '../widgets/home_offers_carousel.dart';
import '../widgets/home_skeleton_loader.dart';
import '../widgets/home_store_video_section.dart';

/// Complete authenticated Home landing screen for the Kitty App.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeState homeState = ref.watch(homeControllerProvider);
    final AppAuthState authState = ref.watch(appAuthStateProvider);

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
              onRetry: () => ref.read(homeControllerProvider.notifier).loadHomeData(),
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

    return Scaffold(
      backgroundColor: AppColors.homeCanvasBg,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.homeBrandGold,
          backgroundColor: AppColors.homeNavbarBg,
          onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: <Widget>[
              // 1. Statutory KYC Compliance Reminder (if not verified)
              if (!authState.isKycVerified)
                SliverToBoxAdapter(
                  child: HomeKycReminderBanner(
                    onVerifyTap: () => context.push(RoutePaths.kyc),
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space8),
              ),

              // 2. Exclusive Promotional Kitty Offers Carousel (Promoted to Top)
              SliverToBoxAdapter(
                child: HomeOffersCarousel(
                  schemes: data.schemes,
                  onViewAllTap: () => context.go(RoutePaths.offers),
                  onSchemeTap: (SchemeEntity scheme) => context.go(RoutePaths.offers),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space12),
              ),

              // 3. Active Jewel Plan Summary Card
              if (data.activeKitty != null)
                SliverToBoxAdapter(
                  child: HomeActiveKittyCard(
                    dashboard: data.activeKitty!,
                    onSeeActiveSchemeTap: () => context.go(RoutePaths.dashboard),
                    onDetailsTap: () => context.go(RoutePaths.dashboard),
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space16),
              ),

              // 6. Store Video Showcase Section ("Experience Swastik")
              const SliverToBoxAdapter(
                child: HomeStoreVideoSection(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.space20),
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
                child: SizedBox(height: AppSpacing.space20),
              ),

              // 9. Editorial Collection Banner ("The Everyday Gold Edit")
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
                child: SizedBox(height: AppSpacing.space64),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
