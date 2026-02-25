import 'package:dio/dio.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/customModal/HomeMovieModal.dart';

/// Get All Comedy Movie ///
class ComedyMovieProvider {
  final Dio _dio = Dio();

  Future<HomeMovieModal> comedymovies() async {
    final queryParameters = {
      "type": "COMEDY",
    };
    Response response = await _dio.get(AppUrls.comedyMovie,
        queryParameters: queryParameters, options: Options(headers: {"key": AppUrls.SECRET_KEY}));
    if (response.statusCode == 200) {
      return HomeMovieModal.fromJson(response.data);
    }

    return HomeMovieModal.fromJson(response.data);
  }
}
