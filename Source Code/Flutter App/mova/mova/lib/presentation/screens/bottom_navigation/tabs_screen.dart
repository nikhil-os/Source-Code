import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/chekuser_api/fetch_profile_provider.dart';
import 'package:webtime_movie_ocean/customModal/themeServic.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/LiveTv_screen/live_tv_page.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/explore_screen/explore_page.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/home_screen/home_page.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profile_page.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/controller/reels_controller.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/view/reels_view.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/database.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Widget> screenSelection = <Widget>[
    const ExploreTab(),
    const ReelsView(),
    const LiveTVScreen(),
    const ProfileTab(),
  ];

  onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget _getCurrentScreen() {
    switch (selectedIndex) {
      case 0:
        return HomePage(
          onIndex: onItemTapped,
        );
      case 1:
        return const ExploreTab();
      case 2:
        return const ReelsView();
      case 3:
        return const LiveTVScreen();
      case 4:
        return const ProfileTab();
      default:
        return HomePage(
          onIndex: onItemTapped,
        );
    }
  }

  bool _logoutSheetShown = false;

  @override
  void initState() {
    super.initState();
    Stripe.publishableKey = stripePublishableKey;
    Get.put(ReelsController());
  }

  @override
  Widget build(BuildContext context) {
    final userprofile = Provider.of<FetchProfileProvider>(context, listen: false);
    if (userId.isNotEmpty) {
      userprofile.onGetProfile();
    }

    if ((Database.fetchProfileModel?.user?.isBlock == true) && !_logoutSheetShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _logoutSheetShown = true;

        Get.bottomSheet(
          backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.whiteColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 3,
              right: SizeConfig.blockSizeHorizontal * 3,
            ),
            height: SizeConfig.screenHeight * 1,
            decoration: BoxDecoration(
              color: (getStorage.read('isDarkMode') == true) ? ColorValues.appBarColor : ColorValues.whiteColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 5),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 8,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: ColorValues.darkModeThird,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  StringValue.blocked.tr,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    color: ColorValues.redColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: ColorValues.dividerColor,
                ),
                SvgPicture.asset(MovixIcon.logOutImage),
                const SizedBox(height: 10),
                Text(
                  StringValue.youAreBlockedByAdmin.tr,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    height: SizeConfig.screenHeight / 16,
                    width: SizeConfig.screenWidth / 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: ColorValues.redColor,
                    ),
                    child: Text(
                      StringValue.closeApp.tr,
                      style: GoogleFonts.outfit(
                        color: ColorValues.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  onTap: () async {
                    exit(0);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      });
    }

    /*
    return PopScope(
      canPop: !(Get.isBottomSheetOpen ?? false),
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
      },*/

    return Scaffold(
      extendBody: true,
      body: _getCurrentScreen(),
      bottomNavigationBar: Obx(
        () => Container(
          color: Colors.transparent,
          padding: const EdgeInsets.only(bottom: 0), // adjust if needed
          child: Column(
            mainAxisSize: MainAxisSize.min, // Important: use min to wrap content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (videoDownload.value || serverSeriesDownload.value) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                  child: Text(
                    "Video Downloading....",
                    style: GoogleFonts.urbanist(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                ),
                const LinearProgressIndicator(
                  backgroundColor: ColorValues.redColor,
                ),
              ],
              BlurryContainer(
                blur: 10,
                width: Get.width,
                borderRadius: BorderRadius.zero,
                color: CustomTheme.isDarkMode.value ? ColorValues.bottomBarBg.withValues(alpha: .7) : Colors.white,
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: CustomTheme.isDarkMode.value ? ColorValues.bottomBar.withValues(alpha: .76) : ColorValues.grayShimmer,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  height: 65,
                  width: Get.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _BottomBarIconUi(
                        icon: selectedIndex == 0 ? MovixIcon.boldHome : MovixIcon.home,
                        callback: () => onItemTapped(0),
                        isSelect: selectedIndex == 0,
                      ),
                      _BottomBarIconUi(
                        icon: selectedIndex == 1 ? MovixIcon.boldExplore : MovixIcon.explore,
                        callback: () => onItemTapped(1),
                        isSelect: selectedIndex == 1,
                      ),
                      _BottomBarIconUi(
                        icon: selectedIndex == 2 ? MovixIcon.shortsFilled : MovixIcon.shortsOutlined,
                        callback: () => onItemTapped(2),
                        isSelect: selectedIndex == 2,
                      ),
                      _BottomBarIconUi(
                        icon: selectedIndex == 3 ? MovixIcon.boldLiveTv : MovixIcon.liveTv,
                        callback: () => onItemTapped(3),
                        isSelect: selectedIndex == 3,
                      ),
                      _BottomBarIconUi(
                        icon: selectedIndex == 4 ? MovixIcon.boldProfile : MovixIcon.profile,
                        callback: () => onItemTapped(4),
                        isSelect: selectedIndex == 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBarIconUi extends StatelessWidget {
  const _BottomBarIconUi({required this.icon, required this.callback, required this.isSelect});

  final String icon;
  final Callback callback;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: callback,
        child: Container(
          height: 48,
          width: 48,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: isSelect ? ColorValues.redColor : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                height: 22,
                width: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
