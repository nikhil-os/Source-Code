import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';

class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0XFFFEFEFE),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: GoogleFonts.plusJakartaSans(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: ColorValues.darkModeMain,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorValues.darkModeMain,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
