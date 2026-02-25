import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/chekuser_api/fetch_profile_model.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/database.dart';
import 'package:webtime_movie_ocean/presentation/utils/routes/app_pages.dart';
import 'package:webtime_movie_ocean/presentation/widget/internetConnection/no_connection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Check InterNet Connectivity ///
class NetworkStatusService extends GetxService {
  NetworkStatusService() {
    DataConnectionChecker().onStatusChange.listen(
      (status) async {
        _getNetworkStatus(status);
      },
    );
  }

  final Dio _dio = Dio();

  Future<FetchProfileModel?> onGetProfile() async {
    try {
      final queryParameters = {"userId": userId};
      final response = await _dio.get(
        AppUrls.chekUserProfile,
        queryParameters: queryParameters,
        options: Options(headers: {"key": AppUrls.SECRET_KEY}),
      );

      log('Response Data: ${response.data}');
      log('QUERY :: $userId');

      if (response.statusCode == 200 && response.data['status'] == true) {
        Database.fetchProfileModel = FetchProfileModel.fromJson(response.data);

        Database.profileImage.value = Database.fetchProfileModel?.user?.image ?? "";

        log("User Image => ${Database.profileImage.value}");
        return Database.fetchProfileModel;
      } else {
        Database.fetchProfileModel = null;
      }
      return Database.fetchProfileModel;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _getNetworkStatus(DataConnectionStatus status) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      List<ConnectivityResult> connectivityResults = await Connectivity().checkConnectivity();

      if (connectivityResults.contains(ConnectivityResult.none)) {
        Get.offAll(() => const NetworkErrorItem());
        return;
      }

      final hasInternet = await DataConnectionChecker().hasConnection;
      if (!hasInternet) {
        Get.offAll(() => const NetworkErrorItem());
        return;
      }

      if (pref.getBool("isLogin") == true) {
        final profile = await onGetProfile();

        if (profile == null || profile.message == "User does not found.") {
          log('Profile fetch failed or user not found');
          await pref.setBool("isLogin", false);
          Get.offAllNamed(Routes.welcome);
        } else {
          Get.offAllNamed(Routes.tabs);
        }
      } else {
        Get.offAllNamed(Routes.welcome);
      }
    } catch (e) {
      log('Error in _getNetworkStatus: $e');
      Get.offAll(() => const NetworkErrorItem());
    }
  }
}
