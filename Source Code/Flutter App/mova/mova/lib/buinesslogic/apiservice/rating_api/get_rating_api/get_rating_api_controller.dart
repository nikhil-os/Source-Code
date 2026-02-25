// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/rating_api/get_rating_api/get_rating_modal.dart';

/// Get Rating of Movie ///
class GetRatingProvider with ChangeNotifier {
  dynamic _data;
  dynamic get data => _data;

  Future<GetRatingModal> getRating() async {
    try{
      final uri = Uri.parse(AppUrls.getRating);
      http.Response res = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "key": AppUrls.SECRET_KEY
        },
      );
      _data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return GetRatingModal.fromJson(_data);
      }
      return GetRatingModal.fromJson(_data);
    }
    catch(e){
      throw Exception(e);
    }

  }
}
