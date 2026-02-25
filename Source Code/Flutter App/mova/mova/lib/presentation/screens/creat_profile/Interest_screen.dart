import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/screens/creat_profile/creat_profile_screen.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:provider/provider.dart';

import '../../../buinesslogic/apiservice/chekuser_api/fetch_profile_provider.dart';
import '../../../buinesslogic/apiservice/creat_user/creat_user_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_string.dart';
import '../../utils/app_var.dart';
import '../../utils/routes/app_pages.dart';
import '../../utils/theme/theme.dart';
import '../../widget/interest_button.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  CreateUserController createUserController = Get.put(CreateUserController());
  bool like = false;

  @override
  Widget build(BuildContext context) {
    final userprofile = Provider.of<FetchProfileProvider>(context, listen: false);
    SizeConfig().init(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5, left: SizeConfig.blockSizeHorizontal * 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    MovixIcon.arrowLeft,
                    height: SizeConfig.blockSizeVertical * 4,
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 3,
                ),
                Text(
                  StringValue.chooseInterest.tr,
                  style: chooseInterestStyle,
                ),
              ],
            ),
          ),
          SizedBox(height: Get.height / 35),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6, right: SizeConfig.blockSizeHorizontal * 3),
            child: Text(
              StringValue.chooseEasy.tr,
              style: titalstyle2,
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              children: [
                Filter_Buttons(text: StringValue.action.tr),
                Filter_Buttons(text: StringValue.drama.tr),
                Filter_Buttons(text: StringValue.comedy.tr),
                Filter_Buttons(text: StringValue.horror.tr),
                Filter_Buttons(text: StringValue.adventure.tr),
                Filter_Buttons(text: StringValue.thriller.tr),
                Filter_Buttons(text: StringValue.romance.tr),
                Filter_Buttons(text: StringValue.science.tr),
                Filter_Buttons(text: StringValue.music.tr),
                Filter_Buttons(text: StringValue.documentary.tr),
                Filter_Buttons(text: StringValue.crime.tr),
                Filter_Buttons(text: StringValue.fantasy.tr),
                Filter_Buttons(text: StringValue.mystery.tr),
                Filter_Buttons(text: StringValue.fiction.tr),
                Filter_Buttons(text: StringValue.animation.tr),
                Filter_Buttons(text: StringValue.war.tr),
                Filter_Buttons(text: StringValue.history.tr),
                Filter_Buttons(text: StringValue.television.tr),
                Filter_Buttons(text: StringValue.superheroes.tr),
                Filter_Buttons(text: StringValue.anime.tr),
                Filter_Buttons(text: StringValue.sports.tr),
                Filter_Buttons(text: StringValue.kDrama.tr),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 2.5, right: SizeConfig.blockSizeHorizontal * 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    height: Get.height / 15,
                    width: Get.width / 2.5,
                    decoration: BoxDecoration(
                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.darkModeThird : ColorValues.skipColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      StringValue.skip.tr,
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.redColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    userprofile.onGetProfile();
                    Get.offAllNamed(Routes.fillYourProfile);
                  },
                ),
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    height: Get.height / 15,
                    width: Get.width / 2.5,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: ColorValues.shadowRedColor,
                          blurRadius: 24,
                          offset: Offset(4, 8),
                        ),
                      ],
                      color: ColorValues.redColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      StringValue.Continue.tr,
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: ColorValues.whiteColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(const FillYourProfileScreen());
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 5),
        ],
      ),
    );
  }
}
