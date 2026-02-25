import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/customModal/faq_modal.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

/// FAQ ///
class FAQ {
  final Dio _dio = Dio();

  Future<FaqModal> faq() async {
    Response response = await _dio.get(
      AppUrls.faq,
      options: Options(headers: {"key": AppUrls.SECRET_KEY}),
    );
     Faqdata = response.data["FaQ"];
    log("$Faqdata");
    if (response.statusCode == 200) {
      return FaqModal.fromJson(response.data);
    }
    return FaqModal.fromJson(response.data);
  }
}
