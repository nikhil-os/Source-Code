import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/home_screen/more_screen/Details/details_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/api/reels_like_dislike_api.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/controller/reels_controller.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:readmore/readmore.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

class PreviewReelsView extends StatefulWidget {
  const PreviewReelsView({super.key, required this.index, required this.currentPageIndex});

  final int index;
  final int currentPageIndex;

  @override
  State<PreviewReelsView> createState() => _PreviewReelsViewState();
}

class _PreviewReelsViewState extends State<PreviewReelsView> with SingleTickerProviderStateMixin {
  final controller = Get.find<ReelsController>();

  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;

  RxBool isPlaying = true.obs;
  RxBool isShowIcon = false.obs;

  RxBool isBuffering = false.obs;
  RxBool isVideoLoading = true.obs;

  RxBool isShowLikeAnimation = false.obs;
  RxBool isShowLikeIconAnimation = false.obs;

  RxBool isReelsPage = true.obs; // This is Use to Stop Auto Playing..

  RxBool isLike = false.obs;

  RxMap customChanges = {"like": 0, "comment": 0}.obs;

  AnimationController? _controller;
  late Animation<double> animation;

  RxBool isReadMore = false.obs;

  @override
  void initState() {
    log('ENTER :: ${controller.mainReels}');
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    if (_controller != null) {
      animation = Tween(begin: 0.0, end: 1.0).animate(_controller!);
    }
    initializeVideoPlayer();
    customSetting();

    ever<bool>(controller.isGlobalMuted, (muted) {
      videoPlayerController?.setVolume(muted ? 0.0 : 1.0);
    });

    super.initState();
  }

