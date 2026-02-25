// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/toprated/topratedMovie_api/top_rated_movie_api_controller.dart';
import 'package:webtime_movie_ocean/customModal/topRated_modal.dart';

/// Top rated Movie  Getx Controller ///
class topRatedMovieController extends GetxController {
  var isLoading = true.obs;
  var topRatedMovieList = <Movie>[].obs;

  @override
  void onInit() {
    allTopRatedMovie();
    super.onInit();
  }

  allTopRatedMovie() async {
    try {
      isLoading(true);
      var allTopRatedMovie = await TopRatedMovieDataProvider.topRatedMovieData();
      if (allTopRatedMovie != null) {
        topRatedMovieList.value = allTopRatedMovie.movie!;
      }
    } finally {
      isLoading(false);
    }
  }
}
