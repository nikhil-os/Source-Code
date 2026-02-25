// ignore_for_file: file_names

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/userLocation/userLocation_modal.dart';

class UserLocation extends GetxService {
  static Future<LocationModel?> userLocation() async {
    try {
      final resposne = await http
          .get(Uri.parse(AppUrls.userLocationURL))
          .timeout(const Duration(seconds: 5));

      if (resposne.statusCode == 200) {
        return LocationModel.fromJson(jsonDecode(resposne.body));
      } else {
        return null;
      }
    } catch (e) {
      print('User location fetch failed: $e');
      return null;
    }
  }
}
