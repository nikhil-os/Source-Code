// ignore_for_file: avoid_print, file_names

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'commentLike_modal.dart';

/// Movie Comments Like And Dislike ///
class CommentLikeProvider with ChangeNotifier {
  dynamic _data;
  dynamic get data => _data;

  Future<CommentLikeModal> commentLike(BuildContext context, commentId) async {
    final uri = Uri.parse(AppUrls.commentLike);
    http.Response res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "key": AppUrls.SECRET_KEY
      },
      body: jsonEncode(
        <String, String>{
          "userId": userId,
          "commentId": commentId
        },
      ),
    );
    _data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      return CommentLikeModal.fromJson(_data);
    }
    return CommentLikeModal.fromJson(_data);
  }
}
