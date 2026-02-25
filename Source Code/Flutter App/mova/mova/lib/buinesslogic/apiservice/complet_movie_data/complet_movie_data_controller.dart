import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

import 'complete_movie_data_modal.dart';

/// Complete Movie Data ///

class CompletMovieDataProvider {
  static Future<CompleteMovieDataModal> completmoviedata(String movieId) async {
    final uri = Uri.parse("${AppUrls.movieDetail}?movieId=$movieId&userId=$userId");

    http.Response res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
    );
    var data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return CompleteMovieDataModal.fromJson(data);
    }
    return CompleteMovieDataModal.fromJson(data);
  }
}
