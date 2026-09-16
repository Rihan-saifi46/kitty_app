import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/buttons/kitty_primary_button.dart';
import '../../../../shared/widgets/feedback/kitty_empty_state.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/scheme_entity.dart';
import '../providers/offers_controller.dart';
import '../providers/offers_state.dart';
import '../widgets/offers_catalog_grid.dart';
import '../widgets/offers_duration_tabs.dart';
import '../widgets/offers_enrollment_dialog.dart';
import '../widgets/offers_hero_header.dart';
import '../widgets/offers_product_detail_sheet.dart';
import '../widgets/offers_section_switcher.dart';
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.statusErrorText.withValues(alpha: 0.1),
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 32,
                  color: AppColors.statusErrorText,
                ),
              ),
              const SizedBox(height: AppSpacing.space16),
              Text(
                'Unable to Load Offers & Catalog',
                style: AppTypography.cardTitle(
                  color: AppColors.textPrimaryDark,
                ).copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.space8),
              Text(
                state.errorMessage ??
                    'Please check your connection and try again.',
                style: AppTypography.bodySmall(
                  color: AppColors.textSecondaryMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.space24),
              KittyPrimaryButton(
                label: 'TRY AGAIN',
                onPressed: controller.retry,
              ),
            ],
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
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Hero Header
            const OffersHeroHeader(),
            const SizedBox(height: AppSpacing.space16),

            // 2. Primary Section Switcher (Schemes vs Catalog)
            OffersSectionSwitcher(
              activeSection: state.activeSection,
              onSectionChanged: controller.setSection,
            ),
            const SizedBox(height: AppSpacing.space16),

            // 3. Section Content
            if (state.activeSection == OffersViewSection.schemes) ...<Widget>[
              // Duration Filter Tabs
              OffersDurationTabs(
                schemes: state.schemes,
                selectedDuration: state.selectedDuration,
                onDurationSelected: controller.setDurationFilter,
              ),
              const SizedBox(height: AppSpacing.space16),

              // Filtered Schemes List
              if (state.filteredSchemes.isEmpty)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.space24),
                  alignment: Alignment.center,
                  child: Text(
                    'No schemes found for the selected duration.',
                    style: AppTypography.bodySmall(
                      color: AppColors.textSecondaryMuted,
                    ),
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
            ] else ...<Widget>[
              // Curated Jewellery Catalog
              OffersCatalogGrid(
                products: state.filteredProducts,
                categories: state.categories,
                selectedCategory: state.selectedCategory,
                wishlistedProductIds: state.wishlistedProductIds,
                onCategorySelected: controller.setCategoryFilter,
                onWishlistTap: controller.toggleWishlist,
                onProductTap: (ProductEntity product) {
                  OffersProductDetailSheet.show(
                    context,
                    product: product,
                    isWishlisted: state.isWishlisted(product.id),
                    onWishlistToggle: () =>
                        controller.toggleWishlist(product.id),
                  );
                },
              ),
            ],

            const SizedBox(height: AppSpacing.space20),

            // 4. Swastik Trust & Security 4-Grid Strip
            const OffersTrustStrip(),
            const SizedBox(height: AppSpacing.space32),
          ],
        ),
      ),
    );
  }
}
