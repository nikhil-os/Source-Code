import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/addViewToMovie/add_view_to_movie_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/createComments_api/createComments_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/createFavoriteMovie_api/create_favourite_movie_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/rating_api/create_rating_api/create_rating_api_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/comment_list_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/getDownolad_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/movieDetailsController.dart';
import 'package:webtime_movie_ocean/controller/api_controller/season_wise_episodes_controller.dart';
import 'package:webtime_movie_ocean/custom/custom_dialog.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/downlode_screen/custom_download.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/downlode_screen/download_history.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/downlode_screen/download_information_model.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/home_screen/more_screen/Details/details_tabs.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profile_premium_view/subscribetopremium.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profilesetting/helpcentermodal/web_page.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/tabs_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/videoPlayer/video_player.dart';
import 'package:webtime_movie_ocean/presentation/screens/videoPlayer/youtube_video_player.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_class.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/helper/ads_helper.dart';
import 'package:webtime_movie_ocean/presentation/utils/utils.dart';
import 'package:webtime_movie_ocean/presentation/widget/interest_button.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:webtime_movie_ocean/presentation/screens/rent/rent_plan_screen.dart';

/*
MOVIE :: 0:YoutubeUrl 1:m3u8Url 2:MOV 3:MP4 4:MKV 5:WEBM 6:Embed 7:File
TRAILER :: 0:link 1:video(file),
*/

class DetailsScreen extends StatefulWidget {
  final String movieId;

  const DetailsScreen({super.key, required this.movieId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final tabs = [
    StringValue.trailers.tr,
    StringValue.moreLikeThis.tr,
    StringValue.comments.tr
  ];
  var top = 0.0;
  String selectedVal = "1";
  ReceivePort receivePort = ReceivePort();
  String rate = '';
  ScrollController scrollController = ScrollController();
  movieDetailsController movieAllDetails = Get.put(movieDetailsController());
  getAllDownloadMovieController downloadMovieList =
      Get.put(getAllDownloadMovieController());
  Filter_Controller controller = Filter_Controller();
  SeasonWiseEpisodesController seasonWiseEpisodesController =
      Get.put(SeasonWiseEpisodesController());
  InterstitialAd? _interstitialAd;

  movieDetailsController movieDetails = Get.put(movieDetailsController());
  TextEditingController commentController = TextEditingController();
  CommentListController allCommentsList = Get.put(CommentListController());
  bool isButtonDisabled = true;
  bool hasActiveRental = false;

  void validateField(text) {
    if (commentController.text.isEmpty ||
        commentController.text.isBlank == true) {
      setState(() {
        isButtonDisabled = true;
      });
    } else {
      setState(() {
        isButtonDisabled = false;
      });
    }
  }

  /// Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId ?? "",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          log('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    _tabController = TabController(length: tabs.length, vsync: this);

    _tabController.animation?.addListener(() {
      final value = _tabController.animation?.value;
      if (value != null && value.round() != _tabController.index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
      }
    });
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ],
    );

    commentController.addListener(() {
      validateField(commentController.text);
    });

    IsolateNameServer.registerPortWithName(receivePort.sendPort, "mova");
    FlutterDownloader.registerCallback(downloadCallBack);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await movieAllDetails.allDetails(widget.movieId);
      await seasonWiseEpisodesController.allEpisodesDetails(
          widget.movieId, "1");
      SharedPreferences pref = await SharedPreferences.getInstance();

      Object isMovieDownload = DownloadHistory.mainDownloadHistory.isNotEmpty
          ? pref.setBool(
              "isMovieDownload", DownloadHistory.mainDownloadHistory[0].isEmpty)
          : false;

      Object isMovieFavorite = movieAllDetails.movieDetailsList.isNotEmpty
          ? pref.setBool("isMovieFavorite",
              movieAllDetails.movieDetailsList[0].isFavorite ?? false)
          : false;

