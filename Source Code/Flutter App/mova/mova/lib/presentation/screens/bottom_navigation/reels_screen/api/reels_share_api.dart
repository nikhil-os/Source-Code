import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';

class ReelsShareApi {
  static Future<void> callApi({required String videoId}) async {
    log("Reels Share Api Calling...");

    final uri = Uri.parse("${AppUrls.BASE_URL + AppUrls.videoShare}?shortVideoId=$videoId");

    final headers = {"key": AppUrls.BASE_URL};

    try {
      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        log("Reels Share Api Api Response => ${response.body}");
      } else {
        log("Reels Share Api StateCode Error");
      }
    } catch (error) {
      log("Reels Share Api Error => $error");
    }
  }
}
