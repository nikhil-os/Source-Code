import 'package:dio/dio.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/customModal/HomeMovieModal.dart';

/// Top 10 Web Series ///
class Top10WebSeriesProvider {
  final Dio _dio = Dio();

  Future<HomeMovieModal> top10webSeries() async {
    final queryParameters = {
      "type": "WEB-SERIES",
    };
    Response response = await _dio.get(AppUrls.top10movies,
        queryParameters: queryParameters,
        options: Options(headers: {"key": AppUrls.SECRET_KEY}));
    if (response.statusCode == 200) {
      return HomeMovieModal.fromJson(response.data);
    }

    return HomeMovieModal.fromJson(response.data);
  }
}
