// ignore_for_file: avoid_print, file_names

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/notification_api/notificationget_modal.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

/// Get All Notification List ///
class GetNotificationProvider with ChangeNotifier {
  dynamic _data;

  dynamic get data => _data;
  final Dio _dio = Dio();

  Future<NotificationgetModal> getNotification() async {
    try {
      Response res = await _dio.get(
        AppUrls.getNotification,
        queryParameters: {"userId": userId},
        options: Options(
          headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
        ),
      );
      log("Notification data :: ${res.data}");

      _data = res.data;
      if (res.statusCode == 200) {
        return NotificationgetModal.fromJson(_data);
      }
    } catch (e) {
      print("Error fetching notification: $e");
      rethrow; // Rethrow the error to propagate it
    }
    return NotificationgetModal.fromJson(_data);
  }
}
