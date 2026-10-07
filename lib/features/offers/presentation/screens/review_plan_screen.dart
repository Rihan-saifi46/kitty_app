import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../checkout/presentation/screens/checkout_screen.dart';

/// Recreated 100% identically from dddd/review.html
/// Features:
/// - Light cream background #FAF7F2
/// - Header with back arrow & "Review Your Plan" (Playfair Display 30px bold)
/// - Plan Details Card with coin icon, title, and "Edit" button
/// - Account Details Card with name, mobile, email, and "Edit" button
/// - Interactive modal sheet to switch plans (6M, 9M, 11M)
/// - "Proceed to Payment" CTA button in #073B2C
class ReviewPlanScreen extends ConsumerStatefulWidget {
  const ReviewPlanScreen({super.key});

  @override
  ConsumerState<ReviewPlanScreen> createState() => _ReviewPlanScreenState();
}

class _ReviewPlanScreenState extends ConsumerState<ReviewPlanScreen> {
  String _planTitle = '6 Month Gold Plan';
  int _monthlyAmount = 5000;
  int _totalAmount = 30000;
  int _durationMonths = 6;

  void _showEditPlanModal() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Change Plan Duration',
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111A16),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildPlanOption(
                title: '6 Month Gold Plan',
                monthly: 5000,
                total: 30000,
                duration: 6,
                isSelected: _durationMonths == 6,
                onSelect: () {
                  setState(() {
                    _planTitle = '6 Month Gold Plan';
                    _monthlyAmount = 5000;
                    _totalAmount = 30000;
                    _durationMonths = 6;
                  });
                  Navigator.of(ctx).pop();
                },
              ),
              const SizedBox(height: 10),
              _buildPlanOption(
                title: '9 Month Gold Plan',
                monthly: 5000,
                total: 45000,
                duration: 9,
                isSelected: _durationMonths == 9,
                onSelect: () {
                  setState(() {
                    _planTitle = '9 Month Gold Plan';
                    _monthlyAmount = 5000;
                    _totalAmount = 45000;
                    _durationMonths = 9;
                  });
                  Navigator.of(ctx).pop();
                },
              ),
              const SizedBox(height: 10),
              _buildPlanOption(
                title: '11 Month Gold Plan',
                monthly: 5000,
                total: 55000,
                duration: 11,
                isSelected: _durationMonths == 11,
                onSelect: () {
                  setState(() {
                    _planTitle = '11 Month Gold Plan';
                    _monthlyAmount = 5000;
                    _totalAmount = 55000;
                    _durationMonths = 11;
                  });
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlanOption({
    required String title,
    required int monthly,
    required int total,
    required int duration,
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEDF5F1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF073B2C) : const Color(0xFFEFE8DE),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: const Color(0xFF111A16),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹$monthly / month • Total ₹$total',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    color: Color(0xFF6B6864),
                  ),
                ),
              ],
            ),
            if (isSelected)
              const Icon(
                Icons.check_rounded,
                color: Color(0xFF073B2C),
                size: 22,
              )
            else
              const Text(
                'Select',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFA8A29E),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppAuthState auth = ref.watch(appAuthStateProvider);
    final String userName = auth.userName.isNotEmpty ? auth.userName : 'Mahak Garg';
    final String userPhone = auth.userPhone.isNotEmpty ? auth.userPhone : '+91 98765 43210';
    const String userEmail = 'mahakgarg@email.com';

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(RoutePaths.offers);
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF161616),
                    size: 24,
                  ),
                ),
              ),
            ),

            // Header Title & Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: <Widget>[
                  Text(
                    'Review Your Plan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111A16),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Please review your plan details\nbefore making the first payment.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B6864),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    // Plan Details Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFEFE8DE)),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          // Card Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFAF2E2),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: const Color(0xFFF3E5CC)),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.monetization_on_rounded,
                                        color: Color(0xFFC88A35),
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _planTitle,
                                    style: const TextStyle(
                                      fontFamily: 'Playfair',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111A16),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: _showEditPlanModal,
                                child: const Row(
                                  children: <Widget>[
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF073B2C),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.edit_outlined,
                                      color: Color(0xFF073B2C),
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          const Divider(color: Color(0xFFF5EFE7), height: 1),
                          const SizedBox(height: 8),

                          // Rows
                          _buildDetailRow('Monthly Installment', '₹$_monthlyAmount'),
                          _buildDetailRow('Total Contribution', '₹$_totalAmount'),
                          _buildDetailRow('Duration', '$_durationMonths Months'),
                          _buildDetailRow('Installments', '$_durationMonths'),
                          _buildDetailRow('Booking Eligibility', 'After 3 installments'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Account Details Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFEFE8DE)),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Account Details',
                                style: TextStyle(
                                  fontFamily: 'Playfair',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111A16),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push(RoutePaths.profile),
                                child: const Row(
                                  children: <Widget>[
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF073B2C),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.edit_outlined,
                                      color: Color(0xFF073B2C),
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: Color(0xFFF5EFE7), height: 1),
                          const SizedBox(height: 8),
                          _buildDetailRow('Name', userName),
                          _buildDetailRow('Mobile', userPhone),
                          _buildDetailRow('Email', userEmail),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Proceed to Payment CTA Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push(
                            RoutePaths.checkout,
                            extra: CheckoutArgs(
                              membershipId: 'mem_994411',
                              chitToken: '#SW-042',
                              monthFor: 1,
                              amount: _monthlyAmount,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF073B2C),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: const Color(0x33073B2C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: const Text(
                          'Proceed to Payment',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B6864),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111A16),
            ),
          ),
        ],
      ),
    );
  }
}
