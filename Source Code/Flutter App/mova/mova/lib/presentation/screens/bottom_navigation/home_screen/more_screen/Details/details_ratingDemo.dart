import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

class DetailsRatingDemo extends StatefulWidget {
  const DetailsRatingDemo({super.key});

  @override
  State<DetailsRatingDemo> createState() => _DetailsRatingDemoState();
}

class _DetailsRatingDemoState extends State<DetailsRatingDemo> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SvgPicture.asset(
        MovixIcon.halfBoldStar,
        height: 15,
        width: 15,
        color: ColorValues.redColor,
      ),
      onTap: () {
        Get.bottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          backgroundColor: (getStorage.read('isDarkMode') == true) ? const Color(0xff1F222A) : ColorValues.whiteColor,
          Container(
            height: 370,
            padding: const EdgeInsets.only(left: 13, right: 13),
            decoration: BoxDecoration(
              color: (getStorage.read('isDarkMode') == true) ? const Color(0xff1F222A) : ColorValues.whiteColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 05,
                ),
                Container(
                  width: 38,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: (getStorage.read('isDarkMode') == true) ? const Color(0xff35383F) : ColorValues.whiteColor,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  StringValue.giveRating.tr,
                  style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              StringValue.rate.tr,
                              style: GoogleFonts.urbanist(fontWeight: FontWeight.bold, fontSize: 40),
                            ),
                            Text(
                              StringValue.totalRate.tr,
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.fontColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              MovixIcon.boldStar,
                              height: 10,
                              width: 10,
                              color: ColorValues.redColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SvgPicture.asset(
                              MovixIcon.boldStar,
                              height: 10,
                              width: 10,
                              color: ColorValues.redColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SvgPicture.asset(
                              MovixIcon.boldStar,
                              height: 10,
                              width: 10,
                              color: ColorValues.redColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SvgPicture.asset(
                              MovixIcon.boldStar,
                              height: 10,
                              width: 10,
                              color: ColorValues.redColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SvgPicture.asset(
                              MovixIcon.halfBoldStar,
                              height: 10,
                              width: 10,
                              color: ColorValues.redColor,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          StringValue.users.tr,
                          style: GoogleFonts.urbanist(fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 135,
                      width: 2,
                      color: ColorValues.boxColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 220,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 10,
                                child: Text(
                                  "5",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : const Color(0xff212121),
                                    fontSize: 10,
                                    fontFamily: "Urbanist",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: 5.88,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 180,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: (getStorage.read('isDarkMode') == true) ? const Color(0xff35383F) : const Color(0xffe0e0e0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 150,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                100,
                                              ),
                                              gradient: const LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [
                                                  ColorValues.redColor,
                                                  Color(
                                                    0xffff4351,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        SizedBox(
                          width: 220,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 10,
                                child: Text(
                                  "4",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : const Color(0xff212121),
                                    fontSize: 10,
                                    fontFamily: "Urbanist",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: 5.88,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 180,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: (getStorage.read('isDarkMode') == true) ? const Color(0xff35383F) : const Color(0xffe0e0e0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 130,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                100,
                                              ),
                                              gradient: const LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [
                                                  ColorValues.redColor,
                                                  Color(
                                                    0xffff4351,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        SizedBox(
                          width: 220,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 10,
                                child: Text(
                                  "3",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : const Color(0xff212121),
                                    fontSize: 10,
                                    fontFamily: "Urbanist",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: 5.88,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 180,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: (getStorage.read('isDarkMode') == true) ? const Color(0xff35383F) : const Color(0xffe0e0e0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 60,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                100,
                                              ),
                                              gradient: const LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [
                                                  ColorValues.redColor,
                                                  Color(
                                                    0xffff4351,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        SizedBox(
                          width: 220,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 10,
                                child: Text(
                                  "2",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : const Color(0xff212121),
                                    fontSize: 10,
                                    fontFamily: "Urbanist",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: 5.88,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 180,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: (getStorage.read('isDarkMode') == true) ? const Color(0xff35383F) : const Color(0xffe0e0e0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 40,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                100,
                                              ),
                                              gradient: const LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [
                                                  ColorValues.redColor,
                                                  Color(
                                                    0xffff4351,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        SizedBox(
                          width: 220,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 10,
                                child: Text(
                                  "1",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : const Color(0xff212121),
                                    fontSize: 10,
                                    fontFamily: "Urbanist",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: 5.88,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 180,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: (getStorage.read('isDarkMode') == true) ? const Color(0xff35383F) : const Color(0xffe0e0e0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 20,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                100,
                                              ),
                                              gradient: const LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [
                                                  ColorValues.redColor,
                                                  Color(
                                                    0xffff4351,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      MovixIcon.boldStar,
                      height: 25,
                      width: 25,
                      color: ColorValues.redColor,
                    ),
                    SvgPicture.asset(
                      MovixIcon.boldStar,
                      height: 25,
                      width: 25,
                      color: ColorValues.redColor,
                    ),
                    SvgPicture.asset(
                      MovixIcon.boldStar,
                      height: 25,
                      width: 25,
                      color: ColorValues.redColor,
                    ),
                    SvgPicture.asset(
                      MovixIcon.boldStar,
                      height: 25,
                      width: 25,
                      color: ColorValues.redColor,
                    ),
                    SvgPicture.asset(
                      MovixIcon.star,
                      height: 30,
                      width: 30,
                      color: ColorValues.redColor,
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 45,
                      width: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: (getStorage.read('isDarkMode') == true) ? const Color(0xff35383F) : ColorValues.redBoxColor,
                      ),
                      child: Text(
                        StringValue.cancel.tr,
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.redColor,
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      width: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: ColorValues.redColor,
                      ),
                      child: Text(
                        StringValue.submit.tr,
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: ColorValues.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
