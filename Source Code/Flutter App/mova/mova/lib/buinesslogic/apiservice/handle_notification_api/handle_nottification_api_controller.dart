import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/handle_notification_api/handle_notification_modal.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

///  Handle Notification ///
class HandleNotificationProvider extends GetxService {
  static Future<HandleNotificationModal> handleNotification(String? type) async {
    final uri = Uri.parse(AppUrls.handleNotification);

    http.Response res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
      body: jsonEncode(
        <String, dynamic>{"userId": userId, "type": type},
      ),
    );
    var data = jsonDecode(res.body);
    log("notification data $data");
    if (res.statusCode == 200) {
      return HandleNotificationModal.fromJson(data);
    }
    return HandleNotificationModal.fromJson(data);
  }
}
