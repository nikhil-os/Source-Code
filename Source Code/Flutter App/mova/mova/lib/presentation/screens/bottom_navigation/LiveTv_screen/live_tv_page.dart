import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/controller/api_controller/adminPannelsLiveDataController.dart';
import 'package:webtime_movie_ocean/controller/api_controller/countryWiseChannels_Controller.dart';
import 'package:webtime_movie_ocean/custom/custom_status_bar_color.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/tabs_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/videoPlayer/liveTvVideo_player.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/utils.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:shimmer/shimmer.dart';

class LiveTVScreen extends StatefulWidget {
  const LiveTVScreen({super.key});

  @override
  State<LiveTVScreen> createState() => _LiveTVScreenState();
}

class _LiveTVScreenState extends State<LiveTVScreen> {
  ChannelsListCountryWiseController liveTvChannelsListData = Get.put(
    ChannelsListCountryWiseController(),
  );
  ChannelsListController adminPanelLiveTvChannelsListData = Get.put(
    ChannelsListController(),
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomStatusBarColor.init();
    SizeConfig().init(context);
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: WillPopScope(
        onWillPop: () async {
          selectedIndex = 0;
          Get.offAll(
            const TabsScreen(),
          );
          return false;
        },
        child: Scaffold(
          backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.scaffoldBg : ColorValues.whiteColor,
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).copyWith(top: 42, bottom: 15),
                color: (getStorage.read('isDarkMode') == true) ? ColorValues.appBarColor : ColorValues.darkModeThird.withValues(alpha: 0.03),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Live TV Channels",
                          style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "All your live channels in one place",
                          style: GoogleFonts.outfit(color: ColorValues.grayColor, fontWeight: FontWeight.w400, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              (showAdminPannelLiveChannels == true)
                  ? Obx(() {
                      if (adminPanelLiveTvChannelsListData.isLoading.value) {
                        return buildShimmer();
                      }
                      return (adminPanelLiveTvChannelsListData.channelsList.isNotEmpty)
                          ? Expanded(
                              child: SingleChildScrollView(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: adminPanelLiveTvChannelsListData.channelsList.length,
                                  padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20, top: 20),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: .91,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemBuilder: (BuildContext context, int i) {
                                    return InkWell(
                                      onTap: () async {
                                        AppUtils.showLog("Navigating to LiveTV");

                                        // Show loading indicator while navigating
                                        Get.dialog(
                                          const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          barrierDismissible: false,
                                        );

                                        // Small delay to prevent immediate orientation change lag
                                        await Future.delayed(const Duration(milliseconds: 100));

                                        // Close loading dialog
                                        Get.back();

                                        // Navigate to video player
                                        Get.to(
                                          () => LiveTvVideoPlayerScreen(
                                            name: adminPanelLiveTvChannelsListData.channelsList[i].channelName.toString(),
                                            link: adminPanelLiveTvChannelsListData.channelsList[i].streamURL.toString(),
                                          ),
                                          transition: Transition.fadeIn,
                                          duration: const Duration(milliseconds: 300),
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: ColorValues.borderColor, width: 0.6),
                                          color: (getStorage.read('isDarkMode') == true) ? ColorValues.containerBg : Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: CachedNetworkImage(
                                                height: 60,
                                                width: 60,
                                                imageUrl: adminPanelLiveTvChannelsListData.channelsList[i].channelLogo.toString(),
                                                placeholder: (context, url) => Image(
                                                  height: 60,
                                                  width: 60,
                                                  color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                                  image: const AssetImage(
                                                    AssetValues.appLogo,
                                                  ),
                                                ),
                                                errorWidget: (context, string, dynamic) => Image(
                                                  height: 60,
                                                  width: 60,
                                                  color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                                  image: const AssetImage(
                                                    AssetValues.appLogo,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  bottomRight: Radius.circular(10),
                                                  bottomLeft: Radius.circular(10),
                                                ),
                                                color: (getStorage.read('isDarkMode') == true)
                                                    ? ColorValues.smallContainerBg
                                                    : ColorValues.darkModeThird.withValues(alpha: 0.05),
                                              ),
                                              width: SizeConfig.blockSizeVertical * 15,
                                              child: Text(
                                                adminPanelLiveTvChannelsListData.channelsList[i].channelName.toString(),
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ).paddingSymmetric(horizontal: 6, vertical: 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: Get.height / 8,
                                  ),
                                  Container(
                                    height: Get.height / 5,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.red),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          AssetValues.noImage,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.blockSizeVertical * 6,
                                  ),
                                  Text(
                                    StringValue.liveChannelsNotAvailable.tr,
                                    style: GoogleFonts.urbanist(
                                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.redColor : ColorValues.blackColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                    })
                  : Obx(() {
                      if (liveTvChannelsListData.isLoading.value) {
                        return buildShimmer();
                      }
                      return (liveTvChannelsListData.channelsList.isNotEmpty)
                          ? Expanded(
                              child: GridView.builder(
                                itemCount: liveTvChannelsListData.channelsList.length,
                                padding: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 4,
                                  top: SizeConfig.blockSizeVertical * 2,
                                  right: SizeConfig.blockSizeHorizontal * 4,
                                ),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: SizeConfig.blockSizeHorizontal * 3,
                                  mainAxisSpacing: SizeConfig.blockSizeVertical * 1.5,
                                ),
                                itemBuilder: (BuildContext context, int i) {
                                  return InkWell(
                                    onTap: () async {
                                      AppUtils.showLog("Navigating to LiveTV>>>>>>>>>>>>>>>>>");

                                      // Show loading indicator while navigating
                                      Get.dialog(
                                        const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        barrierDismissible: false,
                                      );

                                      // Small delay to prevent immediate orientation change lag
                                      await Future.delayed(const Duration(milliseconds: 100));

                                      // Close loading dialog
                                      Get.back();

                                      // Navigate to video player
                                      Get.to(
                                        () => LiveTvVideoPlayerScreen(
                                          name: adminPanelLiveTvChannelsListData.channelsList[i].channelName.toString(),
                                          link: adminPanelLiveTvChannelsListData.channelsList[i].streamURL.toString(),
                                        ),
                                        transition: Transition.fadeIn,
                                        duration: const Duration(milliseconds: 300),
                                      );
                                    },
                                    child: Container(
                                      height: Get.height / 9,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, 1),
                                            blurRadius: 1,
                                            color: Colors.black.withValues(alpha: 0.4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CachedNetworkImage(
                                            height: 60,
                                            width: 60,
                                            imageUrl: liveTvChannelsListData.channelsList[i].channelLogo.toString(),
                                            placeholder: (context, url) => Image(
                                              height: 60,
                                              width: 60,
                                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                              image: const AssetImage(
                                                AssetValues.appLogo,
                                              ),
                                            ),
                                            errorWidget: (context, string, dynamic) => Image(
                                              height: 60,
                                              width: 60,
                                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : Colors.grey.shade400,
                                              image: const AssetImage(
                                                AssetValues.appLogo,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: SizeConfig.blockSizeHorizontal * 2,
                                          ),
                                          SizedBox(
                                            width: SizeConfig.blockSizeVertical * 15,
                                            child: Text(
                                              liveTvChannelsListData.channelsList[i].channelName.toString(),
                                              style: GoogleFonts.urbanist(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: Get.height / 9),
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
                    }),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Shimmer buildShimmer() {
    return Shimmer.fromColors(
      highlightColor: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
      baseColor: (getStorage.read('isDarkMode') == true) ? Colors.white24 : Colors.grey.shade300,
      child: SizedBox(
        height: Get.height / 1.3,
        child: GridView.builder(
          itemCount: 20,
          padding: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 4,
            top: SizeConfig.blockSizeVertical * 2,
            right: SizeConfig.blockSizeHorizontal * 4,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: SizeConfig.blockSizeHorizontal * 3,
            mainAxisSpacing: SizeConfig.blockSizeVertical * 1.5,
          ),
          itemBuilder: (BuildContext context, int i) {
            return Container(
              decoration: BoxDecoration(
                color: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              height: Get.height / 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 60,
                    width: 60,
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeHorizontal * 3,
                  ),
                  Container(
                    height: 20,
                    width: 60,
                    decoration: BoxDecoration(
                      color: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
