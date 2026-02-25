// ignore_for_file: camel_case_types, unnecessary_null_comparison, avoid_print, file_names

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/whoLogin_api/who_login_api_controller.dart';

import '../../presentation/utils/app_var.dart';

/// WhoUserLogin Getx Controller ///
class whoLoginController extends GetxController {
  var isLoading = true.obs;
  var userIsPremiumOrNot = false.obs;

  @override
  void onInit() {
    getWhoUserLoginData();
    super.onInit();
  }

  void getWhoUserLoginData() async {
    try {
      isLoading(true);
      var whoUserLoginData = await WhoUserLoginProvider.whoUserLogin();
      userIsPremiumOrNot.value = whoUserLoginData.user!.isPremiumPlan!;

      userProfileImage = whoUserLoginData.user!.image.toString();
    } finally {
      isLoading(false);
    }
  }
}
