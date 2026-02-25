// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/complet_movie_data/complet_movie_data_controller.dart';

import '../../buinesslogic/apiservice/complet_movie_data/complete_movie_data_modal.dart';

/// Movie Details Getx Controller ///
class movieDetailsController extends GetxController {
  var download = false.obs;
  var isLoading = true.obs;
  var isScrolled = true.obs;
  var movieDetailsList = <Movie>[].obs;
  var commentsCount = 0.obs;

  allDetails(String movieId) async {
    try {
      isLoading(true);
      var allData = await CompletMovieDataProvider.completmoviedata(movieId);

      log("AllData=============${jsonEncode(allData)}");
      log("AllData=============$movieDetailsList");
      if (allData != null) {
        movieDetailsList.value = allData.movie!;
        download.value = allData.movie![0].isDownload!;

        log("download.value======${movieDetailsList.first}");
        log("download.value======${download.value}");
      }
    } finally {
      isLoading(false);
    }
  }
}
