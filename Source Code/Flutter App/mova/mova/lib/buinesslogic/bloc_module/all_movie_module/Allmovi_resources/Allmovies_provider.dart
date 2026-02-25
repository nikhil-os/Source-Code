import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/customModal/MovieModal.dart';

import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

class AllmoviesProvider {
  final Dio _dio = Dio();

  Future<MovieModal> allmovies() async {
    Response response = await _dio.get(
      AppUrls.allMovie,
      queryParameters: {"userId": userId},
      options: Options(headers: {"key": AppUrls.SECRET_KEY}),
    );

    AllMovieData = response.data;
    log("AllmoviesProvider ${response.data.length}");
    log("AllmoviesProvider ${response.data}");
    if (response.statusCode == 200) {
      return MovieModal.fromJson(response.data);
    }

    return MovieModal.fromJson(response.data);
  }
}
