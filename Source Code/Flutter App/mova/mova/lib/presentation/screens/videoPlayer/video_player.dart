// ignore_for_file: depend_on_referenced_packages, must_be_immutable, unnecessary_statements, avoid_print, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webtime_movie_ocean/googleAd/google_video_ad.dart';
import 'package:webtime_movie_ocean/googleAd/video_controller.dart';
import 'package:webtime_movie_ocean/presentation/screens/videoPlayer/video_controller.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/helper/ads_helper.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

///old
/*class VideoPlayers extends StatefulWidget {
  String name;
  String link;
  bool type;

  VideoPlayers({super.key, required this.name, required this.link, required this.type});

  @override
  State<VideoPlayers> createState() => _VideoPlayersState();
}

class _VideoPlayersState extends State<VideoPlayers> {
  var selectedIndexes = [3];
  bool isPlaybackSpeed = false;
  bool isSwitch = true;
  bool isVisible = true;
  bool showBanner = false;
  bool showIcon = true;
  Duration duration = const Duration();
  Timer? timer;
  String videolink = "";
  List<double> playbackSpeed = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];

  InterstitialAd? interstitialAd;
  BannerAd? _bannerAd;

  VideoController videoController = Get.put(VideoController());

  // TODO: Implement _loadInterstitialAd()
  _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              videoController.videoPlayerController.play();
            },
          );

          setState(() {
            interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void loadBannerAds() async {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(minutes: 5), (_) => addTime());
  }

  addTime() async {
    const addSeconds = 1;
    final seconds = duration.inMinutes + addSeconds;
    if (seconds == 5) {
      setState(() {
        _loadInterstitialAd();
        videoController.videoPlayerController.pause();
        interstitialAd?.show();
      });
    }
    duration = Duration(minutes: seconds);
  }

  @override
  void initState() {
    super.initState();
    loadBannerAds();
    _loadInterstitialAd();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ],
    );

    log("Video Link :: ${widget.link}");
    setState(() {
      videolink = widget.link;
    });

    // videoController = VideoController(); // Initialize the video controller
    videoController.videoPlayerController = (widget.type)
        ? VideoPlayerController.networkUrl(Uri.parse(videolink))
        : VideoPlayerController.file(File("/storage/emulated/0/Android/data/com.mova.android/files/${widget.name}"));

    videoController.videoPlayerController.initialize().then((_) {
      if (videoController.videoPlayerController.value.isInitialized) {
        if (widget.type || File(videoController.videoPlayerController.dataSource).existsSync()) {
          setState(() {
            videoController.videoPlayerController.setLooping(false);
            startTimer();
            videoController.videoPlayerController.play();
            log("Video play or not :: ${videoController.videoPlayerController.value.isPlaying}");
          });
        } else {
          log("Video file does not exist");
        }
      }
    }).catchError((error) {
      log("Video initialization error: $error");
    });
  }

  void showToast() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("----------link---------->>>>>>$videolink");
    // print("----------type---------->>>>>>" + {widget.runtimeType});
    print("----------name---------->>>>>>${widget.name}");

    log("Video controlleer :: ${videoController.videoPlayerController}");
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        (isVisible)
            ? await SystemChrome.setPreferredOrientations(
                [
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ],
              ).then(
                (value) {
                  interstitialAd?.show();
                  if (interstitialAd != null) {
                    interstitialAd?.show();
                    Get.back();
                  } else {
                    Get.back();
                  }
                },
              )
            : null;
        return false;
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            log("jkvdjkjdvjkdvjkvbdg");
            isSwitch = !isSwitch;
          });
        },
        child: Scaffold(
          backgroundColor: ColorValues.blackColor,
          body: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              if (orientation == Orientation.landscape) {
                log("Video view ${videoController.videoPlayerController.value.isInitialized}");
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Container(
                          height: Get.height,
                          width: Get.width,
                          color: Colors.blueGrey,
                          // child: AspectRatio(
                          //   aspectRatio: videoController.videoPlayerController.value.aspectRatio,
                          //   child: VideoPlayer(videoController.videoPlayerController),
                          // ),
                          child: YoutubePlayer(
                            controller: YoutubePlayerController(
                              initialVideoId: YoutubePlayer.convertUrlToId(widget.link) ?? '',
                              flags: const YoutubePlayerFlags(
                                autoPlay: true,
                                mute: false,
                                enableCaption: false,
                                // forceHD: true,
                              ),
                            ),
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.blue,
                            topActions: <Widget>[
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  widget.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            onReady: () {
                              log("In n Ready");
                              // Add any additional logic you need when the video is ready
                            },
                            onEnded: (data) {
                              log("In n on Ended $data");

                              // Add any logic you need when the video ends
                            },
                          ),
                        ),
                      ),
                    ),

                    /// Video player
                    Center(
                        child: videoController.videoPlayerController.value.isInitialized
                            ? FittedBox(
                                fit: BoxFit.cover,
                                child: Container(
                                  height: Get.height,
                                  width: Get.width,
                                  color: Colors.blueGrey,
                                  child: AspectRatio(
                                    aspectRatio: videoController.videoPlayerController.value.aspectRatio,
                                    child: VideoPlayer(videoController.videoPlayerController),
                                  ),
                                ),
                              )
                            : const SizedBox()),
                    if (!videoController.videoPlayerController.value.isPlaying)
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          left: Get.width / 3.6,
                          top: Get.height / 2.1,
                          right: Get.width / 3.5,
                        ),
                        child: (showBanner) ? AdWidget(ad: _bannerAd!) : null,
                      ),
                    if (!videoController.videoPlayerController.value.isPlaying)
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 45,
                          top: SizeConfig.blockSizeVertical * 34,
                        ),
                        child: (showIcon)
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    showBanner = false;
                                    showIcon = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: ColorValues.grayColor,
                                  size: 23,
                                ),
                              )
                            : null,
                      ),
                    // (videoController.videoPlayerController.value.isPlaying)
                    //     ? const SizedBox()
                    //     : Container(
                    //         alignment: Alignment.center,
                    //         margin: EdgeInsets.only(
                    //           left: Get.width / 3.6,
                    //           top: Get.height / 2.1,
                    //           right: Get.width / 3.5,
                    //         ),
                    //         child: (showBanner) ? AdWidget(ad: _bannerAd!) : null,
                    //       ),
                    (videoController.videoPlayerController.value.isPlaying)
                        ? const SizedBox()
                        : Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 45,
                              top: SizeConfig.blockSizeVertical * 34,
                            ),
                            child: (showIcon)
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showBanner = false;
                                        showIcon = false;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: ColorValues.grayColor,
                                      size: 23,
                                    ),
                                  )
                                : null,
                          ),
                    (isSwitch)
                        ? Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeHorizontal * 2,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: isVisible,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: SizeConfig.blockSizeHorizontal * 40,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  SystemChrome.setPreferredOrientations(
                                                    [
                                                      DeviceOrientation.portraitUp,
                                                      DeviceOrientation.portraitDown,
                                                    ],
                                                  );
                                                  {
                                                    interstitialAd?.show();
                                                    if (interstitialAd != null) {
                                                      interstitialAd?.show();
                                                      Get.back();
                                                    } else {
                                                      Get.back();
                                                    }
                                                  }
                                                },
                                                icon: SvgPicture.asset(
                                                  MovixIcon.arrowLeft,
                                                  color: ColorValues.whiteColor,
                                                  width: SizeConfig.blockSizeHorizontal * 3,
                                                ),
                                              ),
                                              SizedBox(
                                                width: SizeConfig.screenWidth / 3.5,
                                                child: Text(
                                                  widget.name,
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorValues.whiteColor,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: SizeConfig.blockSizeHorizontal * 11,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  playbackSpeedBottomSheet(context, orientation);
                                                },
                                                child: SvgPicture.asset(
                                                  MovixIcon.speed,
                                                  color: ColorValues.whiteColor,
                                                  width: SizeConfig.blockSizeHorizontal * 3.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                /// Video player line and other controller

                                Column(
                                  children: [
                                    Visibility(
                                      visible: isVisible,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GetBuilder<VideoController>(
                                            builder: (GetxController controller) {
                                              return Text(
                                                videoController.getPosition(),
                                                style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            width: SizeConfig.blockSizeHorizontal * 76,
                                            child: VideoProgressIndicator(
                                              videoController.videoPlayerController,
                                              allowScrubbing: true,
                                              colors: const VideoProgressColors(
                                                backgroundColor: Colors.white,
                                                bufferedColor: Colors.grey,
                                                playedColor: Colors.red,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${videoController.videoPlayerController.value.duration.inHours.bitLength}:${videoController.videoPlayerController.value.duration.inMinutes}:${videoController.videoPlayerController.value.duration.inSeconds.bitLength}",
                                            style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: SizeConfig.blockSizeHorizontal * 11,

                                            /// Volume button and lock
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                (isVisible)
                                                    ? GestureDetector(
                                                        onTap: showToast,
                                                        child: SvgPicture.asset(
                                                          MovixIcon.unLock,
                                                          color: ColorValues.whiteColor,
                                                          width: SizeConfig.blockSizeHorizontal * 4,
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: showToast,
                                                        child: SvgPicture.asset(
                                                          MovixIcon.boldLock,
                                                          color: ColorValues.redColor,
                                                          width: SizeConfig.blockSizeHorizontal * 4,
                                                        ),
                                                      ),
                                                Visibility(
                                                  visible: isVisible,
                                                  child: GetBuilder<VideoController>(
                                                    builder: (GetxController controller) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          videoController.setVolume();
                                                        },
                                                        child: SvgPicture.asset(
                                                          videoController.videoPlayerController.value.volume == 1
                                                              ? MovixIcon.volumeUp
                                                              : MovixIcon.volumeOff,
                                                          color: ColorValues.whiteColor,
                                                          width: SizeConfig.blockSizeHorizontal * 4,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: isVisible,
                                            child: SizedBox(
                                              width: SizeConfig.blockSizeHorizontal * 30,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  GetBuilder<VideoController>(
                                                    builder: (GetxController controller) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          videoController.setTenSecondsPrevious();
                                                        },
                                                        child: SvgPicture.asset(
                                                          MovixIcon.p10,
                                                          color: ColorValues.whiteColor,
                                                          width: SizeConfig.blockSizeHorizontal * 4,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  GetBuilder<VideoController>(
                                                    builder: (GetxController controller) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            showBanner = true;
                                                            showIcon = true;
                                                          });
                                                          videoController.setVideo();
                                                        },
                                                        child: Icon(
                                                          videoController.videoPlayerController.value.isPlaying
                                                              ? Icons.pause
                                                              : Icons.play_arrow_rounded,
                                                          color: Colors.white,
                                                          size: SizeConfig.blockSizeHorizontal * 7.5,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  GetBuilder<VideoController>(
                                                    builder: (GetxController controller) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          videoController.setTenSecondsNext();
                                                        },
                                                        child: SvgPicture.asset(
                                                          MovixIcon.n10,
                                                          color: ColorValues.whiteColor,
                                                          width: SizeConfig.blockSizeHorizontal * 4,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: isVisible,
                                            child: SizedBox(
                                              width: SizeConfig.blockSizeHorizontal * 11,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      SystemChrome.setPreferredOrientations(
                                                        [
                                                          DeviceOrientation.portraitDown,
                                                          DeviceOrientation.portraitUp,
                                                        ],
                                                      );
                                                    },
                                                    child: SvgPicture.asset(
                                                      MovixIcon.collapse,
                                                      color: ColorValues.whiteColor,
                                                      width: SizeConfig.blockSizeHorizontal * 4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // const Spacer(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                );
              } else {
                log("Video view enter else");
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: videoController.videoPlayerController.value.isInitialized
                          ? FittedBox(
                              fit: BoxFit.fill,
                              child: Container(
                                color: ColorValues.blackColor,
                                height: Get.height / 2.7,
                                width: Get.width,
                                child: AspectRatio(
                                  aspectRatio: videoController.videoPlayerController.value.aspectRatio,
                                  child: VideoPlayer(videoController.videoPlayerController),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeHorizontal * 7,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: isVisible,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 1.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          SystemChrome.setPreferredOrientations(
                                            [
                                              DeviceOrientation.portraitUp,
                                              DeviceOrientation.portraitDown,
                                            ],
                                          );
                                          {
                                            interstitialAd?.show();
                                            if (interstitialAd != null) {
                                              interstitialAd?.show();
                                              Get.back();
                                            } else {
                                              Get.back();
                                            }
                                          }
                                        },
                                        icon: SvgPicture.asset(
                                          MovixIcon.arrowLeft,
                                          color: ColorValues.whiteColor,
                                          width: SizeConfig.blockSizeHorizontal * 6,
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.screenWidth / 2.5,
                                        child: Text(
                                          widget.name,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: ColorValues.whiteColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: SizeConfig.blockSizeHorizontal * 17,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GetBuilder<VideoController>(
                                          builder: (GetxController controller) {
                                            return GestureDetector(
                                              onTap: () {
                                                videoController.setVolume();
                                              },
                                              child: SvgPicture.asset(
                                                videoController.videoPlayerController.value.volume == 1 ? MovixIcon.volumeUp : MovixIcon.volumeOff,
                                                color: ColorValues.whiteColor,
                                                width: SizeConfig.blockSizeHorizontal * 7,
                                              ),
                                            );
                                          },
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            playbackSpeedBottomSheet(context, orientation);
                                          },
                                          child: SvgPicture.asset(
                                            MovixIcon.speed,
                                            color: ColorValues.whiteColor,
                                            width: SizeConfig.blockSizeHorizontal * 7,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Visibility(
                                visible: isVisible,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: SizeConfig.blockSizeHorizontal * 0.5,
                                    ),
                                    GetBuilder<VideoController>(
                                      builder: (GetxController controller) {
                                        return Text(
                                          videoController.getPosition(),
                                          style: const TextStyle(
                                            color: ColorValues.whiteColor,
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: SizeConfig.blockSizeHorizontal * 70,
                                      child: VideoProgressIndicator(
                                        videoController.videoPlayerController,
                                        allowScrubbing: true,
                                        colors: const VideoProgressColors(
                                          backgroundColor: Colors.white,
                                          bufferedColor: Colors.grey,
                                          playedColor: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${videoController.videoPlayerController.value.duration.inHours.bitLength}:${videoController.videoPlayerController.value.duration.inMinutes}:${videoController.videoPlayerController.value.duration.inSeconds.bitLength}",
                                      style: const TextStyle(
                                        color: ColorValues.whiteColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.blockSizeHorizontal * 0.5,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: SizeConfig.blockSizeHorizontal * 15,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          (isVisible)
                                              ? GestureDetector(
                                                  onTap: showToast,
                                                  child: SvgPicture.asset(
                                                    MovixIcon.unLock,
                                                    color: ColorValues.whiteColor,
                                                    width: SizeConfig.blockSizeHorizontal * 8,
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: showToast,
                                                  child: SvgPicture.asset(
                                                    MovixIcon.boldLock,
                                                    color: ColorValues.redColor,
                                                    width: SizeConfig.blockSizeHorizontal * 8,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: isVisible,
                                      child: SizedBox(
                                        width: SizeConfig.blockSizeHorizontal * 40,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GetBuilder<VideoController>(
                                              builder: (GetxController controller) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    videoController.setTenSecondsPrevious();
                                                  },
                                                  child: SvgPicture.asset(
                                                    MovixIcon.p10,
                                                    color: ColorValues.whiteColor,
                                                    width: SizeConfig.blockSizeHorizontal * 6,
                                                  ),
                                                );
                                              },
                                            ),
                                            GetBuilder<VideoController>(
                                              builder: (GetxController controller) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    videoController.setVideo();
                                                  },
                                                  child: Icon(
                                                    videoController.videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                                                    color: Colors.white,
                                                    size: SizeConfig.blockSizeHorizontal * 10,
                                                  ),
                                                );
                                              },
                                            ),
                                            GetBuilder<VideoController>(
                                              builder: (GetxController controller) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    videoController.setTenSecondsNext();
                                                  },
                                                  child: SvgPicture.asset(
                                                    MovixIcon.n10,
                                                    color: ColorValues.whiteColor,
                                                    width: SizeConfig.blockSizeHorizontal * 6,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: isVisible,
                                      child: SizedBox(
                                        width: SizeConfig.blockSizeHorizontal * 13,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                SystemChrome.setPreferredOrientations(
                                                  [
                                                    DeviceOrientation.landscapeLeft,
                                                    DeviceOrientation.landscapeRight,
                                                  ],
                                                );
                                              },
                                              child: Icon(
                                                Icons.zoom_out_map,
                                                size: SizeConfig.blockSizeHorizontal * 6,
                                                color: ColorValues.whiteColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // const Spacer(),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<dynamic> playbackSpeedBottomSheet(BuildContext context, Orientation orientation) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      backgroundColor: ColorValues.darkModeMain,
      constraints: BoxConstraints(
        maxWidth: (orientation == Orientation.landscape) ? SizeConfig.screenWidth / 3 : SizeConfig.screenWidth,
        maxHeight: (orientation == Orientation.landscape) ? SizeConfig.screenHeight / 1.5 : SizeConfig.screenHeight / 2.5,
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return false;
              },
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        if (selectedIndexes.contains(index)) {
                          setState(() {
                            selectedIndexes = [];
                          });
                          // unselect
                        } else {
                          setState(() {
                            selectedIndexes = [];
                            selectedIndexes.add(index);
                          }); // select
                        }
                        videoController.videoPlayerController.setPlaybackSpeed(playbackSpeed[index]);
                        Get.back();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (selectedIndexes.contains(index))
                              ? const Icon(
                                  Icons.done,
                                  color: ColorValues.redColor,
                                )
                              : Container(
                                  width: 25,
                                ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            playbackSpeed[index].toString(),
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: playbackSpeed.length,
              ),
            );
          },
        );
      },
    );
  }
}*/

