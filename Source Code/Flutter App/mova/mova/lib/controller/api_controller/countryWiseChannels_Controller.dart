// ignore_for_file: camel_case_types, unnecessary_null_comparison, file_names

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/countryWiseTvChannels/country_wise_live_tv_channels_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/countryWiseTvChannels/country_wise_tv_channels_modal.dart';

/// ChannelsListCountryWise Getx Controller ///
class ChannelsListCountryWiseController extends GetxController {
  var isLoading = true.obs;
  var channelsList = <StreamData>[].obs;

  @override
  void onInit() async {
    liveChannelsDataListData();
    super.onInit();
  }

  liveChannelsDataListData() async {
    try {
      isLoading(true);
      var channelsListData = await CountryWiseLiveChannels.liveTvChannelCountryWise();
      if (channelsListData != null) {
        channelsList.value = channelsListData.streamData!;
      }
    } finally {
      isLoading(false);
    }
  }
}
