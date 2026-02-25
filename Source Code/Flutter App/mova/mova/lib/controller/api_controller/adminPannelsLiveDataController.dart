// ignore_for_file: camel_case_types, unnecessary_null_comparison, file_names

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/liveTvChannels/liveTvChannels_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/liveTvChannels/liveTvChannels_modal.dart';

///ChannelsList Getx Controller ///
class ChannelsListController extends GetxController {
  var isLoading = true.obs;
  var channelsList = <Stream>[].obs;

  @override
  void onInit() async {
    liveChannelsDataListData();
    super.onInit();
  }

  liveChannelsDataListData() async {
    try {
      isLoading(true);
      var livechannelsListData = await LiveTvChannelsProvider.adminPannelsData();
      if (livechannelsListData != null) {
        channelsList.value = livechannelsListData.stream!;
      }
    } finally {
      isLoading(false);
    }
  }
}
