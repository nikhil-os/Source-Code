// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';

import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../presentation/utils/app_class.dart';

/// Update User ///
// class UpdateUserProvider with ChangeNotifier {
//   dynamic _data;
//
//   dynamic get data => _data;
//
//   updateUserDetails(BuildContext context, String? name, String? nicknames, String? country, String? gender,
//       String interest) async {
//     var request = http.MultipartRequest(
//       "PATCH",
//       Uri.parse(AppUrls.updateUser),
//     );
//
//     if (updateProfileImage == null) {
//     } else {
//       var addImage = await http.MultipartFile.fromPath('image', updateProfileImage!.path);
//       request.files.add(addImage);
//     }
//
//     request.headers.addAll({"key": AppUrls.SECRET_KEY});
//
//     Map<String, String> requestBody = <String, String>{
//       "userId": userId,
//       "fullName": name ?? "MovaUser123",
//       "nickName": nicknames ?? "mova",
//       "country": country ?? "India",
//       "gender": gender ?? "Male",
//       "interest": interest,
//     };
//
//     request.fields.addAll(requestBody);
//
//     var res1 = await request.send();
//
//     var res = await http.Response.fromStream(res1);
//
//     _data = jsonDecode(res.body);
//
//     if (res.statusCode == 200) {
//       return UpdateUserModal.fromJson(_data);
//     }
//     return UpdateUserModal.fromJson(_data);
//   }
// }

class UpdateUserProvider with ChangeNotifier {
  dynamic _data;

  dynamic get data => _data;
  updateUserDetails({
    String? image,
    String? name,
    String? nicknames,
    String? country,
    String? gender,
    // String? interest,
  }) async {
    var headers = {
      'key': AppUrls.SECRET_KEY,
      'Content-Type': 'application/json',
    };
    var request = http.Request('PATCH', Uri.parse(AppUrls.updateUser));

    request.body = json.encode({
      'userId': userId,
      'image': image,
      'fullName': name,
      'nickName': nicknames,
      'country': country,
      'gender': gender,
      // 'interest': interest,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      log("Update Response Body: $responseBody");

      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      _data = jsonResponse;
      String image = jsonResponse['user']['image'];
      String id = jsonResponse['user']['_id'];

      log("Image From Api ::: $image");
      log("Id From Api ::: $id");

      var convertedImage = PreviewNetworkImage(id: id, image: image);

      SharedPreferences pref = await SharedPreferences.getInstance();

      await pref.setString("userProfileImage", convertedImage.toString());
      userProfileImage = pref.getString("userProfileImage")!;
    } else {
      log(response.reasonPhrase.toString());
    }
  }
}
