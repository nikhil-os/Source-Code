import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app_url.dart';
import 'categories_modal.dart';

/// Movie All Categories ///
class CategoriesProvider {
  static Future<CategoriesModal> categories() async {
    try {
      final uri = Uri.parse(AppUrls.categories);
      http.Response res = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8', "key": AppUrls.SECRET_KEY},
      );
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return CategoriesModal.fromJson(data);
      }
      return CategoriesModal.fromJson(data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
