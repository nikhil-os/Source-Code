import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/createFavoriteMovie_api/create_favourite_movie_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/all_movie_module/Allmovi_resources/Allmovies_repository.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/all_movie_module/bloc/allmovies_bloc.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/comedyMovie_module/bloc/comedymovie_bloc.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/comedyMovie_module/comedymovie_resources/comedymovie_repository.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/newreleasemovie_module/bloc/new_release_movie_bloc.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/newreleasemovie_module/newReleaseMovie_resources/newReleaseMovie_repository.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/top10movie_module/bloc/top10movies_bloc.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/top10movie_module/top10movies_resources/top10movies_repository.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/top10webSeries_module/bloc/top10web_series_bloc.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/top10webSeries_module/top10webSeries_resources/top10webSeries_repository.dart';
import 'package:webtime_movie_ocean/controller/api_controller/movieDetailsController.dart';
import 'package:webtime_movie_ocean/controller/api_controller/topRatedMovie_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/topRatedWebSeries_controller.dart';
import 'package:webtime_movie_ocean/custom/custom_blur_widget.dart';
import 'package:webtime_movie_ocean/custom/custom_rating_view.dart';
import 'package:webtime_movie_ocean/custom/custom_status_bar_color.dart';
import 'package:webtime_movie_ocean/custom/exit_dialog.dart';
import 'package:webtime_movie_ocean/custom/see_all_container.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/home_screen/more_screen/Details/details_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/home_screen/more_screen/homeScreen_data.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/home_screen/more_screen/notification_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profile_premium_view/subscribetopremium.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/controller/reels_controller.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_class.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/database.dart';
import 'package:webtime_movie_ocean/presentation/utils/helper/ads_helper.dart';
import 'package:webtime_movie_ocean/presentation/utils/theme/theme.dart';
import 'package:webtime_movie_ocean/presentation/widget/nativads.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onIndex});

  final void Function(int)? onIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarouselSliderController scrollController = CarouselSliderController();
  bool isCollapsed = false;
  final ScrollController _scrollController = ScrollController();

  int _current = 0;

  movieDetailsController movieAllDetails = Get.put(movieDetailsController());
  topRatedMovieController topRatedMovie = Get.put(topRatedMovieController());
  topRatedWebSeriesController topRatedWebSeries = Get.put(topRatedWebSeriesController());
  InterstitialAd? _interstitialAd;

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId!,
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

    log("Database.profileImage.value${Database.profileImage.value}");

    log("videoDownload.value::::::::::::::${videoDownload.value}");
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ],
    );
    _loadInterstitialAd();
    // ScrollController listener add karo
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.offset > 5 && !isCollapsed) {
          setState(() {
            isCollapsed = true;
          });
        } else if (_scrollController.offset <= 5 && isCollapsed) {
          setState(() {
            isCollapsed = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomStatusBarColor.init();
    SizeConfig().init(context);
    final createFavoriteMovie = Provider.of<CreateFavoriteMovieProvider>(context, listen: false);
    log("createFavoriteMovie :::::>>>>>>> $createFavoriteMovie");

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          Get.dialog(
            barrierColor: ColorValues.blackColor.withValues(alpha: 0.8),
            const ExitDialog(),
          );
          if (didPop) {
            return;
          }
        },
        child: Scaffold(
          backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.scaffoldBg : ColorValues.whiteColor,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                surfaceTintColor: Colors.transparent,
                backgroundColor: isCollapsed ? Colors.red : Colors.transparent,
                pinned: true,
                expandedHeight: 80.0,
                toolbarHeight: 80.0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: isCollapsed
                        ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              (getStorage.read('isDarkMode') == true) ? Colors.black : Colors.white,
                              (getStorage.read('isDarkMode') == true) ? Colors.black : Colors.white,
                            ],
                          )
                        : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: (getStorage.read('isDarkMode') == true)
                                ? [
                                    Colors.black,
                                    Colors.black.withValues(alpha: .5),
                                    Colors.transparent,
                                  ]
                                : [
                                    Colors.black.withValues(alpha: 0.45),
                                    Colors.black.withValues(alpha: 0.2),
                                    Colors.transparent,
                                  ],
                          ),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 14.0,
                      top: 22.0,
                      left: 14.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: Get.height * 0.125,
                          width: Get.width * 0.125,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : Colors.black,
                              width: 0.5,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 3, right: 3),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorValues.backgroundColor,
                            ),
                            clipBehavior: Clip.hardEdge,
                            child:
                                // (getStorage.read("updatedNewDp")?.isEmpty ?? true)
                                //     ? updateProfileImage == null
                                //         ? Image.asset(
                                //             AssetValues.noProfile,
                                //           )
                                //         : Image.file(updateProfileImage!, fit: BoxFit.cover)
                                //     :

                                Obx(
                              () => PreviewNetworkImage(
                                id: Database.fetchProfileModel?.user?.id ?? "",
                                image: Database.profileImage.value,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Explore top show", style: fillProfileStyle),
                              Text(
                                "Your personalised streaming hub.",
                                style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.grayColorText : ColorValues.darkModeThird,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onIndex?.call(1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.smallContainerBg : Colors.grey.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(11),
                            child: ImageIcon(
                              const AssetImage(IconAssetValues.search),
                              size: 22,
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => const NotificationScreen(),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.smallContainerBg : Colors.grey.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              MovixIcon.notification,
                              colorFilter: ColorFilter.mode(
                                  (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /// All Movie Banner ///
                    allMovieBanner(context, createFavoriteMovie),

                    /// Series Shorts ///

                    Row(
                      children: [
                        Text(
                          StringValue.seriesShorts.tr,
                          style: titalstyle1,
                        ),
                        const Spacer(),
                        SeeAllContainer(onTap: () {
                          widget.onIndex?.call(2);
                        }),
                      ],
                    ).paddingOnly(
                      left: SizeConfig.blockSizeHorizontal * 5,
                      right: SizeConfig.blockSizeHorizontal * 2,
                      top: 10,
                      bottom: 20,
                    ),

                    GetBuilder<ReelsController>(
                      id: 'onGetReels',
                      builder: (logic) {
                        return logic.isLoadingReels
                            ? shimmer()
                            : SizedBox(
                                height: SizeConfig.screenHeight / 4.7,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: logic.mainReels.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return InkWell(
                                      onTap: () {
                                        logic.currentReels = logic.mainReels[i].id ?? '';
                                        widget.onIndex?.call(2);
                                        log("IDD :: ${logic.currentReels}");
                                      },
                                      child: Container(
                                        height: SizeConfig.screenHeight,
                                        clipBehavior: Clip.antiAlias,
                                        width: SizeConfig.screenWidth / 2.8,
                                        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
                                        decoration: BoxDecoration(
                                          color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: logic.mainReels[i].videoImage ?? '',
                                              fit: BoxFit.cover,
                                              height: 200,
                                              width: double.infinity,
                                              placeholder: (context, url) => Image(
                                                image: const AssetImage(AssetValues.appLogo),
                                                width: 50,
                                                height: 50,
                                                color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                color: getStorage.read('isDarkMode') == true ? ColorValues.darkModeThird : Colors.grey.shade400,
                                                child: const Center(
                                                  child: Image(image: AssetImage(AssetValues.appLogo)),
                                                ),
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              MovixIcon.boldPlay,
                                              height: SizeConfig.blockSizeVertical * 3.5,
                                              colorFilter: const ColorFilter.mode(ColorValues.whiteColor, BlendMode.srcIn),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              child: Container(
                                                height: 70,
                                                width: SizeConfig.screenWidth / 2.8,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Colors.black.withValues(alpha: 0.8),
                                                      Colors.black.withValues(alpha: 0.7),
                                                      Colors.black.withValues(alpha: 0.6),
                                                      Colors.black.withValues(alpha: 0.3),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                  borderRadius: const BorderRadius.vertical(
                                                    bottom: Radius.circular(26),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                      },
                    ),

                    /// NewReleases Movie ///
                    newReleases(context, 1),

                    const NativAdsScreen(),

                    /// Top 10 Movie ///
                    top10Movie(context, 2),

                    /// Top 10 Web Series ///
                    top10WebSeries(context, 3),

                    const NativAdsScreen(),

                    /// Top Rated Movie ///
                    movieTopRated(4),

                    /// Top Rated WebSeries ///
                    webSeriesTopRated(5),

                    /// Comedy Movie ///
                    comedyMovie(context, 4),

                    const NativAdsScreen(),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // );
  }

  /// All Movie Banner Api Data ///
  BlocProvider<AllMoviesBloc> allMovieBanner(BuildContext context, CreateFavoriteMovieProvider createFavoriteMovie) {
    return BlocProvider(
      create: (_) => AllMoviesBloc(RepositoryProvider.of<AllMoviesRepository>(context))..add(GetAllMovie()),
      child: BlocListener<AllMoviesBloc, AllMoviesState>(
        listener: (BuildContext context, state) {},
        child: BlocBuilder<AllMoviesBloc, AllMoviesState>(
          builder: (context, state) {
            if (state is AllMoviesLoading) {
              return Shimmer.fromColors(
                highlightColor: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
                baseColor: (getStorage.read('isDarkMode') == true) ? Colors.white24 : Colors.grey.shade300,
                child: Container(
                  height: Get.height * 0.54,
                  width: Get.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorValues.grayColor),
                ).paddingSymmetric(horizontal: 26, vertical: 10),
              );
            } else if (state is AllMoviesLoaded) {
              return (state.movieModal.movie != null && state.movieModal.movie!.isNotEmpty)
                  ? Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            BlurWidget(
                              blurAmount: 80.0,
                              child: SizedBox(
                                height: Get.height * 0.56,
                                width: Get.width,
                                child: CachedNetworkImage(
                                  imageUrl: state.movieModal.movie![_current].image ?? "",
                                  placeholder: (context, url) => Image(
                                    height: SizeConfig.screenHeight / 2.2,
                                    width: SizeConfig.screenWidth,
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                    image: const AssetImage(
                                      AssetValues.appLogo,
                                    ),
                                  ),
                                  errorWidget: (Context, string, dynamic) => Image(
                                    height: SizeConfig.screenHeight / 2.2,
                                    width: SizeConfig.screenWidth,
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                    image: const AssetImage(
                                      AssetValues.appLogo,
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: CarouselSlider(
                                carouselController: scrollController,
                                options: CarouselOptions(
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                  viewportFraction: 1,
                                  autoPlay: false,
                                  height: Get.height * 0.54,
                                ),
                                items: List.generate(state.movieModal.movie!.length, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        DetailsScreen(
                                          movieId: state.movieModal.movie![index].id.toString(),
                                        ),
                                      );
                                    },
                                    child: Builder(builder: (context) {
                                      return Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20.0),
                                              border: Border.all(
                                                color: ColorValues.whiteColor.withValues(alpha: 0.4),
                                                width: 1.0,
                                              ),
                                            ),
                                            height: Get.height * 0.56,
                                            clipBehavior: Clip.hardEdge,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20.0),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: state.movieModal.movie![index].image.toString(),
                                                placeholder: (context, url) => Image(
                                                  height: SizeConfig.screenHeight / 2.2,
                                                  width: SizeConfig.screenWidth,
                                                  color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                                  image: const AssetImage(
                                                    AssetValues.appLogo,
                                                  ),
                                                ),
                                                errorWidget: (Context, string, dynamic) => Image(
                                                  height: SizeConfig.screenHeight / 2.2,
                                                  width: SizeConfig.screenWidth,
                                                  color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                                  image: const AssetImage(
                                                    AssetValues.appLogo,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ).paddingSymmetric(horizontal: 26),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 26.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  bottomLeft: Radius.circular(20),
                                                  bottomRight: Radius.circular(20),
                                                ),
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.black.withValues(alpha: 0.85),
                                                    Colors.black.withValues(alpha: 0.3),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${state.movieModal.movie![_current].title}',
                                                      style: allTitleWhiteStyle,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    Text(
                                                      '${state.movieModal.movie![_current].description}',
                                                      style: GoogleFonts.outfit(
                                                          fontSize: 13, color: ColorValues.grayColorText, fontWeight: FontWeight.w400),
                                                      maxLines: 2,
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                    ).paddingSymmetric(horizontal: 40, vertical: 6),
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        InkWell(
                                                          child: Container(
                                                            padding: EdgeInsets.only(
                                                                left: SizeConfig.blockSizeHorizontal * 1.8,
                                                                right: SizeConfig.blockSizeHorizontal * 3,
                                                                top: SizeConfig.blockSizeVertical * 0.7,
                                                                bottom: SizeConfig.blockSizeVertical * 0.7),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(20),
                                                              color: ColorValues.redColor,
                                                            ),
                                                            alignment: Alignment.center,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(
                                                                  MovixIcon.boldPlay,
                                                                  height: SizeConfig.blockSizeVertical * 2.5,
                                                                  colorFilter: const ColorFilter.mode(ColorValues.whiteColor, BlendMode.srcIn),
                                                                ),
                                                                SizedBox(
                                                                  width: SizeConfig.blockSizeHorizontal * 2,
                                                                ),
                                                                Text(
                                                                  StringValue.play.tr,
                                                                  style: playStyle,
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            Get.to(
                                                              DetailsScreen(
                                                                movieId: state.movieModal.movie![_current].id.toString(),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: SizeConfig.blockSizeHorizontal * 2.5,
                                                        ),
                                                        Consumer<CreateFavoriteMovieProvider>(
                                                          builder: (context, createFavoriteMovie, child) {
                                                            final isFavorite = AllMovieData["movie"][_current]["isFavorite"] == true;

                                                            return InkWell(
                                                              onTap: () async {
                                                                if (createFavoriteMovie.isLoading) {
                                                                  log("work==============");
                                                                } else {
                                                                  await createFavoriteMovie.createFavoriteMovie(
                                                                    state.movieModal.movie![_current].id,
                                                                  );
                                                                  setState(() {
                                                                    AllMovieData["movie"][_current]["isFavorite"] = !isFavorite;
                                                                  });
                                                                }
                                                              },
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                padding: EdgeInsets.symmetric(
                                                                  horizontal: SizeConfig.blockSizeHorizontal * 3,
                                                                  vertical: SizeConfig.blockSizeVertical * 0.4,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                  color: createFavoriteMovie.isLoading
                                                                      ? ColorValues.grayShimmer.withValues(alpha: 0.3)
                                                                      : isFavorite
                                                                          ? ColorValues.redColor
                                                                          : Colors.transparent,
                                                                  borderRadius: BorderRadius.circular(20),
                                                                  border: Border.all(
                                                                    color: createFavoriteMovie.isLoading
                                                                        ? ColorValues.grayShimmer
                                                                        : isFavorite
                                                                            ? ColorValues.redColor
                                                                            : ColorValues.whiteColor,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                                child: createFavoriteMovie.isLoading
                                                                    ? const SizedBox(width: 68, height: 22, child: CupertinoActivityIndicator())
                                                                    : Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Icon(
                                                                            isFavorite ? Icons.done : Icons.add,
                                                                            color: ColorValues.whiteColor,
                                                                            size: SizeConfig.blockSizeVertical * 2.5,
                                                                          ),
                                                                          SizedBox(width: SizeConfig.blockSizeHorizontal * 1.5),
                                                                          Text(StringValue.list.tr, style: playStyle),
                                                                        ],
                                                                      ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ).paddingSymmetric(vertical: 6),
                                                    const SizedBox(height: 10)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        AnimatedSmoothIndicator(
                          onDotClicked: animateToSlide,
                          activeIndex: _current,
                          count: state.movieModal.movie!.length,
                          axisDirection: Axis.horizontal,
                          curve: Curves.easeInCubic,
                          effect: ScrollingDotsEffect(
                            dotHeight: SizeConfig.blockSizeVertical * 1,
                            dotWidth: SizeConfig.blockSizeHorizontal * 2,
                            activeDotColor: ColorValues.redColor,
                            dotColor: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: Get.height / 8,
                          ),
                          Container(
                            height: Get.height / 3,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/gif/noMovie.gif",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 6,
                          ),
                          Text(
                            StringValue.movieNotAvailable.tr,
                            style: GoogleFonts.urbanist(
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.redColor : ColorValues.blackColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
            } else if (state is AllMoviesError) {
              return Container();
            }
            return Container();
          },
        ),
      ),
    );
  }

  /// Top Rated Movie Api Data ///
  Obx movieTopRated(int i) {
    log("topRatedMovie.topRatedMovieList.isNotEmpty${topRatedMovie.topRatedMovieList.length}");
    return Obx(() {
      if (topRatedMovie.isLoading.value) {
        return shimmer();
      }
      return (topRatedMovie.topRatedMovieList.isNotEmpty)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 5,
                    right: SizeConfig.blockSizeHorizontal * 2,
                    top: 20,
                    bottom: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        StringValue.topRatedMovie.tr,
                        style: titalstyle1,
                      ),
                      const Spacer(),
                      SeeAllContainer(
                        onTap: () {
                          _interstitialAd?.show();
                          if (_interstitialAd != null &&
                              topRatedMovie.topRatedMovieList[i].iMDBid == null &&
                              topRatedMovie.topRatedMovieList[i].tmdbMovieId == null) {
                            _interstitialAd?.show();
                            PreviewNetworkImage(
                                id: topRatedMovie.topRatedMovieList[i].id ?? "", image: topRatedMovie.topRatedMovieList[i].thumbnail ?? "");

                            Get.to(
                              HomeScreenData(
                                title: StringValue.topRatedMovie.tr,
                                responce: topRatedMovie.topRatedMovieList,
                              ),
                            );
                          } else {
                            Get.to(
                              HomeScreenData(
                                title: StringValue.topRatedMovie.tr,
                                responce: topRatedMovie.topRatedMovieList,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight / 4.5,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
                    scrollDirection: Axis.horizontal,
                    itemCount: topRatedMovie.topRatedMovieList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return InkWell(
                        child: Container(
                          height: SizeConfig.screenHeight,
                          clipBehavior: Clip.antiAlias,
                          width: SizeConfig.screenWidth / 2.8,
                          margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
                          decoration: BoxDecoration(
                            color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: topRatedMovie.topRatedMovieList[i].tmdbMovieId == null && topRatedMovie.topRatedMovieList[i].iMDBid == null
                              ? PreviewNetworkImage(
                                  id: topRatedMovie.topRatedMovieList[i].id ?? "", image: topRatedMovie.topRatedMovieList[i].thumbnail ?? "")
                              : Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: topRatedMovie.topRatedMovieList[i].thumbnail.toString(),
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: double.infinity,
                                      placeholder: (context, url) => Image(
                                        image: const AssetImage(AssetValues.appLogo),
                                        width: 50,
                                        height: 50,
                                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: getStorage.read('isDarkMode') == true ? ColorValues.darkModeThird : Colors.grey.shade400,
                                        child: const Center(
                                          child: Image(image: AssetImage(AssetValues.appLogo)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 70,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withValues(alpha: 0.8),
                                            Colors.black.withValues(alpha: 0.7),
                                            Colors.black.withValues(alpha: 0.6),
                                            Colors.black.withValues(alpha: 0.3),
                                            Colors.transparent,
                                          ],
                                        ),
                                        borderRadius: const BorderRadius.vertical(
                                          bottom: Radius.circular(12),
                                        ),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                topRatedMovie.topRatedMovieList[i].title ?? '',
                                                style: titalstyle5.copyWith(color: Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 6),
                                              RatingBadge(
                                                rating: topRatedMovie.topRatedMovieList[i].rating.toString(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        onTap: () {
                          _interstitialAd?.show();
                          if (_interstitialAd != null) {
                            _interstitialAd?.show();
                            Get.to(
                              () => DetailsScreen(
                                movieId: topRatedMovie.topRatedMovieList[i].id!,
                              ),
                            );
                          } else {
                            Get.to(
                              () => DetailsScreen(
                                movieId: topRatedMovie.topRatedMovieList[i].id!,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            )
          : const SizedBox();
    });
  }

  /// Top Rated WebSeries Api Data ///
  Obx webSeriesTopRated(int i) {
    return Obx(() {
      if (topRatedWebSeries.isLoading.value) {
        return shimmer();
      }
      return (topRatedWebSeries.topRatedWebSeriesList.isNotEmpty)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 5,
                    right: SizeConfig.blockSizeHorizontal * 2,
                    top: 20,
                    bottom: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        StringValue.topRatedWebSeries.tr,
                        style: titalstyle1,
                      ),
                      const Spacer(),
                      SeeAllContainer(onTap: () {
                        _interstitialAd?.show();
                        if (_interstitialAd != null &&
                            topRatedWebSeries.topRatedWebSeriesList[i].iMDBid == null &&
                            topRatedWebSeries.topRatedWebSeriesList[i].tmdbMovieId == null) {
                          _interstitialAd?.show();

                          PreviewNetworkImage(
                              id: topRatedWebSeries.topRatedWebSeriesList[i].thumbnail ?? "",
                              image: topRatedWebSeries.topRatedWebSeriesList[i].thumbnail ?? "");
                          Get.to(
                            HomeScreenData(
                              title: StringValue.topRatedWebSeries.tr,
                              responce: topRatedWebSeries.topRatedWebSeriesList,
                            ),
                          );
                        } else {
                          Get.to(
                            HomeScreenData(
                              title: StringValue.topRatedWebSeries.tr,
                              responce: topRatedWebSeries.topRatedWebSeriesList,
                            ),
                          );
                        }
                      })
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight / 4.7,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 1,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: topRatedWebSeries.topRatedWebSeriesList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return InkWell(
                        child: Container(
                          height: SizeConfig.screenHeight,
                          clipBehavior: Clip.antiAlias,
                          width: SizeConfig.screenWidth / 2.8,
                          margin: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 3,
                          ),
                          decoration: BoxDecoration(
                            color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: topRatedWebSeries.topRatedWebSeriesList[i].iMDBid == null &&
                                  topRatedWebSeries.topRatedWebSeriesList[i].tmdbMovieId == null
                              ? PreviewNetworkImage(
                                  id: topRatedWebSeries.topRatedWebSeriesList[i].id ?? "",
                                  image: topRatedWebSeries.topRatedWebSeriesList[i].thumbnail ?? "")
                              : Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: topRatedWebSeries.topRatedWebSeriesList[i].thumbnail.toString(),
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: double.infinity,
                                      placeholder: (context, url) => Image(
                                        image: const AssetImage(AssetValues.appLogo),
                                        width: 50,
                                        height: 50,
                                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: getStorage.read('isDarkMode') == true ? ColorValues.darkModeThird : Colors.grey.shade400,
                                        child: const Center(
                                          child: Image(image: AssetImage(AssetValues.appLogo)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 70,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withValues(alpha: 0.8),
                                            Colors.black.withValues(alpha: 0.7),
                                            Colors.black.withValues(alpha: 0.6),
                                            Colors.black.withValues(alpha: 0.3),
                                            Colors.transparent,
                                          ],
                                        ),
                                        borderRadius: const BorderRadius.vertical(
                                          bottom: Radius.circular(26),
                                        ),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                topRatedWebSeries.topRatedWebSeriesList[i].title ?? '',
                                                style: titalstyle5.copyWith(color: Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 6),
                                              RatingBadge(
                                                rating: topRatedWebSeries.topRatedWebSeriesList[i].rating.toString(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        onTap: () {
                          _interstitialAd?.show();
                          if (_interstitialAd != null) {
                            _interstitialAd?.show();
                            Get.to(
                              () => DetailsScreen(
                                movieId: topRatedWebSeries.topRatedWebSeriesList[i].id!,
                              ),
                            );
                          } else {
                            Get.to(
                              () => DetailsScreen(
                                movieId: topRatedWebSeries.topRatedWebSeriesList[i].id!,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            )
          : const SizedBox();
    });
  }

  void animateToSlide(int index) => scrollController.animateToPage(index);

  /// NewReleases Movie Api Data ///
  BlocProvider<NewReleaseMovieBloc> newReleases(BuildContext context, int i) {
    return BlocProvider(
      create: (_) => NewReleaseMovieBloc(RepositoryProvider.of<NewReleasemovieRepository>(context))..add(GetNewReleasemovie()),
      child: BlocListener<NewReleaseMovieBloc, NewReleaseMovieState>(
        listener: (BuildContext context, state) {},
        child: BlocBuilder<NewReleaseMovieBloc, NewReleaseMovieState>(
          builder: (context, state) {
            if (state is NewReleaseMovieLoading) {
              return shimmer();
            } else if (state is NewReleaseMovieLoaded) {
              return (state.movieModal.movie!.isNotEmpty)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 5,
                            right: SizeConfig.blockSizeHorizontal * 2,
                            top: 20,
                            bottom: 20,
                          ),
                          child: Row(
                            children: [
                              Text(
                                StringValue.newReleases.tr,
                                style: titalstyle1,
                              ),
                              const Spacer(),
                              SeeAllContainer(onTap: () {
                                _interstitialAd?.show();
                                if (_interstitialAd != null &&
                                    state.movieModal.movie![i].iMDBid == null &&
                                    state.movieModal.movie![i].tmdbMovieId == null) {
                                  _interstitialAd?.show();
                                  PreviewNetworkImage(id: state.movieModal.movie![i].id ?? "", image: state.movieModal.movie![i].thumbnail ?? "");
                                  Get.to(
                                    HomeScreenData(
                                      title: StringValue.newReleases.tr,
                                      responce: state.movieModal.movie!,
                                    ),
                                  );
                                } else {
                                  Get.to(
                                    HomeScreenData(
                                      title: StringValue.newReleases.tr,
                                      responce: state.movieModal.movie!,
                                    ),
                                  );
                                }
                              })
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight / 4.7,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.movieModal.movie!.length,
                            itemBuilder: (BuildContext context, int i) {
                              return InkWell(
                                onTap: () {
                                  if (state.movieModal.movie![i].tmdbMovieId == null && state.movieModal.movie![i].iMDBid == null) {
                                    PreviewNetworkImage(id: state.movieModal.movie![i].id ?? "", image: state.movieModal.movie![i].image ?? "");
                                    Get.to(
                                      () => DetailsScreen(
                                        movieId: state.movieModal.movie![i].id!,
                                      ),
                                    );
                                  } else {
                                    Get.to(
                                      () => DetailsScreen(
                                        movieId: state.movieModal.movie![i].id!,
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  height: SizeConfig.screenHeight,
                                  clipBehavior: Clip.antiAlias,
                                  width: SizeConfig.screenWidth / 2.8,
                                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
                                  decoration: BoxDecoration(
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  child: state.movieModal.movie![i].tmdbMovieId == null && state.movieModal.movie![i].iMDBid == null
                                      ? PreviewNetworkImage(
                                          id: state.movieModal.movie![i].id ?? "", image: state.movieModal.movie![i].thumbnail ?? "")
                                      : Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: state.movieModal.movie![i].thumbnail.toString(),
                                              fit: BoxFit.cover,
                                              height: 200,
                                              width: double.infinity,
                                              placeholder: (context, url) => Image(
                                                image: const AssetImage(AssetValues.appLogo),
                                                width: 50,
                                                height: 50,
                                                color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                color: getStorage.read('isDarkMode') == true ? ColorValues.darkModeThird : Colors.grey.shade400,
                                                child: const Center(
                                                  child: Image(image: AssetImage(AssetValues.appLogo)),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.black.withValues(alpha: 0.8),
                                                    Colors.black.withValues(alpha: 0.7),
                                                    Colors.black.withValues(alpha: 0.6),
                                                    Colors.black.withValues(alpha: 0.3),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                                borderRadius: const BorderRadius.vertical(
                                                  bottom: Radius.circular(26),
                                                ),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        state.movieModal.movie![i].title ?? '',
                                                        style: titalstyle5.copyWith(color: Colors.white),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const SizedBox(height: 6),
                                                      RatingBadge(
                                                        rating: state.movieModal.movie![i].rating == 0
                                                            ? "N/A"
                                                            : state.movieModal.movie![i].rating.toString(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox();
            } else if (state is NewReleaseMovieError) {
              return Container();
            }
            return Container();
          },
        ),
      ),
    );
  }

  /// Top 10 Movie Api Data ///
  BlocProvider<Top10moviesBloc> top10Movie(BuildContext context, int i) {
    return BlocProvider(
      create: (_) => Top10moviesBloc(RepositoryProvider.of<Top10MoviesRepository>(context))..add(GetTop10Movies()),
      child: BlocListener<Top10moviesBloc, Top10moviesState>(
        listener: (BuildContext context, state) {},
        child: BlocBuilder<Top10moviesBloc, Top10moviesState>(
          builder: (context, state) {
            if (state is Top10moviesLoading) {
              return shimmer();
            } else if (state is Top10moviesLoaded) {
              return (state.movieModal.movie!.isNotEmpty)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 5,
                            right: SizeConfig.blockSizeHorizontal * 2,
                            top: 20,
                            bottom: 20,
                          ),
                          child: Row(
                            children: [
                              Text(
                                StringValue.top10.tr,
                                style: titalstyle1,
                              ),
                              const Spacer(),
                              SeeAllContainer(onTap: () {
                                _interstitialAd?.show();
                                if (_interstitialAd != null &&
                                    state.movieModal.movie![i].iMDBid == null &&
                                    state.movieModal.movie![i].tmdbMovieId == null) {
                                  _interstitialAd?.show();
                                  PreviewNetworkImage(id: state.movieModal.movie![i].id ?? "", image: state.movieModal.movie![i].thumbnail ?? "");
                                  Get.to(
                                    HomeScreenData(
                                      title: StringValue.top10.tr,
                                      responce: state.movieModal.movie!,
                                    ),
                                  );
                                } else {
                                  Get.to(
                                    HomeScreenData(
                                      title: StringValue.top10.tr,
                                      responce: state.movieModal.movie!,
                                    ),
                                  );
                                }
                              })
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight / 4.7,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.movieModal.movie!.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Stack(
                                children: [
                                  InkWell(
                                    child: Container(
                                      height: SizeConfig.screenHeight,
                                      clipBehavior: Clip.antiAlias,
                                      width: SizeConfig.screenWidth / 2.8,
                                      margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
                                      decoration: BoxDecoration(
                                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                      child: state.movieModal.movie![i].tmdbMovieId == null && state.movieModal.movie![i].iMDBid == null
                                          ? PreviewNetworkImage(
                                              id: state.movieModal.movie![i].id ?? "", image: state.movieModal.movie![i].thumbnail ?? "")
                                          : Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: state.movieModal.movie![i].thumbnail.toString(),
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  placeholder: (context, url) => Image(
                                                    image: const AssetImage(AssetValues.appLogo),
                                                    width: 50,
                                                    height: 50,
                                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                                  ),
                                                  errorWidget: (context, url, error) => Container(
                                                    color: getStorage.read('isDarkMode') == true ? ColorValues.darkModeThird : Colors.grey.shade400,
                                                    child: const Center(
                                                      child: Image(image: AssetImage(AssetValues.appLogo)),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.bottomCenter,
                                                      end: Alignment.topCenter,
                                                      colors: [
                                                        Colors.black.withValues(alpha: 0.8),
                                                        Colors.black.withValues(alpha: 0.7),
                                                        Colors.black.withValues(alpha: 0.6),
                                                        Colors.black.withValues(alpha: 0.3),
                                                        Colors.transparent,
                                                      ],
                                                    ),
                                                    borderRadius: const BorderRadius.vertical(
                                                      bottom: Radius.circular(26),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            state.movieModal.movie![i].title ?? '',
                                                            style: titalstyle5.copyWith(color: Colors.white),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(height: 6),
                                                          RatingBadge(
                                                            rating: state.movieModal.movie![i].rating.toString(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                    onTap: () {
                                      _interstitialAd?.show();
                                      if (_interstitialAd != null) {
                                        _interstitialAd?.show();
                                        Get.to(
                                          () => DetailsScreen(
                                            movieId: state.movieModal.movie![i].id!,
                                          ),
                                        );
                                      } else {
                                        Get.to(
                                          () => DetailsScreen(
                                            movieId: state.movieModal.movie![i].id!,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox();
            } else if (state is Top10moviesError) {
              return Container();
            }
            return Container();
          },
        ),
      ),
    );
  }

  /// Top 10 Web Series Api Data ///
  BlocProvider<Top10webSeriesBloc> top10WebSeries(BuildContext context, int i) {
    return BlocProvider(
      create: (_) => Top10webSeriesBloc(RepositoryProvider.of<Top10WebSeriesRepository>(context))..add(GetTop10WebSeries()),
      child: BlocListener<Top10webSeriesBloc, Top10webSeriesState>(
        listener: (BuildContext context, state) {},
        child: BlocBuilder<Top10webSeriesBloc, Top10webSeriesState>(
          builder: (context, state) {
            if (state is Top10webSeriesLoading) {
              return shimmer();
            } else if (state is Top10webSeriesLoaded) {
              return (state.movieModal.movie!.isNotEmpty)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 5,
                            right: SizeConfig.blockSizeHorizontal * 2,
                            top: 20,
                            bottom: 20,
                          ),
                          child: Row(
                            children: [
                              Text(
                                StringValue.top10WebSeries.tr,
                                style: titalstyle1,
                              ),
                              const Spacer(),
                              SeeAllContainer(
                                onTap: () {
                                  _interstitialAd?.show();
                                  if (_interstitialAd != null &&
                                      state.movieModal.movie![i].iMDBid == null &&
                                      state.movieModal.movie![i].tmdbMovieId == null) {
                                    _interstitialAd?.show();
                                    // generatePresignedURL(state.movieModal.movie![i].thumbnail.toString());
                                    PreviewNetworkImage(id: state.movieModal.movie![i].id ?? "", image: state.movieModal.movie![i].thumbnail ?? "");
                                    Get.to(
                                      HomeScreenData(
                                        title: StringValue.top10WebSeries.tr,
                                        responce: state.movieModal.movie!,
                                      ),
                                    );
                                  } else {
                                    Get.to(
                                      HomeScreenData(
                                        title: StringValue.top10WebSeries.tr,
                                        responce: state.movieModal.movie!,
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight / 4.7,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.movieModal.movie!.length,
                            itemBuilder: (BuildContext context, int i) {
                              return InkWell(
                                child: Container(
                                  height: SizeConfig.screenHeight,
                                  clipBehavior: Clip.antiAlias,
                                  width: SizeConfig.screenWidth / 2.8,
                                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
                                  decoration: BoxDecoration(
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  child: state.movieModal.movie![i].tmdbMovieId == null && state.movieModal.movie![i].iMDBid == null
                                      ? PreviewNetworkImage(
                                          id: state.movieModal.movie![i].id ?? "", image: state.movieModal.movie![i].thumbnail ?? "")
                                      : Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: state.movieModal.movie![i].thumbnail.toString(),
                                              fit: BoxFit.cover,
                                              height: 200,
                                              width: double.infinity,
                                              placeholder: (context, url) => Image(
                                                image: const AssetImage(AssetValues.appLogo),
                                                width: 50,
                                                height: 50,
                                                color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                color: getStorage.read('isDarkMode') == true ? ColorValues.darkModeThird : Colors.grey.shade400,
                                                child: const Center(
                                                  child: Image(image: AssetImage(AssetValues.appLogo)),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.black.withValues(alpha: 0.8),
                                                    Colors.black.withValues(alpha: 0.7),
                                                    Colors.black.withValues(alpha: 0.6),
                                                    Colors.black.withValues(alpha: 0.3),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                                borderRadius: const BorderRadius.vertical(
                                                  bottom: Radius.circular(26),
                                                ),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        state.movieModal.movie![i].title ?? '',
                                                        style: titalstyle5.copyWith(color: Colors.white),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const SizedBox(height: 6),
                                                      RatingBadge(
                                                        rating: state.movieModal.movie![i].rating.toString(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                onTap: () {
                                  Get.to(
                                    () => DetailsScreen(
                                      movieId: state.movieModal.movie![i].id!,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox();
            } else if (state is Top10moviesError) {
              return Container();
            }
            return Container();
          },
        ),
      ),
    );
  }

  /// Comedy Movie Api Data ///
  BlocProvider<ComedyMovieBloc> comedyMovie(BuildContext context, int i) {
    return BlocProvider(
      create: (_) => ComedyMovieBloc(RepositoryProvider.of<ComedyMovieRepository>(context))..add(GetComedyMovies()),
      child: BlocListener<ComedyMovieBloc, ComedymovieState>(
        listener: (BuildContext context, state) {},
        child: BlocBuilder<ComedyMovieBloc, ComedymovieState>(
          builder: (context, state) {
            if (state is ComedymovieLoading) {
              return shimmer();
            } else if (state is ComedymovieLoaded) {
              return (state.movieModal.movie!.isNotEmpty)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 5,
                            right: SizeConfig.blockSizeHorizontal * 2,
                            top: 20,
                            bottom: 20,
                          ),
                          child: Row(
                            children: [
                              Text(
                                StringValue.comedyVideo.tr,
                                style: titalstyle1,
                              ),
                              const Spacer(),
                              SeeAllContainer(
                                onTap: () {
                                  _interstitialAd?.show();
                                  if (_interstitialAd != null &&
                                      state.movieModal.movie![i].iMDBid == null &&
                                      state.movieModal.movie![i].tmdbMovieId == null) {
                                    _interstitialAd?.show();
                                    PreviewNetworkImage(id: state.movieModal.movie![i].id ?? "", image: state.movieModal.movie![i].thumbnail ?? "");
                                    Get.to(
                                      HomeScreenData(
                                        title: StringValue.comedyVideo.tr,
                                        responce: state.movieModal.movie!,
                                      ),
                                    );
                                  } else {
                                    Get.to(
                                      HomeScreenData(
                                        title: StringValue.comedyVideo.tr,
                                        responce: state.movieModal.movie!,
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight / 4.7,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 1,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.movieModal.movie!.length,
                            itemBuilder: (BuildContext context, int i) {
                              return InkWell(
                                child: Container(
                                  height: SizeConfig.screenHeight,
                                  clipBehavior: Clip.antiAlias,
                                  width: SizeConfig.screenWidth / 2.8,
                                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
                                  decoration: BoxDecoration(
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  child: state.movieModal.movie![i].tmdbMovieId == null && state.movieModal.movie![i].iMDBid == null
                                      ? PreviewNetworkImage(
                                          id: state.movieModal.movie![i].id ?? "", image: state.movieModal.movie![i].thumbnail ?? "")
                                      : Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: state.movieModal.movie![i].thumbnail.toString(),
                                              fit: BoxFit.cover,
                                              height: 200,
                                              width: double.infinity,
                                              placeholder: (context, url) => Image(
                                                image: const AssetImage(AssetValues.appLogo),
                                                width: 50,
                                                height: 50,
                                                color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                color: getStorage.read('isDarkMode') == true ? ColorValues.darkModeThird : Colors.grey.shade400,
                                                child: const Center(
                                                  child: Image(image: AssetImage(AssetValues.appLogo)),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.black.withValues(alpha: 0.8),
                                                    Colors.black.withValues(alpha: 0.7),
                                                    Colors.black.withValues(alpha: 0.6),
                                                    Colors.black.withValues(alpha: 0.3),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                                borderRadius: const BorderRadius.vertical(
                                                  bottom: Radius.circular(24),
                                                ),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        state.movieModal.movie![i].title ?? '',
                                                        style: titalstyle5.copyWith(color: Colors.white),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const SizedBox(height: 6),
                                                      RatingBadge(
                                                        rating: state.movieModal.movie![i].rating.toString(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                onTap: () {
                                  Get.to(
                                    () => DetailsScreen(
                                      movieId: state.movieModal.movie![i].id!,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox();
              // : Center(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //         SizedBox(
              //           height: Get.height / 8,
              //         ),
              //         Container(
              //           height: Get.height / 3,
              //           decoration: const BoxDecoration(
              //             image: DecorationImage(
              //               image: AssetImage(
              //                 "assets/gif/noMovie.gif",
              //               ),
              //               fit: BoxFit.cover,
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: SizeConfig.blockSizeVertical * 6,
              //         ),
              //         Text(
              //           "Comedy Movie Not Available",
              //           style: GoogleFonts.urbanist(
              //             color: (getStorage.read('isDarkMode') == true)
              //                 ? ColorValues.redColor
              //                 : ColorValues.blackColor,
              //             fontSize: 20,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ],
              //     ),
              //   );
            } else if (state is ComedymovieError) {
              return Container();
            }
            return Container();
          },
        ),
      ),
    );
  }

  Shimmer shimmer() {
    return Shimmer.fromColors(
      highlightColor: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
      baseColor: (getStorage.read('isDarkMode') == true) ? Colors.white24 : Colors.grey.shade300,
      child: SizedBox(
        height: SizeConfig.screenHeight / 3,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (BuildContext context, int i) {
            return Column(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  height: 30,
                  width: 130,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  clipBehavior: Clip.antiAlias,
                  height: 170,
                  width: 130,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
                  decoration: BoxDecoration(
                    color: ColorValues.grayColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> subscribeToPremium() {
    return Get.bottomSheet(
      SizedBox(
        height: Get.height / 3,
        child: Column(
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
              style: GoogleFonts.urbanist(color: ColorValues.redColor, fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2.5,
            ),
            SizedBox(
              width: SizeConfig.screenWidth / 1.1,
              child: Text(
                StringValue.subscribePremiumEnjoyTheBenefits.tr,
                style: GoogleFonts.urbanist(
                    fontSize: 15, color: getStorage.read("isDarkMode") == true ? ColorValues.whiteColor : ColorValues.blackColor),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2.5,
            ),
            InkWell(
              onTap: () {
                Get.back();
                Get.to(
                  () => const SubscribeToPremium(),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: SizeConfig.screenHeight / 15.5,
                width: SizeConfig.screenWidth / 1.1,
                decoration: BoxDecoration(
                  color: ColorValues.redColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  StringValue.subscribeToPremiums.tr,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorValues.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : ColorValues.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
