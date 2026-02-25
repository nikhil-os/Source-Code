// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/toprated/topratedMovie_api/topRatedWebSeries_api/top_rated_web_series_api_controller.dart';
import 'package:webtime_movie_ocean/customModal/topRated_modal.dart';

/// Top rated Movie  Getx Controller ///
class topRatedWebSeriesController extends GetxController {
  var isLoading = true.obs;
  var topRatedWebSeriesList = <Movie>[].obs;

  @override
  void onInit() {
    allTopRatedWebSeries();
    super.onInit();
  }

  allTopRatedWebSeries() async {
    try {
      isLoading(true);
      var allTopRatedWebSeries = await TopRatedWebSeriesDataProvider.topRatedWebSeriesData();
      if (allTopRatedWebSeries != null) {
        topRatedWebSeriesList.value = allTopRatedWebSeries.movie!;
      }
    } finally {
      isLoading(false);
    }
  }
}
