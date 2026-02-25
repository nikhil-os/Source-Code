import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/notification_api/getNotification_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/notification_api/notificationget_modal.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_class.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String formatDateToTime(String inputDateTime) {
    try {
      DateTime dateTime = DateFormat("M/d/y, h:mm:ss a").parse(inputDateTime);

      return DateFormat("h:mm a").format(dateTime);
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final getNotification = Provider.of<GetNotificationProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10).copyWith(top: 10),
              color: (getStorage.read('isDarkMode') == true)
                  ? ColorValues.darkModeThird.withValues(alpha: 0.25)
                  : ColorValues.darkModeThird.withValues(alpha: 0.03),
              child: Row(
                children: [
                  IconButton(
                    icon: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: (getStorage.read('isDarkMode') == true)
                            ? ColorValues.darkModeThird.withValues(alpha: 0.20)
                            : ColorValues.darkModeThird.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          MovixIcon.backArrowIcon,
                          color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                  Text(
                    StringValue.notification.tr,
                    style: GoogleFonts.urbanist(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getNotification.getNotification(),
                builder: (BuildContext context, AsyncSnapshot<NotificationgetModal> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return notificationShimmer();
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.notification!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: Get.height / 3,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/gif/notification.gif"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              StringValue.noNotificationFound.tr,
                              style: GoogleFonts.urbanist(
                                color: (getStorage.read('isDarkMode') == true) ? ColorValues.redColor : ColorValues.blackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 15),
                      itemCount: snapshot.data!.notification!.length,
                      itemBuilder: (context, i) {
                        final notification = snapshot.data!.notification![i];
                        final hasImage = notification.image?.isNotEmpty ?? false;

                        return Container(
                          margin: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 5.5,
                            bottom: SizeConfig.blockSizeVertical * 1.5,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasImage)
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 1.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: PreviewNetworkImage(
                                      id: notification.id ?? "",
                                      image: notification.image ?? "",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              else
                                const SizedBox(width: 50),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.52,
                                            child: Text(
                                              notification.title?.capitalizeFirst ?? "",
                                              style: GoogleFonts.urbanist(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            formatDateToTime(notification.date ?? ""),
                                            style: GoogleFonts.urbanist(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: ColorValues.grayText,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.8,
                                        child: Text(
                                          notification.message?.capitalizeFirst ?? "",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: ColorValues.grayColorText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).paddingOnly(bottom: 8, top: 15);
                      },
                    );
                  } else if (snapshot.hasError) {
                    log("Snapshot error :: ${snapshot.error}");
                    return const Center(child: Text("Something went wrong"));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Shimmer notificationShimmer() {
    return Shimmer.fromColors(
      highlightColor: (getStorage.read('isDarkMode') == true) ? Colors.white12 : Colors.grey.shade100,
      baseColor: (getStorage.read('isDarkMode') == true) ? Colors.white24 : Colors.grey.shade300,
      child: SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, i) {
            return Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 5,
                right: SizeConfig.blockSizeHorizontal * 5,
                top: SizeConfig.blockSizeVertical * 0.5,
                bottom: SizeConfig.blockSizeVertical * 2,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorValues.grayColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: SizeConfig.screenHeight / 8,
                    width: SizeConfig.screenWidth / 3,
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 3,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 14,
                        decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 1.5,
                      ),
                      Container(
                        width: 50,
                        height: 10,
                        decoration: BoxDecoration(
                          color: ColorValues.grayColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ).paddingOnly(top: 10),
      ),
    );
  }
}
