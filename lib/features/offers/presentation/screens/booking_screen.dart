import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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

  String? _selectedNumber;

  @override
  void initState() {
    super.initState();
    _selectedNumber = '07';
  }

  void _selectNumber(String numStr) {
    if (_bookedNumbers.contains(numStr)) return;
    setState(() {
      if (_selectedNumber == numStr) {
        _selectedNumber = null;
      } else {
        _selectedNumber = numStr;
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedNumber = null;
    });
  }

  void _handleBookNumber() {
    if (_selectedNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a number'),
          backgroundColor: Color(0xFF063B2C),
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
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
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
                  Expanded(
                    child: Center(
                      child: Text(
                        'Select Your Number',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1C1917),
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
                            child: Text(
                              'Draw #25',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1C1917),
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
                              text: '₹100 ',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1C1917),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '/ number',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
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

                    // Legend Row (3 Distinct Statuses)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _buildLegendItem(
                          color: Colors.white,
                          borderColor: const Color(0xFFC8BDAB),
                          label: 'Available',
                        ),
                        _buildLegendItem(
                          color: const Color(0xFFDCD7CF),
                          borderColor: const Color(0xFFCFC8BD),
                          label: 'Already Booked',
                        ),
                        _buildLegendItem(
                          color: const Color(0xFF063B2C),
                          borderColor: const Color(0xFF063B2C),
                          label: 'Your Selection',
                        ),
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
                        final bool isSelected = _selectedNumber == numStr;

                        Color bgColor;
                        Color textColor;
                        Border? border;

                        if (isBooked) {
                          bgColor = const Color(0xFFDCD7CF);
                          textColor = const Color(0xFF8D877E);
                          border = Border.all(color: const Color(0xFFCFC8BD));
                        } else if (isSelected) {
                          bgColor = const Color(0xFF063B2C);
                          textColor = Colors.white;
                          border = Border.all(color: const Color(0xFF063B2C));
                        } else {
                          bgColor = Colors.white;
                          textColor = const Color(0xFF1C1917);
                          border = Border.all(color: const Color(0xFFC8BDAB));
                        }

                        return GestureDetector(
                          onTap: isBooked ? null : () => _selectNumber(numStr),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: border,
                              boxShadow: isSelected
                                  ? const <BoxShadow>[
                                      BoxShadow(
                                        color: Color(0x33063B2C),
                                        blurRadius: 6,
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

                    // Selected Number Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _selectedNumber != null
                              ? 'Selected Number'
                              : 'Select A Number',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1917),
                          ),
                        ),
                        if (_selectedNumber != null)
                          GestureDetector(
                            onTap: _clearSelection,
                            child: const Row(
                              children: <Widget>[
                                Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: Color(0xFFE03B24),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Clear',
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

                    // Selected Number Chip or Placeholder
                    if (_selectedNumber != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF5EF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFBFDFD0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Number $_selectedNumber',
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF063B2C),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _clearSelection,
                              child: const Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: Color(0xFF78716C),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const Text(
                        'Tap an available number above to select',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12.5,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFA8A29E),
                        ),
                      ),

                    const SizedBox(height: 18),

                    // Booking Promotion Card
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
                                    Icons.confirmation_number_outlined,
                                    color: Color(0xFF063B2C),
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      _selectedNumber != null
                                          ? 'Selected Number: #$_selectedNumber'
                                          : 'Select a number to book',
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1C1917),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '100/number',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF063B2C),
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Fixed booking amount',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.5,
                                        color: const Color(0xFF78716C),
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
                              onPressed: _selectedNumber == null ? null : _handleBookNumber,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF063B2C),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                disabledBackgroundColor: const Color(0xFF063B2C).withValues(alpha: 0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Book This No',
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
                                      'Want to keep this number for future draws?',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1C1917),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Pay an advance amount to reserve it.',
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
                              child: Text(
                                'Reserve for Future Draws',
                                style: GoogleFonts.plusJakartaSans(
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

  Widget _buildLegendItem({
    required Color color,
    required Color borderColor,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1.5),
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
