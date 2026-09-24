import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Available coin metal types.
enum CoinMetal {
  gold('Gold Coins', Icons.monetization_on_rounded),
  silver('Silver Coins', Icons.circle_outlined);

  const CoinMetal(this.displayName, this.icon);
  final String displayName;
  final IconData icon;
}

/// Gold Karat / Purity options supported by the product.
enum GoldKarat {
  k24('24K (999 Purity)', 7485.50, '99.9% Pure Investment Bullion'),
  k22('22K (916 Purity)', 6861.70, '91.6% Pure Traditional Gold');

  const GoldKarat(this.label, this.ratePerGram, this.description);
  final String label;
  final double ratePerGram;
  final String description;
}

/// Screen displaying live Gold Coins & Silver Coins rates for 1g to 5g,
/// with metal switching tabs, karat selection (Gold only), and custom bulk ordering.
class CoinRatesScreen extends ConsumerStatefulWidget {
  const CoinRatesScreen({
    this.benchmarkGoldRate = 7485.50,
    this.benchmarkSilverRate = 89.50,
    super.key,
  });

  /// Base rate per gram for 24K 999 Investment Grade Gold.
  final double benchmarkGoldRate;

  /// Base rate per gram for 999 Fine Silver (matching API contract v1.0).
  final double benchmarkSilverRate;

  @override
  ConsumerState<CoinRatesScreen> createState() => _CoinRatesScreenState();
}

class _CoinRatesScreenState extends ConsumerState<CoinRatesScreen> {
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  // Active Metal Tab
  CoinMetal _selectedMetal = CoinMetal.gold;

  // Selected Karat for Gold (only active when _selectedMetal == CoinMetal.gold)
  GoldKarat _selectedGoldKarat = GoldKarat.k24;

  // Custom bulk order state (> 5g)
  int _selectedBulkGrams = 20;
  final TextEditingController _customGramsController = TextEditingController();
  bool _isCustomInput = false;

  @override
  void dispose() {
    _customGramsController.dispose();
    super.dispose();
  }

  /// Current applicable rate per gram based on selected metal and karat.
  double get _currentRatePerGram {
    if (_selectedMetal == CoinMetal.silver) {
      return widget.benchmarkSilverRate;
    }
    return _selectedGoldKarat.ratePerGram;
  }

  double _calculatePrice(int grams) {
    if (_selectedMetal == CoinMetal.gold) {
      final double rawGold = grams * _currentRatePerGram;
      final double assayFee = grams <= 2 ? 300 : (grams <= 5 ? 450 : 600);
      return rawGold + assayFee;
    } else {
      // Silver: Base bullion + tamper-proof blister assay packaging
      final double rawSilver = grams * _currentRatePerGram;
      final double assayFee = grams <= 5 ? 75 : 120;
      return rawSilver + assayFee;
    }
  }

  void _handleBookCoin(int grams) {
    final double price = _calculatePrice(grams);
    _showBookingDialog(
      grams: grams,
      totalPrice: price,
      isBulk: grams > 5,
    );
  }

