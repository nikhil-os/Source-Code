import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/chekuser_api/fetch_profile_model.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/database.dart';

class FetchProfileProvider extends ChangeNotifier {
  dynamic _data;

  dynamic get data => _data;
  final Dio _dio = Dio();

  User? getUser;

  Future<FetchProfileModel?> onGetProfile() async {
    try {
      final queryParameters = {"userId": userId};
      final response = await _dio.get(
        AppUrls.chekUserProfile,
        queryParameters: queryParameters,
        options: Options(headers: {"key": AppUrls.SECRET_KEY}),
      );

      log('QUERY :: $userId');

      _data = response.data;
      log("**** Fetch Profile Api Response => $_data");

      if (response.statusCode == 200 && response.data['status'] == true) {
        Database.fetchProfileModel = FetchProfileModel.fromJson(response.data);

        Database.profileImage.value = Database.fetchProfileModel?.user?.image ?? "";

        log("User Image => ${Database.profileImage.value}");
        return Database.fetchProfileModel;
      } else {
        Database.fetchProfileModel = null;
      }
      return Database.fetchProfileModel;
    } catch (e) {
      throw Exception(e);
    }
  }
}
