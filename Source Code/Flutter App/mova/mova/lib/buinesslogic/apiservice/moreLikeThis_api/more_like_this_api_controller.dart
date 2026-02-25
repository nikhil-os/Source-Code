import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';

import 'moreLikeThis_modal.dart';

/// More Like This Movie ///
class MoreLikeThisMovieMovieProvider {
  dynamic _data;
  dynamic get data => _data;

  static Future<MoreLikeThisModal> moreLikeThisMovie(String movieId) async {
    final uri = Uri.parse("${AppUrls.movieAllLikeThis}?movieId=$movieId");

    http.Response res = await http.get(uri, headers: {"key": AppUrls.SECRET_KEY});
    var data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      log("_______+++++${data}");
      return MoreLikeThisModal.fromJson(data);
    }
    return MoreLikeThisModal.fromJson(data);
  }
}
