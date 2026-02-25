import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

import 'filter_wise_modal.dart';

/// FilterWise Chose Movie ///
class FilterWiseProvider extends ChangeNotifier {
  dynamic _data;

  dynamic get data => _data;

  Future<FilterWiseModal> filterWise(List<String> genre, List<String> region, List<String> year, List<String> selectedType) async {
    try {
      http.Response response = await http.post(
        Uri.parse(AppUrls.filterWise),
        headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
        body: jsonEncode(<String, dynamic>{
          "media_type": selectedType,
          "region": region,
          "genre": genre,
          "year": year,
        }),
      );
      _data = jsonDecode(response.body);
      log("filterwise movie :: $_data");

      log("filterwise movie genre :: ${_data[image]}");

      if (response.statusCode == 200) {
        return FilterWiseModal.fromJson(_data);
      }

      return FilterWiseModal.fromJson(_data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
