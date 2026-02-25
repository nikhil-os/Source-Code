// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/moreLikeThis_api/more_like_this_api_controller.dart';

import '../../buinesslogic/apiservice/moreLikeThis_api/moreLikeThis_modal.dart';

/// moreLikeThisMovie Getx Controller ///
class moreLikeThisMovieController extends GetxController {
  var isLoading = true.obs;
  var movieDetailsList = <Movie>[].obs;

  moreLikeThisMovieDetails(String movieId) async {
    try {
      isLoading(true);
      var moreLikeThisMovieData = await MoreLikeThisMovieMovieProvider.moreLikeThisMovie(movieId);
      if (moreLikeThisMovieData != null) {
        movieDetailsList.value = moreLikeThisMovieData.movie!;
      }
    } finally {
      isLoading(false);
    }
  }
}
