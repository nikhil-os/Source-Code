import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/searchmovie_api/SearchMovieModal.dart';

/// Search Movie List ///
class SearchMovieProvider {
  static Future<SearchMovieModal> searchmovie(String search) async {
    try {
      http.Response response = await http.post(Uri.parse(AppUrls.searchMovie),
          headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY}, body: jsonEncode({"search": search}));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return SearchMovieModal.fromJson(data);
      }
      return SearchMovieModal.fromJson(data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
