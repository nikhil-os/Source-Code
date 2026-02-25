// ignore_for_file: camel_case_types, unnecessary_null_comparison, avoid_print

import 'dart:developer';

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/advertisement/advertisement_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/advertisement/advertisement_modal.dart';
import 'package:webtime_movie_ocean/controller/api_controller/whoLoginController.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

whoLoginController getWhoUserLoginData = Get.put(whoLoginController());

/// advertisement Getx Controller ///
class advertisementController extends GetxController {
  var isLoading = true.obs;
  AdvertisementModal? advertisementModal;

  void fetchAdvertisement() async {
    try {
      isLoading(true);
      var advertisement = await AdvertisementProvider.getAdvertisement();
      if (advertisement != null) {
        advertisementModal = advertisement;
        // Safely check for advertisement data with null safety
        final adData = advertisementModal?.advertisement;
        if (adData != null && adData.isGoogleAdd == true) {
          // if(getWhoUserLoginData.userIsPremiumOrNot.value == false){
          nativeAd = adData.native;
          interstitialAd = adData.interstitial;
          bannerAd = adData.banner;
          // }
          // else{}
        } else {
          log("Ads error or no advertisement data");
        }
      }
    } catch (e) {
      log("Error fetching advertisement: $e");
    } finally {
      isLoading(false);
    }
  }
}
