import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/widgets/feedback/kitty_empty_state.dart';
import '../../../../shared/widgets/feedback/kitty_error_state.dart';
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

    // Show floating error notification if pull-to-refresh fails while data is already loaded
    ref.listen<DashboardState>(dashboardControllerProvider, (previous, next) {
      if (next.status == DashboardStatus.loaded &&
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
        child: KittyErrorState(
          title: 'Unable to Load Kitty Details',
          message: errorMessage ??
              'Unable to load your kitty details. Please check your connection and try again.',
          retryLabel: 'Try Again',
          onRetry: controller.retry,
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
            child: SizedBox(height: AppSpacing.space4),
          ),

          // Passbook & Statements Quick Link Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space16,
                vertical: AppSpacing.space4,
              ),
              child: InkWell(
                key: const Key('dashboard_view_passbook_link'),
                onTap: () => context.go(RoutePaths.passbook),
                borderRadius: AppRadius.border16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space16,
                    vertical: AppSpacing.space12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCardBg,
                    borderRadius: AppRadius.border16,
                    border: Border.all(
                      color: AppColors.surfaceCardBorder,
                      width: 1,
                    ),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.goldSubtle,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.goldBorder.withValues(alpha: 0.35),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.menu_book_outlined,
                            color: AppColors.goldPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Passbook & Statements',
                              style: AppTypography.cardTitle(
                                color: AppColors.textPrimaryDark,
                              ).copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'View 12-month installment history & gold allocation',
                              style: AppTypography.bodySmall(
                                color: AppColors.textSecondaryMuted,
                              ).copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                    ],
                  ),
                ),
              ),
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
            child: SizedBox(height: AppSpacing.space64),
          ),
        ],
      ),
    );
  }
}
