import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Categories available under Gold and Diamond Jewellery dropdowns.
enum JewelleryCategory {
  rings('Rings', Icons.circle_outlined),
  pendants('Pendants', Icons.auto_awesome_outlined),
  necklace('Necklace', Icons.all_inclusive_rounded),
  earrings('Earrings', Icons.flare_rounded),
  bangles('Bangles', Icons.radio_button_checked_rounded),
  bracelets('Bracelets', Icons.linear_scale_rounded);

  const JewelleryCategory(this.displayName, this.icon);
  final String displayName;
  final IconData icon;
}

/// Metal type enum.
enum MetalType {
  gold('Gold Jewellery', Icons.workspace_premium_rounded),
  diamond('Diamond Jewellery', Icons.diamond_outlined);

  const MetalType(this.displayName, this.icon);
  final String displayName;
  final IconData icon;
}

/// Item model for Jewellery showcase.
class JewelleryItem {
  const JewelleryItem({
    required this.id,
    required this.name,
    required this.metal,
    required this.category,
    required this.purity,
    required this.weight,
    required this.price,
    required this.imageAsset,
    this.badge,
  });

  final String id;
  final String name;
  final MetalType metal;
  final JewelleryCategory category;
  final String purity;
  final String weight;
  final double price;
  final String imageAsset;
  final String? badge;
}

/// Dedicated Jewellery Screen with 2 Dropdowns (Gold Jewellery & Diamond Jewellery),
/// each featuring Rings, Pendants, Necklace, Earrings, Bangles, and Bracelets.
class JewelleryScreen extends ConsumerStatefulWidget {
  const JewelleryScreen({super.key});

  @override
  ConsumerState<JewelleryScreen> createState() => _JewelleryScreenState();
}

class _JewelleryScreenState extends ConsumerState<JewelleryScreen> {
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  // Active selection
  MetalType _activeMetal = MetalType.gold;
  JewelleryCategory _goldSelectedCategory = JewelleryCategory.rings;
  JewelleryCategory _diamondSelectedCategory = JewelleryCategory.rings;

  JewelleryCategory get _currentCategory =>
      _activeMetal == MetalType.gold ? _goldSelectedCategory : _diamondSelectedCategory;

