import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';

class ReelsLikeDislikeApi {
  static Future<void> callApi({required String loginUserId, required String videoId}) async {
    log("Reels Like-Dislike Api Calling...");

    final uri = Uri.parse("${AppUrls.BASE_URL + AppUrls.reelsLikeDislike}?userId=$loginUserId&videoId=$videoId");

    final headers = {"key": AppUrls.SECRET_KEY};

    try {
      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        log("Reels Like-Dislike Api Response => ${response.body}");
      } else {
        log("Reels Like-Dislike Api StateCode Error");
      }
    } catch (error) {
      log("Reels Like-Dislike Api Error => $error");
    }
  }
}