      await _loadRentalAccess();
      setState(() {
        isMovieFavorite = isMovieFavorite;
        isMovieDownload = isMovieDownload;
        downloadedMovie.value = pref.getStringList("") ?? [];
        hasActiveRental = hasActiveRental;
      });
    });
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _tabController.dispose();

    super.dispose();
  }

  Future<void> _loadRentalAccess() async {
    final prefs = await SharedPreferences.getInstance();
    final expiresMs = prefs.getInt('rental_${widget.movieId}_expires') ?? 0;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      hasActiveRental = expiresMs > nowMs;
    });
  }

  Widget rentButton() {
    return InkWell(
      onTap: () async {
        final movie = movieAllDetails.movieDetailsList[0];
        final result = await Get.to(() => RentPlanScreen(
              movieId: widget.movieId,
              title: movie.title ?? 'Movie',
              rentalOptions: movie.rentalOptions,
              rentalCurrency: movie.rentalCurrency,
            ));
        if (result is Map && result['activated'] == true) {
          await _loadRentalAccess();
          setState(() {});
        }
      },
      child: Container(
        height: SizeConfig.screenHeight / 15,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: ColorValues.redColor,
        ),
        child: Text(
          'Rent',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: ColorValues.whiteColor,
          ),
        ),
      ),
    );
  }

  static downloadCallBack(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("mova");
    sendPort?.send(progress);
  }

  connection() async {
    await (Connectivity().checkConnectivity());
  }

  @override
  Widget build(BuildContext context) {
    connection();
    final createFavoriteMovie =
        Provider.of<CreateFavoriteMovieProvider>(context, listen: false);
    final addViewToMovie =
        Provider.of<AddViewToMovieProvider>(context, listen: false);
    final createRating =
        Provider.of<CreateRatingProvider>(context, listen: false);
    SizeConfig().init(context);

    final createComment =
        Provider.of<CreateCommentProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        _interstitialAd?.show();
        if (interstitialAd != null) {
          _interstitialAd?.show();
          selectedIndex = 0;
          Get.offAll(
            () => const TabsScreen(),
          );
        } else {
          selectedIndex = 0;
          Get.offAll(
            () => const TabsScreen(),
          );
        }
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: Obx(
          () {
            return videoDownload.value || serverSeriesDownload.value
                ? const LinearProgressIndicator(
                    backgroundColor: ColorValues.redColor,
                  )
                : _tabController.index == 2
                    ? Container(
                        decoration: BoxDecoration(
                          color: (getStorage.read('isDarkMode') == true)
                              ? ColorValues.appBarColor
                              : ColorValues.darkModeThird
                                  .withValues(alpha: 0.05),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(17),
                          ),
                          border: Border(
                            top: BorderSide(
                              color: (getStorage.read('isDarkMode') == true)
                                  ? ColorValues.dividerColor
                                  : ColorValues.dividerColor
                                      .withValues(alpha: 0.20),
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              height: 56,
                              padding: const EdgeInsets.only(left: 20),
                              margin: const EdgeInsets.only(left: 15),
                              width: Get.width - 95,
                              decoration: BoxDecoration(
                                color: (getStorage.read('isDarkMode') == true)
                                    ? ColorValues.detailContainer
                                    : ColorValues.darkModeThird
                                        .withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: (getStorage.read('isDarkMode') == true)
                                      ? ColorValues.borderColor
                                      : ColorValues.redColor,
                                ),
                              ),
                              child: TextFormField(
                                controller: commentController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 100,
                                minLines: 1,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                  border: InputBorder.none,
                                  hintText: StringValue.addComments.tr,
                                  hintStyle: GoogleFonts.outfit(
                                      color: ColorValues.grayText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            const Spacer(),
                            AbsorbPointer(
                              absorbing: !enabled,
                              child: InkWell(
                                onTap: isButtonDisabled
                                    ? () {}
                                    : () async {
                                        AppUtils.showLog('buttonClicked');
                                        setState(() {
                                          enabled = false;

                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            setState(() {
                                              enabled = true;
                                            });
                                          });
                                        });
                                        FocusScope.of(context).unfocus();
                                        await createComment.createComment(
                                            widget.movieId,
                                            commentController.text);
                                        commentController.clear();

                                        allCommentsList
                                            .commentsListData(widget.movieId);
                                        allCommentsList.scrollToTop();
                                      },
                                child: const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: ColorValues.redColor,
                                  child: ImageIcon(
                                    AssetImage(
                                      IconAssetValues.boldSend,
                                    ),
                                    color: ColorValues.whiteColor,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      )
                    : const SizedBox();
          },
        ),
        backgroundColor: (getStorage.read('isDarkMode') == true)
            ? ColorValues.scaffoldBg
            : ColorValues.whiteColor,
        body: Obx(
          () {
            log("Loading value :: ${movieAllDetails.isLoading.value}");
            if (movieAllDetails.isLoading.value) {
              return mainShimmer();
            } else {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    centerTitle: true,
                    elevation: 0,
                    pinned: true,
                    toolbarHeight: 60,
                    leading: IconButton(
                      icon: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                            color: (getStorage.read('isDarkMode') == true)
                                ? ColorValues.containerBg
                                    .withValues(alpha: 0.20)
                                : ColorValues.darkModeThird
                                    .withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(14)),
                        child: Center(
                          child: SvgPicture.asset(
                            MovixIcon.backArrowIcon,
                            colorFilter: ColorFilter.mode(
                                (getStorage.read('isDarkMode') == true)
                                    ? ColorValues.whiteColor
                                    : ColorValues.blackColor,
                                BlendMode.srcIn),
                          ),
                        ),
                      ).paddingOnly(left: 6),
                      onPressed: () {
                        _interstitialAd?.show();
                        if (interstitialAd != null) {
                          _interstitialAd?.show();
                          selectedIndex = 0;
                          Get.offAll(
                            () => const TabsScreen(),
                          );
                        } else {
                          selectedIndex = 0;
                          Get.offAll(
                            () => const TabsScreen(),
                          );
                        }
                      },
                    ),
                    expandedHeight: SizeConfig.screenHeight / 3,
                    flexibleSpace: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints con) {
                        top = con.biggest.height;
                        return FlexibleSpaceBar(
                          centerTitle: true,
                          title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: SizeConfig.blockSizeHorizontal * 4,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      _interstitialAd?.show();
                                      if (interstitialAd != null) {
                                        _interstitialAd?.show();
                                        selectedIndex = 0;
                                        Get.offAll(
                                          () => const TabsScreen(),
                                        );
                                      } else {
                                        selectedIndex = 0;
                                        Get.offAll(
                                          () => const TabsScreen(),
                                        );
                                      }
                                    },
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.blockSizeHorizontal * 3,
                                ),
                                SizedBox(
                                  width: Get.width / 2,
                                  child: Text(
                                    movieAllDetails.movieDetailsList[0].title
                                        .toString(),
                                    style: TextStyle(
                                      color: (top <= 100)
                                          ? (getStorage.read('isDarkMode') ==
                                                  true)
                                              ? Colors.white
                                              : ColorValues.blackColor
                                          : Colors.transparent,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          background: Container(
                            height: SizeConfig.screenHeight / 2.4,
                            decoration: BoxDecoration(
                              color: (getStorage.read('isDarkMode') == true)
                                  ? ColorValues.darkModeSecond
                                  : Colors.grey.shade200,
                            ),
                            child: movieAllDetails
                                            .movieDetailsList[0].tmdbMovieId ==
                                        null &&
                                    movieAllDetails
                                            .movieDetailsList[0].tmdbMovieId ==
                                        null
                                ? PreviewNetworkImage(
                                    id: movieAllDetails
                                            .movieDetailsList[0].id ??
                                        "",
                                    image: movieAllDetails
                                            .movieDetailsList[0].image ??
                                        "",
                                  )
                                : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: movieAllDetails
                                        .movieDetailsList[0].image
                                        .toString(),
                                    placeholder: (context, url) => Image(
                                      height: SizeConfig.screenHeight / 2.2,
                                      width: SizeConfig.screenWidth,
                                      color: (getStorage.read('isDarkMode') ==
                                              true)
                                          ? ColorValues.darkModeThird
                                          : Colors.grey.shade400,
                                      image: const AssetImage(
                                        AssetValues.appLogo,
                                      ),
                                    ),
                                    errorWidget: (context, string, dynamic) =>
                                        Image(
                                      height: SizeConfig.screenHeight / 2.2,
                                      width: SizeConfig.screenWidth,
                                      color: (getStorage.read('isDarkMode') ==
                                              true)
                                          ? ColorValues.darkModeThird
                                          : Colors.grey.shade400,
                                      image: const AssetImage(
                                        AssetValues.appLogo,
                                      ),
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 22),
                          decoration: BoxDecoration(
                              color: (getStorage.read('isDarkMode') == true)
                                  ? ColorValues.appBarColor
                                  : ColorValues.darkModeThird
                                      .withValues(alpha: 0.05),
                              borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(20))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 4,
                                  right: SizeConfig.blockSizeHorizontal * 2,
                                  top: SizeConfig.blockSizeVertical * 2,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 3,
                                    ),

                                    /// Movie Title ///
                                    Text(
                                      movieAllDetails.movieDetailsList[0].title
                                          .toString(),
                                      style: GoogleFonts.outfit(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),

                                    /// Movie Favorite/unFavorite ///
                                    GestureDetector(
                                        child: (isMovieFavorite)
                                            ? Container(
                                                height: 48,
                                                width: 48,
                                                decoration: BoxDecoration(
                                                    color: (getStorage.read(
                                                                'isDarkMode') ==
                                                            true)
                                                        ? ColorValues
                                                            .containerBg
                                                        : ColorValues
                                                            .darkModeThird
                                                            .withValues(
                                                                alpha: 0.05),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14)),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    MovixIcon.save,
                                                    height: 20,
                                                    width: 20,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                            ColorValues
                                                                .redColor,
                                                            BlendMode.srcIn),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 48,
                                                width: 48,
                                                decoration: BoxDecoration(
                                                  color: (getStorage.read(
                                                              'isDarkMode') ==
                                                          true)
                                                      ? ColorValues.containerBg
                                                      : ColorValues
                                                          .darkModeThird
                                                          .withValues(
                                                              alpha: 0.05),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    MovixIcon.save,
                                                    height: 19,
                                                    width: 19,
                                                    colorFilter: ColorFilter.mode(
                                                        (getStorage.read(
                                                                    'isDarkMode') ==
                                                                true)
                                                            ? ColorValues
                                                                .whiteColor
                                                            : ColorValues
                                                                .blackColor,
                                                        BlendMode.srcIn),
                                                  ),
                                                ),
                                              ),
                                        onTap: () async {
                                          if (isFavoriteProcessing) {
                                            log("working........................");
                                          } else {
                                            isFavoriteProcessing = true;

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                duration:
                                                    const Duration(seconds: 1),
                                                content: Text(
                                                  StringValue.pleaseWait.tr,
                                                  style: const TextStyle(
                                                      color: ColorValues
                                                          .whiteColor),
                                                ),
                                                backgroundColor:
                                                    ColorValues.redColor,
                                              ),
                                            );

                                            try {
                                              await createFavoriteMovie
                                                  .createFavoriteMovie(
                                                      movieAllDetails
                                                          .movieDetailsList[0]
                                                          .id);
                                              SharedPreferences pref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              pref.setBool(
                                                  "isMovieFavorite",
                                                  createFavoriteMovie
                                                      .data['isFavorite']);

                                              setState(() {
                                                isMovieFavorite = pref.getBool(
                                                        "isMovieFavorite") ??
                                                    false;
                                              });
                                            } finally {
                                              // Wait for snackbar to finish before allowing next tap
                                              await Future.delayed(
                                                  const Duration(seconds: 1));
                                              isFavoriteProcessing = false;
                                            }
                                          } // Prevent double tap
                                        }),
                                    const SizedBox(width: 12),

                                    /// Share ///
                                    GestureDetector(
                                      child: Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(
                                            color: (getStorage
                                                        .read('isDarkMode') ==
                                                    true)
                                                ? ColorValues.containerBg
                                                : ColorValues.darkModeThird
                                                    .withValues(alpha: 0.05),
                                            borderRadius:
                                                BorderRadius.circular(14)),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            MovixIcon.share,
                                            colorFilter: ColorFilter.mode(
                                                (getStorage.read(
                                                            'isDarkMode') ==
                                                        true)
                                                    ? ColorValues.whiteColor
                                                    : ColorValues.blackColor,
                                                BlendMode.srcIn),
                                            // height: SizeConfig.blockSizeVertical * 3,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        SharePlus.instance.share(ShareParams(
                                          text:
                                              'https://play.google.com/store/apps/details?id=com.mova.android',
                                        ));
                                      },
                                    ),
                                    SizedBox(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 1.5,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 2,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 4,
                                ),
                                child: Row(
                                  children: [
                                    /// Add Your Ratings ///
                                    addRating(createRating, context),

                                    SizedBox(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 2.5,
                                    ),

                                    /// Movie Rating ///
                                    Text(
                                      movieAllDetails
                                                  .movieDetailsList[0].rating ==
                                              0
                                          ? "N/A"
                                          : movieAllDetails
                                              .movieDetailsList[0].rating
                                              .toString(),
                                      style: GoogleFonts.urbanist(
                                          color: ColorValues.yellow,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: (getStorage.read('isDarkMode') ==
                                              true)
                                          ? ColorValues.whiteColor
                                          : ColorValues.blackColor,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.blockSizeHorizontal * 2,
                                    ),

                                    /// Movie Release Year ///
                                    Text(
                                      movieAllDetails.movieDetailsList[0].year
                                          .toString(),
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.blockSizeHorizontal * 3,
                                    ),

                                    /// Movie Region ///

                                    Container(
                                      // height: SizeConfig.blockSizeVertical * 3,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: (getStorage.read('isDarkMode') ==
                                                true)
                                            ? ColorValues.detailContainer
                                            : ColorValues.darkModeThird
                                                .withValues(alpha: 0.05),
                                        border: Border.all(
                                          color:
                                              (getStorage.read('isDarkMode') ==
                                                      true)
                                                  ? ColorValues.detailBorder
                                                  : ColorValues.darkModeThird
                                                      .withValues(alpha: 0.05),
                                        ),
                                        borderRadius: BorderRadius.circular(07),
                                      ),
                                      child: Text(
                                        movieAllDetails.movieDetailsList[0]
                                                .region?.name
                                                .toString() ??
                                            "",
                                        style: GoogleFonts.outfit(
                                          color: const Color(0xffB0B1B6),
                                          fontSize: 08,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.blockSizeVertical * 2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 2,
                              ),

                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 4,
                                  right: SizeConfig.blockSizeHorizontal * 2,
                                ),

                                /// Genre Of Movie ///
                                child: Text(
                                  "${StringValue.genre.tr} : ${(movieAllDetails.movieDetailsList[0].genre != null && movieAllDetails.movieDetailsList[0].genre!.isNotEmpty) ? movieAllDetails.movieDetailsList[0].genre!.map((g) => g.name ?? '').where((n) => n.isNotEmpty).join(', ') : 'N/A'}",
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),

                              const SizedBox(height: 5),

                              /// Description of Movie ///
                              buildDescription(),

                              const SizedBox(height: 15),

                              /// Cast of Movie ///
                              buildRoleSizedBox(),

                              /// change completed

                              (movieAllDetails.movieDetailsList[0].mediaType ==
                                      "movie")
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: SizeConfig.blockSizeHorizontal *
                                              3.5,
                                          right:
                                              SizeConfig.blockSizeHorizontal *
                                                  4.5,
                                          top: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          /// Play And Watch A Movie
                                          Expanded(
                                              child:
                                                  playButton(addViewToMovie)),

                                          const SizedBox(width: 15),

                                          // Rent button: Show when movie is rentable with valid rental options
                                          if (movieAllDetails.movieDetailsList
                                                  .isNotEmpty &&
                                              movieAllDetails
                                                      .movieDetailsList[0]
                                                      .isRentable ==
                                                  true &&
                                              movieAllDetails
                                                      .movieDetailsList[0]
                                                      .rentalOptions !=
                                                  null &&
                                              movieAllDetails
                                                  .movieDetailsList[0]
                                                  .rentalOptions!
                                                  .isNotEmpty &&
                                              !hasActiveRental)
                                            Expanded(child: rentButton()),

                                          /// Download A Movie ///
                                          Expanded(
                                            child: buildDownloadInkWell(
                                                MoreInformationModel(
                                              thumbNail: movieAllDetails
                                                  .movieDetailsList[0].image
                                                  .toString(),
                                              videoId: movieAllDetails
                                                      .movieDetailsList[0]
                                                      .genre?[0]
                                                      .id
                                                      .toString() ??
                                                  "",
                                              title: movieAllDetails
                                                  .movieDetailsList[0].title
                                                  .toString(),
                                              videoUrl: movieAllDetails
                                                  .movieDetailsList[0].link
                                                  .toString(),
                                              videoType: movieAllDetails
                                                      .movieDetailsList[0]
                                                      .genre?[0]
                                                      .name
                                                      .toString() ??
                                                  "",
                                              country: movieAllDetails
                                                      .movieDetailsList[0]
                                                      .region
                                                      ?.name
                                                      .toString() ??
                                                  "",
                                            )),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),

                              /// Movie Trailers,more Like this and Comments TabBar
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1),

                        /// Episodes of Only Web Series ///
                        (movieAllDetails
                                    .movieDetailsList[0].episode?.isNotEmpty ==
                                true)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        StringValue.episodes.tr,
                                        style: GoogleFonts.outfit(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      if (movieAllDetails.movieDetailsList[0]
                                              .season?.length !=
                                          1) ...{
                                        const Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig
                                                      .blockSizeHorizontal *
                                                  4),
                                          child: DropdownButton<String>(
                                            isExpanded: false,
                                            value: selectedVal,
                                            underline: const SizedBox(),
                                            items: movieAllDetails
                                                .movieDetailsList[0].season
                                                ?.map((season) {
                                              return DropdownMenuItem<String>(
                                                value: season.seasonNumber
                                                    .toString(),
                                                child: Text(
                                                  season.name.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                setState(() {
                                                  selectedVal = newValue;
                                                });
                                                seasonWiseEpisodesController
                                                    .allEpisodesDetails(
                                                        widget.movieId,
                                                        newValue);
                                              }
                                            },
                                            dropdownColor: (getStorage
                                                        .read('isDarkMode') ==
                                                    true)
                                                ? ColorValues.darkModeSecond
                                                : ColorValues.whiteColor,
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down,
                                                color: ColorValues.redColor),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            style: const TextStyle(
                                              color: ColorValues.redColor,
                                              fontSize: 12,
                                            ),
                                            selectedItemBuilder:
                                                (BuildContext context) {
                                              return movieAllDetails
                                                      .movieDetailsList[0]
                                                      .season
                                                      ?.map((season) {
                                                    return Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        season.name.toString(),
                                                        style: const TextStyle(
                                                          color: ColorValues
                                                              .redColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList() ??
                                                  [];
                                            },
                                          ),
                                        ),
                                      },
                                    ],
                                  ).paddingOnly(
                                    left: SizeConfig.blockSizeHorizontal * 4,
                                  ),
                                  SizedBox(
                                      height: SizeConfig.blockSizeVertical * 1),
                                  Obx(
                                    () {
                                      if (seasonWiseEpisodesController
                                          .isLoading.value) {
                                        return episodesShimmer();
                                      } else {
                                        return SizedBox(
                                          height: SizeConfig.screenHeight / 7.5,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                seasonWiseEpisodesController
                                                    .seasonWiseEpisodesList
                                                    .length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              if (i <
                                                  seasonWiseEpisodesController
                                                      .seasonWiseEpisodesList
                                                      .length) {
                                                return Container(
                                                  height:
                                                      SizeConfig.screenHeight,
                                                  clipBehavior: Clip.antiAlias,
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          2.8,
                                                  margin: EdgeInsets.only(
                                                      left: SizeConfig
                                                              .blockSizeHorizontal *
                                                          3),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .bottomCenter,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (movieAllDetails
                                                                      .movieDetailsList[
                                                                          0]
                                                                      .isPlan ==
                                                                  true ||
                                                              movieAllDetails
                                                                      .movieDetailsList[
                                                                          0]
                                                                      .type ==
                                                                  "Free") {
                                                            setState(() {
                                                              isWatchingMovie =
                                                                  true;
                                                            });

                                                            if (seasonWiseEpisodesController
                                                                    .seasonWiseEpisodesList[
                                                                        i]
                                                                    .videoType ==
                                                                0) {
                                                              key = seasonWiseEpisodesController
                                                                  .seasonWiseEpisodesList[
                                                                      i]
                                                                  .videoUrl
                                                                  .toString();
                                                              youtubeKey = key
                                                                  .split("=");
                                                              Get.to(
                                                                YoutubePlayerPage(
                                                                    name: seasonWiseEpisodesController
                                                                        .seasonWiseEpisodesList[
                                                                            i]
                                                                        .name
                                                                        .toString(),
                                                                    link:
                                                                        youtubeKey[
                                                                            1]),
                                                              );
                                                            } else {
                                                              Get.to(
                                                                VideoPlayers(
                                                                  name: seasonWiseEpisodesController
                                                                      .seasonWiseEpisodesList[
                                                                          i]
                                                                      .title
                                                                      .toString(),
                                                                  link: seasonWiseEpisodesController
                                                                      .seasonWiseEpisodesList[
                                                                          i]
                                                                      .videoUrl
                                                                      .toString(),
                                                                  type: true,
                                                                ),
                                                              );
                                                            }
                                                          } else {
                                                            subscribeToPremium();
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                seasonWiseEpisodesController
                                                                    .seasonWiseEpisodesList[
                                                                        i]
                                                                    .image
                                                                    .toString(),
                                                              ),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          width:
                                                              double.infinity,
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.play_circle,
                                                              color: ColorValues
                                                                  .whiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .bottomCenter,
                                                            end: Alignment
                                                                .topCenter,
                                                            colors: [
                                                              const Color(
                                                                  0xff181A10),
                                                              const Color(
                                                                      0xff181A10)
                                                                  .withValues(
                                                                      alpha:
                                                                          0.40),
                                                              Colors
                                                                  .transparent,
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .vertical(
                                                            bottom:
                                                                Radius.circular(
                                                                    15),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  right: 6,
                                                                  bottom: 6),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  "${seasonWiseEpisodesController.seasonWiseEpisodesList[i].name}",
                                                                  style:
                                                                      GoogleFonts
                                                                          .outfit(
                                                                    color: ColorValues
                                                                        .whiteColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 2),
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  if (movieAllDetails
                                                                              .movieDetailsList[
                                                                                  0]
                                                                              .isPlan ==
                                                                          true ||
                                                                      movieAllDetails
                                                                              .movieDetailsList[0]
                                                                              .type ==
                                                                          "Free") {
                                                                    if (seasonWiseEpisodesController
                                                                        .seasonWiseEpisodesList[
                                                                            i]
                                                                        .videoUrl
                                                                        .isNotEmpty) {
                                                                      setState(
                                                                          () {
                                                                        isWatchingMovie =
                                                                            true;
                                                                      });

                                                                      if (!downloadedMovie.contains(seasonWiseEpisodesController
                                                                          .seasonWiseEpisodesList[
                                                                              i]
                                                                          .id
                                                                          .toString())) {
                                                                        if (seasonWiseEpisodesController.seasonWiseEpisodesList[i].videoType ==
                                                                            3) {
                                                                          log("server Webseries Download");
                                                                          serverWebSeriesDownload(
                                                                            MoreInformationModel(
                                                                              thumbNail: seasonWiseEpisodesController.seasonWiseEpisodesList[i].image.toString(),
                                                                              videoId: seasonWiseEpisodesController.seasonWiseEpisodesList[i].id.toString(),
                                                                              title: seasonWiseEpisodesController.seasonWiseEpisodesList[i].name.toString(),
                                                                              videoUrl: seasonWiseEpisodesController.seasonWiseEpisodesList[i].videoUrl.toString(),
                                                                              videoType: seasonWiseEpisodesController.seasonWiseEpisodesList[i].videoType.toString(),
                                                                              country: movieAllDetails.movieDetailsList[0].region?.name.toString() ?? "",
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          log("Youtube Webseries Download");
                                                                          youtubeWebSeriesDownload(
                                                                            MoreInformationModel(
                                                                              thumbNail: seasonWiseEpisodesController.seasonWiseEpisodesList[i].image.toString(),
                                                                              videoId: seasonWiseEpisodesController.seasonWiseEpisodesList[i].id.toString(),
                                                                              title: seasonWiseEpisodesController.seasonWiseEpisodesList[i].name.toString(),
                                                                              videoUrl: seasonWiseEpisodesController.seasonWiseEpisodesList[i].videoUrl.toString(),
                                                                              videoType: seasonWiseEpisodesController.seasonWiseEpisodesList[i].videoType.toString(),
                                                                              country: movieAllDetails.movieDetailsList[0].region?.name.toString() ?? "",
                                                                            ),
                                                                          );
                                                                        }

                                                                        // Update the downloaded episodes list
                                                                        downloadedMovie.add(seasonWiseEpisodesController
                                                                            .seasonWiseEpisodesList[i]
                                                                            .id
                                                                            .toString());
                                                                        final SharedPreferences
                                                                            preferences =
                                                                            await SharedPreferences.getInstance();
                                                                        preferences.setStringList(
                                                                            "DownloadedEpisodesList",
                                                                            downloadedMovie);

                                                                        setState(
                                                                            () {});
                                                                      } else {
                                                                        // Episode has already been downloaded, show a message or perform any other action
                                                                        Fluttertoast
                                                                            .showToast(
                                                                          msg: StringValue
                                                                              .episodeDownloaded
                                                                              .tr,
                                                                          toastLength:
                                                                              Toast.LENGTH_SHORT,
                                                                          gravity:
                                                                              ToastGravity.BOTTOM,
                                                                          backgroundColor:
                                                                              Colors.red,
                                                                          textColor:
                                                                              Colors.white,
                                                                        );
                                                                      }
                                                                    } else {
                                                                      // Video URL is empty, show toast message
                                                                      Fluttertoast
                                                                          .showToast(
                                                                        msg: StringValue
                                                                            .videoURLNotFound
                                                                            .tr,
                                                                        toastLength:
                                                                            Toast.LENGTH_SHORT,
                                                                        gravity:
                                                                            ToastGravity.CENTER,
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                        textColor:
                                                                            Colors.white,
                                                                      );
                                                                    }
                                                                  }
                                                                },
                                                                child: Obx(
                                                                  () => downloadedMovie.contains(seasonWiseEpisodesController
                                                                          .seasonWiseEpisodesList[
                                                                              i]
                                                                          .id
                                                                          .toString())
                                                                      ? SvgPicture
                                                                          .asset(
                                                                          MovixIcon
                                                                              .done,
                                                                          height:
                                                                              SizeConfig.blockSizeVertical * 2.5,
                                                                          colorFilter: const ColorFilter
                                                                              .mode(
                                                                              ColorValues.redColor,
                                                                              BlendMode.srcIn),
                                                                          color:
                                                                              ColorValues.redColor,
                                                                        )
                                                                      : SvgPicture
                                                                          .asset(
                                                                          MovixIcon
                                                                              .boldDownload,
                                                                          height:
                                                                              SizeConfig.blockSizeVertical * 2.5,
                                                                          colorFilter: const ColorFilter
                                                                              .mode(
                                                                              ColorValues.redColor,
                                                                              BlendMode.srcIn),
                                                                        ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      child: Column(
                        children: [
                          Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: buildTabBar()),
                          DetailsTabsScreen(
                            tabController: _tabController,
                            trailer:
                                movieAllDetails.movieDetailsList[0].trailer ??
                                    [],
                            movieId: widget.movieId,
                            comments:
                                movieAllDetails.movieDetailsList[0].comment ??
                                    0,
                            description: movieAllDetails
                                    .movieDetailsList[0].description ??
                                "",
                            videoType:
                                movieAllDetails.movieDetailsList[0].videoType ??
                                    0,
                          ),
                        ],
                      ), // from above
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  /// Add Rating Methode ///
  InkWell addRating(CreateRatingProvider createRating, BuildContext context) {
    return InkWell(
      child: SvgPicture.asset(
        MovixIcon.halfBoldStar,
        height: SizeConfig.blockSizeVertical * 2,
        colorFilter:
            const ColorFilter.mode(ColorValues.yellow, BlendMode.srcIn),
      ),
      onTap: () {
        (movieAllDetails.movieDetailsList[0].isRating == false)
            ? (isWatchingMovie)
                ? Get.bottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    backgroundColor: (getStorage.read('isDarkMode') == true)
                        ? const Color(0xff1F222A)
                        : ColorValues.whiteColor,
                    Container(
                      height: Get.height / 3.5,
                      padding: const EdgeInsets.only(left: 13, right: 13),
                      decoration: BoxDecoration(
                        color: (getStorage.read('isDarkMode') == true)
                            ? const Color(0xff1F222A)
                            : ColorValues.whiteColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState1) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                StringValue.giveRating.tr,
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                              RatingBar.builder(
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: ColorValues.redColor,
                                ),
                                onRatingUpdate: (rat) {
                                  rating = rat;
                                },
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                        color: (getStorage.read('isDarkMode') ==
                                                true)
                                            ? const Color(0xff35383F)
                                            : ColorValues.redBoxColor,
                                      ),
                                      child: Text(
                                        StringValue.cancel.tr,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color:
                                              (getStorage.read('isDarkMode') ==
                                                      true)
                                                  ? ColorValues.whiteColor
                                                  : ColorValues.redColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        createRating.createRating(
                                            movieAllDetails
                                                .movieDetailsList[0].id
                                                .toString(),
                                            rating.toString());
                                        movieAllDetails
                                            .allDetails(widget.movieId);
                                      });
                                      Get.back();
                                    },
                                    child: Container(
                                      height: SizeConfig.screenHeight / 15,
                                      width: SizeConfig.screenWidth / 2.3,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: ColorValues.redColor,
                                      ),
                                      child: Text(
                                        StringValue.submit.tr,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: ColorValues.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                : ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(milliseconds: 400),
                      content: Text(
                        StringValue.pleaseFirstWatchMovie.tr,
                        style: const TextStyle(color: ColorValues.whiteColor),
                      ),
                      backgroundColor: ColorValues.redColor,
                    ),
                  )
            : ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(milliseconds: 400),
                  content: Text(
                    StringValue.youCanNotGiveRatingASecondTime.tr,
                    style: GoogleFonts.outfit(
                      color: ColorValues.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: ColorValues.redColor,
                ),
              );
      },
    );
  }

  Padding buildDescription() {
    // Function to remove HTML tags
    String removeHtmlTags(String htmlString) {
      final RegExp exp =
          RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
      return htmlString.replaceAll(exp, '');
    }

    // Get the description and remove HTML tags
    String description =
        removeHtmlTags("${movieAllDetails.movieDetailsList[0].description}");

    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.blockSizeHorizontal * 3.7,
        right: SizeConfig.blockSizeHorizontal * 2,
      ),
      child: ReadMoreText(
        description,
        trimLines: 2,
        colorClickableText: ColorValues.redColor,
        trimMode: TrimMode.Line,
        trimCollapsedText: 'View More',
        trimExpandedText: ' View Less',
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
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: ColorValues.grayText,
        ),
      ),
    );
  }

  buildTabBar() {
    return Container(
      color: (getStorage.read('isDarkMode') == true)
          ? ColorValues.scaffoldBg
          : ColorValues.whiteColor,
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: ColorValues.buttonColorRed, width: 2),
          insets: EdgeInsets.symmetric(horizontal: 0),
        ),
        indicatorColor: Colors.green,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ColorValues.buttonColorRed,
        unselectedLabelColor: ColorValues.grayColor,
        labelStyle: GoogleFonts.outfit(
          color: ColorValues.buttonColorRed,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        unselectedLabelStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: ColorValues.grayText,
        ),
        tabs: List.generate(tabs.length, (index) {
          return Tab(
            text: tabs[index],
          );
        }),
      ),
    );
  }

  /// Download Movie Methode ///
  Widget buildDownloadInkWell(MoreInformationModel element) {
    log("check videoType :: ${movieAllDetails.movieDetailsList[0].videoType}");
    log("check type :: ${movieAllDetails.movieDetailsList[0].type}");
    log("check isPlan :: ${movieAllDetails.movieDetailsList[0].isPlan}");
    log("thumbNail ::::::::::::::: ${movieAllDetails.movieDetailsList[0].image}");
    return InkWell(
      onTap: downloadedMovie.contains(
              movieAllDetails.movieDetailsList[0].genre?[0].id.toString())
          ? null
          : () async {
              if (videoDownload.value == true || serverVideo.value == true) {
                Fluttertoast.showToast(
                  msg: "Download already in progress",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: ColorValues.redColor,
                  textColor: Colors.white,
                );
                return;
              }

              log("List Detaile :: $downloadedMovie");
              final SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.setStringList("DownloadList", downloadedMovie.value);
              log("typeeeee :: ${movieAllDetails.movieDetailsList[0].videoType}");

              if (movieAllDetails.movieDetailsList[0].isPlan == true ||
                  movieAllDetails.movieDetailsList[0].type == "Free") {
                if (movieAllDetails.movieDetailsList[0].link?.isNotEmpty ==
                    true) {
                  if (movieAllDetails.movieDetailsList[0].videoType == 0) {
                    log("Enter the Youtube Video Download");
                    youtubeVideoDownload(element);
                    setState(() {});
                  } else {
                    serverVideoDownload(element);
                    setState(() {});
                  }
                } else {
                  Fluttertoast.showToast(
                    msg: "Video URL not found",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              } else {
                return subscribeToPremium();
              }
            },
      child: Obx(
        () => Container(
          height: SizeConfig.blockSizeVertical * 5,
          width: Get.width / 2.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: downloadedMovie.contains(
                    movieAllDetails.movieDetailsList[0].genre?[0].id.toString())
                ? ColorValues.redColor
                : Colors.transparent,
            border: Border.all(
              color: ColorValues.redColor,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              downloadedMovie.contains(movieAllDetails
                      .movieDetailsList[0].genre?[0].id
                      .toString())
                  ? SvgPicture.asset(
                      MovixIcon.done,
                      height: SizeConfig.blockSizeVertical * 2.5,
                      colorFilter: const ColorFilter.mode(
                          ColorValues.whiteColor, BlendMode.srcIn),
                    )
                  : SvgPicture.asset(
                      MovixIcon.boldDownload,
                      height: SizeConfig.blockSizeVertical * 2.5,
                      colorFilter: const ColorFilter.mode(
                          ColorValues.whiteColor, BlendMode.srcIn),
                    ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 1,
              ),
              Text(
                downloadedMovie.contains(movieAllDetails
                        .movieDetailsList[0].genre?[0].id
                        .toString())
                    ? StringValue.downloaded.tr
                    : StringValue.download.tr,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: ColorValues.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Play and Watch Movie methode ///
  InkWell playButton(AddViewToMovieProvider addViewToMovie) {
    return InkWell(
      onTap: () {
        addViewToMovie.addViewToMovie(
          movieAllDetails.movieDetailsList[0].id.toString(),
        );
        if (movieAllDetails.movieDetailsList[0].isPlan == true ||
            movieAllDetails.movieDetailsList[0].type == "Free" ||
            hasActiveRental) {
          setState(() {
            isWatchingMovie = true;
          });
          _interstitialAd?.show();
          if (_interstitialAd != null) {
            _interstitialAd?.show();
            if (movieAllDetails.movieDetailsList[0].videoType == 0) {
              key = movieAllDetails.movieDetailsList[0].link.toString();
              youtubeKey = key.split("=");
              log("youtube video play>>>>>>>>>>>>>>>>>>>>>");
              log("movieAllDetails.movieDetailsList[0].videoType${movieAllDetails.movieDetailsList[0].videoType}");

              Get.to(
                () => YoutubePlayerPage(
                    name: movieAllDetails.movieDetailsList[0].title.toString(),
                    link: youtubeKey[1]),
              );
            } else if (movieAllDetails.movieDetailsList[0].videoType == 6) {
              log("movieAllDetails.movieDetailsList[0].videoType${movieAllDetails.movieDetailsList[0].videoType}");

              Get.to(
                WebViewApp(
                    link: movieAllDetails.movieDetailsList[0].link.toString()),
              );
            } else {
              log("video play>>>>>>>>>>>>>>>>>>>>>");
              log("movieAllDetails.movieDetailsList[0].videoType>>>>>>>>>>${movieAllDetails.movieDetailsList[0].videoType}");

              Get.to(
                () => VideoPlayers(
                  name: movieAllDetails.movieDetailsList[0].title.toString(),
                  link: movieAllDetails.movieDetailsList[0].link.toString(),
                  type: true,
                ),
              );
            }
          } else {
            if (movieAllDetails.movieDetailsList[0].videoType == 0) {
              key = movieAllDetails.movieDetailsList[0].link.toString();
              youtubeKey = key.split("=");
              log("movieAllDetails.movieDetailsList[0].videoType${movieAllDetails.movieDetailsList[0].videoType}");

              Get.to(
                () => YoutubePlayerPage(
                    name: movieAllDetails.movieDetailsList[0].title.toString(),
                    link: youtubeKey[1]),
              );
            } else if (movieAllDetails.movieDetailsList[0].videoType == 6) {
              log("movieAllDetails.movieDetailsList[0].videoType${movieAllDetails.movieDetailsList[0].videoType}");

              Get.to(
                WebViewApp(
                    link: movieAllDetails.movieDetailsList[0].link.toString()),
              );
            } else {
              log("movieAllDetails.movieDetailsList[0].videoType>>>>>>>>>>${movieAllDetails.movieDetailsList[0].videoType}");

              Get.to(
                () => VideoPlayers(
                  name: movieAllDetails.movieDetailsList[0].title.toString(),
                  link: movieAllDetails.movieDetailsList[0].link.toString(),
                  type: true,
                ),
              );
            }
          }
        } else {
          subscribeToPremium();
        }
      },
      child: Container(
        height: SizeConfig.blockSizeVertical * 5,
        width: (movieAllDetails.movieDetailsList[0].videoType == 0)
            ? Get.width / 2.10
            : Get.width / 2.3,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: ColorValues.redColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              MovixIcon.boldPlay,
              height: SizeConfig.blockSizeVertical * 2.5,
              colorFilter: const ColorFilter.mode(
                  ColorValues.whiteColor, BlendMode.srcIn),
            ),
            const SizedBox(
              width: 05,
            ),
            Text(
              StringValue.play.tr,
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: ColorValues.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Existing Rent bottom-sheet flow removed; using RentPlanScreen page instead.

  /// SubScribeToPremium Methode ///
  Future<dynamic> subscribeToPremium() {
    return Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            MovixIcon.king,
            color: ColorValues.redColor,
            height: SizeConfig.blockSizeVertical * 9,
            width: SizeConfig.blockSizeVertical * 9,
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2.5,
          ),
          Text(
            StringValue.subscribeToPremium.tr,
            style: GoogleFonts.outfit(
                color: ColorValues.redColor,
                fontWeight: FontWeight.bold,
                fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2.5,
          ),
          Text(
            StringValue.subscribePremiumEnjoyTheBenefits.tr,
            style: GoogleFonts.outfit(
                fontSize: 15,
                color: getStorage.read("isDarkMode") == true
                    ? ColorValues.whiteColor
                    : ColorValues.blackColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2.5,
          ),
          InkWell(
            onTap: () {
              Get.back();
              Get.to(
                () => const SubscribeToPremium(),
                transition: Transition.downToUp,
              );
            },
            child: Container(
              alignment: Alignment.center,
              height: SizeConfig.screenHeight / 15.5,
              width: SizeConfig.screenWidth / 1.2,
              decoration: BoxDecoration(
                color: ColorValues.redColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                StringValue.subscribeToPremiums.tr,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorValues.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 16),
      backgroundColor: (getStorage.read('isDarkMode') == true)
          ? ColorValues.appBarColor
          : ColorValues.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  /// Cast of Movie Methode ///
  SizedBox buildRoleSizedBox() {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 6,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movieAllDetails.movieDetailsList[0].role?.length,
        itemBuilder: (BuildContext context, int i) {
          return Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              decoration: BoxDecoration(
                color: (getStorage.read('isDarkMode') == true)
                    ? ColorValues.detailContainer
                    : ColorValues.darkModeThird.withValues(alpha: 0.05),
                border: Border.all(
                    color: (getStorage.read('isDarkMode') == true)
                        ? ColorValues.detailBorder
                        : ColorValues.darkModeThird.withValues(alpha: 0.10)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        imageUrl: movieAllDetails
                                .movieDetailsList[0].role?[i].image
                                .toString() ??
                            "",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          AssetValues.noProfile,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 1.4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        movieAllDetails.movieDetailsList[0].role?[i].name
                                .toString() ??
                            "",
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig.blockSizeHorizontal * 2),
                        child: Text(
                          movieAllDetails.movieDetailsList[0].role?[i].position
                                  .toString() ??
                              "",
                          style: GoogleFonts.outfit(fontSize: 09),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Shimmer ///
  Shimmer mainShimmer() {
    return Shimmer.fromColors(
      highlightColor: (getStorage.read('isDarkMode') == true)
          ? Colors.white12
          : Colors.grey.shade100,
      baseColor: (getStorage.read('isDarkMode') == true)
          ? Colors.white24
          : Colors.grey.shade300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: SizeConfig.screenHeight / 2.4,
            decoration: const BoxDecoration(
              color: ColorValues.grayColor,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 75,
                  decoration: BoxDecoration(
                      color: ColorValues.grayColor,
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(right: 250),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 20,
                      width: 120,
                      decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 20,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 24,
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: ColorValues.grayColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 16,
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: ColorValues.grayColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 16,
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: ColorValues.grayColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        height: SizeConfig.blockSizeVertical * 4.8,
                        width: Get.width / 2.3,
                        decoration: BoxDecoration(
                          color: ColorValues.grayShimmer,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        height: SizeConfig.blockSizeVertical * 4.8,
                        width: Get.width / 2.3,
                        decoration: BoxDecoration(
                          color: ColorValues.grayShimmer,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        height: SizeConfig.blockSizeVertical * 4.8,
                        width: Get.width / 2.3,
                        decoration: BoxDecoration(
                          color: ColorValues.grayShimmer,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 26,
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: Get.width / 3,
                      decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const Spacer(),
                    Container(
                      height: 20,
                      width: Get.width / 3.7,
                      decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 26,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, int i) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    height: 20,
                    width: Get.width / 2.57,
                    decoration: BoxDecoration(
                        color: ColorValues.grayColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
            ).paddingOnly(left: 6),
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      width: Get.width / 3.9,
                      decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      height: 4,
                      width: Get.width / 3,
                      decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      width: Get.width / 3.9,
                      decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      height: 4,
                      width: Get.width / 3,
                      decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      width: Get.width / 3.9,
                      decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      height: 4,
                      width: Get.width / 3,
                      decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6)
            ],
          )
        ],
      ),
    );
  }

  Shimmer episodesShimmer() {
    return Shimmer.fromColors(
      highlightColor: (getStorage.read('isDarkMode') == true)
          ? Colors.white12
          : Colors.grey.shade100,
      baseColor: (getStorage.read('isDarkMode') == true)
          ? Colors.white24
          : Colors.grey.shade300,
      child: SizedBox(
        height: SizeConfig.screenHeight / 7.5,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext context, int i) {
            return Container(
              padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 2,
                top: SizeConfig.blockSizeVertical * 6,
              ),
              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorValues.grayColor,
              ),
              width: SizeConfig.screenWidth / 2.8,
            );
          },
        ),
      ),
    );
  }

  /// Latest Youtube Video Download

  youtubeVideoDownload(MoreInformationModel element) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    log("Youtube video download start");

    if (videoDownload.value == true) {
      log("Already downloading...");
      return;
    }

    videoDownload.value = true;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return DownloadProgressDialog(
            onHide: () => Get.back(),
          );
        },
      ),
      barrierDismissible: false,
    );

    String videoUrl = movieAllDetails.movieDetailsList[0].link.toString();
    final yt = YoutubeExplode();
    final id = VideoId(videoUrl);
    final video = await yt.videos.get(videoUrl);

    var status = await Permission.storage.request();
    if (!status.isGranted) {
      videoDownload.value = false;
      Fluttertoast.showToast(
        msg: "Storage permission denied",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
      if (Get.isDialogOpen == true) Get.back();
      return;
    }

    const folderName = 'WebTimeMovieOcean';
    final appDocDir = await getExternalStorageDirectory();
    final folderPath = '${appDocDir?.path}/$folderName';
    Directory(folderPath).createSync(recursive: true);

    final manifest = await yt.videos.streamsClient.getManifest(id);
    final audio = manifest.streams.last;
    final videoStream = manifest.video.first;

    final filePath =
        path.join(folderPath, '${video.id}.${audio.container.name}.mp4');
    log("Downloading video to: $filePath");

    try {
      final file = File(filePath);
      final fileStream = file.openWrite();
      await yt.videos.streamsClient.get(videoStream).pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();

      downloadedMovie.insert(
          0, movieAllDetails.movieDetailsList[0].genre?[0].id.toString() ?? "");
      preferences.setStringList("DownloadList", downloadedMovie);
      downloadedMovie.value = preferences.getStringList("DownloadList") ?? [];
      Fluttertoast.showToast(
        msg: StringValue.downloadCompleted.tr,
        textColor: Colors.white,
        backgroundColor: ColorValues.redColor,
      );

      // ✅ Download thumbnail image from element.thumbNail
      final downloadThumbnail = await CustomDownload.downloadImage(
        element.thumbNail,
        element.videoId,
      );

      log("downloadThumbnail>>>>>>>>>>>>>>>>>>>>>>>>>$downloadThumbnail");

      if (downloadThumbnail != null) {
        DateTime now = DateTime.now();
        String formattedDate = now.toString();

        DownloadHistory.mainDownloadHistory.insert(0, {
          "videoId": element.videoId,
          "videoTitle": element.title,
          "videoUrl": filePath,
          "videoImage": downloadThumbnail,
          "time": formattedDate,
          "country": element.country,
          "videoType": element.videoType,
        });

        DownloadHistory.onSet();

        String jsonData = json.encode(DownloadHistory.mainDownloadHistory);
        preferences.setString("download", jsonData);

        log("Video and thumbnail saved successfully");
      } else {
        log("Thumbnail download failed");
      }
    } catch (e) {
      log("Video download error: $e");
      Fluttertoast.showToast(
        msg: "Download failed: ${e.toString()}",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      videoDownload.value = false;
      if (Get.isDialogOpen == true) Get.back();
    }
  }

  /// server Video Download

  serverVideoDownload(MoreInformationModel element) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    log("Server Video");

    if (serverVideo.value == true) {
      log("Already downloading...");
      return;
    }

    serverVideo.value = true;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return DownloadProgressDialog(
            onHide: () => Get.back(),
          );
        },
      ),
      barrierDismissible: false,
    );

    final baseStorage = await getExternalStorageDirectory();
    log("Video download storage :: $baseStorage");

    // final downloadPath = await CustomDownload.download(element.videoUrl, element.videoId);
    // Get.back();

    /// ✅ Replace with `CustomDownload.downloadImage`
    final downloadThumbnail = await CustomDownload.downloadImage(
      element.thumbNail,
      element.videoId,
    );

    log("downloadThumbnail >>>>>>>>>>>>>>>>>>>> $downloadThumbnail");

    if (downloadThumbnail != null) {
      downloadedMovie.insert(
          0, movieAllDetails.movieDetailsList[0].genre?[0].id.toString() ?? "");
      preferences.setStringList("DownloadList", downloadedMovie);
      downloadedMovie.value = preferences.getStringList("DownloadList") ?? [];

      DateTime now = DateTime.now();
      String formattedDate = now.toString();

      DownloadHistory.mainDownloadHistory.insert(
        0,
        {
          "videoId": element.videoId,
          "videoTitle": element.title,
          "videoUrl": downloadThumbnail,
          "videoImage": downloadThumbnail,
          "time": formattedDate,
          "country": element.country,
          "videoType": element.videoType,
        },
      );
      DownloadHistory.onSet();

      String jsonData = json.encode(DownloadHistory.mainDownloadHistory);
      preferences.setString("download", jsonData);

      preferences.setString(
        "movieDownloaded",
        movieAllDetails.movieDetailsList[0].genre?[0].id.toString() ?? "",
      );

      Fluttertoast.showToast(
        msg: StringValue.downloadCompleted.tr,
        textColor: Colors.white,
        backgroundColor: ColorValues.redColor,
      );

      serverVideo.value = false;
    } else {
      Fluttertoast.showToast(
        msg: "Download failed",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(
        "isMovieDownload", DownloadHistory.mainDownloadHistory.isNotEmpty);

    setState(() {
      isMovieDownload = pref.getBool("isMovieDownload") ?? false;
    });
  }

  ///  Youtube webseries Download

  youtubeWebSeriesDownload(MoreInformationModel element) async {
    log("▶️ Start YouTube web series download");
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    log("element>>>>>>>>>>>>>>>>>>>${element.thumbNail}");

    serverSeriesDownload.value = true;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return DownloadProgressDialog(
            onHide: () => Get.back(),
          );
        },
      ),
      barrierDismissible: false,
    );

    final yt = YoutubeExplode();
    final videoUrl = element.videoUrl;
    final videoId = VideoId(videoUrl);

    try {
      log("📺 Video URL: $videoUrl");
      final video = await yt.videos.get(videoId);

      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        Fluttertoast.showToast(
          msg: "Storage permission denied",
          textColor: Colors.white,
          backgroundColor: Colors.red,
        );
        return;
      }

      final appDocDir = await getExternalStorageDirectory();
      final folderPath = '${appDocDir?.path}/WebTimeMovieOcean';
      await Directory(folderPath).create(recursive: true);

      final manifest = await yt.videos.streamsClient.getManifest(videoId);
      final stream = manifest.video.first;
      final ext = stream.container.name;
      final filePath = path.join(folderPath, '${video.id}.$ext.mp4');

      log("💾 Saving to: $filePath");
      final file = File(filePath);
      final streamData = await yt.videos.streamsClient.get(stream);
      final fileStream = file.openWrite();
      await streamData.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();

      // Add to downloaded list
      downloadedMovie.insert(0,
          seasonWiseEpisodesController.seasonWiseEpisodesList[0].id.toString());
      preferences.setStringList("DownloadList", downloadedMovie);
      downloadedMovie.value = preferences.getStringList("DownloadList") ?? [];

      // Show success toast
      Fluttertoast.showToast(
        msg: StringValue.downloadCompleted.tr,
        textColor: Colors.white,
        backgroundColor: ColorValues.redColor,
      );

      // ✅ Close dialog
      if (Get.isDialogOpen == true) Get.back();

      // 🔻 Download thumbnail from video file
      final downloadThumbnail = await CustomDownload.downloadImage(
        element.thumbNail,
        element.videoId,
      );

      log("downloadThumbnail>>>>>>>>>>>>>>>>>>>>>>>>>$downloadThumbnail");

      // Save to history
      DateTime now = DateTime.now();
      String formattedDate = now.toString();

      DownloadHistory.mainDownloadHistory.insert(0, {
        "videoId": element.videoId,
        "videoTitle": element.title,
        "videoUrl": filePath,
        "videoImage": downloadThumbnail,
        "time": formattedDate,
        "country": element.country,
        "videoType": element.videoType,
      });
      DownloadHistory.onSet();

      String jsonData = json.encode(DownloadHistory.mainDownloadHistory);
      preferences.setString("download", jsonData);

      log("✅ Download complete and saved");
    } catch (e) {
      log("❌ video Download Error: $e");
      Fluttertoast.showToast(
        msg: "Download failed: ${e.toString()}",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
      if (Get.isDialogOpen == true) Get.back();
    } finally {
      // ✅ Reset status
      serverSeriesDownload.value = false;
      if (Get.isDialogOpen == true) Get.back();
    }
  }

  /// server webseries download

  serverWebSeriesDownload(MoreInformationModel element) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    log("▶️ Start Server Web Series Download");

    if (serverWebDownload.value == true) {
      log("Already downloading...");
      return;
    }

    serverWebDownload.value = true;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return DownloadProgressDialog(
            onHide: () => Get.back(),
          );
        },
      ),
      barrierDismissible: false,
    );

    try {
      final baseStorage = await getExternalStorageDirectory();
      log("📁 Storage Path: $baseStorage");

      final downloadPath =
          await CustomDownload.download(element.videoUrl, element.videoId);

      if (downloadPath == null) {
        throw Exception("Download path is null");
      }

      downloadedMovie.insert(0,
          seasonWiseEpisodesController.seasonWiseEpisodesList[0].id.toString());
      preferences.setStringList("DownloadList", downloadedMovie);
      downloadedMovie.value = preferences.getStringList("DownloadList") ?? [];

      Fluttertoast.showToast(
        msg: StringValue.downloadCompleted.tr,
        textColor: Colors.white,
        backgroundColor: ColorValues.redColor,
      );

      if (Get.isDialogOpen == true) Get.back();

      // ✅ Use same thumbnail logic like youtubeWebSeriesDownload
      final downloadThumbnail = await CustomDownload.seriesDownloadImage(
        element.thumbNail,
        element.videoId,
      );

      log("📸 Thumbnail Path: $downloadThumbnail");

      DateTime now = DateTime.now();
      String formattedDate = now.toString();

      DownloadHistory.mainDownloadHistory.insert(0, {
        "videoId": element.videoId,
        "videoTitle": element.title,
        "videoUrl": downloadPath,
        "videoImage": downloadThumbnail,
        "time": formattedDate,
        "country": element.country,
        "videoType": element.videoType,
      });
      DownloadHistory.onSet();

      String jsonData = json.encode(DownloadHistory.mainDownloadHistory);
      preferences.setString("download", jsonData);

      preferences.setString("movieDownloaded",
          seasonWiseEpisodesController.seasonWiseEpisodesList[0].id.toString());

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool(
          "isMovieDownload", DownloadHistory.mainDownloadHistory.isNotEmpty);

      setState(() {
        isMovieDownload = pref.getBool("isMovieDownload") ?? false;
      });

      log("✅ Server web series downloaded and saved");
    } catch (e) {
      log("❌ Server Web Series Download Error: $e");
      Fluttertoast.showToast(
        msg: "Download failed: ${e.toString()}",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      serverWebDownload.value = false;
      if (Get.isDialogOpen == true) Get.back();
    }
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  SliverAppBarDelegate({required this.child});

  @override
  double get minExtent => Get.width;

  @override
  double get maxExtent => Get.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
