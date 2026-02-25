// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/creatDownliad_api/download_movie_list_modal.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Get All Movie Download List ////
class DownloadListProvider {
  static Future<DownloadMovieListModal> getdownloadlist() async {
    final queryParameters = {
      "userId": userId,
    };
    Response response = await Dio().get(
      AppUrls.downloadList,
      queryParameters: queryParameters,
      options: Options(headers: {"key": AppUrls.SECRET_KEY}),
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("download", jsonEncode(response.data));

    var data = response.data;
    print(data);
    DownloadMovieListModal downloadMovieListModal = DownloadMovieListModal.fromJson(response.data);
    pref.setInt("downloadlenth", downloadMovieListModal.download!.length);
    DownloadData = jsonDecode(pref.getString("download")!);
    if (response.statusCode == 200) {
      return DownloadMovieListModal.fromJson(response.data);
    }

    return DownloadMovieListModal.fromJson(response.data);
  }
}