/// ad show video play work

/*class VideoPlayers extends StatefulWidget {
  String name;
  String link;
  bool type;

  VideoPlayers({super.key, required this.name, required this.link, required this.type});

  @override
  State<VideoPlayers> createState() => _VideoPlayersState();
}

class _VideoPlayersState extends State<VideoPlayers> {
  var selectedIndexes = [3];
  bool isPlaybackSpeed = false;
  bool isSwitch = true;
  bool isVisible = true;
  bool showBanner = false;
  bool showIcon = true;
  Duration duration = const Duration();
  Timer? timer;
  Timer? adTimer;
  String videolink = "";
  List<double> playbackSpeed = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];

  // Ad related variables
  InterstitialAd? interstitialAd;
  BannerAd? _bannerAd;
  bool isShowingVideoAd = false;
  bool adsInitialized = false;
  bool videoCanPlay = false; // Video can only play after ad is shown

// Multiple ads configuration
  List<double> adShowPercentages = [25.0, 50.0, 75.0, 90.0]; // Show ads at 25%, 50%, 75%, 90% of video
  List<bool> adsShown = [false, false, false, false]; // Track which ads have been shown
  Duration? videoDuration;
  int currentAdIndex = 0;
  Timer? adProgressTimer;

  VideoController videoController = Get.put(VideoController());

  @override
  void initState() {
    super.initState();
    loadBannerAds();
    _loadInterstitialAd();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    log("Video Link :: ${widget.link}");
    setState(() {
      videolink = widget.link;
    });

    // Initialize video controller but don't play yet
    videoController.videoPlayerController = (widget.type)
        ? VideoPlayerController.networkUrl(Uri.parse(videolink))
        : VideoPlayerController.file(File("/storage/emulated/0/Android/data/com.mova.android/files/${widget.name}"));

    videoController.videoPlayerController.initialize().then((_) {
      if (videoController.videoPlayerController.value.isInitialized) {
        if (widget.type || File(videoController.videoPlayerController.dataSource).existsSync()) {
          setState(() {
            videoDuration = videoController.videoPlayerController.value.duration;
            videoController.videoPlayerController.setLooping(false);
            log("Video initialized with duration: ${videoDuration?.inSeconds} seconds");
          });

          // Show initial ad before starting video
          initializeVideoAds();

          // Start monitoring video progress for mid-roll ads
          startAdProgressTimer();
        } else {
          log("Video file does not exist");
        }
      }
    }).catchError((error) {
      log("Video initialization error: $error");
    });

    Timer.periodic(const Duration(seconds: 1), (_) {
      videoController.updateSeeker();
    });
  }

  bool get _isLandscape => MediaQuery.of(context).orientation == Orientation.landscape;

  Future<void> _toggleOrientation() async {
    if (_isLandscape) {
      // Landscape → Portrait
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      // Portrait → Landscape
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  void startAdProgressTimer() {
    adProgressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (videoController.videoPlayerController.value.isInitialized &&
          videoController.videoPlayerController.value.isPlaying &&
          videoDuration != null) {
        Duration currentPosition = videoController.videoPlayerController.value.position;
        double progressPercentage = (currentPosition.inSeconds / videoDuration!.inSeconds) * 100;

        // Check if we should show an ad at current progress
        for (int i = 0; i < adShowPercentages.length; i++) {
          if (!adsShown[i] && progressPercentage >= adShowPercentages[i]) {
            log("Showing ad at ${adShowPercentages[i]}% progress");
            showMidRollAd(i);
            break;
          }
        }
      }
    });
  }

  Widget _buildCustomProgressIndicator() {
    final controller = videoController.videoPlayerController;

    if (!controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final totalMs = value.duration.inMilliseconds;
        final posMs = value.position.inMilliseconds;
        final played = totalMs == 0 ? 0.0 : (posMs / totalMs).clamp(0.0, 1.0);

        // Best-effort buffered percent (last range end)
        double buffered = 0.0;
        if (value.buffered.isNotEmpty && totalMs > 0) {
          buffered = (value.buffered.last.end.inMilliseconds / totalMs).clamp(0.0, 1.0);
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final barHeight = 4.0;
            final width = constraints.maxWidth;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Background
                Container(
                  height: barHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white, // backgroundColor
                  ),
                ),

                // Buffered layer
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: barHeight,
                    width: width * buffered,
                    decoration: const BoxDecoration(
                      color: Colors.grey, // bufferedColor
                    ),
                  ),
                ),

                // Played layer
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: barHeight,
                    width: width * played,
                    decoration: const BoxDecoration(
                      color: Colors.red, // playedColor
                    ),
                  ),
                ),

                // Scrub gestures layered on top
                SizedBox(
                  height: max(barHeight, 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 16, // bigger hit area
                      child: VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        padding: EdgeInsets.zero,
                        colors: const VideoProgressColors(
                          backgroundColor: Colors.transparent, // we draw bg ourselves
                          bufferedColor: Colors.transparent,
                          playedColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),

                // Ad markers using real width
                for (int i = 0; i < adShowPercentages.length; i++)
                  Positioned(
                    left: (width * (adShowPercentages[i] / 100)) - 4,
                    top: -0.8,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: adsShown[i] ? Colors.grey : Colors.yellow,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  // Show mid-roll ad during video playback
  void showMidRollAd(int adIndex) {
    setState(() {
      adsShown[adIndex] = true;
      currentAdIndex = adIndex;
      isShowingVideoAd = true;
    });

    // Pause the main video
    videoController.videoPlayerController.pause();

    log("Showing mid-roll ad ${adIndex + 1}");

    // Initialize and show video ad
    VideoAdServices.initialize(
      onAdCompletedCallback: () {
        log("Mid-roll ad ${adIndex + 1} completed, resuming video");
        setState(() {
          isShowingVideoAd = false;
        });
        // Resume the main video
        videoController.videoPlayerController.play();
      },
      onAdStartedCallback: () {
        log("Mid-roll ad ${adIndex + 1} started");
        setState(() {
          isShowingVideoAd = true;
        });
      },
      onAdFailedCallback: () {
        log("Mid-roll ad ${adIndex + 1} failed, resuming video");
        setState(() {
          isShowingVideoAd = false;
        });
        // Resume video even if ad fails
        videoController.videoPlayerController.play();
      },
    );
  }

  // Initialize video ads and show immediately
  void initializeVideoAds() {
    VideoAdServices.initialize(
      onAdCompletedCallback: () {
        log("Pre-roll video ad completed, starting video");
        setState(() {
          isShowingVideoAd = false;
          videoCanPlay = true;
        });
        // Now start the actual video
        videoController.videoPlayerController.play();
        log("Video started after ad completion");
      },
      onAdStartedCallback: () {
        log("Pre-roll video ad started");
        setState(() {
          isShowingVideoAd = true;
        });
      },
      onAdFailedCallback: () {
        log("Pre-roll video ad failed, starting video anyway");
        setState(() {
          isShowingVideoAd = false;
          videoCanPlay = true;
        });
        // Start video even if ad fails
        videoController.videoPlayerController.play();
      },
    );
    adsInitialized = true;

    // Show initial ad immediately
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isShowingVideoAd = true;
        });
      }
    });
  }

  _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              if (!isShowingVideoAd) {
                videoController.videoPlayerController.play();
              }
            },
          );
          setState(() {
            interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void loadBannerAds() async {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(minutes: 5), (_) => addTime());
  }

  addTime() async {
    const addSeconds = 1;
    final seconds = duration.inMinutes + addSeconds;
    if (seconds == 5) {
      setState(() {
        _loadInterstitialAd();
        videoController.videoPlayerController.pause();
        interstitialAd?.show();
      });
    }
    duration = Duration(minutes: seconds);
  }

  void showToast() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    adTimer?.cancel();
    videoController.dispose();
    VideoAdServices.dispose();
    adProgressTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print("----------link---------->>>>>>$videolink");
    print("----------name---------->>>>>>${widget.name}");
    log("Video controlleer :: ${videoController.videoPlayerController}");

    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        (isVisible)
            ? await SystemChrome.setPreferredOrientations(
                [
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ],
              ).then(
                (value) {
                  interstitialAd?.show();
                  if (interstitialAd != null) {
                    interstitialAd?.show();
                    Get.back();
                  } else {
                    Get.back();
                  }
                },
              )
            : null;
        return false;
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSwitch = !isSwitch;
          });
        },
        child: Scaffold(
          backgroundColor: ColorValues.blackColor,
          body: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              if (orientation == Orientation.landscape) {
                return Stack(
                  children: [
                    _buildLandscapeView(),
                    // Video ad overlay
                    // if (isShowingVideoAd && adsInitialized)
                    //   Positioned.fill(
                    //     child: Container(
                    //       color: Colors.black,
                    //       child: Center(
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             // Ad counter indicator
                    //             Positioned(
                    //               top: 50,
                    //               right: 20,
                    //               child: Container(
                    //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.black54,
                    //                   borderRadius: BorderRadius.circular(15),
                    //                 ),
                    //                 child: Text(
                    //                   "Ad ${currentAdIndex + 1} of ${adShowPercentages.length + 1}",
                    //                   style: TextStyle(
                    //                     color: Colors.white,
                    //                     fontSize: 12,
                    //                     fontWeight: FontWeight.bold,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             // Video ad widget
                    //             Center(
                    //               child: VideoAdServices.createAdWidget(
                    //                 onAdCompletedCallback: () {
                    //                   setState(() {
                    //                     isShowingVideoAd = false;
                    //                   });
                    //                   videoController.videoPlayerController.play();
                    //                 },
                    //                 onAdStartedCallback: () {
                    //                   setState(() {
                    //                     isShowingVideoAd = true;
                    //                   });
                    //                 },
                    //                 onAdFailedCallback: () {
                    //                   setState(() {
                    //                     isShowingVideoAd = false;
                    //                   });
                    //                   videoController.videoPlayerController.play();
                    //                 },
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),

                    if (isShowingVideoAd) // adsInitialized check not needed
                      Positioned.fill(
                        child: ExcludeSemantics(
                          child: Stack(
                            children: [
                              const Positioned.fill(child: ColoredBox(color: Colors.black)),

                              // ✅ Positioned is now under Stack (valid)
                              // Positioned(
                              //   top: 50,
                              //   right: 20,
                              //   child: Container(
                              //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              //     decoration: BoxDecoration(
                              //       color: Colors.black54,
                              //       borderRadius: BorderRadius.circular(15),
                              //     ),
                              //     child: Text(
                              //       "Ad ${currentAdIndex + 1} of ${adShowPercentages.length + 1}",
                              //       style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              //     ),
                              //   ),
                              // ),

                              // Center the ad content
                              Align(
                                alignment: Alignment.center,
                                child: VideoAdServices.createAdWidget(
                                  onAdCompletedCallback: () {
                                    setState(() => isShowingVideoAd = false);
                                    videoController.videoPlayerController.play();
                                  },
                                  onAdStartedCallback: () => setState(() => isShowingVideoAd = true),
                                  onAdFailedCallback: () {
                                    setState(() => isShowingVideoAd = false);
                                    videoController.videoPlayerController.play();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    /// Video player line and other controller
                    isShowingVideoAd == true
                        ? const SizedBox()
                        : GetBuilder<VideoController>(builder: (context) {
                            return Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: (isSwitch)
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.blockSizeHorizontal * 2,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          /// Video player line and other controller

                                          Column(
                                            children: [
                                              Visibility(
                                                visible: isVisible,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GetBuilder<VideoController>(
                                                      id: "duration",
                                                      builder: (logic) {
                                                        return Text(
                                                          logic.getPosition(),
                                                          style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                        );
                                                      },
                                                    ),
                                                    // SizedBox(
                                                    //   width: SizeConfig.blockSizeHorizontal * 76,
                                                    //   child: VideoProgressIndicator(
                                                    //     videoController.videoPlayerController,
                                                    //     allowScrubbing: true,
                                                    //     colors: const VideoProgressColors(
                                                    //       backgroundColor: Colors.white,
                                                    //       bufferedColor: Colors.grey,
                                                    //       playedColor: Colors.red,
                                                    //     ),
                                                    //   ),
                                                    // ),

                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 76,
                                                      child: _buildCustomProgressIndicator(),
                                                    ),
                                                    Text(
                                                      "${videoController.videoPlayerController.value.duration.inHours.bitLength}:${videoController.videoPlayerController.value.duration.inMinutes}:${videoController.videoPlayerController.value.duration.inSeconds.bitLength}",
                                                      style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 11,

                                                      /// Volume button and lock
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          (isVisible)
                                                              ? GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.unLock,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.boldLock,
                                                                    color: ColorValues.redColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                ),
                                                          Visibility(
                                                            visible: isVisible,
                                                            child: GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setVolume();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    videoController.videoPlayerController.value.volume == 1
                                                                        ? MovixIcon.volumeUp
                                                                        : MovixIcon.volumeOff,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 30,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsPrevious();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.p10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      showBanner = true;
                                                                      showIcon = true;
                                                                    });
                                                                    videoController.setVideo();
                                                                  },
                                                                  child: Icon(
                                                                    videoController.videoPlayerController.value.isPlaying
                                                                        ? Icons.pause
                                                                        : Icons.play_arrow_rounded,
                                                                    color: Colors.white,
                                                                    size: SizeConfig.blockSizeHorizontal * 7.5,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsNext();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.n10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 11,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                // SystemChrome.setPreferredOrientations(
                                                                //   [
                                                                //     DeviceOrientation.portraitDown,
                                                                //     DeviceOrientation.portraitUp,
                                                                //   ],
                                                                // );
                                                                _toggleOrientation();
                                                              },
                                                              child: SvgPicture.asset(
                                                                MovixIcon.collapse,
                                                                color: ColorValues.whiteColor,
                                                                width: SizeConfig.blockSizeHorizontal * 4,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    // const Spacer(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            );
                          }),

                    ///banner ad

                    if (!videoController.videoPlayerController.value.isPlaying)
                      isShowingVideoAd == true
                          ? const SizedBox()
                          : Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: Get.width / 3.6,
                                top: Get.height / 2.4,
                                right: Get.width / 3.5,
                              ),
                              child: (showBanner) ? AdWidget(ad: _bannerAd!) : null,
                            ),
                    if (!videoController.videoPlayerController.value.isPlaying)
                      isShowingVideoAd == true
                          ? const SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal * 65,
                                top: SizeConfig.blockSizeVertical * 54,
                              ),
                              child: (showIcon)
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showBanner = false;
                                          showIcon = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: ColorValues.grayColor,
                                        size: 23,
                                      ),
                                    )
                                  : null,
                            ),
                    // (videoController.videoPlayerController.value.isPlaying)
                    //     ? const SizedBox()
                    //     : Container(
                    //         alignment: Alignment.center,
                    //         margin: EdgeInsets.only(
                    //           left: Get.width / 3.6,
                    //           top: Get.height / 2.1,
                    //           right: Get.width / 3.5,
                    //         ),
                    //         child: (showBanner) ? AdWidget(ad: _bannerAd!) : null,
                    //       ),

                    (isSwitch)
                        ? isShowingVideoAd == true
                            ? const SizedBox()
                            : Padding(
                                padding: EdgeInsets.only(
                                  top: SizeConfig.blockSizeHorizontal * 2,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible: isVisible,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: SizeConfig.blockSizeHorizontal * 40,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      SystemChrome.setPreferredOrientations(
                                                        [
                                                          DeviceOrientation.portraitUp,
                                                          DeviceOrientation.portraitDown,
                                                        ],
                                                      );
                                                      {
                                                        interstitialAd?.show();
                                                        if (interstitialAd != null) {
                                                          interstitialAd?.show();
                                                          Get.back();
                                                        } else {
                                                          Get.back();
                                                        }
                                                      }
                                                    },
                                                    icon: SvgPicture.asset(
                                                      MovixIcon.arrowLeft,
                                                      color: ColorValues.whiteColor,
                                                      width: SizeConfig.blockSizeHorizontal * 3,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig.screenWidth / 3.5,
                                                    child: Text(
                                                      widget.name,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: ColorValues.whiteColor,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig.blockSizeHorizontal * 11,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      playbackSpeedBottomSheet(context, orientation);
                                                    },
                                                    child: SvgPicture.asset(
                                                      MovixIcon.speed,
                                                      color: ColorValues.whiteColor,
                                                      width: SizeConfig.blockSizeHorizontal * 3.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        : const SizedBox(),
                  ],
                );
              } else {
                return Stack(
                  children: [
                    _buildPortraitView(),

                    // Video ad overlay
                    // if (isShowingVideoAd && adsInitialized)
                    //   Positioned.fill(
                    //     child: Container(
                    //       color: Colors.black,
                    //       child: Center(
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             // Ad counter indicator
                    //             Positioned(
                    //               top: 50,
                    //               right: 20,
                    //               child: Container(
                    //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.black54,
                    //                   borderRadius: BorderRadius.circular(15),
                    //                 ),
                    //                 child: Text(
                    //                   "Ad ${currentAdIndex + 1} of ${adShowPercentages.length + 1}",
                    //                   style: TextStyle(
                    //                     color: Colors.white,
                    //                     fontSize: 12,
                    //                     fontWeight: FontWeight.bold,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             // Video ad widget
                    //             Expanded(
                    //               child: VideoAdServices.createAdWidget(
                    //                 onAdCompletedCallback: () {
                    //                   setState(() {
                    //                     isShowingVideoAd = false;
                    //                   });
                    //                   videoController.videoPlayerController.play();
                    //                 },
                    //                 onAdStartedCallback: () {
                    //                   setState(() {
                    //                     isShowingVideoAd = true;
                    //                   });
                    //                 },
                    //                 onAdFailedCallback: () {
                    //                   setState(() {
                    //                     isShowingVideoAd = false;
                    //                   });
                    //                   videoController.videoPlayerController.play();
                    //                 },
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),

                    if (isShowingVideoAd) // adsInitialized check not needed
                      Positioned.fill(
                        child: ExcludeSemantics(
                          child: Stack(
                            children: [
                              const Positioned.fill(child: ColoredBox(color: Colors.black)),

                              // ✅ Positioned is now under Stack (valid)
                              // Positioned(
                              //   top: 50,
                              //   right: 20,
                              //   child: Container(
                              //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              //     decoration: BoxDecoration(
                              //       color: Colors.black54,
                              //       borderRadius: BorderRadius.circular(15),
                              //     ),
                              //     child: Text(
                              //       "Ad ${currentAdIndex + 1} of ${adShowPercentages.length + 1}",
                              //       style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              //     ),
                              //   ),
                              // ),

                              // Center the ad content
                              Align(
                                alignment: Alignment.center,
                                child: VideoAdServices.createAdWidget(
                                  onAdCompletedCallback: () {
                                    setState(() => isShowingVideoAd = false);
                                    videoController.videoPlayerController.play();
                                  },
                                  onAdStartedCallback: () => setState(() => isShowingVideoAd = true),
                                  onAdFailedCallback: () {
                                    setState(() => isShowingVideoAd = false);
                                    videoController.videoPlayerController.play();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    /// Video player line and other controller
                    isShowingVideoAd == true
                        ? const SizedBox()
                        : GetBuilder<VideoController>(builder: (context) {
                            return Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: (isSwitch)
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.blockSizeHorizontal * 2,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          /// Video player line and other controller

                                          Column(
                                            children: [
                                              Visibility(
                                                visible: isVisible,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GetBuilder<VideoController>(
                                                      builder: (GetxController controller) {
                                                        return Text(
                                                          videoController.getPosition(),
                                                          style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                        );
                                                      },
                                                    ),
                                                    // SizedBox(
                                                    //   width: SizeConfig.blockSizeHorizontal * 76,
                                                    //   child: VideoProgressIndicator(
                                                    //     videoController.videoPlayerController,
                                                    //     allowScrubbing: true,
                                                    //     colors: const VideoProgressColors(
                                                    //       backgroundColor: Colors.white,
                                                    //       bufferedColor: Colors.grey,
                                                    //       playedColor: Colors.red,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 76,
                                                      child: _buildCustomProgressIndicator(),
                                                    ),

                                                    Text(
                                                      "${videoController.videoPlayerController.value.duration.inHours.bitLength}:${videoController.videoPlayerController.value.duration.inMinutes}:${videoController.videoPlayerController.value.duration.inSeconds.bitLength}",
                                                      style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 11,

                                                      /// Volume button and lock
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          (isVisible)
                                                              ? GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.unLock,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.boldLock,
                                                                    color: ColorValues.redColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                ),
                                                          Visibility(
                                                            visible: isVisible,
                                                            child: GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setVolume();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    videoController.videoPlayerController.value.volume == 1
                                                                        ? MovixIcon.volumeUp
                                                                        : MovixIcon.volumeOff,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 30,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsPrevious();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.p10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      showBanner = true;
                                                                      showIcon = true;
                                                                    });
                                                                    videoController.setVideo();
                                                                  },
                                                                  child: Icon(
                                                                    videoController.videoPlayerController.value.isPlaying
                                                                        ? Icons.pause
                                                                        : Icons.play_arrow_rounded,
                                                                    color: Colors.white,
                                                                    size: SizeConfig.blockSizeHorizontal * 7.5,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsNext();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.n10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 11,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                // SystemChrome.setPreferredOrientations(
                                                                //   [
                                                                //     DeviceOrientation.portraitDown,
                                                                //     DeviceOrientation.portraitUp,
                                                                //   ],
                                                                // );

                                                                _toggleOrientation();
                                                              },
                                                              child: SvgPicture.asset(
                                                                MovixIcon.collapse,
                                                                color: ColorValues.whiteColor,
                                                                width: SizeConfig.blockSizeHorizontal * 4,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    // const Spacer(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            );
                          }),
                    isShowingVideoAd == true
                        ? const SizedBox()
                        : Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: (isSwitch)
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    child: Visibility(
                                      visible: isVisible,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: SizeConfig.blockSizeHorizontal * 40,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      SystemChrome.setPreferredOrientations(
                                                        [
                                                          DeviceOrientation.portraitUp,
                                                          DeviceOrientation.portraitDown,
                                                        ],
                                                      );
                                                      {
                                                        interstitialAd?.show();
                                                        if (interstitialAd != null) {
                                                          interstitialAd?.show();
                                                          Get.back();
                                                        } else {
                                                          Get.back();
                                                        }
                                                      }
                                                    },
                                                    icon: SvgPicture.asset(
                                                      MovixIcon.arrowLeft,
                                                      color: ColorValues.whiteColor,
                                                      width: SizeConfig.blockSizeHorizontal * 3,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig.screenWidth / 3.5,
                                                    child: Text(
                                                      widget.name,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: ColorValues.whiteColor,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig.blockSizeHorizontal * 11,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      playbackSpeedBottomSheet(context, orientation);
                                                    },
                                                    child: SvgPicture.asset(
                                                      MovixIcon.speed,
                                                      color: ColorValues.whiteColor,
                                                      width: SizeConfig.blockSizeHorizontal * 3.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeView() {
    log("Video view ${videoController.videoPlayerController.value.isInitialized}");
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Container(
              height: Get.height,
              width: Get.width,
              color: Colors.blueGrey,
              child: widget.link.contains('youtube.com') || widget.link.contains('youtu.be')
                  ? YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(widget.link) ?? '',
                        flags: const YoutubePlayerFlags(
                          autoPlay: true,
                          mute: false,
                          enableCaption: false,
                        ),
                      ),
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blue,
                      topActions: <Widget>[
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      onReady: () {
                        log("YouTube player ready");
                      },
                      onEnded: (data) {
                        log("YouTube player ended $data");
                      },
                    )
                  : videoController.videoPlayerController.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: videoController.videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(videoController.videoPlayerController),
                        )
                      : const SizedBox(),
            ),
          ),
        ),

        // Rest of your existing landscape UI controls
        // ... (keeping your existing control UI code)
      ],
    );
  }

  Widget _buildPortraitView() {
    log("Video view enter portrait");
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: videoController.videoPlayerController.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.fill,
                  child: Container(
                    color: ColorValues.blackColor,
                    height: Get.height / 2.7,
                    width: Get.width,
                    child: AspectRatio(
                      aspectRatio: videoController.videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(videoController.videoPlayerController),
                    ),
                  ),
                )
              : const SizedBox(),
        ),

        // Rest of your existing portrait UI controls
        // ... (keeping your existing control UI code)
      ],
    );
  }

  Future<dynamic> playbackSpeedBottomSheet(BuildContext context, Orientation orientation) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      backgroundColor: ColorValues.darkModeMain,
      constraints: BoxConstraints(
        maxWidth: (orientation == Orientation.landscape) ? SizeConfig.screenWidth / 3 : SizeConfig.screenWidth,
        maxHeight: (orientation == Orientation.landscape) ? SizeConfig.screenHeight / 1.5 : SizeConfig.screenHeight / 2.5,
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return false;
              },
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        if (selectedIndexes.contains(index)) {
                          setState(() {
                            selectedIndexes = [];
                          });
                          // unselect
                        } else {
                          setState(() {
                            selectedIndexes = [];
                            selectedIndexes.add(index);
                          }); // select
                        }
                        videoController.videoPlayerController.setPlaybackSpeed(playbackSpeed[index]);
                        Get.back();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (selectedIndexes.contains(index))
                              ? const Icon(
                                  Icons.done,
                                  color: ColorValues.redColor,
                                )
                              : Container(
                                  width: 25,
                                ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            playbackSpeed[index].toString(),
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: playbackSpeed.length,
              ),
            );
          },
        );
      },
    );
  }
}*/

