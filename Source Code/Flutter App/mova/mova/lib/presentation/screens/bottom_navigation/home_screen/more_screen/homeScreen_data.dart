// ignore_for_file: file_names, must_be_immutable, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webtime_movie_ocean/custom/custom_rating_view.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/home_screen/more_screen/Details/details_screen.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/helper/ads_helper.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';

import '../../../../utils/app_class.dart';

class HomeScreenData extends StatefulWidget {
  String title;
  List responce;

  HomeScreenData({super.key, required this.title, required this.responce});

  @override
  State<HomeScreenData> createState() => _HomeScreenDataState();
}

class _HomeScreenDataState extends State<HomeScreenData> {
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

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.scaffoldBg : ColorValues.whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            color: (getStorage.read('isDarkMode') == true) ? ColorValues.appBarColor : ColorValues.darkModeThird.withValues(alpha: 0.05),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 5,
            left: 20,
            right: 16,
            bottom: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  interstitialAd?.show();
                  if (interstitialAd != null) {
                    interstitialAd?.show();
                    Get.back();
                  } else {
                    Get.back();
                  }
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.smallContainerBg : Colors.grey.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(11),
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                  ),
                ),
              ),
              Text(
                widget.title,
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 24), // This balances the row
            ],
          ),
        ),
      ),

      /// Get All New Release movie ///
      body: GridView.builder(
        padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 4,
          top: SizeConfig.blockSizeVertical * 2,
          right: SizeConfig.blockSizeHorizontal * 4,
          bottom: SizeConfig.blockSizeHorizontal * 4,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          mainAxisSpacing: 13,
          crossAxisSpacing: 13,
        ),
        itemCount: widget.responce.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, i) {
          return GestureDetector(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeSecond : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(26),
              ),
              width: SizeConfig.screenWidth / 2.5,
              height: SizeConfig.screenHeight / 4.5,
              child: widget.responce[i].tmdbMovieId == null && widget.responce[i].iMDBid == null
                  ? PreviewNetworkImage(id: widget.responce[i].id ?? "", image: widget.responce[i].thumbnail ?? "")
                  : Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.responce[i].thumbnail,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Image(
                            width: double.infinity,
                            height: double.infinity,
                            color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                            image: const AssetImage(
                              AssetValues.appLogo,
                            ),
                          ),
                          errorWidget: (context, string, dynamic) => Image(
                            width: double.infinity,
                            height: double.infinity,
                            color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                            image: const AssetImage(
                              AssetValues.appLogo,
                            ),
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
                                "${widget.responce[i].title}",
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
                                rating: widget.responce[i].rating.toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            onTap: () {
              Get.to(
                () => DetailsScreen(
                  movieId: widget.responce[i].id!,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
