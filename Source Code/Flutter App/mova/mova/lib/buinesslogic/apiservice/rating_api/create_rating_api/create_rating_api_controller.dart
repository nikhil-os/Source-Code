// ignore_for_file: avoid_print, file_names

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/rating_api/create_rating_api/create_rating_modal.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

/// Create Rating of Movie ///
class CreateRatingProvider with ChangeNotifier {
  dynamic _data;

  dynamic get data => _data;

  Future<CreateRatingModal> createRating(String movieId, String rate) async {
    // String url = AppUrls.getDomainFromURL(AppUrls.BASE_URL);
    final queryParameters = {"movieId": movieId, "userId": userId, "rating": rate};
    // final uri = Uri.http("${AppUrls.BASE_URL + AppUrls.createRating}$queryParameters");

    final uri = Uri.parse("${AppUrls.BASE_URL + AppUrls.createRating}?movieId=$movieId&userId=$userId&rating=$rate");
    http.Response res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
    );
    _data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return CreateRatingModal.fromJson(_data);
    }
    return CreateRatingModal.fromJson(_data);
  }
}
