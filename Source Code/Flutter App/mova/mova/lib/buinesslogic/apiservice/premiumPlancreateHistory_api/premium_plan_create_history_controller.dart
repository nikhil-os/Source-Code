import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';

/// PremiumPlan Create History ///
class PremiumPlanCreateHistoryProvider {
  static Future premiumPlanCreateHistoryProvider(String userId, String paymentGateway, String premiumPlanId) async {
    http.Response response = await http.post(
      Uri.parse(AppUrls.premiumPlanCreateHistory),
      headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
      body: jsonEncode(
        {"userId": userId, "premiumPlanId": premiumPlanId, "paymentGateway": paymentGateway},
      ),
    );
    var data = response.body;
    log(data);
    if (response.statusCode == 200) {
      return data;
    }
    return data;
  }
}
