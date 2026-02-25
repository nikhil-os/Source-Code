import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/controller/api_controller/plan_controller.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profile_premium_view/payment_methods.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/theme/theme.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SubscribeToPremium extends StatefulWidget {
  const SubscribeToPremium({super.key});

  @override
  State<SubscribeToPremium> createState() => _SubscribeToPremiumState();
}

class _SubscribeToPremiumState extends State<SubscribeToPremium> {
  final CarouselSliderController scrollController = CarouselSliderController();
  PlanController planProvider = Get.put(PlanController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(IconAssetValues.premiumBg),
          Container(
            color: (getStorage.read('isDarkMode') == true) ? ColorValues.appBarColor.withValues(alpha: .94) : Colors.white.withValues(alpha: .87),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).copyWith(top: 35),
                  color: (getStorage.read('isDarkMode') == true) ? ColorValues.appBarColor : ColorValues.darkModeThird.withValues(alpha: 0.03),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              color: (getStorage.read('isDarkMode') == true)
                                  ? ColorValues.smallContainerBg
                                  : ColorValues.darkModeThird.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(14)),
                          child: Center(
                            child: SvgPicture.asset(
                              MovixIcon.backArrowIcon,
                              height: 24,
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(StringValue.subscription.tr, style: fillProfileStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        StringValue.subscribeToPremiums.tr,
                        style: GoogleFonts.urbanist(
                          color: ColorValues.redColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        StringValue.benefit.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 15),
                      Obx(
                        () {
                          if (planProvider.isLoading.value) {
                            return buildShimmer();
                          } else {
                            return Expanded(
                              child: PageView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: planProvider.planList.length,
                                  controller: planProvider.pageController,
                                  onPageChanged: (value) {
                                    planProvider.currentIndex.value = value;
                                  },
                                  itemBuilder: (context, index) {
                                    return Align(
                                      alignment: Alignment.topCenter,
                                      child: IntrinsicHeight(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: (getStorage.read('isDarkMode') == true)
                                                ? ColorValues.containerBg
                                                : ColorValues.darkModeThird.withValues(alpha: 0.06),
                                            border: Border.all(color: ColorValues.borderColor.withValues(alpha: .54), width: 0.8),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                                          margin: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                MovixIcon.premium,
                                                height: 70,
                                              ),
                                              const SizedBox(height: 10),
                                              RichText(
                                                text: TextSpan(
                                                  text: "\$${planProvider.planList[index].dollar}",
                                                  style: GoogleFonts.urbanist(
                                                    color: ColorValues.buttonColorRed,
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          " / ${planProvider.planList[index].validity} ${planProvider.planList[index].validityType}",
                                                      style: GoogleFonts.urbanist(
                                                        color: ColorValues.buttonColorRed,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Divider(
                                                color: (getStorage.read('isDarkMode') == true)
                                                    ? ColorValues.dividerColor
                                                    : ColorValues.darkModeThird.withValues(alpha: 0.10),
                                              ),
                                              Expanded(
                                                  child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    for (int i = 0; i < planProvider.planList[index].planBenefit!.length; i++)
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 10),
                                                        child: SizedBox(
                                                          width: Get.width,
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Image.asset(
                                                                IconAssetValues.verificationMark,
                                                                height: 24,
                                                                color: (getStorage.read('isDarkMode') == true) ? Colors.white : Colors.black,
                                                              ),
                                                              const SizedBox(width: 15),
                                                              Expanded(
                                                                child: Text(
                                                                  planProvider.planList[index].planBenefit![i].trim(),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 3,
                                                                  style: GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              )),
                                              const SizedBox(height: 10),
                                              const SizedBox(height: 20),
                                              InkWell(
                                                onTap: () {
                                                  Get.to(
                                                    () => PaymentMethod(
                                                      planId: planProvider.planList[index].id!,
                                                      planPrice: planProvider.planList[index].dollar.toString(),
                                                      productKey: planProvider.planList[index].productKey ?? "",
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  height: 54,
                                                  width: Get.width,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: ColorValues.redColor,
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  child: Text(
                                                    StringValue.buyNow.tr,
                                                    style: GoogleFonts.urbanist(
                                                      color: ColorValues.whiteColor,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ).paddingOnly(bottom: 4),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => AnimatedSmoothIndicator(
                          activeIndex: planProvider.currentIndex.value,
                          count: planProvider.planList.length,
                          axisDirection: Axis.horizontal,
                          curve: Curves.easeInCubic,
                          effect: CustomizableEffect(
                            activeDotDecoration: DotDecoration(
                              width: 22,
                              height: 8,
                              color: ColorValues.buttonColorRed,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            dotDecoration: DotDecoration(
                              height: 8,
                              width: 8,
                              color: (getStorage.read('isDarkMode') == true) ? Colors.white : ColorValues.blackColor,
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildShimmer() {
    return Shimmer.fromColors(
      highlightColor: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
      baseColor: (getStorage.read('isDarkMode') == true) ? Colors.white24 : Colors.grey.shade300,
      child: Container(
        decoration: BoxDecoration(
          color: (getStorage.read('isDarkMode') == true) ? ColorValues.containerBg : ColorValues.darkModeThird.withValues(alpha: 0.06),
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SvgPicture.asset(
              MovixIcon.premium,
            ),
            const SizedBox(height: 16),
            Container(
              height: 22,
              width: 100,
              decoration: BoxDecoration(
                color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird.withValues(alpha: 0.30) : ColorValues.darkModeThird,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            const SizedBox(height: 16),
            Divider(
              color: (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.darkModeThird.withValues(alpha: 0.10),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < 5; i++)
              Container(
                height: 16,
                decoration: BoxDecoration(
                  color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird.withValues(alpha: 0.30) : ColorValues.darkModeThird,
                  borderRadius: BorderRadius.circular(50),
                ),
              ).paddingOnly(bottom: 30),
            const SizedBox(height: 30),
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird.withValues(alpha: 0.30) : ColorValues.darkModeThird,
                borderRadius: BorderRadius.circular(50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
