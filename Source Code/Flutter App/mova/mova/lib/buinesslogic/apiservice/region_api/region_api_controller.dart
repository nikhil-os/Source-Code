// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'dart:convert';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/region_api/region_modal.dart';

/// Get All Region of Movie ///
class RegionProvider  {
static  Future<RegionModal> region() async {
    try{
      final uri = Uri.parse(AppUrls.region);
      http.Response res = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "key": AppUrls.SECRET_KEY
        },
      );
     var  data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return RegionModal.fromJson(data);
      }
      return RegionModal.fromJson(data);
    }
    catch(e){
      throw Exception(e);
    }

  }
}
