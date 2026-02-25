import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/delete_download_api/delete_download_api_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/getDownolad_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/movieDetailsController.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/theme/theme.dart';
import 'package:webtime_movie_ocean/presentation/widget/nativads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../widget/size_configuration.dart';
import 'download_history.dart';
import 'download_video_player.dart';

class DownloadTab extends StatefulWidget {
  const DownloadTab({super.key});

  @override
  State<DownloadTab> createState() => _DownloadTabState();
}

class _DownloadTabState extends State<DownloadTab> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;
  getAllDownloadMovieController downloadMovieList =
      Get.put(getAllDownloadMovieController());
  movieDetailsController movieAllDetails = Get.put(movieDetailsController());

  Future<List<FileInfo>> getDownloadedVideos() async {
    String appDocPath =
        '/storage/emulated/0/Android/data/com.mova.android/files/WebTimeMovieOcean';
    String videosFolderPath = appDocPath;
    log("folder path :: $videosFolderPath");

    Directory(videosFolderPath).createSync(recursive: true);

    List<FileInfo> videoFiles = Directory(videosFolderPath)
        .listSync()
        .where((entity) => entity is File && entity.path.endsWith('.mp4'))
        .map((file) {
      FileStat fileStat = file.statSync();
      return FileInfo(
        filePath: file.path,
        lastModified: fileStat.modified,
        fileSize: fileStat.size,
      );
    }).toList();

    return videoFiles;
  }

  onGet(String videoPath) async {
    final videoThumbnail = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 400,
      quality: 100,
    );
    if (videoThumbnail != null) {
      log("Picked Video Thumbnail Url => $videoThumbnail");
      return videoThumbnail;
    } else {
      log("Picked Video Thumbnail Error");
      return Null;
    }
  }

  @override
  void initState() {
    log("Initstate called");

    DownloadHistory.onGet();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );

    super.initState();

    _videoPlayerController = VideoPlayerController.file(File(
        "/storage/emulated/0/Android/data/com.mova.android/files/WebTimeMovieOcean/64e086cc5527540d6d63d0b9.mp4"));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: false,
    );
  }

  @override
  void dispose() {
    log("dispose");

    _videoPlayerController?.dispose();
    _chewieController?.dispose();

    // Reset orientation for baki app
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  void _playVideo(String videoUrl, String title) async {
    log("hello");
    var connectivityResult = await Connectivity().checkConnectivity();

    if (!mounted) return;

    if (connectivityResult.contains(ConnectivityResult.none)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              VideoPlayerPage(videoUrl: videoUrl, title: title),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(
            videoUrl: videoUrl,
            title: title,
          ),
        ),
      );
    }
  }

  Future<void> _deleteVideo(int index, String filePath) async {
    try {
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        log("✅ Video file deleted: $filePath");

        Fluttertoast.showToast(
          msg: "Video deleted successfully",
          textColor: Colors.white,
          backgroundColor: ColorValues.redColor,
        );
      } else {
        log("⚠️ File not found, skipping delete: $filePath");
      }

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      setState(() {
        log("🗑️ Updating download lists");

        if (index >= 0 && index < DownloadHistory.mainDownloadHistory.length) {
          final videoId = DownloadHistory.mainDownloadHistory[index]["videoId"];
          downloadedMovie.removeWhere((item) => item == videoId);

          DownloadHistory.mainDownloadHistory.removeAt(index);

          preferences.setStringList("DownloadList", downloadedMovie);
          preferences.setString("downloadHistory",
              json.encode(DownloadHistory.mainDownloadHistory));

          log("✅ Removed videoId from history: $videoId");
        } else {
          log("⚠️ Invalid index: $index");
        }
      });
    } catch (e) {
      log("❌ video delete error :: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (getStorage.read('isDarkMode') == true)
          ? ColorValues.scaffoldBg
          : ColorValues.whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            color: (getStorage.read('isDarkMode') == true)
                ? ColorValues.appBarColor
                : ColorValues.whiteColor,
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 5,
            left: 20,
            right: 16,
            bottom: 16,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: (getStorage.read('isDarkMode') == true)
                        ? ColorValues.smallContainerBg
                        : Colors.grey.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(11),
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: (getStorage.read('isDarkMode') == true)
                        ? ColorValues.whiteColor
                        : ColorValues.blackColor,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                StringValue.download.tr,
                style: allTitleStyle,
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),
      body: Obx(
        () => DownloadHistory.mainDownloadHistory.isEmpty
            ? Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight / 4,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight / 4,
                      child: (getStorage.read('isDarkMode') == true)
                          ? SvgPicture.asset(MovixIcon.emptyListDark)
                          : SvgPicture.asset(MovixIcon.emptyList),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 4,
                    ),
                    Text(
                      StringValue.yourListIsEmpty.tr,
                      style: GoogleFonts.urbanist(
                          fontSize: 20,
                          color: ColorValues.redColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 1.5,
                    ),
                    Text(
                      StringValue.notAdded.tr,
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : SizedBox(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 8.0, top: 15),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: DownloadHistory.mainDownloadHistory.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: ColorValues.blackColor),
                                color: (getStorage.read('isDarkMode') == true)
                                    ? ColorValues.darkModeSecond
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: Get.height / 7,
                              width: Get.width / 2.60,
                              child: Image.file(
                                File(DownloadHistory.mainDownloadHistory[index]
                                        ["videoImage"]
                                    .toString()),
                                fit: BoxFit.fill,
                              ),
                            ),
                            onTap: () => _playVideo(
                              DownloadHistory.mainDownloadHistory[index]
                                      ["videoUrl"]
                                  .toString(),
                              DownloadHistory.mainDownloadHistory[index]
                                      ["videoTitle"]
                                  .toString(),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: Get.width / 1.75,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      DownloadHistory.mainDownloadHistory[index]
                                              ["videoTitle"]
                                          .toString(),
                                      style: GoogleFonts.urbanist(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: (getStorage.read('isDarkMode') ==
                                                true)
                                            ? ColorValues.whiteColor
                                            : ColorValues.blackColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "${DownloadHistory.mainDownloadHistory[index]["videoType"].toString()},",
                                    style: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${DownloadHistory.mainDownloadHistory[index]["country"]}",
                                    style: GoogleFonts.urbanist(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 35,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color:
                                              (getStorage.read('isDarkMode') ==
                                                      true)
                                                  ? ColorValues.redColor
                                                      .withValues(alpha: 0.08)
                                                  : ColorValues.redBoxColor,
                                        ),
                                        child: Text(
                                          StringValue.movie.tr,
                                          style: GoogleFonts.urbanist(
                                              color: ColorValues.redColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        icon: const Icon(
                                          Icons.delete,
                                          color: ColorValues.redColor,
                                        ),
                                        onPressed: () {
                                          Get.bottomSheet(
                                            Container(
                                              height: Get.height / 2.90,
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig
                                                          .blockSizeHorizontal *
                                                      1.5,
                                                  right: SizeConfig
                                                          .blockSizeHorizontal *
                                                      1.5),
                                              decoration: BoxDecoration(
                                                color: (getStorage.read(
                                                            'isDarkMode') ==
                                                        true)
                                                    ? ColorValues.darkModeSecond
                                                    : ColorValues.whiteColor,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(30),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: SizeConfig
                                                            .blockSizeVertical *
                                                        1,
                                                  ),
                                                  Container(
                                                    width: SizeConfig
                                                            .blockSizeHorizontal *
                                                        15,
                                                    height: 3,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: (getStorage.read(
                                                                  'isDarkMode') ==
                                                              true)
                                                          ? ColorValues
                                                              .darkModeThird
                                                          : ColorValues
                                                              .boxColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig
                                                            .blockSizeVertical *
                                                        2,
                                                  ),
                                                  Text(
                                                    StringValue.delete.tr,
                                                    style: GoogleFonts.urbanist(
                                                        fontSize: 20,
                                                        color: ColorValues
                                                            .redColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig
                                                            .blockSizeVertical *
                                                        2,
                                                  ),
                                                  const Divider(),
                                                  SizedBox(
                                                    height: SizeConfig
                                                            .blockSizeVertical *
                                                        2,
                                                  ),
                                                  Text(
                                                    StringValue.deleteMovie.tr,
                                                    style: GoogleFonts.urbanist(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig
                                                            .blockSizeVertical *
                                                        2,
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig
                                                            .blockSizeVertical *
                                                        5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Container(
                                                          height: SizeConfig
                                                                  .screenHeight /
                                                              15,
                                                          width: SizeConfig
                                                                  .screenWidth /
                                                              2.3,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            color: (getStorage.read(
                                                                        'isDarkMode') ==
                                                                    true)
                                                                ? ColorValues
                                                                    .darkModeThird
                                                                : ColorValues
                                                                    .redBoxColor,
                                                          ),
                                                          child: Text(
                                                            StringValue
                                                                .cancel.tr,
                                                            style: GoogleFonts
                                                                .urbanist(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color: (getStorage
                                                                          .read(
                                                                              'isDarkMode') ==
                                                                      true)
                                                                  ? ColorValues
                                                                      .whiteColor
                                                                  : ColorValues
                                                                      .redColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        child: Container(
                                                          height: SizeConfig
                                                                  .screenHeight /
                                                              15,
                                                          width: SizeConfig
                                                                  .screenWidth /
                                                              2.3,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            color: ColorValues
                                                                .redColor,
                                                          ),
                                                          child: Text(
                                                            StringValue
                                                                .yesDelete.tr,
                                                            style: GoogleFonts
                                                                .urbanist(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color: ColorValues
                                                                  .whiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Get.back();

                                                          if (index >= 0 &&
                                                              index <
                                                                  DownloadHistory
                                                                      .mainDownloadHistory
                                                                      .length) {
                                                            var historyItem =
                                                                DownloadHistory
                                                                        .mainDownloadHistory[
                                                                    index];
                                                            log("historyItem :: $historyItem");

                                                            if (historyItem
                                                                .containsKey(
                                                                    "videoUrl")) {
                                                              final videoUrl =
                                                                  historyItem[
                                                                          "videoUrl"]
                                                                      .toString();

                                                              _deleteVideo(
                                                                  index,
                                                                  videoUrl);

                                                              if (index >= 0 &&
                                                                  index <
                                                                      downloadedMovie
                                                                          .length) {
                                                                log("deleted movie id ::: ${downloadedMovie[index]}");
                                                                downloadedMovie
                                                                    .removeAt(
                                                                        index);
                                                              } else {
                                                                log("⚠️ Invalid index in downloadedMovie list: $index");
                                                              }
                                                            } else {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      StringValue
                                                                          .invalidVideoData
                                                                          .tr),
                                                                ),
                                                              );
                                                            }
                                                          } else {
                                                            log("⚠️ Invalid index for mainDownloadHistory: $index");
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return (index % 3 == 0 && index > 1)
                        ? const NativAdsScreen()
                        : const SizedBox();
                  },
                ),
              ),
      ),
    );
  }
}

Shimmer shimmer() {
  return Shimmer.fromColors(
    highlightColor: (getStorage.read('isDarkMode') == true)
        ? Colors.white12
        : Colors.grey.shade100,
    baseColor: (getStorage.read('isDarkMode') == true)
        ? Colors.white24
        : Colors.grey.shade300,
    child: SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, i) {
          return Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 5,
              right: SizeConfig.blockSizeHorizontal * 5,
              top: SizeConfig.blockSizeVertical * 0.5,
              bottom: SizeConfig.blockSizeVertical * 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorValues.grayColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: SizeConfig.screenHeight / 8,
                    width: SizeConfig.screenWidth / 3,
                  ),
                  onTap: () {},
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 3,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 8,
                      color: ColorValues.grayColor,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    Container(
                      width: 15,
                      height: 8,
                      color: ColorValues.grayColor,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    Container(
                      width: 30,
                      height: 8,
                      color: ColorValues.grayColor,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

/// Delete A Movie ///
InkWell delete(
    int i, DeleteDownloadMovieProvider deleteDownload, BuildContext context) {
  Future<void> deleteVideo(int index) async {
    try {
      if (index >= 0 && index < DownloadHistory.mainDownloadHistory.length) {
        String filePath =
            DownloadHistory.mainDownloadHistory[index]["videoUrl"];
        File file = File(filePath);
        await file.delete();
        DownloadHistory.mainDownloadHistory.removeAt(index);
        Fluttertoast.showToast(
            msg: StringValue.videoDeletedSuccessfully.tr,
            textColor: Colors.white,
            backgroundColor: ColorValues.redColor);

        await DownloadHistory.onSet();
      } else {
        Fluttertoast.showToast(
            msg: StringValue.invalidIndexForVideoDeletion.tr,
            textColor: Colors.white,
            backgroundColor: ColorValues.redColor);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: StringValue.somethingWentWrong.tr,
          textColor: Colors.white,
          backgroundColor: ColorValues.redColor);
    }
  }

  return InkWell(
    child: SvgPicture.asset(
      MovixIcon.delete,
      height: SizeConfig.blockSizeVertical * 2.5,
      color: ColorValues.redColor,
    ),
    onTap: () {
      Get.bottomSheet(
        Container(
          height: SizeConfig.screenHeight * 5.5,
          padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 1.5,
              right: SizeConfig.blockSizeHorizontal * 1.5),
          decoration: BoxDecoration(
            color: (getStorage.read('isDarkMode') == true)
                ? ColorValues.darkModeSecond
                : ColorValues.whiteColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.blockSizeVertical * 1,
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal * 15,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: (getStorage.read('isDarkMode') == true)
                      ? ColorValues.darkModeThird
                      : ColorValues.boxColor,
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              Text(
                StringValue.delete.tr,
                style: GoogleFonts.urbanist(
                    fontSize: 20,
                    color: ColorValues.redColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              const Divider(),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              Text(
                StringValue.deleteMovie.tr,
                style: GoogleFonts.urbanist(
                    fontSize: 17, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 2,
                  right: SizeConfig.blockSizeHorizontal * 2,
                  top: SizeConfig.blockSizeVertical * 3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(''),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: SizeConfig.screenHeight / 8,
                      width: SizeConfig.screenWidth / 2.5,
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 4,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Get.width / 2.2,
                          child: Text(
                            '',
                            style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.bold, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 2,
                        ),
                        Text(
                          "",
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              const Divider(),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: SizeConfig.screenHeight / 15,
                      width: SizeConfig.screenWidth / 2.3,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: (getStorage.read('isDarkMode') == true)
                            ? ColorValues.darkModeThird
                            : ColorValues.redBoxColor,
                      ),
                      child: Text(
                        StringValue.cancel.tr,
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: (getStorage.read('isDarkMode') == true)
                              ? ColorValues.whiteColor
                              : ColorValues.redColor,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      height: SizeConfig.screenHeight / 15,
                      width: SizeConfig.screenWidth / 2.3,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: ColorValues.redColor,
                      ),
                      child: Text(
                        StringValue.yesDelete.tr,
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: ColorValues.whiteColor,
                        ),
                      ),
                    ),
                    onTap: () {
                      log("deleted video url :: ${DownloadHistory.mainDownloadHistory[0]["videoUrl"]}");
                      deleteVideo(
                          DownloadHistory.mainDownloadHistory[0]["videoUrl"]);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
              ),
            ],
          ),
        ),
      );
    },
  );
}

class FileInfo {
  final String filePath;
  final DateTime lastModified;
  final int fileSize;

  FileInfo({
    required this.filePath,
    required this.lastModified,
    required this.fileSize,
  });
}
