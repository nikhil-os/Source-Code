
// ignore_for_file: camel_case_types

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';


/// Get PremiumPlan History ///
class premiumPlanhistoryController extends ChangeNotifier {
  dynamic _data;
  dynamic  get data => _data;
  final Dio _dio = Dio();

  Future premiumPlanhistoryprovider() async {

    Response response = await _dio.get(AppUrls.premiumPlanHistory,
        queryParameters: {"userId": userId},
        options: Options(headers: {"key": AppUrls.SECRET_KEY}));

    _data = response.data;
    if (response.statusCode == 200) {
      return _data;
    }

    return _data;
  }
}

