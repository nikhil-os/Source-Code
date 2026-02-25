import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/controller/api_controller/file_upload/file_upload_model.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

class FileUploadService extends GetxService {
  Future<FileUploadModel?> Fileupload({
    required String folderStructure,
    required String keyName,
    File? image,
  }) async {
    log("folderStructure :: $folderStructure");
    log("keyName :: $keyName");

    try {
      final uri = Uri.parse(AppUrls.BASE_URL + AppUrls.uploadFile);
      var request = http.MultipartRequest(
        "POST",
        uri,
      );
      log("file upload url :: $uri");
      if (image != null) {
        var addImage = await http.MultipartFile.fromPath('content', image.path);
        request.files.add(addImage);
      }
      request.headers.addAll({
        "key": AppUrls.SECRET_KEY,
        "Content-Type": "application/json; charset=UTF-8",
      });

      Map<String, String> requestBody = <String, String>{
        "folderStructure": folderStructure,
        "keyName": keyName,
        "content": image!.path,
      };
      request.fields.addAll(requestBody);

      await getStorage.write("folderStructure", folderStructure);
      await getStorage.write("Keyname", keyName);
      folderStructures = getStorage.read("folderStructure");
      keyNames = getStorage.read("Keyname");

      var res1 = await request.send();
      var response = await http.Response.fromStream(res1);

      log("Status code :: ${response.statusCode} \n Responce :: ${response.body}");

      if (response.statusCode == 200) {
        final userdata = jsonDecode(response.body);

        return FileUploadModel.fromJson(userdata);
      } else {
        null;
      }
    } catch (e) {
      log("File upload data:: $e");
      Exception(e);
    }

    log("image : $image");
    return null;
  }
}
