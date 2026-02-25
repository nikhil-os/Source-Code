// ignore_for_file: camel_case_types, unnecessary_null_comparison, file_names

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/creatDownliad_api/download_movie_list_modal.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/creatDownliad_api/getdownload_list_controller.dart';

/// Top rated Movie  Getx Controller ///
class getAllDownloadMovieController extends GetxController {
  var isLoading = true.obs;
  var getAllDownloadMovieList = <Download>[].obs;

  @override
  void onInit() {
    getAllDownloadMovie();
    super.onInit();
  }

  getAllDownloadMovie() async {
    try {
      isLoading(true);
      var getAllDownloadMovie = await DownloadListProvider.getdownloadlist();
      if (getAllDownloadMovie != null) {
        getAllDownloadMovieList.value = getAllDownloadMovie.download!;
      }
    } finally {
      isLoading(false);
    }
  }
}
