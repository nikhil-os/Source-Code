import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/userplan_history/userplanhistrory_model.dart';

class userPlanHistoryService extends GetxService {
  static Future<UserplanhistroryModel?> callApi(String loginUserId) async {
    log("GetProfile Api Calling...");

    final uri = Uri.parse("${AppUrls.BASE_URL + AppUrls.userPlanHistory}?userId=$loginUserId");

    final headers = {"key": AppUrls.SECRET_KEY};

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        log("userplan history response ::: ${response.body}");

        return UserplanhistroryModel.fromJson(jsonResponse);
      }
    } catch (error) {
      log("UserplanHistory Api Error => $error");
    }
    return null;
  }
}
