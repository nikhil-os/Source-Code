import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/complain_api/model/complent_model.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_class.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

class userComplainProvider with ChangeNotifier {
  ComplentModel? complentModel;

  dynamic _data;

  dynamic get data => _data;
  updateUserComplainDetails({
    String? image,
    String? description,
    String? contactNumber,
  }) async {
    Map<String, String> queryParams = {
      'userId': userId,
    };
    var headers = {
      'key': AppUrls.SECRET_KEY,
      'Content-Type': 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var request = http.Request('POST', Uri.parse('${AppUrls.userComplain}?$queryString'));
    request.body = json.encode({
      'image': image,
      'description': description,
      'contactNumber': contactNumber,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      log("Complain Response Body: $responseBody");
      Fluttertoast.showToast(
        msg: "Ticket has been sent successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorValues.redColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Get.back();

      Map<String, dynamic> jsonResponse = json.decode(responseBody);

      complentModel = ComplentModel.fromJson(jsonResponse);

      var convertedImage = PreviewNetworkImage(
        id: complentModel?.ticketByUser?.userId ?? "",
        image: complentModel?.ticketByUser?.image ?? "",
      );

      SharedPreferences pref = await SharedPreferences.getInstance();

      await pref.setString("userProfileImage", convertedImage.toString());
      userProfileImage = pref.getString("userProfileImage")!;
    } else {
      log(response.reasonPhrase.toString());
    }
  }
}