  // Catalog items
  static const List<JewelleryItem> _catalog = <JewelleryItem>[
    // Gold Items
    JewelleryItem(
      id: 'G-RNG-01',
      name: 'Royal Mayura Filigree Ring',
      metal: MetalType.gold,
      category: JewelleryCategory.rings,
      purity: '22K (916) Gold',
      weight: '4.85 g',
      price: 36800,
      imageAsset: 'assets/images/hero_diamond_ring.jpg',
      badge: 'Best Seller',
    ),
    JewelleryItem(
      id: 'G-RNG-02',
      name: 'Padma Temple Carved Band',
      metal: MetalType.gold,
      category: JewelleryCategory.rings,
      purity: '22K (916) Gold',
      weight: '6.20 g',
      price: 47100,
      imageAsset: 'assets/images/prod_halo_ring.jpg',
    ),
    JewelleryItem(
      id: 'G-PND-01',
      name: 'Surya Kundan Floral Pendant',
      metal: MetalType.gold,
      category: JewelleryCategory.pendants,
      purity: '22K (916) Gold',
      weight: '8.40 g',
      price: 63800,
      imageAsset: 'assets/images/card_pendant_thumb.jpg',
      badge: 'Chit Eligible',
    ),
    JewelleryItem(
      id: 'G-PND-02',
      name: 'Devi Meenakshi Coin Pendant',
      metal: MetalType.gold,
      category: JewelleryCategory.pendants,
      purity: '22K (916) Gold',
      weight: '5.50 g',
      price: 41800,
      imageAsset: 'assets/images/prod_pear_pendant.jpg',
    ),
    JewelleryItem(
      id: 'G-NCK-01',
      name: 'Aadrika Heritage Choker Set',
      metal: MetalType.gold,
      category: JewelleryCategory.necklace,
      purity: '22K (916) Gold',
      weight: '28.50 g',
      price: 216500,
      imageAsset: 'assets/images/cat_necklace.jpg',
      badge: '0% Making on Kitty',
    ),
    JewelleryItem(
      id: 'G-NCK-02',
      name: 'Rajputana Chikpatti Haar',
      metal: MetalType.gold,
      category: JewelleryCategory.necklace,
      purity: '22K (916) Gold',
      weight: '19.80 g',
      price: 150400,
      imageAsset: 'assets/images/campaign_emerald_necklace.jpg',
    ),
    JewelleryItem(
      id: 'G-EAR-01',
      name: 'Chandbalis with Pearl Drops',
      metal: MetalType.gold,
      category: JewelleryCategory.earrings,
      purity: '22K (916) Gold',
      weight: '12.20 g',
      price: 92700,
      imageAsset: 'assets/images/cat_earrings.jpg',
      badge: 'Popular',
    ),
    JewelleryItem(
      id: 'G-EAR-02',
      name: 'Kundan Floral Jhumkas',
      metal: MetalType.gold,
      category: JewelleryCategory.earrings,
      purity: '22K (916) Gold',
      weight: '9.60 g',
      price: 72900,
      imageAsset: 'assets/images/cat_earrings.jpg',
    ),
    JewelleryItem(
      id: 'G-BNG-01',
      name: 'Kada Textured Temple Bangle',
      metal: MetalType.gold,
      category: JewelleryCategory.bangles,
      purity: '22K (916) Gold',
      weight: '22.00 g',
      price: 167200,
      imageAsset: 'assets/images/prod_twisted_bangle.jpg',
      badge: 'Classic',
    ),
    JewelleryItem(
      id: 'G-BNG-02',
      name: 'Gajra Filigree Pair Bangles',
      metal: MetalType.gold,
      category: JewelleryCategory.bangles,
      purity: '22K (916) Gold',
      weight: '34.50 g',
      price: 262200,
      imageAsset: 'assets/images/prod_twisted_bangle.jpg',
    ),
    JewelleryItem(
      id: 'G-BRC-01',
      name: 'Nawabi Link Chain Bracelet',
      metal: MetalType.gold,
      category: JewelleryCategory.bracelets,
      purity: '22K (916) Gold',
      weight: '14.20 g',
      price: 107900,
      imageAsset: 'assets/images/prod_twisted_bangle.jpg',
    ),
    JewelleryItem(
      id: 'G-BRC-02',
      name: 'Lotus Blossom Charm Bracelet',
      metal: MetalType.gold,
      category: JewelleryCategory.bracelets,
      purity: '22K (916) Gold',
      weight: '11.80 g',
      price: 89600,
      imageAsset: 'assets/images/prod_twisted_bangle.jpg',
      badge: 'Trending',
    ),

    // Diamond Items
    JewelleryItem(
      id: 'D-RNG-01',
      name: 'Celestial Solitaire Halo Ring',
      metal: MetalType.diamond,
      category: JewelleryCategory.rings,
      purity: '18K Gold • VVS/EF (0.75 ct)',
      weight: '3.60 g',
      price: 94500,
      imageAsset: 'assets/images/prod_solitaire_ring.jpg',
      badge: 'IGI Certified',
    ),
    JewelleryItem(
      id: 'D-RNG-02',
      name: 'Eternity Pavé Diamond Band',
      metal: MetalType.diamond,
      category: JewelleryCategory.rings,
      purity: '18K Gold • VVS/GH (0.45 ct)',
      weight: '2.90 g',
      price: 58000,
      imageAsset: 'assets/images/prod_halo_ring.jpg',
    ),
    JewelleryItem(
      id: 'D-PND-01',
      name: 'Teardrop Pear Diamond Pendant',
      metal: MetalType.diamond,
      category: JewelleryCategory.pendants,
      purity: '18K Gold • VVS/EF (0.60 ct)',
      weight: '3.20 g',
      price: 76000,
      imageAsset: 'assets/images/prod_pear_pendant.jpg',
      badge: 'Luxury Edit',
    ),
    JewelleryItem(
      id: 'D-PND-02',
      name: 'Infinite Solitaire Cluster Pendant',
      metal: MetalType.diamond,
      category: JewelleryCategory.pendants,
      purity: '18K Gold • VVS/GH (0.38 ct)',
      weight: '2.40 g',
      price: 49500,
      imageAsset: 'assets/images/prod_pear_pendant.jpg',
    ),
    JewelleryItem(
      id: 'D-NCK-01',
      name: 'Riviera Diamond Tennis Necklace',
      metal: MetalType.diamond,
      category: JewelleryCategory.necklace,
      purity: '18K Gold • VVS (3.20 ct)',
      weight: '21.50 g',
      price: 345000,
      imageAsset: 'assets/images/campaign_emerald_necklace.jpg',
      badge: 'Signature Masterpiece',
    ),
    JewelleryItem(
      id: 'D-NCK-02',
      name: 'Emerald & Diamond Cascading Haar',
      metal: MetalType.diamond,
      category: JewelleryCategory.necklace,
      purity: '18K Gold • VVS (2.10 ct)',
      weight: '18.40 g',
      price: 278000,
      imageAsset: 'assets/images/cat_necklace.jpg',
    ),
    JewelleryItem(
      id: 'D-EAR-01',
      name: 'Solitaire Stud Diamond Earrings',
      metal: MetalType.diamond,
      category: JewelleryCategory.earrings,
      purity: '18K Gold • VVS/EF (1.00 ct)',
      weight: '2.80 g',
      price: 125000,
      imageAsset: 'assets/images/cat_earrings.jpg',
      badge: 'Timeless',
    ),
    JewelleryItem(
      id: 'D-EAR-02',
      name: 'Chandelier Diamond Danglers',
      metal: MetalType.diamond,
      category: JewelleryCategory.earrings,
      purity: '18K Gold • VVS/GH (1.45 ct)',
      weight: '6.50 g',
      price: 168000,
      imageAsset: 'assets/images/cat_earrings.jpg',
    ),
    JewelleryItem(
      id: 'D-BNG-01',
      name: 'Twisted Diamond Kada Bangle',
      metal: MetalType.diamond,
      category: JewelleryCategory.bangles,
      purity: '18K Gold • VVS (1.80 ct)',
      weight: '16.20 g',
      price: 215000,
      imageAsset: 'assets/images/prod_twisted_bangle.jpg',
      badge: 'IGI Certified',
    ),
    JewelleryItem(
      id: 'D-BNG-02',
      name: 'Open End Diamond Floral Bangle',
      metal: MetalType.diamond,
      category: JewelleryCategory.bangles,
      purity: '18K Gold • VVS/GH (1.20 ct)',
      weight: '14.00 g',
      price: 159000,
      imageAsset: 'assets/images/prod_twisted_bangle.jpg',
    ),
    JewelleryItem(
      id: 'D-BRC-01',
      name: 'Classic Diamond Tennis Bracelet',
      metal: MetalType.diamond,
      category: JewelleryCategory.bracelets,
      purity: '18K Gold • VVS/EF (2.50 ct)',
      weight: '12.80 g',
      price: 285000,
      imageAsset: 'assets/images/prod_twisted_bangle.jpg',
      badge: 'Iconic',
    ),
    JewelleryItem(
      id: 'D-BRC-02',
      name: 'Geometric Line Diamond Bracelet',
      metal: MetalType.diamond,
      category: JewelleryCategory.bracelets,
      purity: '18K Gold • VVS/GH (1.10 ct)',
      weight: '9.40 g',
      price: 139000,
      imageAsset: 'assets/images/prod_twisted_bangle.jpg',
    ),
  ];

