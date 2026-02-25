import 'package:dio/dio.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/customModal/HomeMovieModal.dart';

/// Top 10 Movie ///
class Top10MoviesProvider {
  final Dio _dio = Dio();

  Future<HomeMovieModal> top10movies() async {
    final queryParameters = {
      "type": "MOVIE",
    };
    Response response = await _dio.get(AppUrls.top10movies, queryParameters: queryParameters, options: Options(headers: {"key": AppUrls.SECRET_KEY}));
    print('top10 :: ${response.data}');
    if (response.statusCode == 200) {
      return HomeMovieModal.fromJson(response.data);
    }

    return HomeMovieModal.fromJson(response.data);
  }
}
