import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';

import 'addViewToMovie_modal.dart';

/// Add View into Movie ///
class AddViewToMovieProvider with ChangeNotifier {
  dynamic _data;
  dynamic get data => _data;

  Future<AddViewToMovieModal> addViewToMovie(String movieId) async {
    final uri = Uri.parse("${AppUrls.addViewToMovie}?movieId=$movieId");

    http.Response res = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
    );

    log("Responce Body :: ${res.body}");
    _data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return AddViewToMovieModal.fromJson(_data);
    }
    return AddViewToMovieModal.fromJson(_data);
  }
}
