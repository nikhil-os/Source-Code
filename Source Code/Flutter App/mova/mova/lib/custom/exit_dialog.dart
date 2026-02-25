import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : ColorValues.whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: Get.height / 5.5,
                width: Get.width / 1.6,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AssetValues.exitGroup),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                StringValue.exit.tr,
                style: GoogleFonts.urbanist(color: ColorValues.redColor, fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                StringValue.doYouWantToExitThisApp.tr,
                style: GoogleFonts.urbanist(
                    fontSize: 14, color: getStorage.read("isDarkMode") == true ? ColorValues.whiteColor : ColorValues.blackColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  exit(0);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: Get.height / 14.5,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: ColorValues.redColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    StringValue.exit.tr,
                    style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.bold, color: ColorValues.whiteColor),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: Get.height / 14.5,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : ColorValues.darkModeThird.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    StringValue.cancel.tr,
                    style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.bold, color: ColorValues.whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
