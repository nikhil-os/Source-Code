import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/searchmovie_api/search_movie_controller.dart';

import '../../buinesslogic/apiservice/searchmovie_api/SearchMovieModal.dart';

/// Search Movie Getx Controller ///
class SearchMovieController extends GetxController {
  var isLoading = true.obs;
  var searchMovieList = <Movie>[].obs;

  void fetchSearchMovie(String search) async {
    try {
      isLoading(true);
      var searchMovieData = await SearchMovieProvider.searchmovie(search);
      searchMovieList.value = searchMovieData.movie ?? [];
    } finally {
      isLoading(false);
    }
  }
}
