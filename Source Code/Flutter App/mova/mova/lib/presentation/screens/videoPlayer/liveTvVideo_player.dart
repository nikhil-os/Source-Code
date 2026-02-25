// ignore_for_file: file_names, must_be_immutable, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/helper/ads_helper.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:video_player/video_player.dart';

/*
class LiveTvVideoPlayerScreen extends StatefulWidget {
  String name;
  String link;

  LiveTvVideoPlayerScreen({super.key, required this.name, required this.link});

  @override
  State<LiveTvVideoPlayerScreen> createState() => _LiveTvVideoPlayerScreen();
}

class _LiveTvVideoPlayerScreen extends State<LiveTvVideoPlayerScreen> {
  late VideoPlayerController controller;
  bool isVisible = false;
  bool showBanner = false;
  bool showIcon = false;
  BannerAd? _bannerAd;
  InterstitialAd? interstitialAd;
  _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
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

  @override
  void initState() {
    loadBannerAds();
    _loadInterstitialAd();
    super.initState();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ],
    );

    controller = VideoPlayerController.network(widget.link)
      ..addListener(() => setState(() {}))
      ..setLooping(false)
      ..initialize().then((_) {
        controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Timer(
      const Duration(milliseconds: 300),
      () {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        );
      },
    );
    return WillPopScope(
      onWillPop: () async {
        await SystemChrome.setPreferredOrientations(
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
        );
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
          body: Stack(
            children: [
              Center(
                child: controller.value.isInitialized
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          height: Get.height,
                          width: Get.width,
                          child: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          ),
                        ),
                      )
                    : const SpinKitPouringHourGlass(
                        color: Colors.red,
                        size: 60,
                      ),
              ),
              Container(
                height: 90,
                width: Get.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha:0.7),
                      Colors.black.withValues(alpha:0.6),
                      Colors.black.withValues(alpha:0.5),
                      Colors.black.withValues(alpha:0.4),
                      Colors.black.withValues(alpha:0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              (controller.value.isPlaying)
                  ? const SizedBox()
                  : Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        left: Get.width / 3.6,
                        top: Get.height / 1.7,
                        right: Get.width / 3.5,
                      ),
                      child: (showBanner) ? AdWidget(ad: _bannerAd!) : null,
                    ),
              (controller.value.isPlaying)
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
                                  showBanner = false;
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
                        showBanner = true;
                        showIcon = true;
                        controller.value.isPlaying ? controller.pause() : controller.play();
                      });
                    },
                    child: Icon(
                      controller.value.isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: SizeConfig.blockSizeHorizontal * 7.5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.screenHeight / 1.2, left: SizeConfig.screenWidth / 1.1),
                child: Text(
                  StringValue.live.tr,
                  style: GoogleFonts.urbanist(color: ColorValues.redColor, fontSize: 18, fontWeight: FontWeight.bold),
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
                            widget.name,
                            style: GoogleFonts.urbanist(
                              fontSize: 22,
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
            ],
          ),
        ),
      ),
    );
  }
}
*/
class LiveTvVideoPlayerScreen extends StatefulWidget {
  String name;
  String link;

  LiveTvVideoPlayerScreen({super.key, required this.name, required this.link});

  @override
  State<LiveTvVideoPlayerScreen> createState() => _LiveTvVideoPlayerScreen();
}

class _LiveTvVideoPlayerScreen extends State<LiveTvVideoPlayerScreen> {
  late VideoPlayerController controller;
  bool isVisible = false;
  bool showBanner = false;
  bool showIcon = false;
  bool isDisposing = false;
  BannerAd? _bannerAd;
  InterstitialAd? interstitialAd;

  _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
          );

          if (mounted) {
            setState(() {
              interstitialAd = ad;
            });
          }
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
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
            });
          }
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  @override
  void initState() {
    super.initState();
    loadBannerAds();
    _loadInterstitialAd();

    // Set landscape orientation with delay
    Future.delayed(const Duration(milliseconds: 200), () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    });

    controller = VideoPlayerController.network(widget.link)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..setLooping(false)
      ..initialize().then((_) {
        if (mounted) {
          controller.play();
        }
      }).catchError((error) {
        print('Video initialization error: $error');
      });
  }

  @override
  void dispose() {
    isDisposing = true;
    controller.dispose();
    _bannerAd?.dispose();
    interstitialAd?.dispose();

    // Reset orientation back to portrait with delay
    Future.delayed(const Duration(milliseconds: 100), () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });

    super.dispose();
  }

  Future<void> _handleBackPress() async {
    if (isDisposing) return;

    isDisposing = true;

    // Show interstitial ad if available
    if (interstitialAd != null) {
      interstitialAd?.show();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Reset orientation
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Small delay before navigation
    await Future.delayed(const Duration(milliseconds: 200));

    // Navigate back
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // Set status bar style with delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        );
      }
    });

    return WillPopScope(
      onWillPop: () async {
        await _handleBackPress();
        return false;
      },
      child: GestureDetector(
        onTap: () {
          if (mounted) {
            setState(() {
              isVisible = !isVisible;
            });
          }
        },
        child: Scaffold(
          backgroundColor: ColorValues.blackColor,
          body: Stack(
            children: [
              Center(
                child: controller.value.isInitialized
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          height: Get.height,
                          width: Get.width,
                          child: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          ),
                        ),
                      )
                    : const SpinKitPouringHourGlass(
                        color: Colors.red,
                        size: 60,
                      ),
              ),
              Container(
                height: 90,
                width: Get.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.6),
                      Colors.black.withValues(alpha: 0.5),
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              (controller.value.isPlaying)
                  ? const SizedBox()
                  : Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        left: Get.width / 3.6,
                        top: Get.height / 1.7,
                        right: Get.width / 3.5,
                      ),
                      child: (showBanner && _bannerAd != null) ? AdWidget(ad: _bannerAd!) : null,
                    ),
              (controller.value.isPlaying)
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 69,
                        top: SizeConfig.blockSizeVertical * 66,
                      ),
                      child: (showIcon)
                          ? IconButton(
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    showBanner = false;
                                    showIcon = false;
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.cancel,
                                size: 23,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
              Center(
                child: Visibility(
                  visible: isVisible,
                  child: GestureDetector(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          showBanner = true;
                          showIcon = true;
                          controller.value.isPlaying ? controller.pause() : controller.play();
                        });
                      }
                    },
                    child: Icon(
                      controller.value.isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: SizeConfig.blockSizeHorizontal * 7.5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.screenHeight / 1.2, left: SizeConfig.screenWidth / 1.1),
                child: Text(
                  StringValue.live.tr,
                  style: GoogleFonts.urbanist(color: ColorValues.redColor, fontSize: 18, fontWeight: FontWeight.bold),
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
                            onTap: _handleBackPress,
                            child: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
                          ),
                          SizedBox(width: Get.width / 25),
                          Expanded(
                            child: Text(
                              widget.name,
                              style: GoogleFonts.urbanist(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: ColorValues.whiteColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
