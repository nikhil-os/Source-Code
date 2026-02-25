// ignore_for_file: avoid_print, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';

/// Delete Download Movie ///
class DeleteDownloadMovieProvider with ChangeNotifier {
  dynamic _data;
  dynamic get data => _data;

  Future deleteDownloadMovie(BuildContext context, downloadId) async {
    final uri = Uri.parse("${AppUrls.deleteDownload}?downloadId=$downloadId");

    http.Response res = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
    );
    _data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return res;
    }
  }
}
