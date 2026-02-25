import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/controller/saveuser.dart';

import '../../../presentation/utils/app_var.dart';
import 'create_user_modal.dart';

/// Create User ///
class CreateUserController extends GetxController {
  dynamic _data;
  dynamic get data => _data;
  CreateUserModal? createUserModal;

  Future<CreateUserModal> createUser({
    String? email,
    String? password,
    String? loginType,
    String? fcmToken,
    String? identity,
    String? name,
    String? image,
  }) async {
    log("email : $email");
    log("password : $password");
    log("loginType : $loginType");
    log("fcmToken : $fcmToken");
    log("identity : $identity");
    log("name : $name");
    log("image : $image");

    final body = jsonEncode(
      <String, dynamic>{
        "email": email,
        "password": password,
        "loginType": loginType,
        "fcmToken": fcmToken,
        "identity": identity,
        "fullName": name,
        "image": image
      },
    );
    final uri = Uri.parse(AppUrls.BASE_URL + AppUrls.createUser);

    log("URL :: $uri");
    log("body :: $body");

    try {
      http.Response res = await http
          .post(uri,
              headers: {
                "key": AppUrls.SECRET_KEY,
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: body)
          .timeout(const Duration(seconds: 15));

      log("Response Status code :: ${res.statusCode} \nResponse Body ${res.body}");

      SaveUser.setUser(res.body);
      _data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        log("Now call create user profile");
        createUserModal = CreateUserModal.fromJson(_data);
        log("Now call create :: ${createUserModal!.isProfile}");
        isProfile = createUserModal?.isProfile ?? false;
        log("User profile data :: $isProfile");
        return CreateUserModal.fromJson(_data);
      }
      return CreateUserModal.fromJson(_data);
    } catch (e) {
      log("CreateUser Error: $e");
      _data = {"status": false, "message": "Connection failed: $e"};
      return CreateUserModal.fromJson(_data);
    }
  }
}
