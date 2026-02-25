import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/creat_user/create_user_modal.dart';

/// Create User Profile ///
class CreatProfileProvider {
  final Dio _dio = Dio();

  Future<CreateUserModal> creatprofile(String? email, String? password, int loginType, String? fcmToken, String? identity, String? name,String? image) async {
    final queryParameters = {"key": AppUrls.SECRET_KEY};
    Response response = await _dio.post(AppUrls.BASE_URL + AppUrls.createUser,
        queryParameters: queryParameters,
        options: Options(
          headers: {"key": AppUrls.SECRET_KEY},
        ),data:  jsonEncode(
        <String, dynamic>{
          "email": email,
          "password": password,
          "loginType": loginType,
          "fcmToken": fcmToken,
          "identity": identity,
          "fullName": name,
          "image": image
        },
      ),);
    if(response.statusCode == 200){
      return CreateUserModal.fromJson(response.data);
    }
    return CreateUserModal.fromJson(response.data);


  }
}
