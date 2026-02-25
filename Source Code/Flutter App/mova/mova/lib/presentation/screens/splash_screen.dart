import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/userLocation/userLocation_api_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/advertisement.dart';
import 'package:webtime_movie_ocean/controller/api_controller/settingsController.dart';
import 'package:webtime_movie_ocean/controller/notification_conteroller.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/controller/reels_controller.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/widget/internetConnection/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/internetConnection/no_connection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  advertisementController getAdvertisement = Get.put(advertisementController());
  settingsController getSettingsData = Get.put(settingsController());

  @override
  void initState() {
    super.initState();
    NotificationController.notificationActiv();
    getAdvertisement.fetchAdvertisement();
    splashLogin();
    userLocation();
    Get.put(ReelsController());
  }

  Future userLocation() async {
    try {
      var liveCountry = await UserLocation.userLocation();
      if (liveCountry != null && liveCountry.country != null) {
        userLiveCountry = liveCountry.country!;
        print(userLiveCountry);
      } else {
        userLiveCountry = 'Unknown';
        print('Could not determine user location');
      }
    } catch (e) {
      userLiveCountry = 'Unknown';
      print('Error getting user location: $e');
    }
  }

  splashLogin() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (connectivityResult == ConnectivityResult.none &&
        pref.getBool("isLogin") == true) {
      Get.offAll(() => const NetworkErrorItem());
    } else {
      DependencyInjection.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(),
            SvgPicture.asset(
              MovixIcon.appLogo,
              height: Get.height / 4,
            ),
            const SpinKitCircle(
              color: Colors.red,
              size: 60,
            ),
          ],
        ),
      ),
    );
  }
}
