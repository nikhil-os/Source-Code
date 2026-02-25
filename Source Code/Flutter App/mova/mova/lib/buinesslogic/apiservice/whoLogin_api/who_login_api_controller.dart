import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/whoLogin_api/whoLogin_modal.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

/// Who login User ///
class WhoUserLoginProvider {
  static Future<WhoLoginModal> whoUserLogin() async {
    final uri = Uri.parse("${AppUrls.whoLogin}?userId=$userId");

    http.Response res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
    );

    var data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return WhoLoginModal.fromJson(data);
    }
    return WhoLoginModal.fromJson(data);
  }
}
