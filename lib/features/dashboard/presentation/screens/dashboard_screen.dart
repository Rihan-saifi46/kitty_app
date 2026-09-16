import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/widgets/buttons/kitty_primary_button.dart';
import '../../../../shared/widgets/feedback/kitty_empty_state.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../providers/dashboard_controller.dart';
import '../providers/dashboard_state.dart';
import '../widgets/dashboard_hero_card.dart';
import '../widgets/dashboard_next_emi_card.dart';
import '../widgets/dashboard_prejoin_banner.dart';
import '../widgets/dashboard_skeleton_loader.dart';
import '../widgets/dashboard_stats_grid.dart';
import '../widgets/dashboard_trust_bar.dart';

/// Authenticated Kitty Dashboard screen presenting in-depth active scheme metrics,
/// circular progress gauge, financial summary, next installment due countdown, and trust guarantees.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DashboardState state = ref.watch(dashboardControllerProvider);
    final DashboardController controller = ref.read(dashboardControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surfacePageBg,
      body: SafeArea(
        top: false,
        bottom: false,
        child: switch (state.status) {
          DashboardStatus.initial || DashboardStatus.loading => const DashboardSkeletonLoader(),
          DashboardStatus.empty => _buildEmptyView(context, controller),
          DashboardStatus.error => _buildErrorView(context, state.errorMessage, controller),
          DashboardStatus.loaded || DashboardStatus.refreshing => _buildLoadedView(
              context,
              state.data!,
              controller,
            ),
        },
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context, DashboardController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.loadDashboard(refresh: true),
      color: AppColors.goldPrimary,
      backgroundColor: AppColors.surfaceCardBg,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          KittyEmptyState(
            title: 'No Active Kitty Scheme',
            description:
                'Enroll in our exclusive 100% jeweler bonus gold savings schemes to start accumulating 24K pure gold monthly.',
            icon: const Icon(
              Icons.savings_outlined,
              color: AppColors.goldPrimary,
              size: 32,
            ),
            actionLabel: 'EXPLORE SCHEMES',
            onAction: () => context.push(RoutePaths.offers),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    String? errorMessage,
    DashboardController controller,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.statusErrorBg,
                border: Border.all(
                  color: AppColors.statusErrorText.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.statusErrorText,
                size: 32,
              ),
            ),
            const SizedBox(height: AppSpacing.space16),
            Text(
              'Unable to Load Kitty Details',
              style: AppTypography.cardTitle(color: AppColors.textPrimaryLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space8),
            Text(
              errorMessage ??
                  'Unable to load your kitty details. Please check your connection and try again.',
              style: AppTypography.bodySmall(color: AppColors.textSecondaryLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space24),
            KittyPrimaryButton(
              label: 'Try Again',
              onPressed: controller.retry,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedView(
    BuildContext context,
    DashboardSummaryEntity data,
    DashboardController controller,
  ) {
    return RefreshIndicator(
      onRefresh: () => controller.loadDashboard(refresh: true),
      color: AppColors.goldPrimary,
      backgroundColor: AppColors.surfaceCardBg,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: <Widget>[
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.space8),
          ),

          // PRE_JOIN Status Banner (if applicable)
          if (data.isPreJoin)
            const SliverToBoxAdapter(
              child: DashboardPrejoinBanner(),
            ),

          // VIP Active Scheme Hero Card
          SliverToBoxAdapter(
            child: DashboardHeroCard(dashboard: data),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.space8),
          ),

          // 2x2 Statistics Grid
          SliverToBoxAdapter(
            child: DashboardStatsGrid(dashboard: data),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.space8),
          ),

          // Next EMI Installment Due Card
          SliverToBoxAdapter(
            child: DashboardNextEmiCard(
              dashboard: data,
              onPayTap: () => context.push(RoutePaths.checkout),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.space8),
          ),

          // Swastik Trust & Guarantees Bar
          const SliverToBoxAdapter(
            child: DashboardTrustBar(),
          ),

          // Bottom Spacing for smooth navigation dock clearance
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.space32),
          ),
        ],
      ),
    );
  }
}
