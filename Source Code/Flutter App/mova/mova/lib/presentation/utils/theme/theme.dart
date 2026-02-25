import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

TextStyle get hometabstyle {
  return GoogleFonts.urbanist(
      fontSize: 10, fontWeight: FontWeight.bold, color: ColorValues.whiteColor);
}

TextStyle get titalstyle {
  return GoogleFonts.urbanist(fontSize: 17, fontWeight: FontWeight.bold);
}

TextStyle get titalstyle3 {
  return GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w600);
}

TextStyle get titalstyle34 {
  return GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.bold);
}

TextStyle get titalstyle1 {
  return GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w700);
}

TextStyle get titalstyle2 {
  return GoogleFonts.urbanist(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: (getStorage.read('isDarkMode') == true)
          ? ColorValues.whiteColor
          : ColorValues.blackColor);
}

TextStyle get titalstyle4 {
  return GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w600);
}

TextStyle get loginMathodStyle {
  return GoogleFonts.urbanist(fontSize: 17, fontWeight: FontWeight.w600);
}

TextStyle get titalstyle5 {
  return GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700);
}

TextStyle get titalstyle6 {
  return GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.bold);
}

TextStyle get titalstyle7 {
  return GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w500);
}

TextStyle get fillProfileStyle {
  return GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600);
}

TextStyle get welcomeNoteStyle {
  return GoogleFonts.urbanist(
      fontSize: 15, fontWeight: FontWeight.w500, color: ColorValues.whiteColor);
}

TextStyle get welcomeStyle {
  return GoogleFonts.urbanist(
      fontSize: 30, fontWeight: FontWeight.bold, color: ColorValues.whiteColor);
}

TextStyle get getStartStyle {
  return GoogleFonts.urbanist(
      fontWeight: FontWeight.w600, fontSize: 16, color: ColorValues.whiteColor);
}

TextStyle get skipStyle {
  return GoogleFonts.urbanist(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: (getStorage.read('isDarkMode') == true)
          ? ColorValues.whiteColor
          : ColorValues.redColor);
}

TextStyle get letsInStyle {
  return GoogleFonts.urbanist(fontSize: 42, fontWeight: FontWeight.w700);
}

TextStyle get welComeAppStyle {
  return GoogleFonts.urbanist(
      fontSize: 42, fontWeight: FontWeight.w700, color: ColorValues.redColor);
}

TextStyle get titalstyle8 {
  return GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w500);
}

TextStyle get orStyle {
  return GoogleFonts.urbanist(fontSize: 15);
}

TextStyle get signInWithPasswordStyle {
  return GoogleFonts.urbanist(
      fontSize: 15, fontWeight: FontWeight.w600, color: ColorValues.whiteColor);
}

TextStyle get quickLoginStyle {
  return GoogleFonts.urbanist(
      fontSize: 17, fontWeight: FontWeight.w600, color: ColorValues.whiteColor);
}

TextStyle get dontHaveAccountStyle {
  return GoogleFonts.urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: (getStorage.read('isDarkMode') == true)
        ? const Color(0xffFFFFFF)
        : const Color(0xFF9E9E9E),
  );
}

TextStyle get signUpStyle {
  return GoogleFonts.urbanist(
      fontSize: 12, fontWeight: FontWeight.w600, color: ColorValues.redColor);
}

TextStyle get playStyle {
  return GoogleFonts.urbanist(
      fontSize: 12, fontWeight: FontWeight.w600, color: ColorValues.whiteColor);
}

TextStyle get createAccountStyle {
  return GoogleFonts.urbanist(fontSize: 25, fontWeight: FontWeight.bold);
}

TextStyle get rememberStyle {
  return GoogleFonts.urbanist(
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );
}

TextStyle get seeAllStyle {
  return GoogleFonts.urbanist(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: ColorValues.grayColorText,
  );
}

TextStyle get allTitleStyle {
  return GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: (getStorage.read('isDarkMode') == true)
        ? ColorValues.whiteColor
        : ColorValues.blackColor,
  );
}

TextStyle get allTitleWhiteStyle {
  return GoogleFonts.urbanist(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: ColorValues.whiteColor,
  );
}

TextStyle get signUpButtonStyle {
  return GoogleFonts.urbanist(
    textStyle: const TextStyle(
      color: ColorValues.whiteColor,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}

TextStyle get forgetPasswordStyle {
  return GoogleFonts.urbanist(
      color: ColorValues.redColor, fontSize: 13.5, fontWeight: FontWeight.w600);
}

TextStyle get chooseInterestStyle {
  return GoogleFonts.urbanist(
    fontWeight: FontWeight.bold,
    fontSize: 19,
  );
}

TextStyle get fillProfileStyle2 {
  return GoogleFonts.urbanist(
    textStyle: const TextStyle(color: ColorValues.grayColor, fontSize: 12),
  );
}

TextStyle get editProfileStyle {
  return GoogleFonts.urbanist(
    textStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 13,
      color: (getStorage.read('isDarkMode') == true)
          ? ColorValues.whiteColor
          : ColorValues.blackColor,
    ),
  );
}

TextStyle get createPinNoteStyle {
  return GoogleFonts.urbanist(fontSize: 15);
}

TextStyle get accountReadyStyle {
  return GoogleFonts.urbanist(
    fontSize: 14,
    color: (getStorage.read('isDarkMode') == true)
        ? ColorValues.whiteColor
        : ColorValues.blackColor,
  );
}

TextStyle get congratulationsStyle {
  return GoogleFonts.urbanist(
    color: ColorValues.redColor,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
}

TextStyle get forgetPasswordStyle2 {
  return GoogleFonts.urbanist(fontWeight: FontWeight.bold, fontSize: 20);
}

TextStyle get forgetPasswordNoteStyle {
  return GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w600);
}

TextStyle get resendOTPStyle {
  return GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w500);
}

TextStyle get optMathodStyle {
  return GoogleFonts.urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ColorValues.grayColor,
  );
}

TextStyle get otpNoteStyle {
  return GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w500);
}

TextStyle get passwordStyle {
  return GoogleFonts.urbanist(
    textStyle: TextStyle(
        color: (getStorage.read('isDarkMode') == true)
            ? ColorValues.whiteColor
            : ColorValues.blackColor,
        fontSize: 15),
  );
}
