// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'dart:convert';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/genre_api/genre_modal.dart';

/// Get All Genre ///
class GenreProvider {
  static Future<GenreModal> genre() async {
    try {
      final uri = Uri.parse(AppUrls.genre);
      http.Response res = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
      );
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return GenreModal.fromJson(data);
      }
      return GenreModal.fromJson(data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
