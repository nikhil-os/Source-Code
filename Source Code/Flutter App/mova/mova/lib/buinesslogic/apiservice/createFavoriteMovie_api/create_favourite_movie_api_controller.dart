import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

import 'createFavoritemovie_modal.dart';

class CreateFavoriteMovieProvider with ChangeNotifier {
  dynamic _data;
  dynamic get data => _data;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<CreatefavoritemovieModal> createFavoriteMovie(movieId) async {
    _isLoading = true;
    notifyListeners();

    var headers = {
      'key': AppUrls.SECRET_KEY,
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse(AppUrls.BASE_URL + AppUrls.favorite));
    request.body = json.encode({
      "userId": userId,
      "movieId": movieId,
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        _data = json.decode(responseBody);
      } else {
        log("response.reasonPhrase :: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("CreateFavoriteMovie Error: $e");
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    if (_data == null) {
      throw Exception('Failed to create favorite movie - no response data');
    }
    return CreatefavoritemovieModal.fromJson(_data);
  }

  double _appBarOpacity = 0.0;
  double get appBarOpacity => _appBarOpacity;

  void updateAppBarOpacity(double offset) {
    _appBarOpacity = (offset / 200).clamp(0.0, 0.6);
    notifyListeners();
  }
}
