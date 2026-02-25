import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/complet_movie_data/complete_movie_data_modal.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';

class RentPlanScreen extends StatefulWidget {
  final String movieId;
  final String title;
  final List<RentalOption>? rentalOptions;
  final String? rentalCurrency;

  const RentPlanScreen({
    super.key,
    required this.movieId,
    required this.title,
    this.rentalOptions,
    this.rentalCurrency,
  });

  @override
  State<RentPlanScreen> createState() => _RentPlanScreenState();
}

class _RentPlanScreenState extends State<RentPlanScreen> {
  int? selectedIndex;

  // Default options if admin hasn't set any
  static const List<Map<String, dynamic>> defaultOptions = [
    {'duration': 3, 'durationLabel': '3 Hours', 'price': 0},
    {'duration': 6, 'durationLabel': '6 Hours', 'price': 0},
    {'duration': 12, 'durationLabel': '12 Hours', 'price': 0},
    {'duration': 24, 'durationLabel': '24 Hours', 'price': 0},
    {'duration': 48, 'durationLabel': '2 Days', 'price': 0},
    {'duration': 168, 'durationLabel': '7 Days', 'price': 0},
    {'duration': 360, 'durationLabel': '15 Days', 'price': 0},
    {'duration': 504, 'durationLabel': '21 Days', 'price': 0},
    {'duration': 720, 'durationLabel': '30 Days', 'price': 0},
  ];

  List<Map<String, dynamic>> get displayOptions {
    if (widget.rentalOptions != null && widget.rentalOptions!.isNotEmpty) {
      return widget.rentalOptions!
          .where((opt) => opt.price != null && opt.price! > 0)
          .map((opt) => {
                'duration': opt.duration ?? 0,
                'durationLabel': opt.durationLabel ?? '',
                'price': opt.price ?? 0,
              })
          .toList();
    }
    return defaultOptions;
  }

  String get currencySymbol {
    switch (widget.rentalCurrency?.toUpperCase()) {
      case 'INR':
        return '₹';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      default:
        return '₹';
    }
  }

  Future<void> _showPaymentSuccessDialog(Map<String, dynamic> opt) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  'Payment Successful!',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                // Message
                Text(
                  'Your rental is now active',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Details
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Duration:',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            opt['durationLabel'] ?? '',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount Paid:',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            '$currencySymbol${opt['price']}',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorValues.redColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // OK Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Get.back(result: {'activated': true});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorValues.redColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Start Watching',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _processPayment(Map<String, dynamic> opt) async {
    // Store rental locally
    final prefs = await SharedPreferences.getInstance();
    final durationHours = opt['duration'] as num;
    final expiresAtMs = DateTime.now().millisecondsSinceEpoch +
        durationHours.toInt() * 60 * 60 * 1000;

    await prefs.setInt('rental_${widget.movieId}_expires', expiresAtMs);
    await prefs.setString(
        'rental_${widget.movieId}_currency', widget.rentalCurrency ?? 'INR');
    await prefs.setInt(
        'rental_${widget.movieId}_price', (opt['price'] as num).toInt());

    // Show success popup
    await _showPaymentSuccessDialog(opt);
  }

  @override
  Widget build(BuildContext context) {
    final options = displayOptions;

    // Filter out options with zero or no price
    final validOptions = options
        .where((opt) => opt['price'] != null && (opt['price'] as num) > 0)
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: ColorValues.redColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Rent Movie',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: validOptions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.movie_filter_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rental not available',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rental options have not been configured\nfor this movie yet.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Movie Title Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ColorValues.redColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select a rental duration',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Rental Options List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: validOptions.length,
                    itemBuilder: (ctx, i) {
                      final opt = validOptions[i];
                      final isSelected = selectedIndex == i;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = i;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? ColorValues.redColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Selection indicator
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? ColorValues.redColor
                                        : Colors.grey.shade400,
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? ColorValues.redColor
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              // Duration
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      opt['durationLabel'] ?? '',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Access for ${opt['durationLabel']}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Price
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ColorValues.redColor
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '$currencySymbol${opt['price']}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected
                                        ? Colors.white
                                        : ColorValues.redColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Pay Now Button
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedIndex == null
                            ? null
                            : () =>
                                _processPayment(validOptions[selectedIndex!]),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorValues.redColor,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          selectedIndex == null
                              ? 'Select a plan'
                              : 'Pay Now - $currencySymbol${validOptions[selectedIndex!]['price']}',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: selectedIndex == null
                                ? Colors.grey.shade500
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
