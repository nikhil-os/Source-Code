// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/advertisement/advertisement_modal.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'dart:convert';

/// Movie All Categories ///
class AdvertisementProvider {
  static Future<AdvertisementModal> getAdvertisement() async {
    try {
      final uri = Uri.parse(AppUrls.advertisement);
      http.Response res = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
      );
      var _data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return AdvertisementModal.fromJson(_data);
      }
      return AdvertisementModal.fromJson(_data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
