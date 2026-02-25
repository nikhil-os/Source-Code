import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.suffixIcon,
    this.onTap,
    this.enabled,
    this.readOnly,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffixIcon;
  final Callback? onTap;
  final bool? enabled;
  final bool? readOnly;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: Get.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: (getStorage.read('isDarkMode') == true) ? ColorValues.containerBg : ColorValues.darkModeThird.withValues(alpha: 0.03),
          border: Border.all(
              width: 0.6,
              color: (getStorage.read('isDarkMode') == true) ? ColorValues.borderColor : ColorValues.dividerColor.withValues(alpha: 0.02)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                style: GoogleFonts.urbanist(
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                  ),
                ),
                textInputAction: textInputAction,
                readOnly: readOnly ?? false,
                decoration: InputDecoration(
                  isDense: true,
                  enabled: enabled ?? true,
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: GoogleFonts.urbanist(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: ColorValues.grayColor,
                    ),
                  ),
                ),
              ),
            ),
            suffixIcon ?? const Offstage(),
          ],
        ),
      ),
    );
  }
}
