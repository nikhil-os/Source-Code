// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/year_api/get_year_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/year_api/get_year_modal.dart';

/// Year Getx Controller ///
class yearController extends GetxController {
  var isLoading = true.obs;
  var yearList = <Movie>[].obs;

  @override
  void onInit() {
    getMovieYears();
    super.onInit();
  }

  void getMovieYears() async {
    try {
      isLoading(true);
      var year = await GetMovieYearsProvider.movieYear();
      if (year != null) {
        yearList.value = year.movie!;
      }
    } finally {
      isLoading(false);
    }
  }
}
