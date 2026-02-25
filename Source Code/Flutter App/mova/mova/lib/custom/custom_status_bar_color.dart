import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

class CustomStatusBarColor {
  static void init() {
    Timer(
      const Duration(milliseconds: 300),
      () {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: (getStorage.read('isDarkMode') == true) ? Brightness.light : Brightness.dark,
          ),
        );
      },
    );
  }
}
