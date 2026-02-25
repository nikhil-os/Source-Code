import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/complain_api/model/complent_model.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

class CreateComplainService {
  final client = http.Client();

  static Future<ComplentModel> createComplain({required String description, required String contactNumber, required String image}) async {
    try {
      final uri = Uri.parse("${AppUrls.userComplain}?userId=$userId");

      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll({"key": AppUrls.SECRET_KEY});

      Map<String, String> requestBody = <String, String>{
        "description": description,
        "contactNumber": contactNumber,
        "image": image,
      };

      request.fields.addAll(requestBody);
      var res1 = await request.send();
      var res = await http.Response.fromStream(res1);
      log("complain Api Respone :: ${res.body}");
      if (res.statusCode == 200) {
        return ComplentModel.fromJson(jsonDecode(res.body));
      } else {
        log("complain Api Respone status code :: ${res.statusCode.toString()}");
        return ComplentModel.fromJson(jsonDecode(res.body));
      }
    } catch (e) {
      log("Complain Api error :: $e");
      throw Exception(e);
    }
  }
}
