import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/localization/locale_constant.dart';
import 'package:webtime_movie_ocean/localization/localizations_delegate.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  @override
  void initState() {
    getLanguageData();
    // TODO: implement initState
    super.initState();
  }

  LanguageModel? languagesChosenValue;
  String? prefLanguageCode;
  String? prefCountryCode;
  getLanguageData() {
    prefLanguageCode = getStorage.read(LocalizationConstant.selectedLanguage) ?? LocalizationConstant.languageEn;
    prefCountryCode = getStorage.read(LocalizationConstant.selectedCountryCode) ?? LocalizationConstant.countryCodeEn;
    log("prefLanguageCode:::$prefLanguageCode");
    log("prefCountryCode:::$prefCountryCode");
    languagesChosenValue =
        languages.where((element) => (element.languageCode == prefLanguageCode && element.countryCode == prefCountryCode)).toList()[0];
    setState(() {}); // prefLanguageCode = Preference.shared.getString(Preference.selectedLanguage) ?? 'en';
    // prefCountryCode = Preference.shared.getString(Preference.selectedCountryCode) ?? 'US';
    // languagesChosenValue = languages.where((element) => (element.languageCode == prefLanguageCode && element.countryCode == prefCountryCode)).toList()[0];
    // setState(() {});
  }

  onLanguageSave() {
    getStorage.write(LocalizationConstant.selectedLanguage, languagesChosenValue!.languageCode);
    getStorage.write(LocalizationConstant.selectedCountryCode, languagesChosenValue!.countryCode);
    Get.updateLocale(Locale(languagesChosenValue!.languageCode, languagesChosenValue!.countryCode));
    Get.back();
    // Preference.shared.setString(Preference.selectedLanguage, languagesChosenValue!.languageCode);
    // Preference.shared.setString(Preference.selectedCountryCode, languagesChosenValue!.countryCode);
    // Get.updateLocale(Locale(languagesChosenValue!.languageCode, languagesChosenValue!.countryCode));
    // Get.back();
  }

  onChangeLanguage(LanguageModel value) {
    languagesChosenValue = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.scaffoldBg : ColorValues.whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            color: (getStorage.read('isDarkMode') == true) ? ColorValues.appBarColor : ColorValues.whiteColor,
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 5,
            left: 20,
            right: 16,
            bottom: 16,
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.smallContainerBg : Colors.grey.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(11),
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(StringValue.language.tr, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    onLanguageSave();
                  },
                  icon: const Icon(Icons.done)),
              const SizedBox(width: 10)
            ],
          ),
        ),
      ),
      // appBar: AppBar(
      //   toolbarHeight: 60,
      //   backgroundColor:
      //       (getStorage.read('isDarkMode') == true) ? ColorValues.DarkMode_Third.withValues(alpha:0.25) : ColorValues.DarkMode_Third.withValues(alpha:0.03),
      //   leading: IconButton(
      //     icon: Container(
      //       height: 48,
      //       width: 48,
      //       decoration: BoxDecoration(
      //           color: (getStorage.read('isDarkMode') == true)
      //               ? ColorValues.DarkMode_Third.withValues(alpha:0.20)
      //               : ColorValues.DarkMode_Third.withValues(alpha:0.05),
      //           borderRadius: BorderRadius.circular(14)),
      //       child: Center(
      //         child: SvgPicture.asset(
      //           MovixIcon.BackArrowIcon,
      //           color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
      //         ),
      //       ),
      //     ),
      //     onPressed: () {
      //       Get.back();
      //     },
      //   ),
      //   systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.dark),
      //   // backgroundColor: Colors.transparent,
      //   // elevation: 0,
      //   // leading: GestureDetector(
      //   //     child: Image.asset(IconAssetValues.arrowLeft,
      //   //             color: ColorValues.blackColor)
      //   //         .paddingOnly(left: 15),
      //   //     onTap: () => Get.back()),
      //   // leadingWidth: 45,
      //   // centerTitle: AppSettings.isCenterTitle,
      //   title: Text(StringValue.language.tr, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
      //   actions: [
      //     Row(
      //       children: [
      //         IconButton(
      //             onPressed: () {
      //               onLanguageSave();
      //             },
      //             icon: const Icon(Icons.done)),
      //         const SizedBox(width: 10)
      //       ],
      //     )
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            for (int i = 0; i < languages.length; i++)
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 14),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      onChangeLanguage(languages[i]);
                      log("Tapped language: ${languages[i].language} (${languages[i].languageCode}-${languages[i].countryCode})");

                      getStorage.write('selected_language', languages[i].language);
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Container(height: 35, width: 35, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryColor)),
                        // const SizedBox(width: 20),
                        Text(languages[i].language, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w500)),
                        const Spacer(),
                        Transform.scale(
                          scale: 1.3,
                          child: Radio(
                              value: languages[i],
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              activeColor: ColorValues.redColor,
                              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                                return ColorValues.redColor;
                              }),
                              groupValue: languagesChosenValue,
                              onChanged: (value) {
                                setState(() {
                                  onChangeLanguage(value as LanguageModel);

                                  print("language======================${languages[i]}");
                                });
                              }),
                        ),
                      ],
                    ).paddingOnly(bottom: 20, left: 15, right: 15),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
