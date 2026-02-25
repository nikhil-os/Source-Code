// ignore_for_file: avoid_print, file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/liveTvChannels/liveTvChannels_modal.dart';

/// Get All LiveTvChannels Data  ///
class LiveTvChannelsProvider {
  static Future<LiveTvChannelsModal> adminPannelsData() async {
    try {
      final uri = Uri.parse(AppUrls.adminPanelLiveTv);
      http.Response res = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
      );
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return LiveTvChannelsModal.fromJson(data);
      }
      return LiveTvChannelsModal.fromJson(data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