  void _showBookingDialog({
    required int grams,
    required double totalPrice,
    required bool isBulk,
  }) {
    final bool isGold = _selectedMetal == CoinMetal.gold;
    final String purityText = isGold ? _selectedGoldKarat.label : '999 Fine Silver (99.9% Purity)';
    final String metalTitle = isGold ? 'Gold Coin' : 'Silver Coin';

    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: AppColors.creamIvoryCard,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.border20),
          title: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isGold ? AppColors.champagneFoil : AppColors.warmLinenInset,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isGold
                        ? AppColors.honeyGoldAccent.withValues(alpha: 0.4)
                        : AppColors.surfaceCardBorder,
                  ),
                ),
                child: Icon(
                  isGold ? Icons.monetization_on_rounded : Icons.shield_outlined,
                  color: isGold ? AppColors.honeyGoldAccent : AppColors.espressoCharcoal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isBulk ? 'Bulk $metalTitle Booking' : 'Order $grams gm $metalTitle',
                      style: AppTypography.cardTitle(color: AppColors.espressoCharcoal),
                    ),
                    Text(
                      purityText,
                      style: AppTypography.labelMeta(color: AppColors.warmTaupeBrown),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: AppSpacing.all12,
                  decoration: BoxDecoration(
                    color: AppColors.warmLinenInset,
                    borderRadius: AppRadius.border12,
                    border: Border.all(color: AppColors.surfaceCardBorder),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              'Weight Ordered:',
                              style: AppTypography.bodyRegular(color: AppColors.warmTaupeBrown),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$grams g ($purityText)',
                            style: AppTypography.bodyBold(color: AppColors.espressoCharcoal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              'Assay Packaging:',
                              style: AppTypography.bodyRegular(color: AppColors.warmTaupeBrown),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tamper-Proof Blister',
                            style: AppTypography.bodyBold(color: AppColors.statusSuccessText),
                          ),
                        ],
                      ),
                      const Divider(height: 16, color: AppColors.surfaceCardBorder),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              'Total Payable:',
                              style: AppTypography.bodyBold(color: AppColors.espressoCharcoal),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _currencyFormat.format(totalPrice),
                            style: AppTypography.displaySubtitle(color: AppColors.honeyGoldAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isGold
                      ? '• 100% BIS Hallmarked Pure Gold Coin\n'
                        '• Verified Assayer Signature & Unique Serial Code\n'
                        '• Zero Deduction Buyback Guarantee across Swastik stores'
                      : '• 100% Certified 99.9% Fine Silver Coin\n'
                        '• Precision Minted & Anti-Tarnish Blister Sealed\n'
                        '• Guaranteed Purity Certification Included',
                  style: AppTypography.caption(color: AppColors.warmTaupeBrown).copyWith(height: 1.4),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancel',
                style: AppTypography.bodyRegular(color: AppColors.warmTaupeBrown),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.espressoCharcoal,
                    content: Text(
                      'Booking placed for $grams gm $metalTitle (${_currencyFormat.format(totalPrice)}). Our VIP Concierge will contact you shortly.',
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Text('Confirm Booking', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isGold = _selectedMetal == CoinMetal.gold;
    final List<int> standardGrams = <int>[1, 2, 3, 4, 5];

    return Scaffold(
      backgroundColor: AppColors.homeCanvasBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: <Widget>[
            // 1. Metal Selection Tabs (Gold Coins vs Silver Coins)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: _buildMetalSelectorTabs(),
              ),
            ),

            // 2. Live Metal Benchmark Rate Header Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: _buildBenchmarkBanner(isGold),
              ),
            ),

            // 3. Karat / Purity Selector for Gold ONLY (Dynamically hidden for Silver)
            if (isGold)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                  child: _buildGoldKaratSelector(),
                ),
              ),

            // 4. Section Title for Standard Coin Rate Cards (1g - 5g)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        isGold ? 'Gold Coin Rates (1g - 5g)' : 'Silver Coin Rates (1g - 5g)',
                        style: AppTypography.cardTitle(
                          color: AppColors.espressoCharcoal,
                        ).copyWith(fontSize: 16),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.champagneFoil,
                        borderRadius: AppRadius.border12,
                        border: Border.all(
                          color: AppColors.honeyGoldAccent.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        '5 Rectangular Weights',
                        style: AppTypography.kickerCaps(
                          color: AppColors.espressoCharcoal,
                        ).copyWith(fontSize: 9.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 5. Rectangular Cards for 1g, 2g, 3g, 4g, 5g
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final int grams = standardGrams[index];
                    final double price = _calculatePrice(grams);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _CoinRectangularCard(
                        grams: grams,
                        isGold: isGold,
                        purityLabel: isGold ? _selectedGoldKarat.label : '999 Fine Silver',
                        price: price,
                        formattedPrice: _currencyFormat.format(price),
                        onBookTap: () => _handleBookCoin(grams),
                      ),
                    );
                  },
                  childCount: standardGrams.length,
                ),
              ),
            ),

            // 6. Custom Bulk Order Section (With Karat for Gold ONLY, hidden for Silver)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 64),
                child: _BulkCoinOrderSection(
                  isGold: isGold,
                  benchmarkRate: _currentRatePerGram,
                  selectedKarat: _selectedGoldKarat,
                  currencyFormat: _currencyFormat,
                  selectedGrams: _selectedBulkGrams,
                  isCustomInput: _isCustomInput,
                  customController: _customGramsController,
                  onKaratChanged: (GoldKarat karat) {
                    setState(() {
                      _selectedGoldKarat = karat;
                    });
                  },
                  onGramsSelected: (int grams) {
                    setState(() {
                      _selectedBulkGrams = grams;
                      _isCustomInput = false;
                    });
                  },
                  onCustomSubmit: (String val) {
                    final int? parsed = int.tryParse(val);
                    if (parsed != null && parsed > 5) {
                      setState(() {
                        _selectedBulkGrams = parsed;
                        _isCustomInput = true;
                      });
                    }
                  },
                  onBookBulk: () {
                    final int grams = _isCustomInput
                        ? (int.tryParse(_customGramsController.text) ?? _selectedBulkGrams)
                        : _selectedBulkGrams;
                    _handleBookCoin(grams);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Segmented tabs switching between Gold Coins and Silver Coins.
  Widget _buildMetalSelectorTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.warmLinenInset,
        borderRadius: AppRadius.border16,
        border: Border.all(color: AppColors.surfaceCardBorder),
      ),
      child: Row(
        children: CoinMetal.values.map((CoinMetal metal) {
          final bool isSelected = _selectedMetal == metal;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMetal = metal;
                  // Reset bulk grams if switching to silver
                  if (metal == CoinMetal.silver && _selectedBulkGrams < 10) {
                    _selectedBulkGrams = 20;
                  }
                });
              },
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.creamIvoryCard : Colors.transparent,
                  borderRadius: AppRadius.border12,
                  border: isSelected
                      ? Border.all(color: AppColors.honeyGoldAccent.withValues(alpha: 0.5), width: 1.2)
                      : null,
                  boxShadow: isSelected
                      ? const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x0E2B2521),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      metal.icon,
                      size: 18,
                      color: isSelected ? AppColors.honeyGoldAccent : AppColors.warmTaupeBrown,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      metal.displayName,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13.5,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? AppColors.espressoCharcoal : AppColors.warmTaupeBrown,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Live Bullion Benchmark Card (Gold or Silver).
  Widget _buildBenchmarkBanner(bool isGold) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamIvoryCard,
        borderRadius: AppRadius.border16,
        border: Border.all(color: AppColors.warmLinenInset),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x062B2521),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isGold ? AppColors.champagneFoil : AppColors.warmLinenInset,
              shape: BoxShape.circle,
              border: Border.all(
                color: isGold
                    ? AppColors.honeyGoldAccent.withValues(alpha: 0.4)
                    : AppColors.surfaceCardBorder,
              ),
            ),
            child: ClipOval(
              child: isGold
                  ? Image.asset(
                      'assets/images/banner_clean_coin.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.monetization_on_rounded,
                        color: AppColors.honeyGoldAccent,
                        size: 26,
                      ),
                    )
                  : const Icon(
                      Icons.shield_outlined,
                      color: AppColors.espressoCharcoal,
                      size: 26,
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.statusSuccessText,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isGold ? 'LIVE 24K GOLD BULLION BENCHMARK' : 'LIVE 999 SILVER BULLION BENCHMARK',
                      style: AppTypography.kickerCaps(
                        color: AppColors.warmTaupeBrown,
                      ).copyWith(fontSize: 10, letterSpacing: 0.8),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${_currencyFormat.format(_currentRatePerGram)} / Gram',
                  style: AppTypography.displaySubtitle(
                    color: AppColors.espressoCharcoal,
                  ).copyWith(fontWeight: FontWeight.w900, fontSize: 18),
                ),
                const SizedBox(height: 2),
                Text(
                  isGold
                      ? 'BIS Hallmarked • Assay Blister Sealed • 0% Buyback Loss'
                      : '99.9% Purity • Certified Assay Pack • Swastik Guarantee',
                  style: AppTypography.labelMeta(
                    color: AppColors.warmTaupeBrown,
                  ).copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Karat selector chip row (Gold only).
  Widget _buildGoldKaratSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warmLinenInset,
        borderRadius: AppRadius.border14,
        border: Border.all(color: AppColors.surfaceCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.verified_outlined, size: 15, color: AppColors.honeyGoldAccent),
              const SizedBox(width: 6),
              Text(
                'Select Gold Purity / Karat:',
                style: AppTypography.bodyBold(color: AppColors.espressoCharcoal).copyWith(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: GoldKarat.values.map((GoldKarat karat) {
              final bool isSelected = _selectedGoldKarat == karat;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedGoldKarat = karat;
                      });
                    },
                    borderRadius: AppRadius.border12,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.honeyGoldAccent : AppColors.creamIvoryCard,
                        borderRadius: AppRadius.border12,
                        border: Border.all(
                          color: isSelected ? AppColors.honeyGoldAccent : AppColors.surfaceCardBorder,
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        karat.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? AppColors.deepUmberBronze : AppColors.espressoCharcoal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Rectangular card displaying standard coin rates (1g to 5g).
class _CoinRectangularCard extends StatelessWidget {
  const _CoinRectangularCard({
    required this.grams,
    required this.isGold,
    required this.purityLabel,
    required this.price,
    required this.formattedPrice,
    required this.onBookTap,
  });

  final int grams;
  final bool isGold;
  final String purityLabel;
  final double price;
  final String formattedPrice;
  final VoidCallback onBookTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.creamIvoryCard,
        borderRadius: AppRadius.border16,
        border: Border.all(color: AppColors.warmLinenInset, width: 1),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x052B2521),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          // Left: Coin Weight Badge / Emblem
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: isGold
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Color(0xFFF7E6BD), Color(0xFFE4BC66)],
                    )
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
                    ),
              borderRadius: AppRadius.border12,
              border: Border.all(
                color: isGold ? AppColors.honeyGoldAccent : const Color(0xFF94A3B8),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$grams',
                  style: const TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.espressoCharcoal,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'GRAM',
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.espressoCharcoal,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // Center: Coin Info & Metal Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        isGold ? '$grams gm Gold Coin' : '$grams gm Silver Coin',
                        style: AppTypography.cardTitle(
                          color: AppColors.espressoCharcoal,
                        ).copyWith(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: isGold ? AppColors.champagneFoil : AppColors.warmLinenInset,
                        borderRadius: AppRadius.border8,
                        border: Border.all(
                          color: isGold ? AppColors.honeyGoldAccent.withValues(alpha: 0.3) : AppColors.surfaceCardBorder,
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        isGold ? 'Pure Gold' : '999 Silver',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.espressoCharcoal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  isGold
                      ? '$purityLabel • Blister Assay'
                      : '99.9% Purity • Assay Sealed Blister',
                  style: AppTypography.caption(
                    color: AppColors.warmTaupeBrown,
                  ).copyWith(fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedPrice,
                  style: AppTypography.bodyBold(
                    color: isGold ? AppColors.honeyGoldAccent : AppColors.espressoCharcoal,
                  ).copyWith(fontSize: 15, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),

          // Right: Action Button
          ElevatedButton(
            onPressed: onBookTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: isGold ? AppColors.honeyGoldAccent : AppColors.espressoCharcoal,
              foregroundColor: isGold ? AppColors.deepUmberBronze : Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
              minimumSize: const Size(68, 36),
            ),
            child: const Text(
              'Book',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Interactive Bulk Coin Order Section with Karat/Purity selection for Gold ONLY.
class _BulkCoinOrderSection extends StatelessWidget {
  const _BulkCoinOrderSection({
    required this.isGold,
    required this.benchmarkRate,
    required this.selectedKarat,
    required this.currencyFormat,
    required this.selectedGrams,
    required this.isCustomInput,
    required this.customController,
    required this.onKaratChanged,
    required this.onGramsSelected,
    required this.onCustomSubmit,
    required this.onBookBulk,
  });

  final bool isGold;
  final double benchmarkRate;
  final GoldKarat selectedKarat;
  final NumberFormat currencyFormat;
  final int selectedGrams;
  final bool isCustomInput;
  final TextEditingController customController;
  final ValueChanged<GoldKarat> onKaratChanged;
  final ValueChanged<int> onGramsSelected;
  final ValueChanged<String> onCustomSubmit;
  final VoidCallback onBookBulk;

  static const List<int> _goldWeights = <int>[10, 20, 50, 100, 250, 500];
  static const List<int> _silverWeights = <int>[10, 20, 50, 100, 250, 500, 1000];

  @override
  Widget build(BuildContext context) {
    final double calculatedPrice = selectedGrams * benchmarkRate;
    final List<int> weights = isGold ? _goldWeights : _silverWeights;

    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.creamIvoryCard,
        borderRadius: AppRadius.border20,
        border: Border.all(
          color: isGold
              ? AppColors.honeyGoldAccent.withValues(alpha: 0.4)
              : AppColors.surfaceCardBorder,
          width: 1.5,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0C2B2521),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isGold ? AppColors.champagneFoil : AppColors.warmLinenInset,
                  borderRadius: AppRadius.border12,
                  border: Border.all(
                    color: isGold
                        ? AppColors.honeyGoldAccent.withValues(alpha: 0.4)
                        : AppColors.surfaceCardBorder,
                  ),
                ),
                child: Icon(
                  Icons.stars_rounded,
                  color: isGold ? AppColors.honeyGoldAccent : AppColors.espressoCharcoal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isGold ? 'Order More Than 5 Grams Gold' : 'Order Bulk Silver Coins (> 5g)',
                      style: AppTypography.cardTitle(
                        color: AppColors.espressoCharcoal,
                      ).copyWith(fontSize: 16),
                    ),
                    Text(
                      isGold
                          ? 'Custom Bullion & Institutional Gold Orders'
                          : 'Pooja, Gifting & Investment Silver Coins',
                      style: AppTypography.caption(
                        color: AppColors.warmTaupeBrown,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Karat Selection ONLY FOR GOLD (Dynamically hidden for Silver)
          if (isGold) ...<Widget>[
            const SizedBox(height: 14),
            Text(
              'Select Karat / Purity:',
              style: AppTypography.bodyBold(color: AppColors.espressoCharcoal).copyWith(fontSize: 13),
            ),
            const SizedBox(height: 6),
            Row(
              children: GoldKarat.values.map((GoldKarat karat) {
                final bool isSelected = selectedKarat == karat;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => onKaratChanged(karat),
                      borderRadius: AppRadius.border12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.honeyGoldAccent : AppColors.warmLinenInset,
                          borderRadius: AppRadius.border12,
                          border: Border.all(
                            color: isSelected ? AppColors.honeyGoldAccent : AppColors.surfaceCardBorder,
                          ),
                        ),
                        child: Text(
                          karat.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? AppColors.deepUmberBronze : AppColors.espressoCharcoal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 14),

          Text(
            'Select Custom Weight:',
            style: AppTypography.bodyBold(color: AppColors.espressoCharcoal).copyWith(fontSize: 13),
          ),
          const SizedBox(height: 8),

          // Quick weight selector pills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: weights.map((int weight) {
              final bool isSelected = !isCustomInput && selectedGrams == weight;
              return InkWell(
                onTap: () => onGramsSelected(weight),
                borderRadius: AppRadius.border12,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.honeyGoldAccent : AppColors.warmLinenInset,
                    borderRadius: AppRadius.border12,
                    border: Border.all(
                      color: isSelected ? AppColors.honeyGoldAccent : AppColors.surfaceCardBorder,
                    ),
                  ),
                  child: Text(
                    '$weight gm',
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? AppColors.deepUmberBronze : AppColors.espressoCharcoal,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // Custom grams entry
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: customController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter grams (e.g. 75, 150)',
                    hintStyle: AppTypography.caption(color: AppColors.warmTaupeBrown),
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.warmLinenInset,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: const OutlineInputBorder(
                      borderRadius: AppRadius.border12,
                      borderSide: BorderSide(color: AppColors.surfaceCardBorder),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: AppRadius.border12,
                      borderSide: BorderSide(color: AppColors.surfaceCardBorder),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: AppRadius.border12,
                      borderSide: BorderSide(color: AppColors.honeyGoldAccent, width: 1.5),
                    ),
                  ),
                  onSubmitted: onCustomSubmit,
                  onChanged: (String val) {
                    final int? parsed = int.tryParse(val);
                    if (parsed != null && parsed > 0) {
                      onCustomSubmit(val);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Calculation Summary Box
          Container(
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: AppColors.warmLinenInset,
              borderRadius: AppRadius.border12,
              border: Border.all(color: AppColors.surfaceCardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'ESTIMATED BULK VALUE',
                      style: AppTypography.kickerCaps(color: AppColors.warmTaupeBrown).copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currencyFormat.format(calculatedPrice),
                      style: AppTypography.displaySubtitle(
                        color: AppColors.espressoCharcoal,
                      ).copyWith(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.statusSuccessBg,
                    borderRadius: AppRadius.border8,
                    border: Border.all(color: AppColors.statusSuccessBorder),
                  ),
                  child: const Text(
                    '0% Minting Fee',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.statusSuccessText,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Book Action
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: onBookBulk,
              icon: const Icon(Icons.shopping_bag_outlined, size: 20),
              label: Text(
                'Book $selectedGrams gm ${isGold ? "Gold" : "Silver"} Coin Order',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepUmberBronze,
                foregroundColor: AppColors.goldLight,
                elevation: 0,
                shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
