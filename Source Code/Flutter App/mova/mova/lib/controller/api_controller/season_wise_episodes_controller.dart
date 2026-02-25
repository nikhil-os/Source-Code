import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/seasonwiseEpisodes_api/seasonWiseEpisodes_api_controller.dart';

import '../../buinesslogic/apiservice/seasonwiseEpisodes_api/seasonWiseEpisodes_modal.dart';

/// Movie Details Getx Controller ///
class SeasonWiseEpisodesController extends GetxController {
  var isLoading = true.obs;
  RxList seasonWiseEpisodesList = <Episode>[].obs;

  allEpisodesDetails(String movieId, String season) async {
    try {
      isLoading(true);
      seasonWiseEpisodesList.clear();
      var allEpisodes = await SeasonWiseEpisodesProvider.seasonWiseEpisodes(movieId, season);
      seasonWiseEpisodesList.value = allEpisodes.episode!;
      log('DATA :: ${jsonEncode(allEpisodes.episode)}===${jsonEncode(seasonWiseEpisodesList)}');
    } finally {
      isLoading(false);
    }
  }
}
