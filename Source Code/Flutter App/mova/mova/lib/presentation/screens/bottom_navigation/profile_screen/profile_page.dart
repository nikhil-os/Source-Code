import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/chekuser_api/fetch_profile_provider.dart';
import 'package:webtime_movie_ocean/buinesslogic/auth/login_helper.dart';
import 'package:webtime_movie_ocean/controller/api_controller/delete_account_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/file_upload/file_upload_controller.dart';
import 'package:webtime_movie_ocean/custom/custom_status_bar_color.dart';
import 'package:webtime_movie_ocean/customModal/profileModal.dart';
import 'package:webtime_movie_ocean/customModal/themeModal.dart';
import 'package:webtime_movie_ocean/customModal/themeServic.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/downlode_screen/download_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profile_premium_view/subscribetopremium.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profilesetting/editprofilescreen.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profilesetting/helpcenter.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profilesetting/helpcentermodal/web_page.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profilesetting/language/language_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profilesetting/notificationprofilescreen.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/tabs_screen.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_class.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/database.dart';
import 'package:webtime_movie_ocean/presentation/utils/routes/app_pages.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  FileUploadController fileUploadController = Get.put(FileUploadController());
  DeleteAccountController deleteAccountController = Get.put(DeleteAccountController());

  GetXSwitchState getXSwitchState = Get.put(GetXSwitchState());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomStatusBarColor.init();

    SizeConfig().init(context);
    final userLogin = Provider.of<GoogleSignInController>(context, listen: false);
    var userprofile = Provider.of<FetchProfileProvider>(context, listen: false);
    notification1 = userprofile.data["user"]["notification"]["GeneralNotification"] ?? true;
    notification4 = userprofile.data["user"]["notification"]["NewReleasesMovie"] ?? true;

    notification5 = userprofile.data["user"]["notification"]["AppUpdate"] ?? true;
    notification6 = userprofile.data["user"]["notification"]["Subscription"] ?? false;
    userProfileImage = userprofile.data['user']['image'];

    Future<void> refreshProfileData() async {
      userprofile.data;
      await Future.delayed(const Duration(seconds: 2)); // Simulate loading for 2 seconds
      setState(() {
        userprofile = Provider.of<FetchProfileProvider>(context, listen: false);
      });
    }

    List<ProfileModal> settingData = [
      ProfileModal(
        onTap: () {
          Get.to(() => const EditProfileView());
        },
        widget: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
        ),
        iconImage: MovixIcon.editProfileIcon,
        tital: StringValue.editProfile.tr,
      ),
      ProfileModal(
        widget: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
        ),
        iconImage: MovixIcon.notificationIcon,
        tital: StringValue.notification.tr,
        onTap: () {
          Get.to(
            () => const NotificationProfileScreen(),
          );
        },
      ),
      ProfileModal(
        onTap: () {
          Get.to(() => const DownloadTab());
        },
        widget: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
        ),
        iconImage: MovixIcon.downloadIcon,
        tital: StringValue.download.tr,
      ),
      ProfileModal(
          onTap: () {
            Get.to(
              () => const LanguageView(),
            );
          },
          widget: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15,
          ),
          iconImage: MovixIcon.languageIcon,
          tital: StringValue.language.tr,
          subTital: "${getStorage.read('selected_language')}"),
      ProfileModal(
        onTap: () {},
        widget: Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
              activeColor: const Color(0xFF0CC133),
              value: getXSwitchState.isSwitcheded,
              onChanged: (val) {
                setState(() {
                  getXSwitchState.changeSwitchState(val);
                  ThemeServices().switchTheme();
                });
              }),
        ),
        iconImage: MovixIcon.themeModeIcon,
        tital: StringValue.darkMode.tr,
      ),
      ProfileModal(
        widget: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
        ),
        iconImage: MovixIcon.helpCenterIcon,
        tital: StringValue.helpCenter.tr,
        onTap: () {
          Get.to(
            () => const HelpCenterProfileScreen(),
          );
        },
      ),
      ProfileModal(
        onTap: () {
          Get.to(
            WebViewApp(
              link: privacyPolicy!,
            ),
          );
        },
        widget: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
        ),
        iconImage: MovixIcon.privacyPolicyIcon,
        tital: StringValue.privacyPolicy.tr,
      ),
      ProfileModal(
        onTap: () {
          Get.to(
            WebViewApp(
              link: termConditionLink!,
            ),
          );
        },
        widget: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
        ),
        iconImage: MovixIcon.termsConditionIcon,
        tital: StringValue.termsCondition.tr,
      ),
      ProfileModal(
        onTap: () {
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
                    StringValue.logOut.tr,
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
                    StringValue.youWantToLogOut.tr,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: SizeConfig.screenHeight / 16,
                          width: SizeConfig.screenWidth / 2.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: (getStorage.read('isDarkMode') == true) ? const Color(0xff35383F) : ColorValues.redBoxColor,
                          ),
                          child: Text(
                            StringValue.cancel.tr,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.redColor,
                            ),
                          ),
                        ),
                      ),
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
                            StringValue.yesLogout.tr,
                            style: GoogleFonts.outfit(
                              color: ColorValues.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        onTap: () async {
                          FirebaseAuth.instance.authStateChanges().listen((User? user) {
                            if (user != null) {
                              // print("user:$user");
                              if (user.providerData[0].providerId.contains("password")) {
                                // print("Login via Email");
                                FirebaseAuth.instance.signOut();
                              } else if (user.providerData[0].providerId.contains("google.com")) {
                                // print("Login via Google");
                                userLogin.logOut();
                              }
                            }
                          });
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          pref.setBool("isLogin", false);
                          pref.remove("userId");
                          pref.remove("userNickName");
                          pref.remove("userEmail");
                          pref.remove("userGender");
                          pref.remove("userCountry");
                          pref.remove("userProfileImage");
                          pref.remove("isMovieDownload");
                          pref.remove("isMovieFavorite");
                          pref.remove("isMovieFavorite");
                          pref.remove("DownloadList");
                          pref.remove("movieDownloaded");
                          pref.remove("download");
                          pref.remove("downloadHistory");
                          userId = "";
                          userEmail = "";
                          userName = "";
                          userNickName = "";
                          userGender = "";
                          userCountry = "";
                          updateProfileImage = null;
                          Get.offNamed(Routes.welcome);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
        widget: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
        ),
        iconImage: MovixIcon.logOutIcon,
        tital: StringValue.logOut.tr,
      ),
    ];
    return WillPopScope(
      child: Scaffold(
        backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.scaffoldBg : ColorValues.whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => refreshProfileData(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(height: 40),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.darkModeMain, width: 2),
                                  shape: BoxShape.circle),
                              child: Container(
                                height: 115,
                                width: 115,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeMain : ColorValues.whiteColor,
                                ),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ClipOval(
                                    child: updateProfileImage == null
                                        ? Database.fetchProfileModel?.user?.image != null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child: PreviewNetworkImage(
                                                  id: Database.fetchProfileModel?.user?.id ?? "",
                                                  image: Database.profileImage.value,
                                                ),
                                              )
                                            : Container(
                                                height: 124,
                                                width: 124,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                                child: Image.asset(AssetValues.noProfile, fit: BoxFit.cover),
                                              )
                                        : Container(
                                            height: 124,
                                            width: 124,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: const BoxDecoration(shape: BoxShape.circle),
                                            child: Image.file(updateProfileImage!, fit: BoxFit.cover),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          userName2.tr,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Text(
                          userEmail2.tr,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                          ),
                        ),

                        const SizedBox(height: 26),

                        /// SubscribetoPremium ///
                        (userprofile.data["user"]["isPremiumPlan"] == false)
                            ? GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => const SubscribeToPremium(),
                                    transition: Transition.downToUp,
                                  );
                                },
                                child: Container(
                                  width: Get.width,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      image: const DecorationImage(image: AssetImage(AssetValues.redContainer), fit: BoxFit.cover)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        MovixIcon.king,
                                        height: 50,
                                        width: 50,
                                        color: ColorValues.whiteColor,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringValue.joinPremium.tr,
                                            style: GoogleFonts.outfit(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20,
                                              color: ColorValues.whiteColor,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            StringValue.benefit.tr,
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              color: ColorValues.whiteColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SvgPicture.asset(
                                        MovixIcon.smallArrowRight,
                                        height: SizeConfig.blockSizeVertical * 3,
                                        color: ColorValues.whiteColor,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                child: Container(
                                  width: Get.width,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: const DecorationImage(image: AssetImage(AssetValues.redContainer), fit: BoxFit.cover),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 10),
                                      Image.asset(
                                        MovixIcon.king,
                                        color: ColorValues.whiteColor,
                                        height: 50,
                                        width: 50,
                                      ),
                                      const SizedBox(width: 24),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "\$${userprofile.data["user"]["plan"]["premiumPlanId"]["dollar"] ?? 0} / month".toString(),
                                                style: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18,
                                                  color: ColorValues.whiteColor,
                                                ),
                                              ),
                                              const SizedBox(width: 2),
                                              const Image(
                                                image: AssetImage(ProfileAssetValues.host),
                                                height: 20,
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            StringValue.benefit.tr,
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              color: ColorValues.textWhite,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            StringValue.currentPlanRunning.tr,
                                            style: GoogleFonts.outfit(
                                              fontSize: 13,
                                              color: ColorValues.whiteColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        const SizedBox(height: 16),

                        Divider(
                          color:
                              (getStorage.read('isDarkMode') == true) ? ColorValues.dividerColor : ColorValues.darkModeThird.withValues(alpha: 0.10),
                        ).paddingSymmetric(horizontal: 12),

                        const SizedBox(height: 4),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          itemCount: settingData.length,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onTap: settingData[i].onTap,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: (getStorage.read('isDarkMode') == true)
                                        ? ColorValues.containerBg
                                        : ColorValues.darkModeThird.withValues(alpha: 0.03),
                                    border: Border.all(
                                        width: 0.6,
                                        color: (getStorage.read('isDarkMode') == true)
                                            ? ColorValues.borderColor.withValues(alpha: .64)
                                            : ColorValues.dividerColor.withValues(alpha: 0.02))),
                                padding: EdgeInsets.only(top: 5, bottom: 5, left: 6, right: i == 4 ? 0 : 14),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 56,
                                      width: 56,
                                      decoration: BoxDecoration(
                                          color: (getStorage.read('isDarkMode') == true)
                                              ? ColorValues.profileSmallContainerBg
                                              : ColorValues.darkModeThird.withValues(alpha: 0.05),
                                          borderRadius: BorderRadius.circular(14)),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          settingData[i].iconImage,
                                          color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                                          height: 28,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      settingData[i].tital,
                                      style: GoogleFonts.outfit(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    (settingData[i].subTital == null)
                                        ? Container()
                                        : Text(
                                            "${settingData[i].subTital}",
                                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: ColorValues.redColor),
                                          ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    i == 4
                                        ? Transform.scale(
                                            scale: 0.7,
                                            child: CupertinoSwitch(
                                              activeColor: const Color(0xFF0CC133),
                                              value: getXSwitchState.isSwitcheded,
                                              onChanged: (val) {
                                                setState(() {
                                                  getXSwitchState.changeSwitchState(val);
                                                  ThemeServices().switchTheme();
                                                });
                                              },
                                            ),
                                          )
                                        : i == 7 || i == 6
                                            ? const SizedBox(width: 20)
                                            : Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: SizeConfig.blockSizeVertical * 2,
                                              ),
                                  ],
                                ),
                              ).paddingOnly(bottom: 10, top: 10),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        selectedIndex = 0;
        Get.offAll(const TabsScreen());
        return false;
      },
    );
  }
}
