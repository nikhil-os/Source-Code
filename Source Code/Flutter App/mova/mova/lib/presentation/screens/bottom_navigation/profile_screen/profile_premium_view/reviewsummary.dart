// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/premiumPlancreateHistory_api/createPremium_contoller.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/tabs_screen.dart';
import 'package:webtime_movie_ocean/presentation/utils/helper/razorpay_checkout_helper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_var.dart';
import '../../../../widget/appbarlayout.dart';

class reviewsummary extends StatefulWidget {
  final String planId;
  final String planPrice;
  final String planName;

  const reviewsummary({
    super.key,
    required this.planId,
    required this.planPrice,
    required this.planName,
  });

  @override
  State<reviewsummary> createState() => _reviewsummaryState();
}

class _reviewsummaryState extends State<reviewsummary> {
  late RazorpayCheckoutHelper _razorpayHelper;
  final CreatePremiumController createPremiumPlan = Get.put(CreatePremiumController());

  @override
  void initState() {
    super.initState();
    _razorpayHelper = RazorpayCheckoutHelper(
      onSuccess: _handlePaymentSuccess,
      onError: _handlePaymentError,
    );
  }

  @override
  void dispose() {
    _razorpayHelper.dispose();
    super.dispose();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(msg: "Payment Successful", timeInSecForIosWeb: 4);
    
    // Call backend API
    await createPremiumPlan.createPremiumData(userId, "Razorpay", widget.planId);
    
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("isPremiumPlan", true);
    isPremiumPlan = true;
    
    selectedIndex = 0;
    Get.offAll(() => const TabsScreen());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "${StringValue.error.tr}: ${response.code} - ${response.message}",
      timeInSecForIosWeb: 4,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Appbarlayout(
                  tital: StringValue.reviewSummary.tr,
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: Get.height / 2.9,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond.withValues(alpha: 0.9) : Colors.transparent,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(width: 2, color: ColorValues.redColor),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 40,
                          width: 40,
                          child: ImageIcon(
                            AssetImage(ProfileAssetValues.profileVector),
                            color: Color(0xFFE21221),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "\$${widget.planPrice}",
                            style: GoogleFonts.urbanist(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: getStorage.read("isDarkMode") == true ? ColorValues.whiteColor : ColorValues.blackColor,
                            ),
                            children: [
                              TextSpan(
                                text: StringValue.month.tr,
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  color: getStorage.read("isDarkMode") == true ? ColorValues.whiteColor : ColorValues.blackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Divider(
                            color: Color(0xFFEEEEEE),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const ImageIcon(
                                    AssetImage(ProfileAssetValues.profileDone),
                                    color: ColorValues.redColor,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    StringValue.watchAllYouWantAdFree.tr,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      color: (getStorage.read('isDarkMode') == true)
                                          ? ColorValues.whiteColor.withValues(alpha: 0.9)
                                          : const Color(0xFF616161),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const ImageIcon(
                                    AssetImage(ProfileAssetValues.profileDone),
                                    color: ColorValues.redColor,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    StringValue.allowsStreamingOf4K.tr,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      color: (getStorage.read('isDarkMode') == true)
                                          ? ColorValues.whiteColor.withValues(alpha: 0.9)
                                          : const Color(0xFF616161),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const ImageIcon(
                                    AssetImage(ProfileAssetValues.profileDone),
                                    color: ColorValues.redColor,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    StringValue.videoAudioQualityIsBetter.tr,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      color: (getStorage.read('isDarkMode') == true)
                                          ? ColorValues.whiteColor.withValues(alpha: 0.9)
                                          : const Color(0xFF616161),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 174,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : ColorValues.whiteColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 20),
                        child: Row(
                          children: [
                            Text(
                              StringValue.amount.tr,
                              style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            Text(
                              "\$${widget.planPrice}",
                              style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 20),
                        child: Row(
                          children: [
                            Text(
                              StringValue.tax.tr,
                              style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            Text(
                              "\$0.00",
                              style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 20),
                        child: Row(
                          children: [
                            Text(
                              StringValue.total.tr,
                              style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            Text(
                              "\$${widget.planPrice}",
                              style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : ColorValues.whiteColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: SvgPicture.asset(
                      MovixIcon.masterCard,
                      width: 25,
                      height: 25,
                    ),
                    title: Text(
                      StringValue.cardNumber.tr,
                      style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      StringValue.change.tr,
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: ColorValues.redColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                InkWell(
                  onTap: () {
                    _razorpayHelper.openCheckout(
                      amount: widget.planPrice,
                      description: "Payment for ${widget.planName}",
                      email: userEmail,
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: Get.height / 15.5,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: ColorValues.redColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      StringValue.confirmPayment.tr,
                      style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.bold, color: ColorValues.whiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
