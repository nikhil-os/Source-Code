import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webtime_movie_ocean/controller/api_controller/file_upload/file_upload_model.dart';
import 'package:webtime_movie_ocean/controller/api_controller/file_upload/file_upload_service.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:path/path.dart';

class FileUploadController extends GetxController {
  FileUploadModel? fileUploadModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  String? updatedNewDp = "";

  submit({required File profileImage}) async {
    String fileName = updateProfileImage!.path;
    fileName = basename(fileName);
    var data = await FileUploadService().Fileupload(
      folderStructure: '${StringValue.appName}/userImage',
      keyName: fileName,
      image: profileImage,
    );
    fileUploadModel = data;

    updatedNewDp = fileUploadModel?.url ?? "";
    getStorage.write("updatedNewDp", updatedNewDp.toString());
    log("Read updated profile :: ${getStorage.read("updatedNewDp")}");
    update();
  }

  File? image;

  Future pickImage() async {
    try {
      final imagePick =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagePick == null) return;

      final imageTeam = File(imagePick.path);
      image = imageTeam;

      update();

      Get.back();
    } on PlatformException catch (e) {
      log("fail $e");
    }
  }
}
