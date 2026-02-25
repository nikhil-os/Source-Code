// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/all_movie_module/Allmovi_resources/Allmovies_repository.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/all_movie_module/bloc/allmovies_bloc.dart';
import 'package:webtime_movie_ocean/controller/api_controller/search_movie_controller.dart';
import 'package:webtime_movie_ocean/custom/custom_rating_view.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/home_screen/more_screen/Details/details_screen.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_class.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/utils.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:shimmer/shimmer.dart';

class SelectedFilterMovieScreen extends StatefulWidget {
  final List data;

  const SelectedFilterMovieScreen({super.key, required this.data});

  @override
  State<SelectedFilterMovieScreen> createState() => _SelectedFilterMovieScreenState();
}

class _SelectedFilterMovieScreenState extends State<SelectedFilterMovieScreen> {
  TextEditingController searchController = TextEditingController();
  SearchMovieController searchMovieData = Get.put(SearchMovieController());
  FocusNode searchTextFiledFocus = FocusNode();
  Color color = ColorValues.boxColor;

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

  searchUsers(String value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.scaffoldBg : ColorValues.whiteColor,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 4, bottom: 14),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : Colors.grey.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 26,
                        color: ColorValues.grayColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: Get.height / 16,
                  width: Get.width / 1.35,
                  padding: const EdgeInsets.only(left: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: searchTextFiledFocus.hasFocus
                        ? ColorValues.buttonColorRed.withValues(alpha: 0.15)
                        : (getStorage.read('isDarkMode') == true)
                            ? ColorValues.containerBg
                            : ColorValues.darkModeThird.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: searchTextFiledFocus.hasFocus ? ColorValues.redColor : Colors.transparent,
                    ),
                  ),
                  child: TextFormField(
                    enabled: true,
                    // onEditingComplete: () {
                    //   setState(() async {
                    //     AppUtils.showLog(searchController.text);
                    //
                    //     searchMovieData.fetchSearchMovie(searchController.text);
                    //   });
                    // },
                    onEditingComplete: () {
                      final query = searchController.text.trim();
                      AppUtils.showLog(query);
                      searchMovieData.fetchSearchMovie(query); // start async work
                      setState(() {}); // sync rebuild if you really need one
                    },
                    // onEditingComplete: () {
                    //                   final query = searchController.text.trim();
                    //                   AppUtils.showLog(query);
                    //                   searchMovieData.fetchSearchMovie(query); // don't await here
                    //                   // If you want to close the keyboard:
                    //                   FocusScope.of(context).unfocus();
                    //                 },
                    onTap: () {
                      setState(() {
                        listVisible = true;
                      });
                    },
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
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
                        size: 15,
                        color: ColorValues.grayColor,
                      ),
                      hintText: StringValue.search.tr,
                      hintStyle: GoogleFonts.urbanist(
                        textStyle: const TextStyle(
                          color: ColorValues.grayColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /*/// Selected Filter Data ///
          (widget.data.isNotEmpty)
              ? Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 4,
                      right: SizeConfig.blockSizeHorizontal * 4,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 13,
                      crossAxisSpacing: 13,
                    ),
                    itemCount: widget.data.length,
                    itemBuilder: (context, i) {
                      return InkWell(
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
                                  fit: BoxFit.cover,
                                  imageUrl: widget.data[i]["thumbnail"],
                                  width: double.infinity,
                                  height: double.infinity,
                                  placeholder: (context, url) => Image(
                                    height: SizeConfig.screenHeight / 2.2,
                                    width: SizeConfig.screenWidth,
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.DarkMode_Third : Colors.grey.shade400,
                                    image: const AssetImage(
                                      AssetValues.appLogo,
                                    ),
                                  ),
                                  errorWidget: (context, string, dynamic) => Image(
                                    height: SizeConfig.screenHeight / 2.2,
                                    width: SizeConfig.screenWidth,
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.DarkMode_Third : Colors.grey.shade400,
                                    image: const AssetImage(
                                      AssetValues.appLogo,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 120,
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                    colors: [Colors.transparent, ColorValues.DarkMode_Main],
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
                                        "${widget.data[i]["title"]}",
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.visible,
                                      ),
                                      const SizedBox(height: 6),
                                      RatingBadge(
                                        rating: "${widget.data[i]["rating"]}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          log("${widget.data[i][""]}");
                          Get.to(
                            () => DetailsScreen(
                              movieId: widget.data[i]["_id"],
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: Get.height / 16),
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
                ),*/

          /// search data

          searchController.text.isNotEmpty == true
              ? Obx(() {
                  if (searchMovieData.isLoading.value) {
                  } else if (searchMovieData.searchMovieList.isNotEmpty) {
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
                                        child: searchMovieData.searchMovieList[i].iMDBid == null &&
                                                searchMovieData.searchMovieList[i].tmdbMovieId == null
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
                                                errorWidget: (context, string, dynamic) => Image(
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
                                                        color: (getStorage.read('isDarkMode') == true)
                                                            ? ColorValues.darkModeThird
                                                            : Colors.grey.shade400,
                                                      ),
                                                      errorWidget: (context, url, error) => Image(
                                                        image: const AssetImage(AssetValues.appLogo),
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        color: (getStorage.read('isDarkMode') == true)
                                                            ? ColorValues.darkModeThird
                                                            : Colors.grey.shade400,
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
                                            (getStorage.read('isDarkMode') == true)
                                                ? "assets/images/noimage.png"
                                                : "assets/images/noimageavailable.png",
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
                })
              : (widget.data.isNotEmpty)
                  ? Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 4,
                          right: SizeConfig.blockSizeHorizontal * 4,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 13,
                          crossAxisSpacing: 13,
                        ),
                        itemCount: widget.data.length,
                        itemBuilder: (context, i) {
                          return InkWell(
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
                                      fit: BoxFit.cover,
                                      imageUrl: widget.data[i]["thumbnail"],
                                      width: double.infinity,
                                      height: double.infinity,
                                      placeholder: (context, url) => Image(
                                        height: SizeConfig.screenHeight / 2.2,
                                        width: SizeConfig.screenWidth,
                                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                        image: const AssetImage(
                                          AssetValues.appLogo,
                                        ),
                                      ),
                                      errorWidget: (context, string, dynamic) => Image(
                                        height: SizeConfig.screenHeight / 2.2,
                                        width: SizeConfig.screenWidth,
                                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                        image: const AssetImage(
                                          AssetValues.appLogo,
                                        ),
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
                                            "${widget.data[i]["title"]}",
                                            style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(height: 6),
                                          RatingBadge(
                                            rating: "${widget.data[i]["rating"]}",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              log("${widget.data[i][""]}");
                              Get.to(
                                () => DetailsScreen(
                                  movieId: widget.data[i]["_id"],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: Get.height / 16),
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
                    ),
        ],
      ),
    );
  }
}