  List<JewelleryItem> get _filteredItems {
    return _catalog.where((item) {
      return item.metal == _activeMetal && item.category == _currentCategory;
    }).toList();
  }

  void _showItemDetailDialog(JewelleryItem item) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: AppColors.creamIvoryCard,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.border20),
          title: Text(
            item.name,
            style: AppTypography.cardTitle(color: AppColors.espressoCharcoal),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: AppRadius.border12,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    item.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.warmLinenInset,
                      child: const Icon(Icons.diamond_outlined, size: 40, color: AppColors.honeyGoldAccent),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Purity & Spec:', style: AppTypography.bodyRegular(color: AppColors.warmTaupeBrown)),
                  Text(item.purity, style: AppTypography.bodyBold(color: AppColors.espressoCharcoal)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Estimated Weight:', style: AppTypography.bodyRegular(color: AppColors.warmTaupeBrown)),
                  Text(item.weight, style: AppTypography.bodyBold(color: AppColors.espressoCharcoal)),
                ],
              ),
              const Divider(height: 16, color: AppColors.surfaceCardBorder),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Estimated Price:', style: AppTypography.bodyBold(color: AppColors.espressoCharcoal)),
                  Text(
                    _currencyFormat.format(item.price),
                    style: AppTypography.displaySubtitle(color: AppColors.honeyGoldAccent),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• 100% BIS Hallmarked & IGI Certified\n'
                '• Redeemable with Kitty Maturity Savings\n'
                '• Try at any Swastik Jewellers flagship showroom',
                style: AppTypography.caption(color: AppColors.warmTaupeBrown).copyWith(height: 1.4),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Close', style: AppTypography.bodyRegular(color: AppColors.warmTaupeBrown)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.espressoCharcoal,
                    content: Text(
                      'Added "${item.name}" to your Kitty Scheme Wishlist!',
                      style: const TextStyle(color: Colors.white),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.honeyGoldAccent,
                foregroundColor: AppColors.deepUmberBronze,
                shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
              ),
              child: const Text('Add to Wishlist', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeCanvasBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: <Widget>[
            // 1. Page Header Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Container(
                  padding: AppSpacing.all16,
                  decoration: BoxDecoration(
                    color: AppColors.creamIvoryCard,
                    borderRadius: AppRadius.border16,
                    border: Border.all(color: AppColors.warmLinenInset),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x062B2521),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.champagneFoil,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.honeyGoldAccent.withValues(alpha: 0.35),
                          ),
                        ),
                        child: const Icon(
                          Icons.diamond_outlined,
                          color: AppColors.honeyGoldAccent,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'FINE JEWELLERY CATALOG',
                              style: AppTypography.kickerCaps(
                                color: AppColors.warmTaupeBrown,
                              ).copyWith(fontSize: 10, letterSpacing: 0.8),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Handcrafted Collections',
                              style: AppTypography.cardTitle(
                                color: AppColors.espressoCharcoal,
                              ).copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Redeemable with your Kitty Savings plan at 0% Making',
                              style: AppTypography.caption(
                                color: AppColors.warmTaupeBrown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. The 2 Dropdowns Section (Gold Jewellery & Diamond Jewellery)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Select Category by Metal:',
                      style: AppTypography.bodyBold(
                        color: AppColors.espressoCharcoal,
                      ).copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 10),

                    // Two Dropdown Containers side by side
                    Row(
                      children: <Widget>[
                        // Dropdown 1: Gold Jewellery
                        Expanded(
                          child: _JewelleryDropdownCard(
                            title: 'Gold Jewellery',
                            icon: Icons.workspace_premium_rounded,
                            isActive: _activeMetal == MetalType.gold,
                            selectedCategory: _goldSelectedCategory,
                            onCategoryChanged: (JewelleryCategory newCat) {
                              setState(() {
                                _activeMetal = MetalType.gold;
                                _goldSelectedCategory = newCat;
                              });
                            },
                            onCardTapped: () {
                              setState(() {
                                _activeMetal = MetalType.gold;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Dropdown 2: Diamond Jewellery
                        Expanded(
                          child: _JewelleryDropdownCard(
                            title: 'Diamond Jewellery',
                            icon: Icons.diamond_outlined,
                            isActive: _activeMetal == MetalType.diamond,
                            selectedCategory: _diamondSelectedCategory,
                            onCategoryChanged: (JewelleryCategory newCat) {
                              setState(() {
                                _activeMetal = MetalType.diamond;
                                _diamondSelectedCategory = newCat;
                              });
                            },
                            onCardTapped: () {
                              setState(() {
                                _activeMetal = MetalType.diamond;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. Category Quick Tabs (Rings, Pendants, Necklace, Earrings, Bangles, Bracelets)
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: JewelleryCategory.values.map((JewelleryCategory cat) {
                    final bool isSelected = _currentCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              cat.icon,
                              size: 15,
                              color: isSelected ? AppColors.deepUmberBronze : AppColors.espressoCharcoal,
                            ),
                            const SizedBox(width: 5),
                            Text(cat.displayName),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          if (selected) {
                            setState(() {
                              if (_activeMetal == MetalType.gold) {
                                _goldSelectedCategory = cat;
                              } else {
                                _diamondSelectedCategory = cat;
                              }
                            });
                          }
                        },
                        selectedColor: AppColors.honeyGoldAccent,
                        backgroundColor: AppColors.creamIvoryCard,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          color: isSelected ? AppColors.deepUmberBronze : AppColors.espressoCharcoal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.border16,
                          side: BorderSide(
                            color: isSelected ? AppColors.honeyGoldAccent : AppColors.warmLinenInset,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // 4. Curated Items Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: _filteredItems.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No items available in this category yet.',
                            style: AppTypography.bodyRegular(color: AppColors.warmTaupeBrown),
                          ),
                        ),
                      ),
                    )
                  : SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.68,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final JewelleryItem item = _filteredItems[index];
                          return _ProductCard(
                            item: item,
                            formattedPrice: _currencyFormat.format(item.price),
                            onTap: () => _showItemDetailDialog(item),
                          );
                        },
                        childCount: _filteredItems.length,
                      ),
                    ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 64)),
          ],
        ),
      ),
    );
  }
}

/// Custom Dropdown Card for Gold or Diamond Jewellery.
class _JewelleryDropdownCard extends StatelessWidget {
  const _JewelleryDropdownCard({
    required this.title,
    required this.icon,
    required this.isActive,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onCardTapped,
  });

  final String title;
  final IconData icon;
  final bool isActive;
  final JewelleryCategory selectedCategory;
  final ValueChanged<JewelleryCategory> onCategoryChanged;
  final VoidCallback onCardTapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTapped,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.champagneFoil.withValues(alpha: 0.45) : AppColors.creamIvoryCard,
          borderRadius: AppRadius.border16,
          border: Border.all(
            color: isActive ? AppColors.honeyGoldAccent : AppColors.warmLinenInset,
            width: isActive ? 1.5 : 1.0,
          ),
          boxShadow: isActive
              ? <BoxShadow>[
                  BoxShadow(
                    color: AppColors.honeyGoldAccent.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  icon,
                  size: 18,
                  color: isActive ? AppColors.honeyGoldAccent : AppColors.warmTaupeBrown,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                      color: isActive ? AppColors.espressoCharcoal : AppColors.warmTaupeBrown,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Dropdown Menu
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.warmLinenInset,
                borderRadius: AppRadius.border12,
                border: Border.all(color: AppColors.surfaceCardBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<JewelleryCategory>(
                  value: selectedCategory,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.espressoCharcoal),
                  dropdownColor: AppColors.creamIvoryCard,
                  borderRadius: AppRadius.border16,
                  items: JewelleryCategory.values.map((JewelleryCategory cat) {
                    return DropdownMenuItem<JewelleryCategory>(
                      value: cat,
                      child: Text(
                        cat.displayName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.espressoCharcoal,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (JewelleryCategory? newCat) {
                    if (newCat != null) {
                      onCategoryChanged(newCat);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product grid card matching warm luxury design.
class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.item,
    required this.formattedPrice,
    required this.onTap,
  });

  final JewelleryItem item;
  final String formattedPrice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.creamIvoryCard,
          borderRadius: AppRadius.border16,
          border: Border.all(color: AppColors.warmLinenInset),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x062B2521),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image with optional badge
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.asset(
                      item.imageAsset,
                      fit: BoxFit.cover,
                      cacheWidth: 400,
                      cacheHeight: 400,
                      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) return child;
                        return AnimatedOpacity(
                          opacity: frame == null ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          child: frame == null
                              ? Container(
                                  color: AppColors.warmLinenInset,
                                  child: Center(
                                    child: Icon(
                                      Icons.diamond_outlined,
                                      size: 24,
                                      color: AppColors.honeyGoldAccent.withValues(alpha: 0.5),
                                    ),
                                  ),
                                )
                              : child,
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.warmLinenInset,
                        child: const Center(
                          child: Icon(Icons.diamond_outlined, size: 36, color: AppColors.honeyGoldAccent),
                        ),
                      ),
                    ),
                  ),
                  if (item.badge != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: const BoxDecoration(
                          color: AppColors.champagneFoil,
                          borderRadius: AppRadius.border8,
                        ),
                        child: Text(
                          item.badge!,
                          style: const TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.espressoCharcoal,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Details
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.name,
                          style: AppTypography.cardTitle(
                            color: AppColors.espressoCharcoal,
                          ).copyWith(fontSize: 12.5),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.purity,
                          style: AppTypography.caption(
                            color: AppColors.warmTaupeBrown,
                          ).copyWith(fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          formattedPrice,
                          style: AppTypography.bodyBold(
                            color: AppColors.honeyGoldAccent,
                          ).copyWith(fontSize: 13, fontWeight: FontWeight.w900),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.warmLinenInset,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 10,
                            color: AppColors.espressoCharcoal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