  getCurrentVideo() {
    int id = controller.mainReels.indexWhere((video) => video.id == controller.currentReels);
    if (id != -1) {
      final item = controller.mainReels.removeAt(id);
      controller.mainReels.insert(0, item);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    onDisposeVideoPlayer();
    log("Dispose Method Called Success");
    super.dispose();
  }

  Future<void> initializeVideoPlayer() async {
    try {
      await getCurrentVideo();
      final videoPath = controller.mainReels[widget.index].videoUrl!;
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoPath));
      await videoPlayerController?.initialize();

      videoPlayerController?.setVolume(controller.isGlobalMuted.value ? 0.0 : 1.0);

      if (videoPlayerController!.value.isInitialized) {
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          looping: true,
          allowedScreenSleep: false,
          allowMuting: false,
          showControlsOnInitialize: false,
          showControls: false,
          maxScale: 1,
        );

        isVideoLoading.value = false;
        if (widget.index == widget.currentPageIndex && isReelsPage.value) onPlayVideo();

        videoPlayerController!.addListener(() {
          isBuffering.value = videoPlayerController!.value.isBuffering;
          if (!isReelsPage.value) onStopVideo();
        });
      } else {
        isVideoLoading.value = true;
      }
    } catch (e) {
      onDisposeVideoPlayer();
      log("Reels Video Initialization Failed !!! ${widget.index} => $e");
    }
  }

  void onStopVideo() {
    isPlaying.value = false;
    videoPlayerController?.pause();
  }

  void onPlayVideo() {
    isPlaying.value = true;
    videoPlayerController?.play();
  }

  void onDisposeVideoPlayer() {
    try {
      onStopVideo();
      videoPlayerController?.dispose();
      chewieController?.dispose();
      chewieController = null;
      videoPlayerController = null;
      isVideoLoading.value = true;
    } catch (e) {
      log(">>>> On Dispose VideoPlayer Error => $e");
    }
  }

  void customSetting() {
    isLike.value = controller.mainReels[widget.index].isLike!;
  }

  void onClickVideo() async {
    if (isVideoLoading.value == false) {
      videoPlayerController!.value.isPlaying ? onStopVideo() : onPlayVideo();
      isShowIcon.value = true;
      await 2.seconds.delay();
      isShowIcon.value = false;
    }
    if (isReelsPage.value == false) {
      isReelsPage.value = true; // Use => On Back Reels Page...
    }
  }

  void onClickPlayPause() async {
    videoPlayerController!.value.isPlaying ? onStopVideo() : onPlayVideo();
    if (isReelsPage.value == false) {
      isReelsPage.value = true; // Use => On Back Reels Page...
    }
  }

  Future<void> onClickShare() async {
    isReelsPage.value = false;
  }

  Future<void> onClickLike() async {
    if (isLike.value) {
      isLike.value = false;
      customChanges["like"]--;
    } else {
      isLike.value = true;
      customChanges["like"]++;
    }

    isShowLikeIconAnimation.value = true;
    await 500.milliseconds.delay();
    isShowLikeIconAnimation.value = false;

    await ReelsLikeDislikeApi.callApi(
      loginUserId: userId,
      videoId: controller.mainReels[widget.index].id!,
    );
  }

  Future<void> onDoubleClick() async {
    if (isLike.value) {
      isLike.value = false;
      customChanges["like"]--;
    } else {
      isLike.value = true;
      customChanges["like"]++;

      isShowLikeAnimation.value = true;
      Vibration.vibrate(duration: 50, amplitude: 128);
      await 1200.milliseconds.delay();
      isShowLikeAnimation.value = false;
    }
    await ReelsLikeDislikeApi.callApi(
      loginUserId: userId,
      videoId: controller.mainReels[widget.index].id!,
    );
  }

  Widget _buildIconButton({required Widget icon, required Callback callback}) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: callback,
        child: CircleAvatar(
          // radius: 20,
          backgroundColor: ColorValues.whiteColor.withValues(alpha: 0.1),
          child: icon,
        ),
      );
    });
  }

  void toggleMute() {
    controller.toggleGlobalMute();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index == widget.currentPageIndex) {
      // Use => Play Current Video On Scrolling...
      isReadMore.value = false;
      (isVideoLoading.value == false && isReelsPage.value) ? onPlayVideo() : null;
    } else {
      // Restart Previous Video On Scrolling...
      isVideoLoading.value == false ? videoPlayerController?.seekTo(Duration.zero) : null;
      onStopVideo(); // Stop Previous Video On Scrolling...
    }
    return Scaffold(
      body: Container(
        color: Colors.red,
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            GestureDetector(
              onTap: onClickVideo,
              onDoubleTap: onDoubleClick,
              child: Container(
                color: ColorValues.blackColor,
                height: (Get.height - bottomBarSize),
                width: Get.width,
                child: Obx(
                  () => isVideoLoading.value
                      ? const Align(alignment: Alignment.bottomCenter, child: LinearProgressIndicator(color: ColorValues.redColor))
                      : SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: videoPlayerController?.value.size.width ?? 0,
                              height: videoPlayerController?.value.size.height ?? 0,
                              child: Chewie(controller: chewieController!),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Obx(
              () => isShowIcon.value
                  ? Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: onClickPlayPause,
                        child: Container(
                          height: 70,
                          width: 70,
                          padding: EdgeInsets.only(left: isPlaying.value ? 0 : 2),
                          decoration: BoxDecoration(color: ColorValues.blackColor.withValues(alpha: 0.2), shape: BoxShape.circle),
                          child: Center(
                            child: Icon(
                              isPlaying.value ? Icons.play_arrow_rounded : Icons.pause,
                              color: ColorValues.whiteColor,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Offstage(),
            ),
            Positioned(
              bottom: 0,
              child: Obx(
                () => Visibility(
                  visible: (isVideoLoading == false),
                  child: Container(
                    height: Get.height / 4,
                    width: Get.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ColorValues.transparent, ColorValues.blackColor.withValues(alpha: 0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 80,
              child: Container(
                padding: const EdgeInsets.only(top: 30, right: 16),
                height: Get.height,
                child: Column(
                  children: [
                    const Spacer(),
                    const SizedBox(height: 10),
                    Obx(
                      () => controller.isGlobalFullScreen.value
                          ? SizedBox(
                              height: 40,
                              child: _buildIconButton(
                                icon: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: isShowLikeIconAnimation.value ? 15 : 50,
                                  width: isShowLikeIconAnimation.value ? 15 : 50,
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    isLike.value ? MovixIcon.like : MovixIcon.whiteFavouriteIcon,
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                                callback: onClickLike,
                              ),
                            )
                          : const Offstage(),
                    ),
                    const SizedBox(height: 15),
                    Obx(
                      () => controller.isGlobalFullScreen.value
                          ? _buildIconButton(
                              icon: SvgPicture.asset(
                                controller.isGlobalMuted.value ? MovixIcon.muteIcon : MovixIcon.whiteSpeakerIcon,
                                height: 24,
                                width: 24,
                                color: ColorValues.whiteColor,
                              ),
                              callback: toggleMute,
                            )
                          : const Offstage(),
                    ),
                    const SizedBox(height: 15),
                    Obx(
                      () => _buildIconButton(
                        icon: SvgPicture.asset(
                          controller.isGlobalFullScreen.value ? MovixIcon.fullScreenViewIcon : MovixIcon.fullScreen,
                          height: 24,
                          width: 24,
                          color: ColorValues.whiteColor,
                        ),
                        callback: () {
                          controller.toggleGlobalFullScreen();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => controller.isGlobalFullScreen.value
                  ? Positioned(
                      left: 15,
                      bottom: 80,
                      child: SizedBox(
                        width: Get.width / 1.5,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: ColorValues.whiteColor,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: CachedNetworkImage(
                                          imageUrl: controller.mainReels[widget.index].videoImage ?? '',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            height: 60,
                                            width: 60,
                                            color: (getStorage.read('isDarkMode') == true) ? Colors.white24 : Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            maxLines: 1,
                                            controller.mainReels[widget.index].movieSeriesTitle ?? "",
                                            style: const TextStyle(
                                              color: ColorValues.whiteColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            maxLines: 2,
                                            controller.mainReels[widget.index].genre?.join(',').capitalizeFirst ?? "",
                                            style: const TextStyle(
                                              color: ColorValues.whiteColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              ReadMoreText(
                                controller.mainReels[widget.index].movieSeriesDes?.replaceAll(RegExp(r'<[^>]*>'), '') ?? '',
                                trimMode: TrimMode.Line,
                                trimLines: 2,
                                style: TextStyle(color: ColorValues.whiteText.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.w400),
                                colorClickableText: ColorValues.redColor,
                                trimCollapsedText: ' Show more',
                                trimExpandedText: ' Show less',
                                moreStyle: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500, // Bold for "View More"
                                  color: ColorValues.redColor,
                                ),
                                lessStyle: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600, // Bold for "View Less"
                                  color: ColorValues.redColor,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const Offstage(),
            ),
            Positioned(
              left: 15,
              right: 15,
              bottom: 16,
              child: Obx(
                () => controller.isGlobalFullScreen.value
                    ? GestureDetector(
                        onTap: () {
                          onDisposeVideoPlayer();
                          Get.to(() => DetailsScreen(movieId: controller.mainReels[widget.index].movieSeriesId ?? ''));
                        },
                        child: Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            color: ColorValues.buttonColorRed,
                          ),
                          alignment: Alignment.center,
                          child: Center(
                            child: Text(
                              StringValue.watchFullMovie.tr,
                              style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : const Offstage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
