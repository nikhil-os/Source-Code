import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

import 'comment_list_modal.dart';

/// All Comments of List ///
class CommentListProvider {
  static Future<CommentListModal> commentList(String movieId) async {
    final uri = Uri.parse("${AppUrls.commentList}?movieId=$movieId&start=0&limit=20&userId=$userId");

    http.Response res = await http.get(uri, headers: {"key": AppUrls.SECRET_KEY});
    var data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      return CommentListModal.fromJson(data);
    }
    return CommentListModal.fromJson(data);
  }
}
