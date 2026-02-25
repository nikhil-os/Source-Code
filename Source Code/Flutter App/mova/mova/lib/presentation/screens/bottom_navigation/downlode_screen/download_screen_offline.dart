// // ignore_for_file: cancel_subscriptions
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
// import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
// import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
// import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
// import 'package:webtime_movie_ocean/presentation/screens/videoPlayer/video_player.dart';
//
// class DownloadOffline extends StatefulWidget {
//   const DownloadOffline({Key? key}) : super(key: key);
//
//   @override
//   State<DownloadOffline> createState() => _DownloadOfflineState();
// }
//
// class _DownloadOfflineState extends State<DownloadOffline> {
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(
//                 left: SizeConfig.blockSizeHorizontal * 4,
//                 top: SizeConfig.blockSizeVertical * 6,
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     height: SizeConfig.screenHeight / 23,
//                     width: SizeConfig.screenWidth / 10,
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(AssetValues.appLogo),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: SizeConfig.blockSizeHorizontal * 2,
//                   ),
//                   Text(
//                     "Download",
//                     style: GoogleFonts.urbanist(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             /// Get All Download Movie List ///
//
//             (DownloadDatalenth == null)
//                 ? Column(
//                     children: [
//                       SizedBox(
//                         height: SizeConfig.screenHeight / 4,
//                       ),
//                       SizedBox(
//                         height: SizeConfig.screenHeight / 4,
//                         child: (getStorage.read('isDarkMode') == true)
//                             ? SvgPicture.asset(MovixIcon.emptyList_Dark)
//                             : SvgPicture.asset(MovixIcon.emptyList),
//                       ),
//                       SizedBox(
//                         height: SizeConfig.blockSizeVertical * 5,
//                       ),
//                       Text(
//                         "Your Download is Empty",
//                         style: GoogleFonts.urbanist(
//                           fontSize: 20,
//                           color: ColorValues.redColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   )
//                 : SizedBox(
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: DownloadDatalenth,
//                       itemBuilder: (context, i) {
//                         return Padding(
//                           padding: EdgeInsets.only(
//                             left: SizeConfig.blockSizeHorizontal * 5,
//                             right: SizeConfig.blockSizeHorizontal * 5,
//                             top: SizeConfig.blockSizeVertical * 0.5,
//                             bottom: SizeConfig.blockSizeVertical * 2,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               InkWell(
//                                 child: Stack(
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                           fit: BoxFit.fill,
//                                           image: FileImage(File(
//                                               "/storage/emulated/0/Android/data/com.mova.android/files/${DownloadData["download"][i]["movieTitle"]}image")),
//                                           // image: NetworkImage(
//                                           //     "${downloadMovieList.getAllDownloadMovieList[i].movieImage}"),
//                                         ),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       height: SizeConfig.screenHeight / 8,
//                                       width: SizeConfig.screenWidth / 3,
//                                     ),
//                                     Positioned(
//                                       top: SizeConfig.blockSizeVertical * 4.5,
//                                       left: SizeConfig.blockSizeHorizontal * 14,
//                                       child: SvgPicture.asset(
//                                         MovixIcon.boldPlay,
//                                         height:
//                                             SizeConfig.blockSizeVertical * 3,
//                                         color: ColorValues.whiteColor,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 onTap: () {
//                                   Get.to(
//                                     VideoPlayers(
//                                       name: DownloadData["download"][i]
//                                               ["movieTitle"]
//                                           .toString(),
//                                       link: "",
//                                       type: false,
//                                     ),
//                                   );
//                                 },
//                               ),
//                               SizedBox(
//                                 width: SizeConfig.blockSizeHorizontal * 3,
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(
//                                     width: Get.width/2.2,
//                                     child: Text(
//                                       "${DownloadData["download"][i]["movieTitle"]}",
//                                       style: GoogleFonts.urbanist(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14),overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: SizeConfig.blockSizeVertical * 2,
//                                   ),
//                                   Text(
//                                     "3h",
//                                     style: GoogleFonts.urbanist(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                   SizedBox(
//                                     height: SizeConfig.blockSizeVertical * 2,
//                                   ),
//                                   Container(
//                                     alignment: Alignment.center,
//                                     height: SizeConfig.screenHeight / 35,
//                                     decoration: BoxDecoration(
//                                       color: (getStorage.read('isDarkMode') ==
//                                               true)
//                                           ? ColorValues.redColor
//                                               .withValues(alpha:0.08)
//                                           : ColorValues.redBoxColor,
//                                       borderRadius: BorderRadius.circular(5),
//                                     ),
//                                     padding: EdgeInsets.only(
//                                         left:
//                                             SizeConfig.blockSizeHorizontal * 3,
//                                         right:
//                                             SizeConfig.blockSizeHorizontal * 2),
//                                     child: Text(
//                                       "1.5 GB",
//                                       style: GoogleFonts.urbanist(
//                                         color: ColorValues.redColor,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const Spacer(),
//
//                               /// Delete a Movie ///
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
