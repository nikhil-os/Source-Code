import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/year_api/get_year_modal.dart';

/// Get All Genre ///
class GetMovieYearsProvider {
  static Future<GetYearModal> movieYear() async {
    try {
      final uri = Uri.parse(AppUrls.year);
      http.Response res = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
      );
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return GetYearModal.fromJson(data);
      }
      return GetYearModal.fromJson(data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
