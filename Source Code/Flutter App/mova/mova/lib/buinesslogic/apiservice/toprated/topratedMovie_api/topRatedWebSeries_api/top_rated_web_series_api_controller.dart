import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/customModal/topRated_modal.dart';

/// Top Rated Web Series Data ///
class TopRatedWebSeriesDataProvider {
  static Future<TopRatedModal> topRatedWebSeriesData() async {
    final uri = Uri.parse("${AppUrls.topRated}?type=WEB-SERIES");

    http.Response res = await http.get(
      uri,
      headers: {"key": AppUrls.SECRET_KEY},
    );
    var data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return TopRatedModal.fromJson(data);
    }
    return TopRatedModal.fromJson(data);
  }
}
