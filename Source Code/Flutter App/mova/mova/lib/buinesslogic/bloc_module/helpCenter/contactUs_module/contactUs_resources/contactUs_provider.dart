import 'package:dio/dio.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/customModal/contactUs_modal.dart';

/// Contact us ////
class GetContactus {
  final Dio _dio = Dio();

  Future<ContactUsModal> contactUs () async {
    Response response = await _dio.get(AppUrls.contactUs,
        options: Options(headers: {"key": AppUrls.SECRET_KEY}));
    if(response.statusCode == 200){
      return ContactUsModal.fromJson(response.data);
    }
    return ContactUsModal.fromJson(response.data);
  }

}