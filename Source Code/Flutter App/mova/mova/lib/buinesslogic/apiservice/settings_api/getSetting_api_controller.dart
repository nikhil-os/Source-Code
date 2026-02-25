// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, file_names

import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/settings_api/settings_modal.dart';
import 'dart:convert';

/// Get All settings data ///
class GetSettingProvider {
  static Future<SettingsModal?> settings() async {
    try {
      final uri = Uri.parse(AppUrls.setting);
      http.Response res = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "key": AppUrls.SECRET_KEY
        },
      ).timeout(const Duration(seconds: 10));
      log("message:::get setting :${res.body}");
      var _data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return SettingsModal.fromJson(_data);
      }
      return null;
    } catch (e) {
      log('Settings fetch failed: $e');
      return null;
    }
  }
}
