import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/theme/theme.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';

class PrivacyPolicyProfileScreen extends StatefulWidget {
  const PrivacyPolicyProfileScreen({super.key});

  @override
  State<PrivacyPolicyProfileScreen> createState() => _PrivacyPolicyProfileScreenState();
}

class _PrivacyPolicyProfileScreenState extends State<PrivacyPolicyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: SvgPicture.asset(
            MovixIcon.arrowLeft,
            color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          StringValue.privacyPolicy.tr,
          style: allTitleStyle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 3.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringValue.typesOfDataWeCollect.tr,
                  style: titalstyle,
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                SizedBox(
                  child: Text(
                    StringValue.paragraph.tr,
                    style: GoogleFonts.urbanist(
                      color: (getStorage.read('isDarkMode') == true) ? const Color(0xffE0E0E0) : const Color(0xff424242),
                      fontSize: 12.5,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                Text(
                  StringValue.useOfYourPersonalData.tr,
                  style: titalstyle,
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                SizedBox(
                  child: Text(
                    StringValue.paragraph2.tr,
                    style: GoogleFonts.urbanist(
                      color: (getStorage.read('isDarkMode') == true) ? const Color(0xffE0E0E0) : const Color(0xff424242),
                      fontSize: 12.5,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                Text(
                  StringValue.disclosureOfYourPersonalData.tr,
                  style: titalstyle,
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                SizedBox(
                  child: Text(
                    StringValue.paragraph3.tr,
                    style: GoogleFonts.urbanist(
                      color: (getStorage.read('isDarkMode') == true) ? const Color(0xffE0E0E0) : const Color(0xff424242),
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
