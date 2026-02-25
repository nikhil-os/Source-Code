import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/customModal/HomeMovieModal.dart';

/// New Release Movie ///

class NewReleaseMovieProvider {
  final Dio _dio = Dio();

  Future<HomeMovieModal> newReleaseMovie() async {
    Response response = await _dio.get(AppUrls.newReleaseMovie, options: Options(headers: {"key": AppUrls.SECRET_KEY}));
    if (response.statusCode == 200) {
      log("HomeMovieModal: body::: ${response.data}  ");
      return HomeMovieModal.fromJson(response.data);
    }
    return HomeMovieModal.fromJson(response.data);
  }
}
