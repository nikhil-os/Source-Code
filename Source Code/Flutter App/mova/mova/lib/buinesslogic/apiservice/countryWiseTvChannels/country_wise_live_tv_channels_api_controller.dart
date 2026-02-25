// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/countryWiseTvChannels/country_wise_tv_channels_modal.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

class CountryWiseLiveChannels {
  static Future<CountryWiseTvChannelsModal?> liveTvChannelCountryWise() async {
    final uri = Uri.parse("${AppUrls.countryWiseLiveChannels}?countryName=$userLiveCountry");

    http.Response res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
    );
    if (res.statusCode == 200) {
      return CountryWiseTvChannelsModal.fromJson(jsonDecode(res.body));
    } else {
      return CountryWiseTvChannelsModal.fromJson(jsonDecode(res.body));
    }
  }
}
