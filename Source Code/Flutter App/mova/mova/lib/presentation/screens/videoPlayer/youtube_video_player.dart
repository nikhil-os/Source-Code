// ignore_for_file: depend_on_referenced_packages, must_be_immutable, unnecessary_statements, avoid_print, unused_field, unused_element

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webtime_movie_ocean/presentation/screens/videoPlayer/youtubeVideoController.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/helper/ads_helper.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerPage extends StatefulWidget {
  String name;
  String link;

  YoutubePlayerPage({
    super.key,
    required this.name,
    required this.link,
  });

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  var selectedIndexes = [3];
  bool isPlaybackSpeed = false;
  bool isSwitch = true;
  bool isVisible = true;
  Duration duration = const Duration();
  Timer? timer;
  List<double> playbackSpeed = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];
  InterstitialAd? interstitialAd;
  BannerAd? _bannerAd;

  _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              youtubeVideoController.youtubePlayerController.play();
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
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
      // adUnitId: AdHelper.bannerAdUnitId,
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
      if (mounted) {
        setState(() {
          _loadInterstitialAd();
          youtubeVideoController.youtubePlayerController.pause();
          interstitialAd?.show();
        });
      }
    }
    duration = Duration(minutes: seconds);
  }

  @override
  void initState() {
    super.initState();
    log("Trailer Link :: ${widget.link}");
    youtubeVideoController.youtubePlayerController = YoutubePlayerController(
      initialVideoId: widget.link,
      flags: const YoutubePlayerFlags(),
    )
      ..addListener(() => setState(() {
            startTimer();
          }))
      ..play();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    super.dispose();
  }

  void showToast() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  YoutubeVideoController youtubeVideoController = Get.put(YoutubeVideoController());

  @override
  Widget build(BuildContext context) {
    log("***** Current Routes => You Tube Video Playing Page");
    SizeConfig().init(context);
    print(youtubeVideoController.youtubePlayerController.value.volume);
    return WillPopScope(
      onWillPop: () async {
        (isVisible)
            ? await SystemChrome.setPreferredOrientations(
                [
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ],
              ).then(
                (value) => Get.back(),
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
              return Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        height: Get.height,
                        width: Get.width,
                        child: YoutubePlayer(
                          aspectRatio: Get.height,
                          topActions: [
                            IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: ColorValues.whiteColor,
                              ),
                            ),
                            SizedBox(
                              width: Get.width / 1.5,
                              child: Text(
                                widget.name,
                                style: GoogleFonts.urbanist(
                                  color: ColorValues.whiteColor,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                          ],
                          progressColors: const ProgressBarColors(
                            playedColor: ColorValues.redColor,
                            backgroundColor: ColorValues.whiteColor,
                            bufferedColor: ColorValues.grayColor,
                            handleColor: ColorValues.redColor,
                          ),
                          progressIndicatorColor: ColorValues.redColor,
                          controller: youtubeVideoController.youtubePlayerController,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
