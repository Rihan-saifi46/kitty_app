import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/display/kitty_section_header.dart';
import '../../../offers/domain/entities/scheme_entity.dart';

/// Interactive promotional carousel showcasing exclusive Kitty offers & schemes.
class HomeOffersCarousel extends StatefulWidget {
  const HomeOffersCarousel({
    super.key,
    required this.schemes,
    required this.onViewAllTap,
    required this.onSchemeTap,
  });

  final List<SchemeEntity> schemes;
  final VoidCallback onViewAllTap;
  final ValueChanged<SchemeEntity> onSchemeTap;

  @override
  State<HomeOffersCarousel> createState() => _HomeOffersCarouselState();
}

class _HomeOffersCarouselState extends State<HomeOffersCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  static const List<Map<String, String>> _fallbackBanners = <Map<String, String>>[
    <String, String>{
      'title': '11+1 Month Bonus Kitty',
      'cta': 'Enrol Plan',
      'asset': 'assets/images/banner_clean_bonus.jpg',
    },
    <String, String>{
      'title': 'Akshaya Gold Coin Plan',
      'cta': 'Claim Coin',
      'asset': 'assets/images/banner_clean_coin.jpg',
    },
    <String, String>{
      'title': 'Royal Bridal Kitty',
      'cta': 'Explore Plan',
      'asset': 'assets/images/banner_clean_bridal.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (!mounted || !_pageController.hasClients) return;
      final int count = widget.schemes.isNotEmpty ? widget.schemes.length : _fallbackBanners.length;
      final int nextPage = (_currentPage + 1) % count;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = widget.schemes.isNotEmpty ? widget.schemes.length : _fallbackBanners.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
          child: KittySectionHeader(
            title: 'KITTY OFFERS & SCHEMES',
            eyebrow: 'EXCLUSIVE PRIVILEGES',
            actionLabel: 'View All →',
            onAction: widget.onViewAllTap,
            isDarkSurface: true,
          ),
        ),
        const SizedBox(height: AppSpacing.space12),

        // Carousel Slider
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _pageController,
            itemCount: itemCount,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              final SchemeEntity? scheme = widget.schemes.isNotEmpty && index < widget.schemes.length
                  ? widget.schemes[index]
                  : null;
              final Map<String, String> fallback = _fallbackBanners[index % _fallbackBanners.length];

              final String title = scheme?.name ?? fallback['title']!;
              final String cta = fallback['cta']!;
              final String imageAsset = scheme?.bannerImageUrl ?? fallback['asset']!;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.border16,
                  border: Border.all(
                    color: AppColors.goldBorder.withValues(alpha: 0.4),
                    width: 1,
                  ),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x30000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.border16,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      // Banner Image
                      Image.asset(
                        imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Container(
                            color: AppColors.deepEmeraldBase,
                            child: const Center(
                              child: Icon(
                                Icons.diamond_outlined,
                                color: AppColors.goldPrimary,
                                size: 48,
                              ),
                            ),
                          );
                        },
                      ),

                      // Gradient Shade
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.1),
                              Colors.black.withValues(alpha: 0.85),
                            ],
                            stops: const <double>[0.3, 0.6, 1.0],
                          ),
                        ),
                      ),

                      // Bottom Info Bar
                      Positioned(
                        left: 14,
                        right: 14,
                        bottom: 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                title,
                                style: AppTypography.cardTitle(
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                if (scheme != null) {
                                  widget.onSchemeTap(scheme);
                                } else {
                                  widget.onViewAllTap();
                                }
                              },
                              borderRadius: AppRadius.border10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: const BoxDecoration(
                                  color: AppColors.goldPrimary,
                                  borderRadius: AppRadius.border10,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      cta,
                                      style: AppTypography.labelMeta(
                                        color: AppColors.deepEmeraldBase,
                                      ).copyWith(fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 12,
                                      color: AppColors.deepEmeraldBase,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.space10),

        // Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(itemCount, (int index) {
            final bool isActive = _currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? AppColors.goldPrimary : AppColors.textTertiary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
