import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/customModal/getFavoriteListMovie_modal.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

/// Get All Favorite Movie List ///
class GetFavoriteMovieListProvider with ChangeNotifier {
  dynamic _data;
  dynamic get data => _data;

  Future<GetFavoriteListMovieModal> getFavoriteMovieList(BuildContext context) async {
    final uri = Uri.parse("${AppUrls.getFavorite}?userId=$userId");

    http.Response res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
    );
    _data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return GetFavoriteListMovieModal.fromJson(_data);
    }
    return GetFavoriteListMovieModal.fromJson(_data);
  }
}