/// new first ad not show
/*class VideoPlayers extends StatefulWidget {
  String name;
  String link;
  bool type;

  VideoPlayers({super.key, required this.name, required this.link, required this.type});

  @override
  State<VideoPlayers> createState() => _VideoPlayersState();
}

class _VideoPlayersState extends State<VideoPlayers> {
  var selectedIndexes = [3];
  bool isPlaybackSpeed = false;
  bool isSwitch = true;
  bool isVisible = true;
  bool showBanner = false;
  bool showIcon = true;
  Duration duration = const Duration();
  Timer? timer;
  Timer? adTimer;
  String videolink = "";
  List<double> playbackSpeed = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];

  // Ad related variables
  InterstitialAd? interstitialAd;
  BannerAd? _bannerAd;

  // CHANGED: start with no ad overlay; we won’t trigger pre-roll at all
  bool isShowingVideoAd = false;
  bool adsInitialized = false;

  // CHANGED: we no longer gate video start behind an ad
  bool videoCanPlay = true;

  // Multiple ads configuration
  List<double> adShowPercentages = [25.0, 50.0, 75.0, 90.0];
  List<bool> adsShown = [false, false, false, false];
  Duration? videoDuration;
  int currentAdIndex = 0;
  Timer? adProgressTimer;

  VideoController videoController = Get.put(VideoController());

  @override
  void initState() {
    super.initState();
    loadBannerAds();
    _loadInterstitialAd();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    log("Video Link :: ${widget.link}");
    setState(() {
      videolink = widget.link;
    });

    // Initialize video controller and PLAY IMMEDIATELY (no pre-roll)
    videoController.videoPlayerController = (widget.type)
        ? VideoPlayerController.networkUrl(Uri.parse(videolink))
        : VideoPlayerController.file(
            File("/storage/emulated/0/Android/data/com.mova.android/files/${widget.name}"),
          );

    videoController.videoPlayerController.initialize().then((_) {
      if (videoController.videoPlayerController.value.isInitialized) {
        if (widget.type || File(videoController.videoPlayerController.dataSource).existsSync()) {
          setState(() {
            videoDuration = videoController.videoPlayerController.value.duration;
            videoController.videoPlayerController.setLooping(false);
            log("Video initialized with duration: ${videoDuration?.inSeconds} seconds");
          });

          // CHANGED: Remove pre-roll. Start the video right away.
          videoController.videoPlayerController.play(); // <-- starts immediately
          log("Video started without pre-roll ad");

          // Keep mid-roll checks
          startAdProgressTimer();
        } else {
          log("Video file does not exist");
        }
      }
    }).catchError((error) {
      log("Video initialization error: $error");
    });

    Timer.periodic(const Duration(seconds: 1), (_) {
      videoController.updateSeeker();
    });
  }

  bool get _isLandscape => MediaQuery.of(context).orientation == Orientation.landscape;

  Future<void> _toggleOrientation() async {
    if (_isLandscape) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  void startAdProgressTimer() {
    adProgressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (videoController.videoPlayerController.value.isInitialized &&
          videoController.videoPlayerController.value.isPlaying &&
          videoDuration != null) {
        Duration currentPosition = videoController.videoPlayerController.value.position;
        double progressPercentage = (currentPosition.inSeconds / videoDuration!.inSeconds) * 100;

        for (int i = 0; i < adShowPercentages.length; i++) {
          if (!adsShown[i] && progressPercentage >= adShowPercentages[i]) {
            log("Showing ad at ${adShowPercentages[i]}% progress");
            showMidRollAd(i);
            break;
          }
        }
      }
    });
  }

  Widget _buildCustomProgressIndicator() {
    final controller = videoController.videoPlayerController;

    if (!controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final totalMs = value.duration.inMilliseconds;
        final posMs = value.position.inMilliseconds;
        final played = totalMs == 0 ? 0.0 : (posMs / totalMs).clamp(0.0, 1.0);

        double buffered = 0.0;
        if (value.buffered.isNotEmpty && totalMs > 0) {
          buffered = (value.buffered.last.end.inMilliseconds / totalMs).clamp(0.0, 1.0);
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final barHeight = 4.0;
            final width = constraints.maxWidth;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: barHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: barHeight,
                    width: width * buffered,
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: barHeight,
                    width: width * played,
                    decoration: const BoxDecoration(color: Colors.red),
                  ),
                ),
                SizedBox(
                  height: max(barHeight, 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 16,
                      child: VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        padding: EdgeInsets.zero,
                        colors: const VideoProgressColors(
                          backgroundColor: Colors.transparent,
                          bufferedColor: Colors.transparent,
                          playedColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                for (int i = 0; i < adShowPercentages.length; i++)
                  Positioned(
                    left: (width * (adShowPercentages[i] / 100)) - 4,
                    top: -0.8,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: adsShown[i] ? Colors.grey : Colors.yellow,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  // Mid-roll ad only (no pre-roll)
  void showMidRollAd(int adIndex) {
    setState(() {
      adsShown[adIndex] = true;
      currentAdIndex = adIndex;
      isShowingVideoAd = true;
    });

    videoController.videoPlayerController.pause();

    log("Showing mid-roll ad ${adIndex + 1}");

    VideoAdServices.initialize(
      onAdCompletedCallback: () {
        log("Mid-roll ad ${adIndex + 1} completed, resuming video");
        setState(() => isShowingVideoAd = false);
        videoController.videoPlayerController.play();
      },
      onAdStartedCallback: () {
        log("Mid-roll ad ${adIndex + 1} started");
        setState(() => isShowingVideoAd = true);
      },
      onAdFailedCallback: () {
        log("Mid-roll ad ${adIndex + 1} failed, resuming video");
        setState(() => isShowingVideoAd = false);
        videoController.videoPlayerController.play();
      },
    );
  }

  // CHANGED: Removed pre-roll flow. Keeping method stub in case referenced elsewhere.
  // void initializeVideoAds() {} // no-op

  _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              // Resume video after interstitial is dismissed if it was paused
              if (!isShowingVideoAd) {
                videoController.videoPlayerController.play();
              }
            },
          );
          setState(() {
            interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void loadBannerAds() async {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(minutes: 5), (_) => addTime());
  }

  addTime() async {
    const addSeconds = 1;
    final seconds = duration.inMinutes + addSeconds;
    if (seconds == 5) {
      setState(() {
        _loadInterstitialAd();
        videoController.videoPlayerController.pause();
        interstitialAd?.show();
      });
    }
    duration = Duration(minutes: seconds);
  }

  void showToast() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    adTimer?.cancel();
    videoController.dispose();
    VideoAdServices.dispose();
    adProgressTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print("----------link---------->>>>>>$videolink");
    print("----------name---------->>>>>>${widget.name}");
    log("Video controlleer :: ${videoController.videoPlayerController}");

    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        if (isVisible) {
          await SystemChrome.setPreferredOrientations(
            [
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ],
          );
          // Avoid double show; just once is enough
          if (interstitialAd != null) {
            interstitialAd!.show();
          }
          Get.back();
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSwitch = !isSwitch;
          });
        },
        child: Scaffold(
          backgroundColor: ColorValues.blackColor,
          body: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              if (orientation == Orientation.landscape) {
                return Stack(
                  children: [
                    _buildLandscapeView(),

                    // Only mid-roll ad overlay remains
                    if (isShowingVideoAd)
                      Positioned.fill(
                        child: ExcludeSemantics(
                          child: Stack(
                            children: [
                              const Positioned.fill(child: ColoredBox(color: Colors.black)),
                              Align(
                                alignment: Alignment.center,
                                child: VideoAdServices.createAdWidget(
                                  onAdCompletedCallback: () {
                                    setState(() => isShowingVideoAd = false);
                                    videoController.videoPlayerController.play();
                                  },
                                  onAdStartedCallback: () => setState(() => isShowingVideoAd = true),
                                  onAdFailedCallback: () {
                                    setState(() => isShowingVideoAd = false);
                                    videoController.videoPlayerController.play();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Controls
                    isShowingVideoAd
                        ? const SizedBox()
                        : GetBuilder<VideoController>(builder: (context) {
                            return Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: (isSwitch)
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.blockSizeHorizontal * 2,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Visibility(
                                                visible: isVisible,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GetBuilder<VideoController>(
                                                      id: "duration",
                                                      builder: (logic) {
                                                        return Text(
                                                          logic.getPosition(),
                                                          style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 76,
                                                      child: _buildCustomProgressIndicator(),
                                                    ),
                                                    Text(
                                                      "${videoController.videoPlayerController.value.duration.inHours.bitLength}:${videoController.videoPlayerController.value.duration.inMinutes}:${videoController.videoPlayerController.value.duration.inSeconds.bitLength}",
                                                      style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 11,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          (isVisible)
                                                              ? GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.unLock,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.boldLock,
                                                                    color: ColorValues.redColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                ),
                                                          Visibility(
                                                            visible: isVisible,
                                                            child: GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setVolume();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    videoController.videoPlayerController.value.volume == 1
                                                                        ? MovixIcon.volumeUp
                                                                        : MovixIcon.volumeOff,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 30,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsPrevious();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.p10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      showBanner = true;
                                                                      showIcon = true;
                                                                    });
                                                                    videoController.setVideo();
                                                                  },
                                                                  child: Icon(
                                                                    videoController.videoPlayerController.value.isPlaying
                                                                        ? Icons.pause
                                                                        : Icons.play_arrow_rounded,
                                                                    color: Colors.white,
                                                                    size: SizeConfig.blockSizeHorizontal * 7.5,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsNext();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.n10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 11,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                _toggleOrientation();
                                                              },
                                                              child: SvgPicture.asset(
                                                                MovixIcon.collapse,
                                                                color: ColorValues.whiteColor,
                                                                width: SizeConfig.blockSizeHorizontal * 4,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            );
                          }),

                    if (!videoController.videoPlayerController.value.isPlaying)
                      isShowingVideoAd
                          ? const SizedBox()
                          : Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: Get.width / 3.6,
                                top: Get.height / 2.4,
                                right: Get.width / 3.5,
                              ),
                              child: (showBanner) ? AdWidget(ad: _bannerAd!) : null,
                            ),
                    if (!videoController.videoPlayerController.value.isPlaying)
                      isShowingVideoAd
                          ? const SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal * 65,
                                top: SizeConfig.blockSizeVertical * 54,
                              ),
                              child: (showIcon)
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showBanner = false;
                                          showIcon = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: ColorValues.grayColor,
                                        size: 23,
                                      ),
                                    )
                                  : null,
                            ),
                    if (isSwitch)
                      isShowingVideoAd
                          ? const SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeHorizontal * 2,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: isVisible,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: SizeConfig.blockSizeHorizontal * 40,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    SystemChrome.setPreferredOrientations(
                                                      [
                                                        DeviceOrientation.portraitUp,
                                                        DeviceOrientation.portraitDown,
                                                      ],
                                                    );
                                                    if (interstitialAd != null) {
                                                      interstitialAd!.show();
                                                    }
                                                    Get.back();
                                                  },
                                                  icon: SvgPicture.asset(
                                                    MovixIcon.arrowLeft,
                                                    color: ColorValues.whiteColor,
                                                    width: SizeConfig.blockSizeHorizontal * 3,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: SizeConfig.screenWidth / 3.5,
                                                  child: Text(
                                                    widget.name,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: ColorValues.whiteColor,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: SizeConfig.blockSizeHorizontal * 11,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    playbackSpeedBottomSheet(context, orientation);
                                                  },
                                                  child: SvgPicture.asset(
                                                    MovixIcon.speed,
                                                    color: ColorValues.whiteColor,
                                                    width: SizeConfig.blockSizeHorizontal * 3.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ],
                );
              } else {
                return Stack(
                  children: [
                    _buildPortraitView(),
                    if (isShowingVideoAd)
                      Positioned.fill(
                        child: ExcludeSemantics(
                          child: Stack(
                            children: [
                              const Positioned.fill(child: ColoredBox(color: Colors.black)),
                              Align(
                                alignment: Alignment.center,
                                child: VideoAdServices.createAdWidget(
                                  onAdCompletedCallback: () {
                                    setState(() => isShowingVideoAd = false);
                                    videoController.videoPlayerController.play();
                                  },
                                  onAdStartedCallback: () => setState(() => isShowingVideoAd = true),
                                  onAdFailedCallback: () {
                                    setState(() => isShowingVideoAd = false);
                                    videoController.videoPlayerController.play();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    isShowingVideoAd
                        ? const SizedBox()
                        : GetBuilder<VideoController>(builder: (context) {
                            return Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: (isSwitch)
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.blockSizeHorizontal * 2,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Visibility(
                                                visible: isVisible,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GetBuilder<VideoController>(
                                                      builder: (GetxController controller) {
                                                        return Text(
                                                          videoController.getPosition(),
                                                          style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 76,
                                                      child: _buildCustomProgressIndicator(),
                                                    ),
                                                    Text(
                                                      "${videoController.videoPlayerController.value.duration.inHours.bitLength}:${videoController.videoPlayerController.value.duration.inMinutes}:${videoController.videoPlayerController.value.duration.inSeconds.bitLength}",
                                                      style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 11,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          (isVisible)
                                                              ? GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.unLock,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.boldLock,
                                                                    color: ColorValues.redColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                ),
                                                          Visibility(
                                                            visible: isVisible,
                                                            child: GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setVolume();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    videoController.videoPlayerController.value.volume == 1
                                                                        ? MovixIcon.volumeUp
                                                                        : MovixIcon.volumeOff,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 30,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsPrevious();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.p10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      showBanner = true;
                                                                      showIcon = true;
                                                                    });
                                                                    videoController.setVideo();
                                                                  },
                                                                  child: Icon(
                                                                    videoController.videoPlayerController.value.isPlaying
                                                                        ? Icons.pause
                                                                        : Icons.play_arrow_rounded,
                                                                    color: Colors.white,
                                                                    size: SizeConfig.blockSizeHorizontal * 7.5,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsNext();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.n10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 11,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                _toggleOrientation();
                                                              },
                                                              child: SvgPicture.asset(
                                                                MovixIcon.collapse,
                                                                color: ColorValues.whiteColor,
                                                                width: SizeConfig.blockSizeHorizontal * 4,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            );
                          }),
                    isShowingVideoAd
                        ? const SizedBox()
                        : Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: (isSwitch)
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    child: Visibility(
                                      visible: isVisible,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: SizeConfig.blockSizeHorizontal * 40,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      SystemChrome.setPreferredOrientations(
                                                        [
                                                          DeviceOrientation.portraitUp,
                                                          DeviceOrientation.portraitDown,
                                                        ],
                                                      );
                                                      if (interstitialAd != null) {
                                                        interstitialAd!.show();
                                                      }
                                                      Get.back();
                                                    },
                                                    icon: SvgPicture.asset(
                                                      MovixIcon.arrowLeft,
                                                      color: ColorValues.whiteColor,
                                                      width: SizeConfig.blockSizeHorizontal * 3,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig.screenWidth / 3.5,
                                                    child: Text(
                                                      widget.name,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: ColorValues.whiteColor,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig.blockSizeHorizontal * 11,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      playbackSpeedBottomSheet(context, orientation);
                                                    },
                                                    child: SvgPicture.asset(
                                                      MovixIcon.speed,
                                                      color: ColorValues.whiteColor,
                                                      width: SizeConfig.blockSizeHorizontal * 3.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeView() {
    log("Video view ${videoController.videoPlayerController.value.isInitialized}");
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Container(
              height: Get.height,
              width: Get.width,
              color: Colors.blueGrey,
              child: widget.link.contains('youtube.com') || widget.link.contains('youtu.be')
                  ? YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(widget.link) ?? '',
                        flags: const YoutubePlayerFlags(
                          autoPlay: true,
                          mute: false,
                          enableCaption: false,
                        ),
                      ),
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blue,
                      topActions: <Widget>[
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      onReady: () {
                        log("YouTube player ready");
                      },
                      onEnded: (data) {
                        log("YouTube player ended $data");
                      },
                    )
                  : videoController.videoPlayerController.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: videoController.videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(videoController.videoPlayerController),
                        )
                      : const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitView() {
    log("Video view enter portrait");
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: videoController.videoPlayerController.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.fill,
                  child: Container(
                    color: ColorValues.blackColor,
                    height: Get.height / 2.7,
                    width: Get.width,
                    child: AspectRatio(
                      aspectRatio: videoController.videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(videoController.videoPlayerController),
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Future<dynamic> playbackSpeedBottomSheet(BuildContext context, Orientation orientation) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      backgroundColor: ColorValues.darkModeMain,
      constraints: BoxConstraints(
        maxWidth: (orientation == Orientation.landscape) ? SizeConfig.screenWidth / 3 : SizeConfig.screenWidth,
        maxHeight: (orientation == Orientation.landscape) ? SizeConfig.screenHeight / 1.5 : SizeConfig.screenHeight / 2.5,
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return false;
              },
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        if (selectedIndexes.contains(index)) {
                          setState(() {
                            selectedIndexes = [];
                          });
                        } else {
                          setState(() {
                            selectedIndexes = [];
                            selectedIndexes.add(index);
                          });
                        }
                        videoController.videoPlayerController.setPlaybackSpeed(playbackSpeed[index]);
                        Get.back();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (selectedIndexes.contains(index))
                              ? const Icon(
                                  Icons.done,
                                  color: ColorValues.redColor,
                                )
                              : Container(width: 25),
                          const SizedBox(width: 20),
                          Text(
                            playbackSpeed[index].toString(),
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: playbackSpeed.length,
              ),
            );
          },
        );
      },
    );
  }
}*/

