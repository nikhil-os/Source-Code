// ignore_for_file: camel_case_types, unnecessary_null_comparison, avoid_print, file_names

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/settings_api/getSetting_api_controller.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

/// movieSettingData Getx Controller ///
class settingsController extends GetxController {
  var isLoading = true.obs;

  @override
  void onInit() {
    getSettingsData();
    super.onInit();
  }

  void getSettingsData() async {
    try {
      isLoading(true);
      var movieSettingData = await GetSettingProvider.settings();
      if (movieSettingData != null) {
        showAdminPannelLiveChannels = movieSettingData.setting?.isIptvApi ?? false;
        privacyPolicy = movieSettingData.setting?.privacyPolicyLink ?? '';
        termConditionLink = movieSettingData.setting?.termConditionLink ?? '';
        SECRET_KEY = movieSettingData.setting?.stripeSecretKey ?? '';
        razorPaySecretKey = movieSettingData.setting?.razorSecretKey ?? '';
        stripePublishableKey = movieSettingData.setting?.stripePublishableKey ?? "";
        stripePublishableKey = movieSettingData.setting?.stripePublishableKey ?? '';
        flutterWaveId = movieSettingData.setting?.flutterWaveId ?? '';
        isFlutterWave = movieSettingData.setting?.flutterWaveSwitch ?? false;
        isStripe = movieSettingData.setting?.stripeSwitch ?? false;
        isRazorpay = movieSettingData.setting?.razorPaySwitch ?? false;
        isGooglePlaySwitch = movieSettingData.setting?.googlePlaySwitch ?? false;
      }
    } catch (e) {
      print('Error loading settings: $e');
    } finally {
      isLoading(false);
    }
  }
}
