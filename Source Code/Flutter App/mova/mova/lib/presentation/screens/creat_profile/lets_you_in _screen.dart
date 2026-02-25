// ignore_for_file: avoid_print, file_names
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/creat_user/creat_user_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/auth/login_helper.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profilesetting/helpcentermodal/web_page.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/theme/theme.dart';
import 'package:webtime_movie_ocean/presentation/utils/utils.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:provider/provider.dart';

class LetsYouInScreen extends StatefulWidget {
  const LetsYouInScreen({super.key});

  @override
  State<LetsYouInScreen> createState() => _LetsYouInScreenState();
}

class _LetsYouInScreenState extends State<LetsYouInScreen> {
  bool isClick = false;
  // bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  GoogleSignInController googleSignInController =
      Get.put(GoogleSignInController());
  CreateUserController createUser = Get.put(CreateUserController());

  onClickTerms() {
    isClick = !isClick;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final userLogin =
        Provider.of<GoogleSignInController>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AssetValues.loginScreen),
              ),
            ),
          ),
          Container(
            height: Get.height,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                50.height,
                Container(
                  alignment: Alignment.center,
                  height: Get.height / 4.5,
                  decoration: const BoxDecoration(),
                  child: Image.asset(AssetValues.appLogo),
                ),
                SizedBox(height: Get.height / 165),
                Text(
                  "Welcome to WebTime Movie Ocean",
                  textAlign: TextAlign.center,
                  style: welComeAppStyle,
                ),

                Text(
                  StringValue.letsYouIn.tr,
                  textAlign: TextAlign.center,
                  style: letsInStyle,
                ),
                SizedBox(height: Get.height / 35),

                /// Google LogIn ///
                InkWell(
                  onTap: () async {
                    if (!isClick) {
                      Fluttertoast.showToast(
                        msg: "Please accept privacy policy first",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: ColorValues.redColor,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      await userLogin.googleLogin();
                      print(
                          "----------google login-----------${googleSignInController.loginGoogle}");
                    }
                  },
                  child: Container(
                    // height: Get.height / 14.5,
                    width: Get.width / 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: (getStorage.read('isDarkMode') == true)
                            ? Colors.transparent
                            : const Color(0xff1C1E27),
                        width: 1,
                      ),
                      color: (getStorage.read('isDarkMode') == true)
                          ? ColorValues.darkModeSecond
                          : ColorValues.whiteColor,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          // mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                color: Color(0xff292B35),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: SvgPicture.asset(
                                MovixIcon.google,
                                height: 32,
                              )),
                            ).paddingAll(5),
                            // Spacer(),
                            Text(
                              StringValue.google.tr,
                              style: loginMathodStyle,
                            ).paddingOnly(left: 45),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Get.height / 40),

                /// Apple LogIn ///
                Visibility(
                  visible: Platform.isIOS,
                  child: Column(
                    children: [
                      InkWell(
                        child: Container(
                          width: Get.width / 1.1,
                          height: Get.height / 14.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: (getStorage.read('isDarkMode') == true)
                                  ? Colors.transparent
                                  : const Color(0xffeeeeee),
                              width: 1,
                            ),
                            color: (getStorage.read('isDarkMode') == true)
                                ? ColorValues.darkModeSecond
                                : ColorValues.whiteColor,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        (getStorage.read('isDarkMode') == true)
                                            ? ColorValues.darkModeSecond
                                            : ColorValues.whiteColor,
                                    radius: 10,
                                    child: SvgPicture.asset(MovixIcon.apple,
                                        color: (getStorage.read('isDarkMode') ==
                                                true)
                                            ? ColorValues.whiteColor
                                            : ColorValues.darkModeSecond),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    StringValue.apple.tr,
                                    style: loginMathodStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          if (!isClick) {
                            Fluttertoast.showToast(
                              msg: "Please accept privacy policy first",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: ColorValues.redColor,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            userLogin.appleLogin();
                          }
                        },
                      ),
                      SizedBox(height: Get.height / 40),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 135,
                      height: 1,
                      color: (getStorage.read('isDarkMode') == true)
                          ? ColorValues.darkModeThird
                          : ColorValues.lightGrayColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      StringValue.or.tr,
                      style: orStyle,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 135,
                      height: 1,
                      color: (getStorage.read('isDarkMode') == true)
                          ? ColorValues.darkModeThird
                          : ColorValues.lightGrayColor,
                    ),
                  ],
                ),
                SizedBox(height: Get.height / 30),

                /// Quick LogIn ///
                InkWell(
                  onTap: () async {
                    log("On Tap Work");

                    if (!isClick) {
                      Fluttertoast.showToast(
                        msg: "Please accept privacy policy first",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: ColorValues.redColor,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      googleSignInController.quickLogin();
                    }
                  },
                  child: Container(
                    // height: 47,
                    width: Get.width / 1.1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: const [
                        BoxShadow(
                          color: ColorValues.shadowRedColor,
                          blurRadius: 24,
                          offset: Offset(4, 8),
                        ),
                      ],
                      color: ColorValues.shadow2RedColor,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: ColorValues.whiteColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: SvgPicture.asset(
                            MovixIcon.quickLogin,
                            height: 26,
                          )),
                        ).paddingAll(5),
                        Text(
                          StringValue.quickLogin.tr,
                          textAlign: TextAlign.center,
                          style: quickLoginStyle,
                        ).paddingOnly(left: 45),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    InkWell(
                      overlayColor: WidgetStateColor.transparent,
                      onTap: () {
                        onClickTerms();
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorValues.redColor,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: isClick
                            ? Container(
                                decoration: const BoxDecoration(
                                  color: ColorValues.redColor,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      overlayColor: WidgetStateColor.transparent,
                      onTap: () {
                        if (privacyPolicy != null &&
                            privacyPolicy!.isNotEmpty) {
                          WebViewApp(
                            link: privacyPolicy!,
                          );
                        }
                      },
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: (getStorage.read('isDarkMode') == true)
                                ? ColorValues.whiteColor
                                : ColorValues.blackColor,
                          ),
                          children: [
                            const TextSpan(text: "I agree to the "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: ColorValues.redColor,
                                decorationThickness: 2,
                                color: (getStorage.read('isDarkMode') == true)
                                    ? ColorValues.whiteColor
                                    : ColorValues.blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).paddingOnly(left: 15),
                15.height,

                AppUtils.systemBottomPadding(context: context).height,
              ],
            ),
          ),
          Consumer<GoogleSignInController>(
            builder: (context, controller, _) {
              return controller.isLoading
                  ? const Positioned(
                      bottom: 0,
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorValues.redColor,
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          )
        ],
      ),
    );
  }
}