///circular ad show
/*class VideoPlayers extends StatefulWidget {
  String name;
  String link;
  bool type;

  VideoPlayers({super.key, required this.name, required this.link, required this.type});

  @override
  State<VideoPlayers> createState() => _VideoPlayersState();
}

class _VideoPlayersState extends State<VideoPlayers> {
  var selectedIndexes = [3];
  bool isPlaybackSpeed = false;
  bool isSwitch = true;
  bool isVisible = true;
  bool showBanner = false;
  bool showIcon = true;
  Duration duration = const Duration();
  Timer? timer;
  Timer? adTimer;
  String videolink = "";
  List<double> playbackSpeed = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];

  // Ad related variables
  InterstitialAd? interstitialAd;
  BannerAd? _bannerAd;

  // Ad overlay flags
  bool isShowingVideoAd = false;
  bool adsInitialized = false;

  // Video starts right away (no pre-roll)
  bool videoCanPlay = true;

  // Mid-roll configuration
  List<double> adShowPercentages = [25.0, 50.0, 75.0, 90.0];
  List<bool> adsShown = [false, false, false, false];
  Duration? videoDuration;
  int currentAdIndex = 0;
  Timer? adProgressTimer;

  // NEW: spinner for first 2–3s while ad loads
  bool showAdSpinner = false;
  Timer? adSpinnerTimer;

  VideoController videoController = Get.put(VideoController());

  @override
  void initState() {
    super.initState();
    loadBannerAds();
    _loadInterstitialAd();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    log("Video Link :: ${widget.link}");
    setState(() {
      videolink = widget.link;
    });

    // Initialize and play immediately (no pre-roll)
    videoController.videoPlayerController = (widget.type)
        ? VideoPlayerController.networkUrl(Uri.parse(videolink))
        : VideoPlayerController.file(
            File("/storage/emulated/0/Android/data/com.mova.android/files/${widget.name}"),
          );

    videoController.videoPlayerController.initialize().then((_) {
      if (videoController.videoPlayerController.value.isInitialized) {
        if (widget.type || File(videoController.videoPlayerController.dataSource).existsSync()) {
          setState(() {
            videoDuration = videoController.videoPlayerController.value.duration;
            videoController.videoPlayerController.setLooping(false);
            log("Video initialized with duration: ${videoDuration?.inSeconds} seconds");
          });

          videoController.videoPlayerController.play(); // starts immediately
          log("Video started without pre-roll ad");

          // Start mid-roll monitor
          startAdProgressTimer();
        } else {
          log("Video file does not exist");
        }
      }
    }).catchError((error) {
      log("Video initialization error: $error");
    });

    Timer.periodic(const Duration(seconds: 1), (_) {
      videoController.updateSeeker();
    });
  }

  bool get _isLandscape => MediaQuery.of(context).orientation == Orientation.landscape;

  Future<void> _toggleOrientation() async {
    if (_isLandscape) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  void startAdProgressTimer() {
    adProgressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (videoController.videoPlayerController.value.isInitialized &&
          videoController.videoPlayerController.value.isPlaying &&
          videoDuration != null) {
        Duration currentPosition = videoController.videoPlayerController.value.position;
        double progressPercentage = (currentPosition.inSeconds / videoDuration!.inSeconds) * 100;

        for (int i = 0; i < adShowPercentages.length; i++) {
          if (!adsShown[i] && progressPercentage >= adShowPercentages[i]) {
            log("Showing ad at ${adShowPercentages[i]}% progress");
            showMidRollAd(i);
            break;
          }
        }
      }
    });
  }

  Widget _buildCustomProgressIndicator() {
    final controller = videoController.videoPlayerController;

    if (!controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final totalMs = value.duration.inMilliseconds;
        final posMs = value.position.inMilliseconds;
        final played = totalMs == 0 ? 0.0 : (posMs / totalMs).clamp(0.0, 1.0);

        double buffered = 0.0;
        if (value.buffered.isNotEmpty && totalMs > 0) {
          buffered = (value.buffered.last.end.inMilliseconds / totalMs).clamp(0.0, 1.0);
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final barHeight = 4.0;
            final width = constraints.maxWidth;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: barHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: barHeight,
                    width: width * buffered,
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: barHeight,
                    width: width * played,
                    decoration: const BoxDecoration(color: Colors.red),
                  ),
                ),
                SizedBox(
                  height: max(barHeight, 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 16,
                      child: VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        padding: EdgeInsets.zero,
                        colors: const VideoProgressColors(
                          backgroundColor: Colors.transparent,
                          bufferedColor: Colors.transparent,
                          playedColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                for (int i = 0; i < adShowPercentages.length; i++)
                  Positioned(
                    left: (width * (adShowPercentages[i] / 100)) - 4,
                    top: -0.8,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: adsShown[i] ? Colors.grey : Colors.yellow,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  // Helper: start the spinner for ~2.5s while ad loads
  void _startAdSpinner({int millis = 2500}) {
    setState(() => showAdSpinner = true);
    adSpinnerTimer?.cancel();
    adSpinnerTimer = Timer(Duration(milliseconds: millis), () {
      if (mounted) setState(() => showAdSpinner = false);
    });
  }

  // Mid-roll ad only (no pre-roll)
  void showMidRollAd(int adIndex) {
    setState(() {
      adsShown[adIndex] = true;
      currentAdIndex = adIndex;
      isShowingVideoAd = true;
    });

    // Pause main video and show spinner immediately
    videoController.videoPlayerController.pause();
    _startAdSpinner(); // show 2–3s loader while ad prepares

    log("Showing mid-roll ad ${adIndex + 1}");

    VideoAdServices.initialize(
      onAdCompletedCallback: () {
        log("Mid-roll ad ${adIndex + 1} completed, resuming video");
        setState(() {
          isShowingVideoAd = false;
          showAdSpinner = false;
        });
        videoController.videoPlayerController.play();
      },
      onAdStartedCallback: () {
        log("Mid-roll ad ${adIndex + 1} started");
        // As soon as the ad actually starts, we can hide spinner if still visible
        if (mounted) setState(() => showAdSpinner = false);
      },
      onAdFailedCallback: () {
        log("Mid-roll ad ${adIndex + 1} failed, resuming video");
        setState(() {
          isShowingVideoAd = false;
          showAdSpinner = false;
        });
        videoController.videoPlayerController.play();
      },
    );
  }

  _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              if (!isShowingVideoAd) {
                videoController.videoPlayerController.play();
              }
            },
          );
          setState(() {
            interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void loadBannerAds() async {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(minutes: 5), (_) => addTime());
  }

  addTime() async {
    const addSeconds = 1;
    final seconds = duration.inMinutes + addSeconds;
    if (seconds == 5) {
      setState(() {
        _loadInterstitialAd();
        videoController.videoPlayerController.pause();
        interstitialAd?.show();
      });
    }
    duration = Duration(minutes: seconds);
  }

  void showToast() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    adTimer?.cancel();
    adProgressTimer?.cancel();
    adSpinnerTimer?.cancel();
    videoController.dispose();
    VideoAdServices.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("----------link---------->>>>>>$videolink");
    print("----------name---------->>>>>>${widget.name}");
    log("Video controlleer :: ${videoController.videoPlayerController}");

    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        if (isVisible) {
          await SystemChrome.setPreferredOrientations(
            [
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ],
          );
          if (interstitialAd != null) {
            interstitialAd!.show();
          }
          Get.back();
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSwitch = !isSwitch;
          });
        },
        child: Scaffold(
          backgroundColor: ColorValues.blackColor,
          body: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              if (orientation == Orientation.landscape) {
                return Stack(
                  children: [
                    _buildLandscapeView(),

                    // Ad overlay (mid-roll) with spinner for first 2–3 seconds
                    if (isShowingVideoAd)
                      Positioned.fill(
                        child: ExcludeSemantics(
                          child: Stack(
                            children: [
                              const Positioned.fill(child: ColoredBox(color: Colors.black)),
                              Align(
                                alignment: Alignment.center,
                                child: showAdSpinner
                                    ? const SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 4,
                                          color: Colors.red,
                                        ),
                                      )
                                    : VideoAdServices.createAdWidget(
                                        onAdCompletedCallback: () {
                                          setState(() => isShowingVideoAd = false);
                                          videoController.videoPlayerController.play();
                                        },
                                        onAdStartedCallback: () => setState(() => showAdSpinner = false),
                                        onAdFailedCallback: () {
                                          setState(() => isShowingVideoAd = false);
                                          videoController.videoPlayerController.play();
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Controls
                    isShowingVideoAd
                        ? const SizedBox()
                        : GetBuilder<VideoController>(builder: (context) {
                            return Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: (isSwitch)
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.blockSizeHorizontal * 2,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Visibility(
                                                visible: isVisible,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GetBuilder<VideoController>(
                                                      id: "duration",
                                                      builder: (logic) {
                                                        return Text(
                                                          logic.getPosition(),
                                                          style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 76,
                                                      child: _buildCustomProgressIndicator(),
                                                    ),
                                                    Text(
                                                      "${videoController.videoPlayerController.value.duration.inHours.bitLength}:${videoController.videoPlayerController.value.duration.inMinutes}:${videoController.videoPlayerController.value.duration.inSeconds.bitLength}",
                                                      style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 11,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          (isVisible)
                                                              ? GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.unLock,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.boldLock,
                                                                    color: ColorValues.redColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                ),
                                                          Visibility(
                                                            visible: isVisible,
                                                            child: GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setVolume();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    videoController.videoPlayerController.value.volume == 1
                                                                        ? MovixIcon.volumeUp
                                                                        : MovixIcon.volumeOff,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 30,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsPrevious();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.p10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      showBanner = true;
                                                                      showIcon = true;
                                                                    });
                                                                    videoController.setVideo();
                                                                  },
                                                                  child: Icon(
                                                                    videoController.videoPlayerController.value.isPlaying
                                                                        ? Icons.pause
                                                                        : Icons.play_arrow_rounded,
                                                                    color: Colors.white,
                                                                    size: SizeConfig.blockSizeHorizontal * 7.5,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsNext();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.n10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 11,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                _toggleOrientation();
                                                              },
                                                              child: SvgPicture.asset(
                                                                MovixIcon.collapse,
                                                                color: ColorValues.whiteColor,
                                                                width: SizeConfig.blockSizeHorizontal * 4,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            );
                          }),

                    if (!videoController.videoPlayerController.value.isPlaying)
                      isShowingVideoAd
                          ? const SizedBox()
                          : Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: Get.width / 3.6,
                                top: Get.height / 2.4,
                                right: Get.width / 3.5,
                              ),
                              child: (showBanner) ? AdWidget(ad: _bannerAd!) : null,
                            ),
                    if (!videoController.videoPlayerController.value.isPlaying)
                      isShowingVideoAd
                          ? const SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal * 65,
                                top: SizeConfig.blockSizeVertical * 54,
                              ),
                              child: (showIcon)
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showBanner = false;
                                          showIcon = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: ColorValues.grayColor,
                                        size: 23,
                                      ),
                                    )
                                  : null,
                            ),
                    if (isSwitch)
                      isShowingVideoAd
                          ? const SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeHorizontal * 2,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: isVisible,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: SizeConfig.blockSizeHorizontal * 40,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    SystemChrome.setPreferredOrientations(
                                                      [
                                                        DeviceOrientation.portraitUp,
                                                        DeviceOrientation.portraitDown,
                                                      ],
                                                    );
                                                    if (interstitialAd != null) {
                                                      interstitialAd!.show();
                                                    }
                                                    Get.back();
                                                  },
                                                  icon: SvgPicture.asset(
                                                    MovixIcon.arrowLeft,
                                                    color: ColorValues.whiteColor,
                                                    width: SizeConfig.blockSizeHorizontal * 3,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: SizeConfig.screenWidth / 3.5,
                                                  child: Text(
                                                    widget.name,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: ColorValues.whiteColor,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: SizeConfig.blockSizeHorizontal * 11,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    playbackSpeedBottomSheet(context, orientation);
                                                  },
                                                  child: SvgPicture.asset(
                                                    MovixIcon.speed,
                                                    color: ColorValues.whiteColor,
                                                    width: SizeConfig.blockSizeHorizontal * 3.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ],
                );
              } else {
                return Stack(
                  children: [
                    _buildPortraitView(),

                    // Ad overlay in portrait with spinner
                    if (isShowingVideoAd)
                      Positioned.fill(
                        child: ExcludeSemantics(
                          child: Stack(
                            children: [
                              const Positioned.fill(child: ColoredBox(color: Colors.black)),
                              Align(
                                alignment: Alignment.center,
                                child: showAdSpinner
                                    ? const SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 4,
                                          color: Colors.red,
                                        ),
                                      )
                                    : VideoAdServices.createAdWidget(
                                        onAdCompletedCallback: () {
                                          setState(() => isShowingVideoAd = false);
                                          videoController.videoPlayerController.play();
                                        },
                                        onAdStartedCallback: () => setState(() => showAdSpinner = false),
                                        onAdFailedCallback: () {
                                          setState(() => isShowingVideoAd = false);
                                          videoController.videoPlayerController.play();
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    isShowingVideoAd
                        ? const SizedBox()
                        : GetBuilder<VideoController>(builder: (context) {
                            return Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: (isSwitch)
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.blockSizeHorizontal * 2,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Visibility(
                                                visible: isVisible,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GetBuilder<VideoController>(
                                                      builder: (GetxController controller) {
                                                        return Text(
                                                          videoController.getPosition(),
                                                          style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 76,
                                                      child: _buildCustomProgressIndicator(),
                                                    ),
                                                    Text(
                                                      "${videoController.videoPlayerController.value.duration.inHours.bitLength}:${videoController.videoPlayerController.value.duration.inMinutes}:${videoController.videoPlayerController.value.duration.inSeconds.bitLength}",
                                                      style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 11,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          (isVisible)
                                                              ? GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.unLock,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.boldLock,
                                                                    color: ColorValues.redColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                ),
                                                          Visibility(
                                                            visible: isVisible,
                                                            child: GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setVolume();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    videoController.videoPlayerController.value.volume == 1
                                                                        ? MovixIcon.volumeUp
                                                                        : MovixIcon.volumeOff,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 30,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsPrevious();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.p10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      showBanner = true;
                                                                      showIcon = true;
                                                                    });
                                                                    videoController.setVideo();
                                                                  },
                                                                  child: Icon(
                                                                    videoController.videoPlayerController.value.isPlaying
                                                                        ? Icons.pause
                                                                        : Icons.play_arrow_rounded,
                                                                    color: Colors.white,
                                                                    size: SizeConfig.blockSizeHorizontal * 7.5,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsNext();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.n10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 11,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                _toggleOrientation();
                                                              },
                                                              child: SvgPicture.asset(
                                                                MovixIcon.collapse,
                                                                color: ColorValues.whiteColor,
                                                                width: SizeConfig.blockSizeHorizontal * 4,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            );
                          }),
                    isShowingVideoAd
                        ? const SizedBox()
                        : Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: (isSwitch)
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    child: Visibility(
                                      visible: isVisible,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: SizeConfig.blockSizeHorizontal * 40,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      SystemChrome.setPreferredOrientations(
                                                        [
                                                          DeviceOrientation.portraitUp,
                                                          DeviceOrientation.portraitDown,
                                                        ],
                                                      );
                                                      if (interstitialAd != null) {
                                                        interstitialAd!.show();
                                                      }
                                                      Get.back();
                                                    },
                                                    icon: SvgPicture.asset(
                                                      MovixIcon.arrowLeft,
                                                      color: ColorValues.whiteColor,
                                                      width: SizeConfig.blockSizeHorizontal * 3,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig.screenWidth / 3.5,
                                                    child: Text(
                                                      widget.name,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: ColorValues.whiteColor,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig.blockSizeHorizontal * 11,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      playbackSpeedBottomSheet(context, orientation);
                                                    },
                                                    child: SvgPicture.asset(
                                                      MovixIcon.speed,
                                                      color: ColorValues.whiteColor,
                                                      width: SizeConfig.blockSizeHorizontal * 3.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeView() {
    log("Video view ${videoController.videoPlayerController.value.isInitialized}");
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Container(
              height: Get.height,
              width: Get.width,
              color: Colors.blueGrey,
              child: widget.link.contains('youtube.com') || widget.link.contains('youtu.be')
                  ? YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(widget.link) ?? '',
                        flags: const YoutubePlayerFlags(
                          autoPlay: true,
                          mute: false,
                          enableCaption: false,
                        ),
                      ),
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blue,
                      topActions: <Widget>[
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      onReady: () {
                        log("YouTube player ready");
                      },
                      onEnded: (data) {
                        log("YouTube player ended $data");
                      },
                    )
                  : videoController.videoPlayerController.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: videoController.videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(videoController.videoPlayerController),
                        )
                      : const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitView() {
    log("Video view enter portrait");
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: videoController.videoPlayerController.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.fill,
                  child: Container(
                    color: ColorValues.blackColor,
                    height: Get.height / 2.7,
                    width: Get.width,
                    child: AspectRatio(
                      aspectRatio: videoController.videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(videoController.videoPlayerController),
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Future<dynamic> playbackSpeedBottomSheet(BuildContext context, Orientation orientation) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      backgroundColor: ColorValues.darkModeMain,
      constraints: BoxConstraints(
        maxWidth: (orientation == Orientation.landscape) ? SizeConfig.screenWidth / 3 : SizeConfig.screenWidth,
        maxHeight: (orientation == Orientation.landscape) ? SizeConfig.screenHeight / 1.5 : SizeConfig.screenHeight / 2.5,
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return false;
              },
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        if (selectedIndexes.contains(index)) {
                          setState(() {
                            selectedIndexes = [];
                          });
                          // unselect
                        } else {
                          setState(() {
                            selectedIndexes = [];
                            selectedIndexes.add(index);
                          }); // select
                        }
                        videoController.videoPlayerController.setPlaybackSpeed(playbackSpeed[index]);
                        Get.back();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (selectedIndexes.contains(index))
                              ? const Icon(
                                  Icons.done,
                                  color: ColorValues.redColor,
                                )
                              : Container(
                                  width: 25,
                                ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            playbackSpeed[index].toString(),
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: playbackSpeed.length,
              ),
            );
          },
        );
      },
    );
  }
}*/

