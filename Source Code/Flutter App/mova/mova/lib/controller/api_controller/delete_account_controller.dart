import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/presentation/utils/routes/app_pages.dart';

class DeleteAccountController extends GetxController {
  Future<void> deleteAccount(String userId) async {
    Get.dialog(const Center(
      child: SpinKitCircle(
        color: Colors.red,
      ),
    ));
    try {
      final uri = Uri.parse("${AppUrls.deleteAccount}?userId=$userId");

      log("Delete Account url ::$uri");
      final header = {"Key": AppUrls.SECRET_KEY};
      var response = await http.delete(uri, headers: header);
      log("delete Account Response :: ${response.body}");
      if (response.statusCode == 200) {
        await Fluttertoast.showToast(
          msg: "Account Delete SuccessFully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withValues(alpha: 0.35),
          textColor: Colors.white,
          fontSize: 16.0,
        );

        Get.back();
        Get.offNamed(Routes.welcome);
      }
    } catch (e) {
      log("Api Response Error :: $e");
    }
  }
}
