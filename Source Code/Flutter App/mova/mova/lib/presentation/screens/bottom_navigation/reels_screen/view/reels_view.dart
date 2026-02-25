import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/controller/reels_controller.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/widget/reels_widget.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/tabs_screen.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:shimmer/shimmer.dart';

class ReelsView extends GetView<ReelsController> {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        selectedIndex = 0;
        Get.offAll(const TabsScreen());
        return false;
      },
      child: Scaffold(
        body: GetBuilder<ReelsController>(
          id: "onGetReels",
          builder: (controller) => controller.isLoadingReels
              ? const ReelsShimmerUi()
              : controller.mainReels.isEmpty
                  ? RefreshIndicator(
                      color: ColorValues.redColor,
                      onRefresh: () async => await controller.init(),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: Get.height + 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      color: ColorValues.redColor,
                      onRefresh: () async {
                        await 400.milliseconds.delay();
                        await controller.init();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        child: PreloadPageView.builder(
                          controller: controller.preloadPageController,
                          itemCount: controller.mainReels.length,
                          preloadPagesCount: 4,
                          scrollDirection: Axis.vertical,
                          onPageChanged: (value) async {
                            controller.onPagination(value);
                            controller.onChangePage(value);
                          },
                          itemBuilder: (context, index) {
                            return GetBuilder<ReelsController>(
                              id: "onChangePage",
                              builder: (controller) => PreviewReelsView(
                                index: index,
                                currentPageIndex: controller.currentPageIndex,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}

class ReelsShimmerUi extends StatelessWidget {
  const ReelsShimmerUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
      baseColor: (getStorage.read('isDarkMode') == true) ? Colors.white24 : Colors.grey.shade300,
      child: Stack(
        children: [
          Positioned(
            right: 20,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - bottomBarSize,
              width: 50,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    const Spacer(),
                    for (int i = 0; i < 5; i++)
                      Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: const BoxDecoration(color: ColorValues.blackColor, shape: BoxShape.circle),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(left: 15, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorValues.blackColor,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 15,
                          width: 150,
                          margin: const EdgeInsets.only(left: 12, bottom: 5),
                          decoration: BoxDecoration(color: ColorValues.blackColor, borderRadius: BorderRadius.circular(5)),
                        ),
                        Container(
                          height: 15,
                          width: 100,
                          margin: const EdgeInsets.only(left: 12, bottom: 5),
                          decoration: BoxDecoration(color: ColorValues.blackColor, borderRadius: BorderRadius.circular(5)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 15,
                  width: 280,
                  margin: const EdgeInsets.only(left: 20, bottom: 5),
                  decoration: BoxDecoration(
                    color: ColorValues.blackColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Container(
                  height: 15,
                  width: 220,
                  margin: const EdgeInsets.only(left: 20, bottom: 5),
                  decoration: BoxDecoration(
                    color: ColorValues.blackColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