///
class VideoPlayers extends StatefulWidget {
  String name;
  String link;
  bool type;

  VideoPlayers({super.key, required this.name, required this.link, required this.type});

  @override
  State<VideoPlayers> createState() => _VideoPlayersState();
}

class _VideoPlayersState extends State<VideoPlayers> {
  var selectedIndexes = [3];
  bool isPlaybackSpeed = false;
  bool isSwitch = true;
  bool isVisible = true;
  bool showBanner = false;
  bool showIcon = true;
  Duration duration = const Duration();
  Timer? timer;
  Timer? adTimer;
  String videolink = "";
  List<double> playbackSpeed = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];

  // Ad related variables
  InterstitialAd? interstitialAd;
  BannerAd? _bannerAd;

  // Ad overlay flags
  bool isShowingVideoAd = false;
  bool adsInitialized = false;

  // Video starts right away (no pre-roll)
  bool videoCanPlay = true;

  // Mid-roll configuration
  List<double> adShowPercentages = [25.0, 50.0, 75.0, 90.0];
  List<bool> adsShown = [false, false, false, false];
  Duration? videoDuration;
  int currentAdIndex = 0;
  Timer? adProgressTimer;

  // Spinner shown only until ad actually starts; it does NOT block ad from rendering
  bool showAdSpinner = false;

  VideoController videoController = Get.put(VideoController());

  @override
  void initState() {
    super.initState();
    loadBannerAds();
    _loadInterstitialAd();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    log("Video Link :: ${widget.link}");
    setState(() {
      videolink = widget.link;
    });

    // Initialize and play immediately (no pre-roll)
    videoController.videoPlayerController = (widget.type)
        ? VideoPlayerController.networkUrl(Uri.parse(videolink))
        : VideoPlayerController.file(
            File("/storage/emulated/0/Android/data/com.mova.android/files/${widget.name}"),
          );

    videoController.videoPlayerController.initialize().then((_) {
      if (videoController.videoPlayerController.value.isInitialized) {
        if (widget.type || File(videoController.videoPlayerController.dataSource).existsSync()) {
          setState(() {
            videoDuration = videoController.videoPlayerController.value.duration;
            videoController.videoPlayerController.setLooping(false);
            log("Video initialized with duration: ${videoDuration?.inSeconds} seconds");
          });

          videoController.videoPlayerController.play();
          log("Video started without pre-roll ad");

          // Start mid-roll monitor
          startAdProgressTimer();
        } else {
          log("Video file does not exist");
        }
      }
    }).catchError((error) {
      log("Video initialization error: $error");
    });

    Timer.periodic(const Duration(seconds: 1), (_) {
      videoController.updateSeeker();
    });
  }

  bool get _isLandscape => MediaQuery.of(context).orientation == Orientation.landscape;

  Future<void> _toggleOrientation() async {
    if (_isLandscape) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  void startAdProgressTimer() {
    adProgressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (videoController.videoPlayerController.value.isInitialized &&
          videoController.videoPlayerController.value.isPlaying &&
          videoDuration != null) {
        Duration currentPosition = videoController.videoPlayerController.value.position;
        double progressPercentage = (currentPosition.inSeconds / videoDuration!.inSeconds) * 100;

        for (int i = 0; i < adShowPercentages.length; i++) {
          if (!adsShown[i] && progressPercentage >= adShowPercentages[i]) {
            log("Showing ad at ${adShowPercentages[i]}% progress");
            showMidRollAd(i);
            break;
          }
        }
      }
    });
  }

  Widget _buildCustomProgressIndicator() {
    final controller = videoController.videoPlayerController;

    if (!controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final totalMs = value.duration.inMilliseconds;
        final posMs = value.position.inMilliseconds;
        final played = totalMs == 0 ? 0.0 : (posMs / totalMs).clamp(0.0, 1.0);

        double buffered = 0.0;
        if (value.buffered.isNotEmpty && totalMs > 0) {
          buffered = (value.buffered.last.end.inMilliseconds / totalMs).clamp(0.0, 1.0);
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final barHeight = 4.0;
            final width = constraints.maxWidth;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: barHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: barHeight,
                    width: width * buffered,
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: barHeight,
                    width: width * played,
                    decoration: const BoxDecoration(color: Colors.red),
                  ),
                ),
                SizedBox(
                  height: max(barHeight, 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 16,
                      child: VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        padding: EdgeInsets.zero,
                        colors: const VideoProgressColors(
                          backgroundColor: Colors.transparent,
                          bufferedColor: Colors.transparent,
                          playedColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                for (int i = 0; i < adShowPercentages.length; i++)
                  Positioned(
                    left: (width * (adShowPercentages[i] / 100)) - 4,
                    top: -0.8,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: adsShown[i] ? Colors.grey : Colors.yellow,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  // Mid-roll ad only (no pre-roll)
  void showMidRollAd(int adIndex) {
    setState(() {
      adsShown[adIndex] = true;
      currentAdIndex = adIndex;
      isShowingVideoAd = true;
      showAdSpinner = true; // show spinner but DO NOT block ad widget
    });

    // Pause main video
    videoController.videoPlayerController.pause();

    log("Showing mid-roll ad ${adIndex + 1}");

    VideoAdServices.initialize(
      onAdCompletedCallback: () {
        log("Mid-roll ad ${adIndex + 1} completed, resuming video");
        if (mounted) {
          setState(() {
            isShowingVideoAd = false;
            showAdSpinner = false;
          });
        }
        videoController.videoPlayerController.play();
      },
      onAdStartedCallback: () {
        log("Mid-roll ad ${adIndex + 1} started");
        // As soon as the ad actually starts, hide the spinner
        if (mounted) setState(() => showAdSpinner = false);
      },
      onAdFailedCallback: () {
        log("Mid-roll ad ${adIndex + 1} failed, resuming video");
        if (mounted) {
          setState(() {
            isShowingVideoAd = false;
            showAdSpinner = false;
          });
        }
        videoController.videoPlayerController.play();
      },
    );
  }

  _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              if (!isShowingVideoAd) {
                videoController.videoPlayerController.play();
              }
            },
          );
          setState(() {
            interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void loadBannerAds() async {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(minutes: 5), (_) => addTime());
  }

  addTime() async {
    const addSeconds = 1;
    final seconds = duration.inMinutes + addSeconds;
    if (seconds == 5) {
      setState(() {
        _loadInterstitialAd();
        videoController.videoPlayerController.pause();
        interstitialAd?.show();
      });
    }
    duration = Duration(minutes: seconds);
  }

  void showToast() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    adTimer?.cancel();
    adProgressTimer?.cancel();
    videoController.dispose();
    VideoAdServices.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("----------link---------->>>>>>$videolink");
    print("----------name---------->>>>>>${widget.name}");
    log("Video controlleer :: ${videoController.videoPlayerController}");

    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        if (isVisible) {
          await SystemChrome.setPreferredOrientations(
            [
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ],
          );
          if (interstitialAd != null) {
            interstitialAd!.show();
          }
          Get.back();
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSwitch = !isSwitch;
          });
        },
        child: Scaffold(
          backgroundColor: ColorValues.blackColor,
          body: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              if (orientation == Orientation.landscape) {
                return Stack(
                  children: [
                    _buildLandscapeView(),

                    // Ad overlay (mid-roll): ad widget renders immediately, spinner overlays it and hides on ad start
                    if (isShowingVideoAd)
                      Positioned.fill(
                        child: ExcludeSemantics(
                          child: Stack(
                            children: [
                              const Positioned.fill(child: ColoredBox(color: Colors.black)),
                              // Ad widget is ALWAYS in the tree so it can show immediately.
                              Align(
                                alignment: Alignment.center,
                                child: VideoAdServices.createAdWidget(
                                  onAdCompletedCallback: () {
                                    setState(() => isShowingVideoAd = false);
                                    videoController.videoPlayerController.play();
                                  },
                                  onAdStartedCallback: () => setState(() => showAdSpinner = false),
                                  onAdFailedCallback: () {
                                    setState(() => isShowingVideoAd = false);
                                    videoController.videoPlayerController.play();
                                  },
                                ),
                              ),
                              // Spinner overlays the ad until onAdStarted fires (does not block ad render)
                              if (showAdSpinner)
                                const IgnorePointer(
                                  ignoring: true,
                                  child: Center(
                                    child: SpinKitCircle(
                                      color: Colors.red,
                                      size: 60,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                    // Controls
                    isShowingVideoAd
                        ? const SizedBox()
                        : GetBuilder<VideoController>(builder: (context) {
                            return Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: (isSwitch)
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.blockSizeHorizontal * 2,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Visibility(
                                                visible: isVisible,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GetBuilder<VideoController>(
                                                      id: "duration",
                                                      builder: (logic) {
                                                        return Text(
                                                          logic.getPosition(),
                                                          style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 76,
                                                      child: _buildCustomProgressIndicator(),
                                                    ),
                                                    Text(
                                                      "${videoController.videoPlayerController.value.duration.inHours.bitLength}:${videoController.videoPlayerController.value.duration.inMinutes}:${videoController.videoPlayerController.value.duration.inSeconds.bitLength}",
                                                      style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 11,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          (isVisible)
                                                              ? GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.unLock,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.boldLock,
                                                                    color: ColorValues.redColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                ),
                                                          Visibility(
                                                            visible: isVisible,
                                                            child: GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setVolume();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    videoController.videoPlayerController.value.volume == 1
                                                                        ? MovixIcon.volumeUp
                                                                        : MovixIcon.volumeOff,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 30,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsPrevious();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.p10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      showBanner = true;
                                                                      showIcon = true;
                                                                    });
                                                                    videoController.setVideo();
                                                                  },
                                                                  child: Icon(
                                                                    videoController.videoPlayerController.value.isPlaying
                                                                        ? Icons.pause
                                                                        : Icons.play_arrow_rounded,
                                                                    color: Colors.white,
                                                                    size: SizeConfig.blockSizeHorizontal * 7.5,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsNext();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.n10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 11,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                _toggleOrientation();
                                                              },
                                                              child: SvgPicture.asset(
                                                                MovixIcon.collapse,
                                                                color: ColorValues.whiteColor,
                                                                width: SizeConfig.blockSizeHorizontal * 4,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            );
                          }),

                    if (!videoController.videoPlayerController.value.isPlaying)
                      isShowingVideoAd
                          ? const SizedBox()
                          : Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: Get.width / 3.6,
                                top: Get.height / 2.4,
                                right: Get.width / 3.5,
                              ),
                              child: (showBanner) ? AdWidget(ad: _bannerAd!) : null,
                            ),
                    if (!videoController.videoPlayerController.value.isPlaying)
                      isShowingVideoAd
                          ? const SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal * 65,
                                top: SizeConfig.blockSizeVertical * 54,
                              ),
                              child: (showIcon)
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showBanner = false;
                                          showIcon = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: ColorValues.grayColor,
                                        size: 23,
                                      ),
                                    )
                                  : null,
                            ),
                    if (isSwitch)
                      isShowingVideoAd
                          ? const SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeHorizontal * 2,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: isVisible,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: SizeConfig.blockSizeHorizontal * 40,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    SystemChrome.setPreferredOrientations(
                                                      [
                                                        DeviceOrientation.portraitUp,
                                                        DeviceOrientation.portraitDown,
                                                      ],
                                                    );
                                                    if (interstitialAd != null) {
                                                      interstitialAd!.show();
                                                    }
                                                    Get.back();
                                                  },
                                                  icon: SvgPicture.asset(
                                                    MovixIcon.arrowLeft,
                                                    color: ColorValues.whiteColor,
                                                    width: SizeConfig.blockSizeHorizontal * 3,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: SizeConfig.screenWidth / 3.5,
                                                  child: Text(
                                                    widget.name,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: ColorValues.whiteColor,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: SizeConfig.blockSizeHorizontal * 11,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    playbackSpeedBottomSheet(context, orientation);
                                                  },
                                                  child: SvgPicture.asset(
                                                    MovixIcon.speed,
                                                    color: ColorValues.whiteColor,
                                                    width: SizeConfig.blockSizeHorizontal * 3.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ],
                );
              } else {
                return Stack(
                  children: [
                    _buildPortraitView(),

                    // Ad overlay in portrait (ad renders immediately; spinner overlays and hides on start)
                    if (isShowingVideoAd)
                      Positioned.fill(
                        child: ExcludeSemantics(
                          child: Stack(
                            children: [
                              const Positioned.fill(child: ColoredBox(color: Colors.black)),
                              Align(
                                alignment: Alignment.center,
                                child: VideoAdServices.createAdWidget(
                                  onAdCompletedCallback: () {
                                    setState(() => isShowingVideoAd = false);
                                    videoController.videoPlayerController.play();
                                  },
                                  onAdStartedCallback: () => setState(() => showAdSpinner = false),
                                  onAdFailedCallback: () {
                                    setState(() => isShowingVideoAd = false);
                                    videoController.videoPlayerController.play();
                                  },
                                ),
                              ),
                              if (showAdSpinner)
                                const IgnorePointer(
                                  ignoring: true,
                                  child: Center(
                                    child: SpinKitCircle(
                                      color: Colors.red,
                                      size: 60,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                    isShowingVideoAd
                        ? const SizedBox()
                        : GetBuilder<VideoController>(builder: (context) {
                            return Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: (isSwitch)
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.blockSizeHorizontal * 2,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Visibility(
                                                visible: isVisible,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GetBuilder<VideoController>(
                                                      builder: (GetxController controller) {
                                                        return Text(
                                                          videoController.getPosition(),
                                                          style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 76,
                                                      child: _buildCustomProgressIndicator(),
                                                    ),
                                                    Text(
                                                      "${videoController.videoPlayerController.value.duration.inHours.bitLength}:${videoController.videoPlayerController.value.duration.inMinutes}:${videoController.videoPlayerController.value.duration.inSeconds.bitLength}",
                                                      style: const TextStyle(color: ColorValues.whiteColor, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal * 11,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          (isVisible)
                                                              ? GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.unLock,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap: showToast,
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.boldLock,
                                                                    color: ColorValues.redColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                ),
                                                          Visibility(
                                                            visible: isVisible,
                                                            child: GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setVolume();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    videoController.videoPlayerController.value.volume == 1
                                                                        ? MovixIcon.volumeUp
                                                                        : MovixIcon.volumeOff,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 30,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsPrevious();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.p10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      showBanner = true;
                                                                      showIcon = true;
                                                                    });
                                                                    videoController.setVideo();
                                                                  },
                                                                  child: Icon(
                                                                    videoController.videoPlayerController.value.isPlaying
                                                                        ? Icons.pause
                                                                        : Icons.play_arrow_rounded,
                                                                    color: Colors.white,
                                                                    size: SizeConfig.blockSizeHorizontal * 7.5,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            GetBuilder<VideoController>(
                                                              builder: (GetxController controller) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    videoController.setTenSecondsNext();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    MovixIcon.n10,
                                                                    color: ColorValues.whiteColor,
                                                                    width: SizeConfig.blockSizeHorizontal * 4,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isVisible,
                                                      child: SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal * 11,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                _toggleOrientation();
                                                              },
                                                              child: SvgPicture.asset(
                                                                MovixIcon.collapse,
                                                                color: ColorValues.whiteColor,
                                                                width: SizeConfig.blockSizeHorizontal * 4,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            );
                          }),
                    isShowingVideoAd
                        ? const SizedBox()
                        : Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: (isSwitch)
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    child: Visibility(
                                      visible: isVisible,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: SizeConfig.blockSizeHorizontal * 40,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      SystemChrome.setPreferredOrientations(
                                                        [
                                                          DeviceOrientation.portraitUp,
                                                          DeviceOrientation.portraitDown,
                                                        ],
                                                      );
                                                      if (interstitialAd != null) {
                                                        interstitialAd!.show();
                                                      }
                                                      Get.back();
                                                    },
                                                    icon: SvgPicture.asset(
                                                      MovixIcon.arrowLeft,
                                                      color: ColorValues.whiteColor,
                                                      width: SizeConfig.blockSizeHorizontal * 3,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig.screenWidth / 3.5,
                                                    child: Text(
                                                      widget.name,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: ColorValues.whiteColor,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig.blockSizeHorizontal * 11,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      playbackSpeedBottomSheet(context, orientation);
                                                    },
                                                    child: SvgPicture.asset(
                                                      MovixIcon.speed,
                                                      color: ColorValues.whiteColor,
                                                      width: SizeConfig.blockSizeHorizontal * 3.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeView() {
    log("Video view ${videoController.videoPlayerController.value.isInitialized}");
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Container(
              height: Get.height,
              width: Get.width,
              color: Colors.blueGrey,
              child: widget.link.contains('youtube.com') || widget.link.contains('youtu.be')
                  ? YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(widget.link) ?? '',
                        flags: const YoutubePlayerFlags(
                          autoPlay: true,
                          mute: false,
                          enableCaption: false,
                        ),
                      ),
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blue,
                      topActions: <Widget>[
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      onReady: () {
                        log("YouTube player ready");
                      },
                      onEnded: (data) {
                        log("YouTube player ended $data");
                      },
                    )
                  : videoController.videoPlayerController.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: videoController.videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(videoController.videoPlayerController),
                        )
                      : const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitView() {
    log("Video view enter portrait");
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: videoController.videoPlayerController.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.fill,
                  child: Container(
                    color: ColorValues.blackColor,
                    height: Get.height / 2.7,
                    width: Get.width,
                    child: AspectRatio(
                      aspectRatio: videoController.videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(videoController.videoPlayerController),
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Future<dynamic> playbackSpeedBottomSheet(BuildContext context, Orientation orientation) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      backgroundColor: ColorValues.darkModeMain,
      constraints: BoxConstraints(
        maxWidth: (orientation == Orientation.landscape) ? SizeConfig.screenWidth / 3 : SizeConfig.screenWidth,
        maxHeight: (orientation == Orientation.landscape) ? SizeConfig.screenHeight / 1.5 : SizeConfig.screenHeight / 2.5,
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return false;
              },
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        if (selectedIndexes.contains(index)) {
                          setState(() {
                            selectedIndexes = [];
                          }); // unselect
                        } else {
                          setState(() {
                            selectedIndexes = [];
                            selectedIndexes.add(index);
                          }); // select
                        }
                        videoController.videoPlayerController.setPlaybackSpeed(playbackSpeed[index]);
                        Get.back();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (selectedIndexes.contains(index)) ? const Icon(Icons.done, color: ColorValues.redColor) : Container(width: 25),
                          const SizedBox(width: 20),
                          Text(
                            playbackSpeed[index].toString(),
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: playbackSpeed.length,
              ),
            );
          },
        );
      },
    );
  }
}
