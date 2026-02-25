import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';


/// Create Download Movie ///
class CreatDownloadProvider with ChangeNotifier {
  dynamic _data;
  dynamic get data => _data;

   creatdownload(String userId,String movieId,String type) async {
    final uri = Uri.parse(AppUrls.download);

    http.Response res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "key": AppUrls.SECRET_KEY
      },
      body: jsonEncode(<String , String>{
        "userId":userId,
        "movieId":movieId,
      "type":type})
    );
    _data = jsonDecode(res.body);
    if (res.statusCode == 200) {

    }

  }
}
