import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';

class CustomDownload {
  static Future<String?> download(String videoUrl, String videoId) async {
    try {
      final response = await http.get(Uri.parse(videoUrl));
      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;

        final filePath = await getExternalStorageDirectory();

        final downloadPath = '${filePath?.path}/MyDownload';

        Directory(downloadPath).createSync(recursive: true);

        final downloaded = '$downloadPath/$videoId.mp4';

        log("Downloaded Video Path => $downloaded");

        log("Download Video Successfully");

        final File file = File(downloaded);

        await file.writeAsBytes(bytes);

        return downloaded;
      } else {
        log('Download Video Error !!!');
      }
    } catch (e) {
      log("Download Video Failed !!!");
    }
    return null;
  }

  // static Future<String?> downloadImage(String imageUrl, String imageId) async {
  //   try {
  //     final response = await http.get(Uri.parse(imageUrl));
  //     if (response.statusCode == 200) {
  //       final Uint8List bytes = response.bodyBytes;
  //
  //       final filePath = await getExternalStorageDirectory();
  //       final downloadPath = '${filePath?.path}/MyDownload';
  //
  //       Directory(downloadPath).createSync(recursive: true);
  //
  //       final downloaded = '$downloadPath/$imageId.jpg';
  //
  //       final File file = File(downloaded);
  //       await file.writeAsBytes(bytes);
  //
  //       log("Downloaded Image Path => $downloaded");
  //       return downloaded;
  //     } else {
  //       log('Download Image Error: HTTP ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     log("Download Image Failed: $e");
  //   }
  //   return null;
  // }

  static Future<String?> downloadImage(String imageUrl, String imageId) async {
    int retryCount = 0;
    const maxRetries = 1;

    while (retryCount < maxRetries) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final Uint8List bytes = response.bodyBytes;

          final filePath = await getExternalStorageDirectory();
          final downloadPath = '${filePath?.path}/MyDownload';

          Directory(downloadPath).createSync(recursive: true);

          final downloaded = '$downloadPath/$imageId.jpg';
          final File file = File(downloaded);
          await file.writeAsBytes(bytes);

          log("✅ Downloaded Image Path => $downloaded");
          return downloaded;
        } else {
          log('❌ Download Image Error: HTTP ${response.statusCode}');
        }
      } catch (e) {
        log("⚠️ Download Image Attempt ${retryCount + 1} Failed: $e");
      }

      retryCount++;
      await Future.delayed(Duration(seconds: 1)); // delay before retry
    }

    log("❌ Failed to download image after $maxRetries attempts");
    return null;
  }

  static Future<String?> seriesDownloadImage(String imageUrl, String imageId) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        final filePath = await getExternalStorageDirectory();
        final downloadPath = '${filePath?.path}/MyDownload';
        Directory(downloadPath).createSync(recursive: true);
        final downloaded = '$downloadPath/$imageId.jpg';
        final File file = File(downloaded);
        await file.writeAsBytes(bytes);
        log("Downloaded Image Path => $downloaded");
        return downloaded;
      } else {
        log('Download Image Error: HTTP ${response.statusCode}');
      }
    } catch (e) {
      log("Download Image Failed: $e");
    }
    return null;
  }
}
