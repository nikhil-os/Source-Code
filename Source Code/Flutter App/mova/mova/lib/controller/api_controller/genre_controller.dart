import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/genre_api/genre_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/genre_api/genre_modal.dart';

/// Genre Getx Controller ///
class GenreController extends GetxController {
  var isLoading = true.obs;
  var genreList = <Genre>[].obs;

  @override
  void onInit() {
    fetchGenre();
    super.onInit();
  }

  void fetchGenre() async {
    try {
      isLoading(true);
      var genre = await GenreProvider.genre();
      genreList.value = genre.genre!;
    } finally {
      isLoading(false);
    }
  }
}
