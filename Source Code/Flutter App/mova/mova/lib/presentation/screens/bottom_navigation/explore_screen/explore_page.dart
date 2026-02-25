import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/filterWise_api/filter_wise_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/all_movie_module/Allmovi_resources/Allmovies_repository.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/all_movie_module/bloc/allmovies_bloc.dart';
import 'package:webtime_movie_ocean/controller/api_controller/genre_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/region_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/search_movie_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/yearController.dart';
import 'package:webtime_movie_ocean/custom/custom_rating_view.dart';
import 'package:webtime_movie_ocean/custom/custom_status_bar_color.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/explore_screen/selected_filterd_movie.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/home_screen/more_screen/Details/details_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/tabs_screen.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_class.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/utils.dart';
import 'package:webtime_movie_ocean/presentation/widget/interest_button.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTab();
}

class _ExploreTab extends State<ExploreTab> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchTextFiledFocus = FocusNode();
  Color color = ColorValues.boxColor;
  FocusNode focusNode = FocusNode();
  bool isFilterTapped = false;

  @override
  void initState() {
    super.initState();
    searchTextFiledFocus.addListener(() {
      if (searchTextFiledFocus.hasFocus) {
        setState(() {
          color = const Color(0xFFFCE7E9);
        });
      } else {
        color = ColorValues.boxColor;
      }
    });
  }

  bool search = false;
  bool listVisible = false;

  RegionController regionController = Get.put(RegionController());
  yearController getMovieYearController = Get.put(yearController());
  GenreController genreController = Get.put(GenreController());
  SearchMovieController searchMovieData = Get.put(SearchMovieController());

  @override
  Widget build(BuildContext context) {
    CustomStatusBarColor.init();
    SizeConfig().init(context);
    final filterWise = Provider.of<FilterWiseProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        selectedIndex = 0;
        Get.offAll(const TabsScreen());
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.scaffoldBg : ColorValues.whiteColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 42, bottom: 14),
              decoration: BoxDecoration(
                color: (getStorage.read('isDarkMode') == true) ? ColorValues.appBarColor : ColorValues.darkModeThird.withValues(alpha: 0.05),
              ),
              child: Row(
                children: [
                  /// Search a Movie ///
                  Expanded(
                    child: Container(
                      height: SizeConfig.screenHeight / 16,
                      width: SizeConfig.screenWidth / 1.35,
                      margin: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 2,
                      ),
                      padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 4,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: searchTextFiledFocus.hasFocus
                            ? ColorValues.buttonColorRed.withValues(alpha: 0.15)
                            : (getStorage.read('isDarkMode') == true)
                                ? ColorValues.containerBg
                                : ColorValues.darkModeThird.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: searchTextFiledFocus.hasFocus ? ColorValues.redColor : Colors.transparent,
                        ),
                      ),
                      child: TextFormField(
                        enabled: true,
                        onEditingComplete: () {
                          setState(() {
                            AppUtils.showLog(searchController.text);
                            searchMovieData.fetchSearchMovie(searchController.text);
                          });
                          if (searchController.text.isEmpty == true) {
                            FocusScope.of(context).unfocus();
                            searchMovieData.searchMovieList.clear();
                            listVisible = true;
                          }
                          setState(() {});
                        },
                        onTap: () {
                          setState(() {
                            listVisible = true;
                          });
                        },
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                          if (searchController.text.isEmpty == true) {
                            searchMovieData.searchMovieList.clear();
                            listVisible = true;
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            AppUtils.showLog(val!);
                            searchMovieData.fetchSearchMovie(val);
                            searchController.clear();
                          });
                        },
                        controller: searchController,
                        focusNode: searchTextFiledFocus,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 2,
                            minHeight: 2,
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 2,
                            minHeight: 2,
                          ),
                          icon: const ImageIcon(
                            AssetImage(IconAssetValues.lightSearch),
                            size: 18,
                            color: ColorValues.grayColor,
                          ),
                          hintText: StringValue.search.tr,
                          hintStyle: GoogleFonts.urbanist(
                            textStyle: const TextStyle(
                              color: ColorValues.grayColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  /// Select Your Filter ///
                  GestureDetector(
                    child: Container(
                      height: SizeConfig.screenWidth / 7.5,
                      width: SizeConfig.screenWidth / 7.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: isFilterTapped
                              ? Colors.blue.withValues(alpha: 0.2)
                              : (getStorage.read('isDarkMode') == true)
                                  ? ColorValues.containerBg
                                  : ColorValues.darkModeThird.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: isFilterTapped ? Colors.blue : Colors.transparent)),
                      child: Center(
                        child: SvgPicture.asset(
                          MovixIcon.whiteFilterIcon,
                          height: SizeConfig.blockSizeVertical * 2,
                          color: isFilterTapped
                              ? Colors.blue
                              : (getStorage.read('isDarkMode') == true)
                                  ? ColorValues.whiteColor
                                  : ColorValues.blackColor,
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (focusNode.hasFocus) {
                        FocusScope.of(context).unfocus();
                      } else {
                        setState(() {
                          isFilterTapped = true;
                        });

                        await buildBottomSheet(filterWise);

                        setState(() {
                          isFilterTapped = false;
                        });
                      }
                    },
                  ),
                ],
              ).paddingOnly(left: 10, right: 10),
            ),
            Obx(() {
              if (searchMovieData.isLoading.value) {
              } else if (searchMovieData.searchMovieList.isNotEmpty || searchController.text.isNotEmpty) {
                if (searchMovieData.searchMovieList.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: searchMovieData.searchMovieList.length,
                      padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            Get.to(() => DetailsScreen(movieId: searchMovieData.searchMovieList[i].id!));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                                decoration: BoxDecoration(
                                    color: (getStorage.read('isDarkMode') == true)
                                        ? ColorValues.smallContainerBg
                                        : ColorValues.darkModeThird.withValues(alpha: 0.05),
                                    border: Border.all(color: ColorValues.borderColor, width: 0.6),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: SizeConfig.screenHeight / 9,
                                      width: SizeConfig.screenWidth / 3,
                                      child:
                                          searchMovieData.searchMovieList[i].iMDBid == null && searchMovieData.searchMovieList[i].tmdbMovieId == null
                                              ? PreviewNetworkImage(
                                                  id: searchMovieData.searchMovieList[i].id ?? "",
                                                  image: searchMovieData.searchMovieList[i].image ?? "")
                                              : CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: searchMovieData.searchMovieList[i].image.toString(),
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${searchMovieData.searchMovieList[i].title}",
                                            style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            searchMovieData.searchMovieList[i].description.toString(),
                                            style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w400, color: ColorValues.grayText),
                                            maxLines: 2,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ],
                                      ).paddingSymmetric(horizontal: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: Get.height / 17),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 280,
                            width: 280,
                            child: Image.asset(
                              (getStorage.read('isDarkMode') == true) ? "assets/images/noimage.png" : "assets/images/noimageavailable.png",
                            ),
                          ),
                          Text(
                            StringValue.theKeywordYouEnteredCouldNotBe.tr,
                            style: GoogleFonts.urbanist(
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            StringValue.tryToCheckAgainOrSearchWithOther.tr,
                            style: GoogleFonts.urbanist(
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            StringValue.keyWords.tr,
                            style: GoogleFonts.urbanist(
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
              return BlocProvider(
                create: (_) => AllMoviesBloc(RepositoryProvider.of<AllMoviesRepository>(context))..add(GetAllMovie()),
                child: BlocListener<AllMoviesBloc, AllMoviesState>(
                  listener: (BuildContext context, state) {},
                  child: BlocBuilder<AllMoviesBloc, AllMoviesState>(builder: (context, state) {
                    if (state is AllMoviesLoading) {
                    } else if (state is AllMoviesLoaded) {
                      return (state.movieModal.movie?.isNotEmpty ?? true)
                          ? Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: SizeConfig.blockSizeHorizontal * 1,
                                ),
                                child: SingleChildScrollView(
                                  child: GridView.builder(
                                    padding: const EdgeInsets.only(top: 15),
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: state.movieModal.movie!.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 13, mainAxisSpacing: 13),
                                    itemBuilder: (context, i) {
                                      return InkWell(
                                        onTap: () {
                                          Get.to(() => DetailsScreen(movieId: state.movieModal.movie![i].id!));
                                        },
                                        child: Container(
                                          width: SizeConfig.screenWidth / 2.5,
                                          height: SizeConfig.screenHeight / 4.5,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(26),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(26),
                                            child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: state.movieModal.movie![i].thumbnail.toString(),
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  placeholder: (context, url) => Image(
                                                    image: const AssetImage(AssetValues.appLogo),
                                                    width: 50,
                                                    height: 50,
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
                                                Container(
                                                  height: 120,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                    colors: [Colors.transparent, ColorValues.darkModeMain],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                  )),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "${state.movieModal.movie![i].title}",
                                                        style: GoogleFonts.outfit(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.visible,
                                                      ),
                                                      const SizedBox(height: 6),
                                                      RatingBadge(
                                                        rating: state.movieModal.movie![i].rating.toString(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ).paddingSymmetric(horizontal: 13),
                                ),
                              ),
                            )
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: Get.height / 14),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 280,
                                      width: 280,
                                      child: Image.asset(
                                        (getStorage.read('isDarkMode') == true) ? "assets/images/noimage.png" : "assets/images/noimageavailable.png",
                                      ),
                                    ),
                                    Text(
                                      StringValue.theKeywordYouEnteredCouldNotBe.tr,
                                      style: GoogleFonts.urbanist(
                                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      StringValue.tryToCheckAgainOrSearchWithOther.tr,
                                      style: GoogleFonts.urbanist(
                                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      StringValue.keyWords.tr,
                                      style: GoogleFonts.urbanist(
                                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                    } else if (state is AllMoviesError) {
                      return Center(
                        child: Text(StringValue.error.tr),
                      );
                    }
                    return Expanded(
                      child: Shimmer.fromColors(
                        highlightColor: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
                        baseColor: (getStorage.read('isDarkMode') == true) ? Colors.white24 : Colors.grey.shade300,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 6,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 13,
                            mainAxisSpacing: 13,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 5,
                            vertical: SizeConfig.blockSizeVertical * 2,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: ColorValues.grayColor,
                                borderRadius: BorderRadius.circular(26),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(26),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      color: ColorValues.grayColor,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
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
                                    Container(
                                      height: 80,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            ColorValues.darkModeMain,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 12,
                                            color: ColorValues.grayColor,
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            width: 60,
                                            height: 10,
                                            color: ColorValues.grayColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  /// Get all Filter ///
  Future<dynamic> buildBottomSheet(FilterWiseProvider filterWise) {
    return Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height: SizeConfig.screenHeight / 1.4,
        decoration: BoxDecoration(
          color: (getStorage.read('isDarkMode') == true) ? ColorValues.appBarColor : ColorValues.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          border: Border(
            top: BorderSide(
              width: 1,
              color: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.darkModeThird.withValues(alpha: 0.10),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                      color: (getStorage.read('isDarkMode') == true)
                          ? ColorValues.darkModeThird.withValues(alpha: 0.50)
                          : ColorValues.darkModeThird.withValues(alpha: 0.10),
                      borderRadius: const BorderRadius.all(Radius.circular(7))),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 1.5,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  StringValue.sortFilter.tr,
                  style: GoogleFonts.outfit(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              Divider(
                endIndent: SizeConfig.blockSizeHorizontal * 2,
                indent: SizeConfig.blockSizeHorizontal * 2,
                color: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.boxColor,
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
                        child: Text(
                          StringValue.categories.tr,
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                      SizedBox(
                        height: 46,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: type.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, i) {
                            return Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                Filter_Buttons2(
                                  text: type[i],
                                  id: '',
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 2.5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
                        child: Text(
                          StringValue.regions.tr,
                          style: GoogleFonts.urbanist(fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 1.5,
                      ),
                      Obx(() {
                        if (regionController.isLoading.value) {
                          return shimmer();
                        } else {
                          return SizedBox(
                            height: 46,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: regionController.regionList.length,
                              itemBuilder: (context, i) {
                                return Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: [
                                    Filter_Buttons3(
                                      text: regionController.regionList[i].name.toString(),
                                      id: regionController.regionList[i].id!,
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      }),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 2.5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
                        child: Text(
                          StringValue.genre.tr,
                          style: GoogleFonts.urbanist(fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 1.5,
                      ),
                      Obx(() {
                        if (genreController.isLoading.value) {
                          return shimmer();
                        } else {
                          return SizedBox(
                            height: 46,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: genreController.genreList.length,
                              itemBuilder: (context, i) {
                                return Wrap(
                                  children: [
                                    Filter_Buttons4(text: genreController.genreList[i].name.toString(), id: genreController.genreList[i].id!),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      }),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 2.5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
                        child: Text(
                          StringValue.timePeriods.tr,
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 1.5,
                      ),
                      Obx(() {
                        if (getMovieYearController.isLoading.value) {
                          return shimmer();
                        } else {
                          return SizedBox(
                            height: 46,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: getMovieYearController.yearList.length,
                              itemBuilder: (context, i) {
                                return Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  alignment: WrapAlignment.start,
                                  children: [
                                    Filter_Buttons5(
                                      text: getMovieYearController.yearList[i].year.toString(),
                                      id: getMovieYearController.yearList[i].id!,
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      }),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 2.5,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                endIndent: SizeConfig.blockSizeHorizontal * 2,
                indent: SizeConfig.blockSizeHorizontal * 2,
                color: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.boxColor,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: SizeConfig.screenHeight / 16,
                        width: SizeConfig.screenWidth / 2.4,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: (getStorage.read('isDarkMode') == true) ? ColorValues.detailContainer : ColorValues.whiteColor,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: (getStorage.read('isDarkMode') == true)
                                  ? ColorValues.detailBorder
                                  : ColorValues.grayColorText.withValues(alpha: 0.20),
                            )),
                        child: Text(
                          StringValue.reset.tr,
                          style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.redColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      child: Container(
                        height: SizeConfig.screenHeight / 16,
                        width: SizeConfig.screenWidth / 2.4,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorValues.buttonColorRed,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          StringValue.apply.tr,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorValues.whiteColor,
                          ),
                        ),
                      ),
                      onTap: () async {
                        await filterWise.filterWise(Genres, Regions, year, selectedType);
                        Get.back();

                        await Get.to(
                          () => SelectedFilterMovieScreen(
                            data: filterWise.data["movie"],
                          ),
                        );

                        searchController.clear();
                        searchMovieData.searchMovieList.clear();

                        selectedType.clear();
                        Regions.clear();
                        Genres.clear();
                        year.clear();

                        setState(() {});
                      },
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 16),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shimmer ///
  Shimmer shimmer() {
    return Shimmer.fromColors(
      highlightColor: (getStorage.read('isDarkMode') == true) ? ColorValues.redShimmer : ColorValues.grayShimmer,
      baseColor: ColorValues.grayColor,
      child: SizedBox(
        height: SizeConfig.screenHeight / 19,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 2),
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, i) {
            return Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Filter_Buttons2(
                  text: StringValue.helloFlutter.tr,
                  id: "",
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
