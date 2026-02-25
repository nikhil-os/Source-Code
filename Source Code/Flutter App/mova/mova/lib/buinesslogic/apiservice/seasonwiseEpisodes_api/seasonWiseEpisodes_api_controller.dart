// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/seasonwiseEpisodes_api/seasonWiseEpisodes_modal.dart';

/// Get Season Wise Episode ///
class SeasonWiseEpisodesProvider {
  static Future<SeasonWiseEpisodesModal> seasonWiseEpisodes(String movieId, String season) async {
    log("Movie ID :: $movieId");
    log("Sesion ID :: $season");

    final uri = Uri.parse("${AppUrls.seasonEpisodes}?movieId=$movieId&seasonNumber=$season");

    log("Season Uri :: $uri");
    http.Response res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
    );

    log("Season wise Response body :: ${res.body}");
    var data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return SeasonWiseEpisodesModal.fromJson(data);
    }
    return SeasonWiseEpisodesModal.fromJson(data);
  }
}
