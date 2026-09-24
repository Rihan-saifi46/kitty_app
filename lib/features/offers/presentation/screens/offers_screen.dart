import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/feedback/kitty_empty_state.dart';
import '../../../../shared/widgets/feedback/kitty_error_state.dart';
import '../../domain/entities/scheme_entity.dart';
import '../providers/offers_controller.dart';
import '../providers/offers_state.dart';
import '../widgets/offers_duration_tabs.dart';
import '../widgets/offers_enrollment_dialog.dart';
import '../widgets/offers_hero_header.dart';
import '../widgets/offers_skeleton_loader.dart';
import '../widgets/offers_scheme_card.dart';
import '../widgets/offers_trust_strip.dart';

/// Full Kitty Offers & Product Catalog Screen.
///
/// Implements the approved UI from `offers.html`, `kitty-offers.html`, and `home.html`.
class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OffersState state = ref.watch(offersControllerProvider);
    final OffersController controller =
        ref.read(offersControllerProvider.notifier);

    // Show floating error notification if pull-to-refresh fails while catalog is already loaded
    ref.listen<OffersState>(offersControllerProvider, (previous, next) {
      if (next.status == OffersStatus.loaded &&
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
        child: _buildBody(context, state, controller),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    OffersState state,
    OffersController controller,
  ) {
    // 1. Initial / Full Loading State
    if (state.status == OffersStatus.loading && state.schemes.isEmpty) {
      return const OffersSkeletonLoader();
    }

    // 2. Full Error State
    if (state.status == OffersStatus.error && state.schemes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space24),
          child: KittyErrorState(
            title: 'Unable to Load Offers & Catalog',
            message: state.errorMessage ??
                'Please check your connection and try again.',
            retryLabel: 'Try Again',
            onRetry: controller.retry,
          ),
        ),
      );
    }

    // 3. Complete Empty State
    if (state.status == OffersStatus.empty) {
      return KittyEmptyState(
        title: 'No Active Offers & Plans',
        description:
            'There are currently no active Kitty savings schemes or products in the catalog.',
        actionLabel: 'REFRESH',
        onAction: controller.retry,
      );
    }

    // 4. Loaded Content with Pull-to-Refresh
    return RefreshIndicator(
      color: AppColors.goldPrimary,
      onRefresh: () => controller.loadOffersAndCatalog(refresh: true),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space16,
              vertical: AppSpacing.space16,
            ),
            sliver: SliverMainAxisGroup(
              slivers: <Widget>[
                // 1. Hero Header
                const SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      OffersHeroHeader(),
                      SizedBox(height: AppSpacing.space16),
                    ],
                  ),
                ),

                // 2. Savings Schemes Content
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Duration Filter Tabs
                      OffersDurationTabs(
                        schemes: state.schemes,
                        selectedDuration: state.selectedDuration,
                        onDurationSelected: controller.setDurationFilter,
                      ),
                      const SizedBox(height: AppSpacing.space16),

                      // Filtered Schemes List
                      if (state.filteredSchemes.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.space24),
                          child: KittyEmptyState(
                            title: 'No offers available right now',
                            description: 'No schemes found for the selected duration.',
                          ),
                        )
                      else
                        ...state.filteredSchemes.map((SchemeEntity scheme) {
                          return OffersSchemeCard(
                            key: ValueKey<String>(scheme.id),
                            scheme: scheme,
                            onEnrollTap: (SchemeEntity s) {
                              OffersEnrollmentDialog.show(context, scheme: s);
                            },
                          );
                        }),

                      const SizedBox(height: AppSpacing.space20),
                      const OffersTrustStrip(),
                      const SizedBox(height: AppSpacing.space64),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
