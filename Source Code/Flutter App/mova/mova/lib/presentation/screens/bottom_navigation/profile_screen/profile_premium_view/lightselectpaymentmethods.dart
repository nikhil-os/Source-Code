// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profile_premium_view/reviewsummary.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/widget/appbarlayout.dart';

class LightSelectPaymentMethods extends StatefulWidget {
  const LightSelectPaymentMethods({super.key});

  @override
  State<LightSelectPaymentMethods> createState() => _LightSelectPaymentMethodsState();
}

class _LightSelectPaymentMethodsState extends State<LightSelectPaymentMethods> {
  String? gender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Appbarlayout(
                tital: StringValue.payment.tr,
              ),
              SizedBox(
                height: Get.height / 45,
              ),
              Text(
                StringValue.selectThePaymentMethod.tr,
                style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: Get.height / 35,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Container(
                  height: 65,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : ColorValues.whiteColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: SvgPicture.asset(
                      MovixIcon.payPal,
                      width: 25,
                      height: 25,
                    ),
                    title: Text(
                      StringValue.payPal.tr,
                      style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Radio(
                      fillColor: WidgetStateColor.resolveWith((states) => ColorValues.redColor),
                      activeColor: ColorValues.redColor,
                      value: StringValue.male.tr,
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Container(
                  height: 65,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : ColorValues.whiteColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: SvgPicture.asset(
                      MovixIcon.google,
                      width: 25,
                      height: 25,
                    ),
                    title: Text(
                      StringValue.googlePay.tr,
                      style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Radio(
                      fillColor: WidgetStateColor.resolveWith((states) => ColorValues.redColor),
                      activeColor: ColorValues.redColor,
                      value: StringValue.female.tr,
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Container(
                  height: 65,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : ColorValues.whiteColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: SvgPicture.asset(
                      MovixIcon.apple,
                      width: 25,
                      height: 25,
                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                    ),
                    title: Text(
                      StringValue.applePay.tr,
                      style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Radio(
                      fillColor: WidgetStateColor.resolveWith((states) => ColorValues.redColor),
                      value: StringValue.other.tr,
                      groupValue: gender,
                      activeColor: ColorValues.redColor,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Container(
                  height: 65,
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
                      style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Radio(
                      fillColor: WidgetStateColor.resolveWith((states) => ColorValues.redColor),
                      value: AssetValues.card.tr,
                      groupValue: gender,
                      activeColor: ColorValues.redColor,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height / 35,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  height: Get.height / 15.5,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : const Color(0xFFFCE7E9),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    StringValue.addNewCard.tr,
                    style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.redColor),
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Get.to(() => const reviewsummary());
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
                    StringValue.Continue.tr,
                    style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.bold, color: ColorValues.whiteColor),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
