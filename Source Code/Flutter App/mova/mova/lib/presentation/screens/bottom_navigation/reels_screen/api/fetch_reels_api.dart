import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/model/fetch_reels_model.dart';

class FetchReelsApi {
  // static int startPagination = 0;
  // static int limitPagination = 20;

  static Future<FetchReelsModel?> callApi({
    required String loginUserId,
    required int start,
    required int limit,
  }) async {
    log("Get Reels Api Calling... ");

    start += 1;

    log("Get Reels Pagination Page => $start");

    final uri = Uri.parse("${AppUrls.BASE_URL + AppUrls.fetchReels}?start=$start&limit=$limit&userId=$loginUserId");
    log("Get Reels Api Url => $uri");

    final headers = {"key": AppUrls.SECRET_KEY};

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        log("Get Reels Api Response => ${response.body}");
        return FetchReelsModel.fromJson(jsonResponse);
      } else {
        log("Get Reels Api StateCode Error");
      }
    } catch (error) {
      log("Get Reels Api Error => $error");
    }
    return null;
  }
}
