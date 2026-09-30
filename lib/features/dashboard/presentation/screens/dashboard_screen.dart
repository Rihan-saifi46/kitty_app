import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/widgets/feedback/kitty_empty_state.dart';
import '../../../../shared/widgets/feedback/kitty_error_state.dart';
import '../../../checkout/presentation/screens/checkout_screen.dart';
import '../../../home/presentation/widgets/home_section_heading.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../providers/dashboard_controller.dart';
import '../providers/dashboard_state.dart';
import '../widgets/dashboard_multi_scheme_carousel.dart';
import '../widgets/dashboard_prejoin_banner.dart';
import '../widgets/dashboard_skeleton_loader.dart';

/// Authenticated Kitty Dashboard screen presenting in-depth active scheme metrics,
/// horizontal multi-scheme carousel, circular progress gauge, financial summary,
/// next installment due countdown, and passbook statements.
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
              state,
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
            title: 'No Active Gold Scheme',
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
          title: 'Unable to Load Scheme Details',
          message: errorMessage ??
              'Unable to load your scheme details. Please check your connection and try again.',
          retryLabel: 'Try Again',
          onRetry: controller.retry,
        ),
      ),
    );
  }

  Widget _buildLoadedView(
    BuildContext context,
    DashboardState dashboardState,
    DashboardController controller,
  ) {
    final List<DashboardSummaryEntity> schemes = dashboardState.schemes.isNotEmpty
        ? dashboardState.schemes
        : (dashboardState.data != null
            ? <DashboardSummaryEntity>[dashboardState.data!]
            : <DashboardSummaryEntity>[]);

    final DashboardSummaryEntity selectedScheme =
        dashboardState.selectedScheme ?? (schemes.isNotEmpty ? schemes.first : const DashboardSummaryEntity(hasActiveScheme: false));

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
          if (selectedScheme.isPreJoin)
            const SliverToBoxAdapter(
              child: DashboardPrejoinBanner(),
            ),

          // Active Scheme Section Heading
          const SliverToBoxAdapter(
            child: HomeSectionHeading(
              title: 'Active Scheme',
              fontSize: 14,
              padding: EdgeInsets.symmetric(vertical: AppSpacing.space12),
            ),
          ),

          // Multi-Scheme Carousel or Single Hero Card
          SliverToBoxAdapter(
            child: DashboardMultiSchemeCarousel(
              schemes: schemes,
              selectedIndex: dashboardState.selectedSchemeIndex,
              onSchemeChanged: controller.selectScheme,
              onPaySelected: (DashboardSummaryEntity scheme) {
                context.push(
                  RoutePaths.checkout,
                  extra: CheckoutArgs(
                    membershipId: scheme.membershipId ?? 'mem_994411',
                    chitToken: scheme.chitToken ?? '#SW-042',
                    monthFor: scheme.nextInstallment?.month ?? 1,
                    amount: scheme.nextInstallment?.amount ?? scheme.customMonthlyEmi ?? 5000,
                  ),
                );
              },
              onViewPassbook: (DashboardSummaryEntity scheme) {
                context.go(RoutePaths.passbook);
              },
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.space8),
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
                    boxShadow: AppShadows.cardSubtle,
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

          // Bottom Spacing for smooth navigation dock clearance
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.space64),
          ),
        ],
      ),
    );
  }
}
