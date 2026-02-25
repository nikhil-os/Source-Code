import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/createFavoriteMovie_api/create_favourite_movie_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/getFavoritemovie_module/bloc/getfavoritemovie_bloc.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/getFavoritemovie_module/getfavoritemovie_resources/getfavoritemovie_repository.dart';
import 'package:webtime_movie_ocean/custom/custom_rating_view.dart';
import 'package:webtime_movie_ocean/custom/custom_status_bar_color.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/home_screen/more_screen/Details/details_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/tabs_screen.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/app_class.dart';
import '../../../utils/database.dart';

class MainListTab extends StatefulWidget {
  const MainListTab({super.key});

  @override
  State<MainListTab> createState() => _MainListTabState();
}

class _MainListTabState extends State<MainListTab> {
  @override
  Widget build(BuildContext context) {
    CustomStatusBarColor.init();

    SizeConfig().init(context);
    final createFavoriteMovie = Provider.of<CreateFavoriteMovieProvider>(context, listen: false);
    return WillPopScope(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).copyWith(top: 42, bottom: 15),
              color: (getStorage.read('isDarkMode') == true)
                  ? ColorValues.darkModeThird.withValues(alpha: 0.25)
                  : ColorValues.darkModeThird.withValues(alpha: 0.03),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        border: Border.all(color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor),
                        shape: BoxShape.circle),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(color: ColorValues.whiteColor, shape: BoxShape.circle),
                      child: ClipOval(
                        child: (getStorage.read("updatedNewDp")?.isEmpty ?? true)
                            ? (updateProfileImage == null
                                ? Image.asset(
                                    AssetValues.noProfile,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    updateProfileImage!,
                                    fit: BoxFit.cover,
                                  ))
                            : Obx(
                                () => PreviewNetworkImage(
                                  id: Database.fetchProfileModel?.user?.id ?? "",
                                  image: Database.profileImage.value,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringValue.welcomeHere.tr,
                        style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor),
                      ),
                      Text(
                        StringValue.letsEnjoyWebSeries.tr,
                        style: GoogleFonts.outfit(color: ColorValues.grayColor, fontWeight: FontWeight.w400, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Get Your Favorites Movie List ///
                    myList(createFavoriteMovie),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      onWillPop: () async {
        selectedIndex = 0;
        Get.offAll(
          const TabsScreen(),
        );
        return false;
      },
    );
  }

  BlocProvider<GetfavoritemovieBloc> myList(CreateFavoriteMovieProvider createFavoriteMovie) => BlocProvider(
        create: (_) => GetfavoritemovieBloc(RepositoryProvider.of<GetFavoriteMovieRepositroy>(context))..add((FavoriteMovie())),
        child: BlocListener<GetfavoritemovieBloc, GetfavoritemovieState>(
          listener: (BuildContext context, state) {},
          child: BlocBuilder<GetfavoritemovieBloc, GetfavoritemovieState>(
            builder: (BuildContext context, state) {
              if (state is GetfavoritemovieLoading) {
                return shimmer();
              } else if (state is GetfavoritemovieLoaded) {
                return (state.movieModal.favorite != null)
                    ? GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.movieModal.favorite!.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 13, mainAxisSpacing: 13),
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => DetailsScreen(
                                  movieId: state.movieModal.favorite![i].movie![0].id.toString(),
                                ),
                              );
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
                                      imageUrl: state.movieModal.favorite![i].movie![0].image!,
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
                                            "${state.movieModal.favorite![i].movie![0].title}",
                                            style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(height: 6),
                                          RatingBadge(
                                            rating: "${state.movieModal.favorite![i].rating}",
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
                      ).paddingSymmetric(horizontal: 13)
                    : Column(
                        children: [
                          SizedBox(
                            height: SizeConfig.screenHeight / 4,
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight / 4,
                            child: (getStorage.read('isDarkMode') == true)
                                ? SvgPicture.asset(MovixIcon.emptyListDark)
                                : SvgPicture.asset(MovixIcon.emptyList),
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 4,
                          ),
                          Text(
                            StringValue.yourListIsEmpty.tr,
                            style: GoogleFonts.urbanist(fontSize: 20, color: ColorValues.redColor, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 1.5,
                          ),
                          Text(
                            StringValue.notAdded.tr,
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      );

  Shimmer shimmer() {
    return Shimmer.fromColors(
      highlightColor: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
      baseColor: (getStorage.read('isDarkMode') == true) ? Colors.white24 : Colors.grey.shade300,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6, // You can change this count as needed
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
    );
  }
}
