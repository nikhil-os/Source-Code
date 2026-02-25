import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/complet_movie_data/complete_movie_data_modal.dart';
import 'package:webtime_movie_ocean/controller/api_controller/comment_list_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/moreLikeThisMovieController.dart';
import 'package:webtime_movie_ocean/controller/api_controller/movieDetailsController.dart';
import 'package:webtime_movie_ocean/custom/custom_rating_view.dart';
import 'package:webtime_movie_ocean/custom/see_all_container.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/home_screen/more_screen/Details/details_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/home_screen/more_screen/comments_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/videoPlayer/video_player.dart';
import 'package:webtime_movie_ocean/presentation/screens/videoPlayer/youtube_video_player.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_class.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:shimmer/shimmer.dart';

class DetailsTabsScreen extends StatefulWidget {
  final TabController tabController;
  final List<Trailer> trailer;
  final String movieId;
  final String? description;
  final num comments;
  final num videoType;

  const DetailsTabsScreen({
    super.key,
    required this.tabController,
    required this.trailer,
    this.description,
    required this.movieId,
    required this.videoType,
    required this.comments,
  });

  @override
  State<DetailsTabsScreen> createState() => _DetailsTabsScreenState();
}

class _DetailsTabsScreenState extends State<DetailsTabsScreen> {
  moreLikeThisMovieController moreLikeThisMovie = Get.put(moreLikeThisMovieController());
  CommentListController allCommentsList = Get.put(CommentListController());
  movieDetailsController movieDetails = Get.put(movieDetailsController());

  List<String> commentButton = ["Report", "Block"];

