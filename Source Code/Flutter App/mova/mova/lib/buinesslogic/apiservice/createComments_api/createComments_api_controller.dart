// ignore_for_file: avoid_print, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/createComments_api/create_comments_modal.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

/// Create Comment of Movie ///
class CreateCommentProvider with ChangeNotifier {
  dynamic _data;
  dynamic get data => _data;

  Future<CreateCommentsModal> createComment(String movieId, String comment) async {
    final uri = Uri.parse(AppUrls.createComments);
    http.Response res = await http.post(
      uri,
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
      body: jsonEncode(
        <String, String>{"userId": userId, "movieId": movieId, "comment": comment},
      ),
    );
    _data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return CreateCommentsModal.fromJson(_data);
    }
    return CreateCommentsModal.fromJson(_data);
  }
}
