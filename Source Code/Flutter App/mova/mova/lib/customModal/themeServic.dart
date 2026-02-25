// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class ThemeServices extends GetxController {
  final box = GetStorage();
  final key = 'isDarkMode';

  ThemeServices() {
    if (!box.hasData(key)) {
      box.write(key, true); // ✅ Set dark mode by default
    }
  }

  saveThemeToBox(bool isDarkMode) => box.write(key, isDarkMode);

  bool loadThemeFromBox() => box.read(key) ?? false;

  ThemeMode get theme => loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    Get.changeThemeMode(loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    saveThemeToBox(!loadThemeFromBox());
    CustomTheme.init();
  }
}

class GetStorageKey {
  static const IS_DARK_MODE = "sms_is_dark_mode";
}

class CustomTheme {
  static RxBool isDarkMode = true.obs;
  static final storage = GetStorage();

  static void init() {
    final stored = storage.read("isDarkMode");
    isDarkMode.value = stored == true;
    // isDarkMode.value = storage.read('isDarkMode') == true ? true : false;
    log("My Current Theme => ${isDarkMode.value}");
  }
}
