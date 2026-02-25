// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
//
// class NormalVideoUi extends StatelessWidget {
//   const NormalVideoUi({
//     super.key,
//     required this.videoId,
//     required this.title,
//     required this.videoImage,
//     required this.videoUrl,
//     required this.videoTime,
//     required this.channelId,
//     required this.channelImage,
//     required this.channelName,
//     required this.views,
//     required this.uploadTime,
//   });
//
//   final String videoId;
//   final String title;
//   final String videoImage;
//   final String videoUrl;
//   final int videoTime;
//   final String channelId;
//   final String channelImage;
//   final String channelName;
//   final int views;
//   final String uploadTime;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           height: 200,
//           width: Get.width,
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//           decoration: BoxDecoration(
//             color: ColorValues.grayColor,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Stack(
//             children: [
//               Image(
//                 image: NetworkImage(videoImage),
//                 height: 100,
//                 width: 100,
//               ),
//               Positioned(
//                 right: 20,
//                 bottom: 15,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10), color: ColorValues.blackColor),
//                   child: Text(
//                     CustomFormatTime.convert(videoTime),
//                     style: GoogleFonts.urbanist(color: ColorValues.whiteColor, fontSize: 11),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(width: 10),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.bold),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     "$channelName - ${CustomFormatNumber.convert(views)} Views - $uploadTime",
//                     style: GoogleFonts.urbanist(fontSize: 12, color: ColorValues.grayColor),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 5),
//           ],
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }
// }
//
// class CustomFormatTime {
//   static String convert(int milliseconds) {
//     int seconds = (milliseconds / 1000).floor();
//     int hours = (seconds / 3600).floor();
//     int minutes = ((seconds % 3600) / 60).floor();
//     int remainingSeconds = (seconds % 60);
//
//     return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }
// }
//
// class CustomFormatNumber {
//   static String convert(int number) {
//     if (number >= 10000000) {
//       double millions = number / 1000000;
//       return '${millions.toStringAsFixed(1)}M';
//     } else if (number >= 1000) {
//       double thousands = number / 1000;
//       return '${thousands.toStringAsFixed(1)}k';
//     } else {
//       return number.toString();
//     }
//   }
// }
