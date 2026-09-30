import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../home/presentation/providers/home_controller.dart';
import '../../../home/presentation/widgets/home_section_heading.dart';
import '../../../offers/data/repositories/mock_scheme_repository.dart';
import '../../../offers/domain/entities/scheme_entity.dart';
import '../../../offers/presentation/widgets/start_kitty_flow_sheet.dart';

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
  k24('24K (999)', '99.9% Pure Investment Gold', 24.0 / 24.0),
  k22('22K (916)', '91.6% Pure Jewellery Gold', 22.0 / 24.0),
  k18('18K (750)', '75.0% Fine Diamond Setting Gold', 18.0 / 24.0);

  const CalculatorKarat(this.label, this.purityTitle, this.purityFraction);
  final String label;
  final String purityTitle;
  final double purityFraction;

  double dynamicRate(double base24k) => base24k * purityFraction;
}

/// Dedicated Gold Valuation Calculator Modal / Screen matching the Warm Luxury aesthetic.
///
/// Features:
/// - Openable as popup/modal overlay over Coins page.
/// - Top close icon (×) and clearly visible bottom Close button.
/// - Pure user input and calculation focus with zero live rate labels/badges.
/// - Prominent center-aligned decorative heading: "Enter Weight in Grams".
/// - Side-by-side 2x2 Quick Presets (Quick Weight & Quick Budget) matching Coins selector styling.
class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({
    this.initialRate24k = 15268.00,
    this.isModal = false,
    this.onClose,
    super.key,
  });

  final double initialRate24k;
  final bool isModal;
  final VoidCallback? onClose;

  /// Helper to launch the calculator as a modal popup overlay.
  static Future<void> showAsModal(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (BuildContext ctx) => FractionallySizedBox(
        heightFactor: 0.90,
        child: CalculatorScreen(
          isModal: true,
          onClose: () => Navigator.of(ctx).pop(),
        ),
      ),
    );
  }

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
    final homeData = ref.watch(homeControllerProvider).data;
    final double base24k = homeData?.goldRate?.ratePerGram ?? widget.initialRate24k;
    return _selectedKarat.dynamicRate(base24k);
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
        _errorMessage = 'Please enter a valid numeric amount in rupees.';
      });
      return;
    }

    if (money <= 0) {
      setState(() {
        _errorMessage = 'Budget must be greater than ₹0.';
      });
      return;
    }

    if (money > 100000000) {
      setState(() {
        _errorMessage = 'Maximum supported budget is ₹10 Crore.';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });
  }

  void _selectQuickGram(double grams) {
    HapticFeedback.selectionClick();
    setState(() {
      _activeMode = CalculatorInputMode.byGram;
      _gramController.text = grams % 1 == 0 ? grams.toInt().toString() : grams.toString();
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
    final Widget content = Container(
      decoration: BoxDecoration(
        color: AppColors.homeCanvasBg,
        borderRadius: widget.isModal
            ? const BorderRadius.vertical(top: Radius.circular(24))
            : BorderRadius.zero,
      ),
      child: Column(
        children: <Widget>[
          // Drag handle if modal
          if (widget.isModal) ...<Widget>[
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 40,
                height: 4.5,
                decoration: BoxDecoration(
                  color: AppColors.warmTaupeBrown.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          ],

          // Modal / Top Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Gold Calculator',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.espressoCharcoal,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 24, color: AppColors.espressoCharcoal),
                  tooltip: 'Close',
                  onPressed: () {
                    if (widget.onClose != null) {
                      widget.onClose!();
                    } else {
                      Navigator.of(context).maybePop();
                    }
                  },
                ),
              ],
            ),
          ),

          Container(
            height: 1,
            color: AppColors.surfaceCardBorder,
          ),

          // Scrollable Body
          Expanded(
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: <Widget>[
                // 1. Karat Selector Pills
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                    child: _buildKaratSelector(),
                  ),
                ),

                // 2. Mode Switcher (Shop by Gram vs Shop by Money)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: _buildModeSwitcher(),
                  ),
                ),

                // 3. Primary Input Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: _buildInputSection(),
                  ),
                ),

                // 4. Side-by-side Quick Presets (matching Coins selector structure)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: _buildQuickPickers(),
                  ),
                ),

                // 5. Dynamic Calculation Results Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: _buildResultView(),
                  ),
                ),

                // 6. Bottom Close Button
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    child: SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.onClose != null) {
                            widget.onClose!();
                          } else {
                            Navigator.of(context).maybePop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.espressoCharcoal,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.isModal) {
      return content;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.homeCanvasBg,
        body: SafeArea(
          bottom: false,
          child: content,
        ),
      ),
    );
  }

  /// Karat selector chips without live rate text, with reset option.
  Widget _buildKaratSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (_gramController.text.isNotEmpty || _moneyController.text.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6, right: 4),
              child: GestureDetector(
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
            ),
          ),
        Container(
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
                        color: isSelected ? AppColors.primaryEmerald : AppColors.pureWhite,
                        borderRadius: AppRadius.border12,
                        border: Border.all(
                          color: isSelected ? AppColors.primaryEmerald : AppColors.surfaceCardBorder,
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        karat.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.deepForestCharcoal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
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
                            color: Color(0x0D063D2E),
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

  /// Primary active input field with centered luxury HomeSectionHeading.
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
            color: Color(0x0D063D2E),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          HomeSectionHeading(
            title: isGramMode ? 'Enter Weight in Grams' : 'Enter Budget in Rupees',
            padding: const EdgeInsets.only(bottom: 12),
          ),

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

  /// Calculation Breakdown & Output Results View (Zero live rate cards/labels).
  Widget _buildResultView() {
    final bool isGramMode = _activeMode == CalculatorInputMode.byGram;
    final String text = isGramMode ? _gramController.text.trim() : _moneyController.text.trim();

    // 1. Empty State
    if (text.isEmpty || _errorMessage != null) {
      return const SizedBox.shrink();
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
            color: Color(0x0D063D2E),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'VALUATION SUMMARY',
            style: AppTypography.kickerCaps(color: AppColors.warmTaupeBrown).copyWith(fontSize: 11),
          ),
          const SizedBox(height: 12),

          // Output Pillars: Weight, Karat, Total Amount (No Live Rate info)
          Container(
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: AppColors.warmLinenInset,
              borderRadius: AppRadius.border12,
              border: Border.all(color: AppColors.surfaceCardBorder),
            ),
            child: Column(
              children: <Widget>[
                // Pillar 1: Weight
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

                // Pillar 2: Selected Karat
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

          // Gold Scheme Privilege Benefit Note
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
                    'Enrolled in Gold Scheme? Redeem your savings with 0% Making Charge on jewellery at maturity.',
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
          const SizedBox(height: 14),

          // Conversion Flow CTA: [START KITTY WITH THIS BUDGET]
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              key: const Key('btn_calculator_start_kitty'),
              onPressed: () {
                final int calculatedBudget = calculatedAmount.round();
                _handleStartKittyWithBudget(
                  context,
                  budget: calculatedBudget,
                  grams: enteredGrams,
                  karat: _selectedKarat,
                );
              },
              icon: const Icon(Icons.bolt_rounded, color: Colors.black, size: 20),
              label: Text(
                'Start Kitty with this Budget (${_currencyFormat.format(calculatedAmount.round())})',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: 0.3,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.honeyGoldAccent,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.border12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStartKittyWithBudget(
    BuildContext context, {
    required int budget,
    required double grams,
    required CalculatorKarat karat,
  }) {
    HapticFeedback.mediumImpact();
    final SchemeEntity defaultScheme = MockSchemeRepository.prototypeSchemes.first;

    StartKittyFlowSheet.show(
      context,
      scheme: defaultScheme,
      customMonthlyAmount: budget,
      sourceGrams: grams,
      sourceKarat: karat.label,
    );
  }

  /// Side-by-side Quick Presets matching the Coins page 2x2 selector structure.
  Widget _buildQuickPickers() {
    final double? currentGrams = _activeMode == CalculatorInputMode.byGram
        ? double.tryParse(_gramController.text.trim())
        : null;
    final int? currentAmount = _activeMode == CalculatorInputMode.byMoney
        ? int.tryParse(_moneyController.text.trim())
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Left Side — Quick Weight Preset (5g 6g / 7g 8g)
        Expanded(
          child: _buildSelectorBox(
            title: 'Quick Weight Preset',
            rows: <List<Widget>>[
              <Widget>[
                _buildSelectorOption(
                  label: '5g',
                  isSelected: currentGrams == 5.0,
                  onTap: () => _selectQuickGram(5.0),
                ),
                _buildSelectorOption(
                  label: '6g',
                  isSelected: currentGrams == 6.0,
                  onTap: () => _selectQuickGram(6.0),
                ),
              ],
              <Widget>[
                _buildSelectorOption(
                  label: '7g',
                  isSelected: currentGrams == 7.0,
                  onTap: () => _selectQuickGram(7.0),
                ),
                _buildSelectorOption(
                  label: '8g',
                  isSelected: currentGrams == 8.0,
                  onTap: () => _selectQuickGram(8.0),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Right Side — Quick Budget Preset (40K 50K / 60K 70K)
        Expanded(
          child: _buildSelectorBox(
            title: 'Quick Budget Preset',
            rows: <List<Widget>>[
              <Widget>[
                _buildSelectorOption(
                  label: '40K',
                  isSelected: currentAmount == 40000,
                  onTap: () => _selectQuickAmount(40000),
                ),
                _buildSelectorOption(
                  label: '50K',
                  isSelected: currentAmount == 50000,
                  onTap: () => _selectQuickAmount(50000),
                ),
              ],
              <Widget>[
                _buildSelectorOption(
                  label: '60K',
                  isSelected: currentAmount == 60000,
                  onTap: () => _selectQuickAmount(60000),
                ),
                _buildSelectorOption(
                  label: '70K',
                  isSelected: currentAmount == 70000,
                  onTap: () => _selectQuickAmount(70000),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectorBox({
    required String title,
    required List<List<Widget>> rows,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: AppRadius.border12,
        border: Border.all(color: AppColors.surfaceCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.espressoCharcoal,
            ),
          ),
          const SizedBox(height: 10),
          ...rows.asMap().entries.map((MapEntry<int, List<Widget>> entry) {
            final int rowIndex = entry.key;
            final List<Widget> rowItems = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: rowIndex < rows.length - 1 ? 8.0 : 0.0),
              child: Row(
                children: rowItems.map((Widget item) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: item,
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSelectorOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryEmerald : AppColors.alabasterSilk,
          borderRadius: AppRadius.border8,
          border: Border.all(
            color: isSelected ? AppColors.primaryEmerald : AppColors.warmLinenInset,
            width: 1,
          ),
          boxShadow: isSelected
              ? const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x18063D2E),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.espressoCharcoal,
          ),
        ),
      ),
    );
  }
}
