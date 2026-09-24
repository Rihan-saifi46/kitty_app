import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../home/presentation/providers/home_controller.dart';

/// Available input modes for the gold valuation calculator.
enum CalculatorInputMode {
  byGram('Shop by Gram', Icons.scale_rounded),
  byMoney('Shop by Money', Icons.currency_rupee_rounded);

  const CalculatorInputMode(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Supported karat / purity tiers for calculation.
enum CalculatorKarat {
  k24('24K (999)', 7485.50, '99.9% Pure Investment Gold'),
  k22('22K (916)', 6861.70, '91.6% Pure Jewellery Gold'),
  k18('18K (750)', 5614.10, '75.0% Fine Diamond Setting Gold');

  const CalculatorKarat(this.label, this.ratePerGram, this.purityTitle);
  final String label;
  final double ratePerGram;
  final String purityTitle;
}

/// Dedicated Gold Valuation Calculator Screen matching the Warm Luxury aesthetic.
///
/// Features dynamic 2-mode valuation ("Shop by Gram" & "Shop by Money"),
/// live karat selector (24K, 22K, 18K), real-time reactive calculations,
/// zero/invalid/decimal/large number handling, and quick-picker chips.
class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({
    this.initialRate24k = 7485.50,
    super.key,
  });

  final double initialRate24k;

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  final NumberFormat _decimalFormat = NumberFormat('#,##0.000', 'en_IN');

  // Input Controllers
  final TextEditingController _gramController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();

  CalculatorInputMode _activeMode = CalculatorInputMode.byGram;
  CalculatorKarat _selectedKarat = CalculatorKarat.k24;

  String? _errorMessage;

  // Quick weight & money chips
  static const List<double> _quickGrams = <double>[1, 2, 5, 8, 10, 20, 50, 100];
  static const List<int> _quickAmounts = <int>[5000, 10000, 25000, 50000, 100000, 250000];

  @override
  void initState() {
    super.initState();
    _gramController.addListener(_onGramChanged);
    _moneyController.addListener(_onMoneyChanged);
  }

  @override
  void dispose() {
    _gramController.removeListener(_onGramChanged);
    _moneyController.removeListener(_onMoneyChanged);
    _gramController.dispose();
    _moneyController.dispose();
    super.dispose();
  }

  double get _currentRate {
    final homeData = ref.read(homeControllerProvider).data;
    final double base24k = homeData?.goldRate?.ratePerGram ?? widget.initialRate24k;
    switch (_selectedKarat) {
      case CalculatorKarat.k24:
        return base24k;
      case CalculatorKarat.k22:
        return (base24k * (22.0 / 24.0));
      case CalculatorKarat.k18:
        return (base24k * (18.0 / 24.0));
    }
  }

  void _onGramChanged() {
    if (_activeMode != CalculatorInputMode.byGram) return;
    final String text = _gramController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorMessage = null;
      });
      return;
    }

    final double? grams = double.tryParse(text);
    if (grams == null) {
      setState(() {
        _errorMessage = 'Please enter a valid numeric weight in grams.';
      });
      return;
    }

    if (grams <= 0) {
      setState(() {
        _errorMessage = 'Weight must be greater than 0 grams.';
      });
      return;
    }

    if (grams > 10000) {
      setState(() {
        _errorMessage = 'Maximum supported valuation is 10,000 grams.';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });
  }

  void _onMoneyChanged() {
    if (_activeMode != CalculatorInputMode.byMoney) return;
    final String text = _moneyController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorMessage = null;
      });
      return;
    }

    final double? money = double.tryParse(text);
    if (money == null) {
      setState(() {
        _errorMessage = 'Please enter a valid numeric amount in Rupees.';
      });
      return;
    }

    if (money <= 0) {
      setState(() {
        _errorMessage = 'Amount must be greater than ₹0.';
      });
      return;
    }

    if (money > 100000000) {
      setState(() {
        _errorMessage = 'Maximum supported valuation is ₹10 Crores.';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });
  }

  void _selectQuickGram(double g) {
    HapticFeedback.selectionClick();
    setState(() {
      _activeMode = CalculatorInputMode.byGram;
      _gramController.text = g % 1 == 0 ? g.toInt().toString() : g.toString();
      _errorMessage = null;
    });
  }

  void _selectQuickAmount(int amount) {
    HapticFeedback.selectionClick();
    setState(() {
      _activeMode = CalculatorInputMode.byMoney;
      _moneyController.text = amount.toString();
      _errorMessage = null;
    });
  }

  void _resetCalculator() {
    HapticFeedback.lightImpact();
    setState(() {
      _gramController.clear();
      _moneyController.clear();
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.homeCanvasBg,
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: <Widget>[
              // 1. Header Card with Live Benchmark Rates
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: _buildHeaderCard(),
                ),
              ),

              // 2. Karat Selector Pills
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: _buildKaratSelector(),
                ),
              ),

              // 3. Mode Switcher (Shop by Gram vs Shop by Money)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildModeSwitcher(),
                ),
              ),

              // 4. Primary Input Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: _buildInputSection(),
                ),
              ),

              // 5. Dynamic Calculation Results Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: _buildResultView(),
                ),
              ),

              // 6. Quick Pickers
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 64),
                  child: _buildQuickPickers(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Top header banner with title and live bullion benchmark.
  Widget _buildHeaderCard() {
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.champagneFoil,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.honeyGoldAccent.withValues(alpha: 0.4),
              ),
            ),
            child: const Icon(
              Icons.calculate_rounded,
              color: AppColors.honeyGoldAccent,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'GOLD VALUE CALCULATOR',
                      style: AppTypography.kickerCaps(
                        color: AppColors.warmTaupeBrown,
                      ).copyWith(fontSize: 10, letterSpacing: 0.8),
                    ),
                    if (_gramController.text.isNotEmpty || _moneyController.text.isNotEmpty)
                      GestureDetector(
                        onTap: _resetCalculator,
                        child: const Text(
                          'RESET',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.honeyGoldAccent,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${_currencyFormat.format(_currentRate)} / Gram',
                  style: AppTypography.displaySubtitle(
                    color: AppColors.espressoCharcoal,
                  ).copyWith(fontWeight: FontWeight.w900, fontSize: 18),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_selectedKarat.label} • ${_selectedKarat.purityTitle}',
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

  /// Karat selector chips.
  Widget _buildKaratSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warmLinenInset,
        borderRadius: AppRadius.border14,
        border: Border.all(color: AppColors.surfaceCardBorder),
      ),
      child: Row(
        children: CalculatorKarat.values.map((CalculatorKarat karat) {
          final bool isSelected = _selectedKarat == karat;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedKarat = karat;
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
    );
  }

  /// Segmented switch between "Shop by Gram" and "Shop by Money".
  Widget _buildModeSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.warmLinenInset,
        borderRadius: AppRadius.border16,
        border: Border.all(color: AppColors.surfaceCardBorder),
      ),
      child: Row(
        children: CalculatorInputMode.values.map((CalculatorInputMode mode) {
          final bool isSelected = _activeMode == mode;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _activeMode = mode;
                  _errorMessage = null;
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
                      mode.icon,
                      size: 17,
                      color: isSelected ? AppColors.honeyGoldAccent : AppColors.warmTaupeBrown,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      mode.label,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? AppColors.espressoCharcoal : AppColors.warmTaupeBrown,
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

  /// Primary active input field.
  Widget _buildInputSection() {
    final bool isGramMode = _activeMode == CalculatorInputMode.byGram;

    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.creamIvoryCard,
        borderRadius: AppRadius.border20,
        border: Border.all(
          color: _errorMessage != null
              ? AppColors.statusErrorText
              : AppColors.honeyGoldAccent.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A2B2521),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                isGramMode ? 'ENTER WEIGHT IN GRAMS' : 'ENTER BUDGET / MONEY IN RUPEES',
                style: AppTypography.kickerCaps(color: AppColors.warmTaupeBrown).copyWith(fontSize: 10.5),
              ),
              Text(
                isGramMode ? 'Precision: 3 Decimals' : 'Currency: INR (₹)',
                style: AppTypography.labelMeta(color: AppColors.warmTaupeBrown).copyWith(fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Main Numerical TextField
          TextField(
            controller: isGramMode ? _gramController : _moneyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.espressoCharcoal,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.warmLinenInset,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: Text(
                  isGramMode ? '⚖' : '₹',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.honeyGoldAccent,
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 0),
              suffixText: isGramMode ? 'Grams' : 'Rupees',
              suffixStyle: AppTypography.bodyBold(color: AppColors.warmTaupeBrown),
              hintText: isGramMode ? 'e.g. 5.5 or 10' : 'e.g. 25000 or 50000',
              hintStyle: AppTypography.bodyRegular(color: AppColors.warmTaupeBrown.withValues(alpha: 0.6)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: AppRadius.border12,
                borderSide: BorderSide(
                  color: _errorMessage != null ? AppColors.statusErrorText : AppColors.surfaceCardBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.border12,
                borderSide: BorderSide(
                  color: _errorMessage != null ? AppColors.statusErrorText : AppColors.surfaceCardBorder,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: AppRadius.border12,
                borderSide: BorderSide(
                  color: AppColors.honeyGoldAccent,
                  width: 1.8,
                ),
              ),
            ),
          ),

          if (_errorMessage != null) ...<Widget>[
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                const Icon(Icons.error_outline_rounded, size: 14, color: AppColors.statusErrorText),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.statusErrorText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Calculation Breakdown & Output Results View.
  Widget _buildResultView() {
    final bool isGramMode = _activeMode == CalculatorInputMode.byGram;
    final String text = isGramMode ? _gramController.text.trim() : _moneyController.text.trim();

    // 1. Empty State
    if (text.isEmpty || _errorMessage != null) {
      return Container(
        padding: AppSpacing.all16,
        decoration: BoxDecoration(
          color: AppColors.creamIvoryCard,
          borderRadius: AppRadius.border16,
          border: Border.all(color: AppColors.warmLinenInset),
        ),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.analytics_outlined,
              size: 32,
              color: AppColors.honeyGoldAccent.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 8),
            Text(
              isGramMode
                  ? 'Enter a weight in grams above or tap quick chips'
                  : 'Enter a budget in rupees above or tap quick chips',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall(color: AppColors.warmTaupeBrown),
            ),
            const SizedBox(height: 4),
            Text(
              'Live Gold Rate: ${_currencyFormat.format(_currentRate)} / g (${_selectedKarat.label})',
              style: AppTypography.caption(color: AppColors.espressoCharcoal).copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
    }

    // Calculations
    double enteredGrams = 0.0;
    double calculatedAmount = 0.0;

    if (isGramMode) {
      final double? parsedGrams = double.tryParse(text);
      if (parsedGrams != null && parsedGrams > 0) {
        enteredGrams = parsedGrams;
        calculatedAmount = enteredGrams * _currentRate;
      }
    } else {
      final double? parsedMoney = double.tryParse(text);
      if (parsedMoney != null && parsedMoney > 0) {
        calculatedAmount = parsedMoney;
        enteredGrams = calculatedAmount / _currentRate;
      }
    }

    // 2. Active Result State
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.creamIvoryCard,
        borderRadius: AppRadius.border20,
        border: Border.all(
          color: AppColors.honeyGoldAccent.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0C2B2521),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'VALUATION SUMMARY',
                style: AppTypography.kickerCaps(color: AppColors.warmTaupeBrown).copyWith(fontSize: 11),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.statusSuccessBg,
                  borderRadius: AppRadius.border8,
                  border: Border.all(color: AppColors.statusSuccessBorder),
                ),
                child: const Text(
                  'Verified Live Rate',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.statusSuccessText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3 Output Pillars: Gold Rate, Weight, Total Amount
          Container(
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: AppColors.warmLinenInset,
              borderRadius: AppRadius.border12,
              border: Border.all(color: AppColors.surfaceCardBorder),
            ),
            child: Column(
              children: <Widget>[
                // Pillar 1: Applicable Gold Rate
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Applicable Gold Rate:',
                      style: AppTypography.bodyRegular(color: AppColors.warmTaupeBrown),
                    ),
                    Text(
                      '${_currencyFormat.format(_currentRate)} / g',
                      style: AppTypography.bodyBold(color: AppColors.espressoCharcoal),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Pillar 2: Weight
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Calculated Weight:',
                      style: AppTypography.bodyRegular(color: AppColors.warmTaupeBrown),
                    ),
                    Text(
                      '${_decimalFormat.format(enteredGrams)} g',
                      style: AppTypography.bodyBold(color: AppColors.espressoCharcoal),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Pillar 3: Selected Karat
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Purity Standard:',
                      style: AppTypography.bodyRegular(color: AppColors.warmTaupeBrown),
                    ),
                    Text(
                      _selectedKarat.label,
                      style: AppTypography.bodyBold(color: AppColors.honeyGoldAccent),
                    ),
                  ],
                ),

                const Divider(height: 18, color: AppColors.surfaceCardBorder),

                // Grand Total Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total Gold Value:',
                      style: AppTypography.bodyBold(color: AppColors.espressoCharcoal).copyWith(fontSize: 14),
                    ),
                    Text(
                      _currencyFormat.format(calculatedAmount.round()),
                      style: AppTypography.displaySubtitle(color: AppColors.honeyGoldAccent).copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Kitty Privilege Benefit Note
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.champagneFoil.withValues(alpha: 0.6),
              borderRadius: AppRadius.border8,
            ),
            child: const Row(
              children: <Widget>[
                Icon(Icons.workspace_premium_rounded, size: 16, color: AppColors.deepUmberBronze),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Enrolled in Kitty Scheme? Redeem your savings with 0% Making Charge on jewellery at maturity.',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepUmberBronze,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Quick picker chips for fast valuation.
  Widget _buildQuickPickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Quick Weight Presets:',
          style: AppTypography.bodyBold(color: AppColors.espressoCharcoal).copyWith(fontSize: 13),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickGrams.map((double g) {
            final String label = g % 1 == 0 ? '${g.toInt()}g' : '${g}g';
            return InkWell(
              onTap: () => _selectQuickGram(g),
              borderRadius: AppRadius.border12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.warmLinenInset,
                  borderRadius: AppRadius.border12,
                  border: Border.all(color: AppColors.surfaceCardBorder),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.espressoCharcoal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        Text(
          'Quick Budget Presets:',
          style: AppTypography.bodyBold(color: AppColors.espressoCharcoal).copyWith(fontSize: 13),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickAmounts.map((int amount) {
            return InkWell(
              onTap: () => _selectQuickAmount(amount),
              borderRadius: AppRadius.border12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.warmLinenInset,
                  borderRadius: AppRadius.border12,
                  border: Border.all(color: AppColors.surfaceCardBorder),
                ),
                child: Text(
                  _currencyFormat.format(amount),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.espressoCharcoal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
