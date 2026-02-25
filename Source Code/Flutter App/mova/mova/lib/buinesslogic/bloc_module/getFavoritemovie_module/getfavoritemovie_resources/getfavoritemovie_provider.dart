import 'package:dio/dio.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/customModal/getFavoriteListMovie_modal.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

/// Get All Favorite Movie ///
class GetFavoritemovie {
  final Dio _dio = Dio();

  Future<GetFavoriteListMovieModal> getfavoritemovie ()async{


    Response response = await _dio.get(AppUrls.getFavorite,
        queryParameters: {"userId": userId},
        options: Options(headers: {"key": AppUrls.SECRET_KEY}));
    if(response.statusCode == 200){
      return GetFavoriteListMovieModal.fromJson(response.data);
    }
    return GetFavoriteListMovieModal.fromJson(response.data);
  }

}