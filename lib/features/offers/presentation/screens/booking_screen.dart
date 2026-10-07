import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_paths.dart';

/// Recreated 100% identically from dddd/book.html
/// Features:
/// - Light parchment background #FAF8F3
/// - Top header with back button & "Select Your Numbers"
/// - Draw #25 badge & ₹1,000 per number card
/// - 3-state legend (Available #E5DDCF, Already Booked #BFBAB0, Your Selection #09362C)
/// - 30-Numbers Grid (5 cols x 6 rows)
/// - Selected chips with "Clear All" action
/// - FREE Booking Promotion Card with "Book for FREE" CTA
/// - Reserve for Future Draws Card with "Reserve for Future Draws" CTA
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Pre-configured according to dddd/book.html
  static const Set<String> _bookedNumbers = <String>{
    '03', '09', '13', '16', '17', '22', '25'
  };

  late final Set<String> _selectedNumbers;

  @override
  void initState() {
    super.initState();
    _selectedNumbers = <String>{'07', '14', '18'};
  }

  void _toggleNumber(String numStr) {
    if (_bookedNumbers.contains(numStr)) return;
    setState(() {
      if (_selectedNumbers.contains(numStr)) {
        _selectedNumbers.remove(numStr);
      } else {
        _selectedNumbers.add(numStr);
      }
    });
  }

  void _clearAll() {
    setState(() {
      _selectedNumbers.clear();
    });
  }

  void _handleBookFree() {
    if (_selectedNumbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one number'),
          backgroundColor: Color(0xFF09362C),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    // Navigate directly to Review Your Plan (dddd/review.html)
    context.push(RoutePaths.review);
  }

  void _handleReserveFuture() {
    // Navigate directly to Review Your Plan (dddd/review.html)
    context.push(RoutePaths.review);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> sortedSelected = _selectedNumbers.toList()..sort();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F3),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Navigation Header
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 16, top: 8, bottom: 4),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(RoutePaths.offers);
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF1C1917),
                      size: 24,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Select Your Numbers',
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C1917),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balancing spacer
                ],
              ),
            ),

            // Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 6),

                    // Draw Info & Price Pill Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEFE5D8)),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBE9CE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Draw #25',
                              style: TextStyle(
                                fontFamily: 'Playfair',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1C1917),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 22,
                            color: const Color(0xFFE7E5E4),
                          ),
                          RichText(
                            text: const TextSpan(
                              text: '₹1,000 ',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1C1917),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'per number',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.5,
                                    color: Color(0xFF57534E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Legend Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _buildLegendItem(const Color(0xFFE5DDCF), 'Available'),
                        _buildLegendItem(const Color(0xFFBFBAB0), 'Already Booked'),
                        _buildLegendItem(const Color(0xFF09362C), 'Your Selection'),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // 30-Numbers Grid (5 columns x 6 rows)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 9,
                        mainAxisSpacing: 9,
                        childAspectRatio: 1.35,
                      ),
                      itemCount: 30,
                      itemBuilder: (BuildContext context, int index) {
                        final String numStr = (index + 1).toString().padLeft(2, '0');
                        final bool isBooked = _bookedNumbers.contains(numStr);
                        final bool isSelected = _selectedNumbers.contains(numStr);

                        Color bgColor;
                        Color textColor;
                        Border? border;

                        if (isBooked) {
                          bgColor = const Color(0xFFBFBAB0);
                          textColor = Colors.white;
                        } else if (isSelected) {
                          bgColor = const Color(0xFF09362C);
                          textColor = Colors.white;
                        } else {
                          bgColor = const Color(0xFFFAF4EB);
                          textColor = const Color(0xFF1C1917);
                          border = Border.all(color: const Color(0xFFEBDCCB));
                        }

                        return GestureDetector(
                          onTap: isBooked ? null : () => _toggleNumber(numStr),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: border,
                              boxShadow: isSelected
                                  ? const <BoxShadow>[
                                      BoxShadow(
                                        color: Color(0x3309362C),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              numStr,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 15,
                                fontWeight: isSelected || isBooked
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Selected Numbers Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Selected Numbers (${_selectedNumbers.length})',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1917),
                          ),
                        ),
                        GestureDetector(
                          onTap: _clearAll,
                          child: const Row(
                            children: <Widget>[
                              Icon(
                                Icons.delete_outline_rounded,
                                size: 16,
                                color: Color(0xFFE03B24),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Clear All',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFE03B24),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Selected Chips Row
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: sortedSelected.isEmpty
                          ? <Widget>[
                              const Text(
                                'Tap available numbers above to select',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFFA8A29E),
                                ),
                              ),
                            ]
                          : sortedSelected.map((numStr) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAF5EF),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFBFDFD0)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      numStr,
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF09362C),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () => _toggleNumber(numStr),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 14,
                                        color: Color(0xFF78716C),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                    ),

                    const SizedBox(height: 18),

                    // FREE Booking Promotion Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECF7F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFCDEBDD)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFBCE4D1)),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.card_giftcard_rounded,
                                    color: Color(0xFF09362C),
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Book these numbers for this draw',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1C1917),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'FREE',
                                      style: TextStyle(
                                        fontFamily: 'Playfair',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF09362C),
                                        height: 1.1,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'No payment needed',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 11.5,
                                        color: Color(0xFF78716C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _selectedNumbers.isEmpty ? null : _handleBookFree,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF09362C),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                disabledBackgroundColor: const Color(0xFF09362C).withValues(alpha: 0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Book for FREE',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Reserve for Future Draws Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEFE7D8)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFCF6EC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFF3E3CA)),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.calendar_month_outlined,
                                    color: Color(0xFF9C682A),
                                    size: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Want to keep these numbers for future draws?',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1C1917),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Pay an advance amount to reserve them.',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 11.5,
                                        color: Color(0xFF78716C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFFA8A29E),
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: OutlinedButton(
                              onPressed: _handleReserveFuture,
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFFFAF3E7),
                                foregroundColor: const Color(0xFF8A5722),
                                side: const BorderSide(color: Color(0xFFE9D9C3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              child: const Text(
                                'Reserve for Future Draws',
                                style: TextStyle(
                                  fontFamily: 'Playfair',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: <Widget>[
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF44403C),
          ),
        ),
      ],
    );
  }
}
