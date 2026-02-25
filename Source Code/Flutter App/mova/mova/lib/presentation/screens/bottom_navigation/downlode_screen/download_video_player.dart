import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerPage({super.key, required this.videoUrl, required this.title});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPage();
}

class _VideoPlayerPage extends State<VideoPlayerPage> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;
  bool isVisible = false;
  bool showIcon = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    _videoPlayerController = VideoPlayerController.file(File(widget.videoUrl))
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) {
        _videoPlayerController.play();
      });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: Get.height / Get.width,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      fullScreenByDefault: true,
      showControlsOnInitialize: false,
    );
  }

  @override
  void dispose() {
    log("dispose");
    _videoPlayerController.dispose();
    _chewieController.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            isVisible = !isVisible;
          });
        },
        child: Scaffold(
          backgroundColor: ColorValues.blackColor,
          body: Stack(children: [
            _videoPlayerController.value.isInitialized
                ? Chewie(controller: _chewieController)
                : const Center(
                    child: SpinKitPouringHourGlass(
                      color: Colors.red,
                      size: 60,
                    ),
                  ),
            (_videoPlayerController.value.isPlaying)
                ? const SizedBox()
                : Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      left: Get.width / 3.6,
                      top: Get.height / 1.7,
                      right: Get.width / 3.5,
                    ),
                  ),
            (_videoPlayerController.value.isPlaying)
                ? const SizedBox()
                : Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 69,
                      top: SizeConfig.blockSizeVertical * 66,
                    ),
                    child: (showIcon)
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                showIcon = false;
                              });
                            },
                            icon: const Icon(
                              Icons.cancel,
                              size: 23,
                            ),
                          )
                        : null,
                  ),
            Center(
              child: Visibility(
                visible: isVisible,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showIcon = true;
                      _videoPlayerController.value.isPlaying ? _videoPlayerController.pause() : _videoPlayerController.play();
                    });
                  },
                  child: Icon(
                    _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: SizeConfig.blockSizeHorizontal * 7.5,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isVisible,
              child: Padding(
                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5, top: SizeConfig.blockSizeVertical * 4),
                child: SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 40,
                  child: SizedBox(
                    width: SizeConfig.screenWidth / 3.2,
                    height: SizeConfig.screenHeight / 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(Icons.arrow_back,
                              size: 25, color: (getStorage.read('isDarkMode') == true) ? Colors.white : ColorValues.whiteColor),
                        ),
                        SizedBox(
                          width: Get.width / 25,
                        ),
                        Text(
                          widget.title,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorValues.whiteColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