  bool apiCallsMade = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi();
    });

    allCommentsList.scrollToTop();
    super.initState();
  }

  @override
  void dispose() {
    allCommentsList.scrollController.dispose();
    super.dispose();
  }

  callApi() {
    moreLikeThisMovie.moreLikeThisMovieDetails(widget.movieId);
    allCommentsList.commentsListData(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 3,
        child: TabBarView(
          controller: widget.tabController,
          children: [
            /// Movie Trailers ///
            trailersTab(),

            /// More Like This ///
            moreLikeThisTab(),

            /// Comments of Movie ///
            commentsTab(),
          ],
        ),
      ),
    );
  }

  /// Comments of Movie ///
  Widget commentsTab() {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * 2,
        left: SizeConfig.blockSizeHorizontal * 5,
        right: SizeConfig.blockSizeHorizontal * 5,
      ),
      height: Get.height,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "${allCommentsList.commentsList.length} ${StringValue.comments.tr}",
                style: GoogleFonts.urbanist(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SeeAllContainer(onTap: () {
                Get.to(
                  CommentsScreen(
                    movieId: widget.movieId,
                    comments: allCommentsList.commentsList.length,
                  ),
                );
              }),
            ],
          ),
          Expanded(
            child: Obx(() {
              return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return false;
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  reverse: false,
                  controller: allCommentsList.scrollController,
                  itemCount: allCommentsList.commentsList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: (getStorage.read("updatedNewDp")?.isEmpty ?? true)
                                  ? (allCommentsList.commentsList[i].userImage == null
                                      ? Image.asset(
                                          AssetValues.noProfile,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          allCommentsList.commentsList[i].userImage ?? "",
                                          fit: BoxFit.cover,
                                        ))
                                  : Obx(
                                      () => ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: PreviewNetworkImage(
                                          id: allCommentsList.commentsList[i].id ?? "",
                                          image: allCommentsList.commentsList[i].userImage ?? "",
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 2,
                            ),
                            Text(
                              allCommentsList.commentsList[i].fullName.toString().capitalizeFirst ?? "",
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            PopupMenuButton<String>(
                              offset: const Offset(0, 40),
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : ColorValues.whiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              icon: ImageIcon(
                                const AssetImage(
                                  IconAssetValues.moreCircle,
                                ),
                                color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.darkModeSecond,
                              ),
                              onSelected: (String value) {
                                if (value == "Report") {
                                  openReportBottomSheet();
                                } else if (value == "Block") {
                                  openBlockBottomSheet();
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return <String>["Report", "Block"].map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(
                                      choice,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: Get.width / 1.15,
                              child: Text(
                                allCommentsList.commentsList[i].comment?.capitalizeFirst ?? "",
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),
                        Row(
                          children: [
                            Text(
                              allCommentsList.commentsList[i].time.toString(),
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: (getStorage.read('isDarkMode') == true) ? ColorValues.grayColor : ColorValues.grayColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          color:
                              (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.darkModeThird.withValues(alpha: 0.10),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ).paddingOnly(bottom: Get.height * 0.13),
              );
            }),
          ),
        ],
      ),
    );
  }

  Shimmer commentsShimmer() {
    return Shimmer.fromColors(
      highlightColor: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
      baseColor: (getStorage.read('isDarkMode') == true) ? Colors.white24 : Colors.grey.shade300,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
        itemCount: 10,
        itemBuilder: (BuildContext context, int i) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 60,
                    height: 20,
                    alignment: Alignment.centerLeft,
                    color: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 120,
                height: 20,
                alignment: Alignment.centerLeft,
                color: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 80,
                height: 20,
                alignment: Alignment.centerLeft,
                color: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );
  }

  /// More Like This ///
  Obx moreLikeThisTab() {
    return Obx(() {
      if (moreLikeThisMovie.isLoading.value) {}
      return GridView.builder(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: moreLikeThisMovie.movieDetailsList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: SizeConfig.blockSizeHorizontal * 4,
          mainAxisSpacing: SizeConfig.blockSizeVertical * 1.5,
        ),
        padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 3,
          right: SizeConfig.blockSizeHorizontal * 3,
          top: SizeConfig.blockSizeVertical * 2,
        ),
        itemBuilder: (context, i) {
          final movie = moreLikeThisMovie.movieDetailsList[i];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(movieId: movie.id!),
                ),
              );
            },
            child: Container(
              width: SizeConfig.screenWidth / 3,
              height: SizeConfig.screenHeight / 4.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    (movie.tmdbMovieId == null && movie.iMDBid == null)
                        ? PreviewNetworkImage(
                            id: movie.id ?? "",
                            image: movie.thumbnail ?? "",
                          )
                        : CachedNetworkImage(
                            imageUrl: movie.thumbnail.toString(),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            placeholder: (context, url) => Image(
                              image: const AssetImage(AssetValues.appLogo),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                            ),
                            errorWidget: (context, url, error) => Image(
                              image: const AssetImage(AssetValues.appLogo),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                            ),
                          ),

                    // Gradient Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Optional Title + Rating
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            movie.title ?? "No Title",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          RatingBadge(rating: movie.rating.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ).paddingOnly(bottom: 100);
    });
  }

  /// Movie Trailers ///
  trailersTab() {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.blockSizeHorizontal * 3,
        right: SizeConfig.blockSizeHorizontal * 3,
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.trailer.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.smallContainerBg : ColorValues.darkModeThird.withValues(alpha: 0.05),
                    border: Border.all(
                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.borderColor : ColorValues.darkModeThird.withValues(alpha: 0.10)),
                    borderRadius: BorderRadius.circular(18)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        log("video >>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
                        final videoUrl = widget.trailer[index].videoUrl.toString();

                        if (videoUrl.contains("youtube.com") || videoUrl.contains("youtu.be")) {
                          log("video type: YOUTUBE");
                          String key = videoUrl;
                          log("video key>>>>>>>>>>>>>>>>>$key");

                          List<String> youtubeKey = key.split("=");
                          log("YOUTUBE key>>>>>>>>>>>>>>>>>$youtubeKey");

                          Get.to(
                            YoutubePlayerPage(
                              name: widget.trailer[index].name.toString(),
                              link: youtubeKey.last,
                            ),
                          );
                        } else if (videoUrl.endsWith(".mp4")) {
                          log("video type: MP4");
                          Get.to(
                            VideoPlayers(
                              name: widget.trailer[index].name.toString(),
                              link: videoUrl,
                              type: true,
                            ),
                          );
                        } else {
                          log("Unknown video type: $videoUrl");
                        }
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : Colors.grey.shade200,
                        ),
                        height: SizeConfig.screenHeight / 8.5,
                        width: SizeConfig.screenWidth / 2.6,
                        child: movieDetails.movieDetailsList[0].iMDBid == null && movieDetails.movieDetailsList[0].tmdbMovieId == null
                            ? PreviewNetworkImage(id: widget.trailer[index].id ?? "", image: widget.trailer[index].trailerImage ?? "")
                            : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: widget.trailer[index].trailerImage.toString(),
                                placeholder: (context, url) => Image(
                                  height: SizeConfig.screenHeight / 9,
                                  color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                  image: const AssetImage(
                                    AssetValues.appLogo,
                                  ),
                                ),
                                errorWidget: (context, string, dynamic) => Image(
                                  height: SizeConfig.screenHeight / 9,
                                  color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                  image: const AssetImage(
                                    AssetValues.appLogo,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.trailer[index].name.toString(),
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 1,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: (getStorage.read('isDarkMode') == true)
                                      ? ColorValues.buttonColorRed.withValues(alpha: 0.07)
                                      : ColorValues.redBoxColor,
                                ),
                                child: Center(
                                  child: Text(
                                    "${widget.trailer[index].type}",
                                    style: GoogleFonts.urbanist(color: ColorValues.redColor, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 12),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 1.5,
              ),
            ],
          );
        },
      ),
    );
  }

  void openReportBottomSheet() {
    Get.bottomSheet(
      backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.whiteColor,
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: Get.height * 0.55,
        decoration: BoxDecoration(
          color: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.whiteColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.grey.shade400,
              ),
            ),
            Text(
              StringValue.report.tr,
              style: GoogleFonts.outfit(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Divider(color: Colors.grey),
            const Icon(Icons.report_problem, size: 70, color: Colors.red),
            Text(
              StringValue.wantToReport.tr,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 50,
                    width: Get.width / 2.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: (getStorage.read('isDarkMode') == true) ? const Color(0xff35383F) : ColorValues.redBoxColor,
                    ),
                    child: Text(
                      StringValue.cancel.tr,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.redColor,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Get.back();
                    _showLoader();

                    await Future.delayed(const Duration(seconds: 2));

                    Get.back();
                    Fluttertoast.showToast(msg: "Report submitted successfully");
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: Get.width / 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.red,
                    ),
                    child: Text(
                      StringValue.report.tr,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void openBlockBottomSheet() {
    Get.bottomSheet(
      backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.whiteColor,
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: Get.height * 0.55,
        decoration: BoxDecoration(
          color: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.whiteColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.grey.shade400,
              ),
            ),
            Text(
              StringValue.block.tr,
              style: GoogleFonts.outfit(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Divider(color: Colors.grey),
            const Icon(Icons.block, size: 70, color: Colors.red),
            Text(
              StringValue.wantToBlock.tr,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 50,
                    width: Get.width / 2.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: (getStorage.read('isDarkMode') == true) ? const Color(0xff35383F) : ColorValues.redBoxColor,
                    ),
                    child: Text(
                      StringValue.cancel.tr,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.redColor,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Get.back();
                    _showLoader();

                    await Future.delayed(const Duration(seconds: 2));

                    Get.back();
                    Fluttertoast.showToast(msg: "Blocked successfully");
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: Get.width / 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.red,
                    ),
                    child: Text(
                      StringValue.block.tr,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLoader() {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.red)),
      barrierDismissible: false,
    );
  }
}
