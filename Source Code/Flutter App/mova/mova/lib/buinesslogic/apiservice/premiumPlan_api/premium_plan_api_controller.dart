import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';

import 'premium_plan_modal.dart';

/// Get All Premium Plan ///
class PremiumPlanProvider {
  static Future<PremiumPlanModal> premiumPlanController() async {
    http.Response response = await http.get(Uri.parse(AppUrls.premiumPlan), headers: {"key": AppUrls.SECRET_KEY});
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return PremiumPlanModal.fromJson(data);
    }
    return PremiumPlanModal.fromJson(data);
  }
}
