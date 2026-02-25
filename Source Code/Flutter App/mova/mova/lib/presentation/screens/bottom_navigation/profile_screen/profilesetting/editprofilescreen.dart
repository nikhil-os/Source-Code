// ignore_for_file: avoid_print
import 'dart:developer';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/chekuser_api/fetch_profile_provider.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/update_user/update_user_controller.dart';
import 'package:webtime_movie_ocean/custom/custom_text_field.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_class.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/database.dart';
import 'package:webtime_movie_ocean/presentation/utils/routes/app_pages.dart';
import 'package:webtime_movie_ocean/presentation/utils/theme/theme.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../controller/api_controller/file_upload/file_upload_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final List<String> genderItems = [
    'Male',
    'Female',
  ];

  @override
  void initState() {
    super.initState();
    emailController.text = userEmail2;
    nameController.text = userName2;
    nickNameController.text = userNickName2;
    countryController.text = userCountry2;
    selectedValue = userGender2;
    imagePicker = ImagePicker();
    updateProfileImage = null;

    log("User Id :: $userId");
    log("Edit profile in :: ${getStorage.read("updatedNewDp")}");
  }

  dynamic imagePicker;
  dynamic type;

  FileUploadController fileUploadController = Get.put(FileUploadController());

  bool indicator = true;

  @override
  Widget build(BuildContext context) {
    final updateUser = Provider.of<UpdateUserProvider>(context, listen: false);
    final userprofile =
        Provider.of<FetchProfileProvider>(context, listen: false);
    SizeConfig().init(context);

    Future<void> refreshProfileData() async {
      userprofile.data;
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        userprofile.data['user']['image'];
      });
    }

    return Scaffold(
      backgroundColor: (getStorage.read('isDarkMode') == true)
          ? ColorValues.scaffoldBg
          : ColorValues.whiteColor,
      body: RefreshIndicator(
        onRefresh: refreshProfileData,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                  .copyWith(top: 35),
              color: (getStorage.read('isDarkMode') == true)
                  ? ColorValues.appBarColor
                  : ColorValues.darkModeThird.withValues(alpha: 0.03),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      updateProfileImage = null;
                      Get.back();
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                          color: (getStorage.read('isDarkMode') == true)
                              ? ColorValues.smallContainerBg
                              : ColorValues.darkModeThird
                                  .withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(14)),
                      child: Center(
                        child: SvgPicture.asset(
                          MovixIcon.backArrowIcon,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            (getStorage.read('isDarkMode') == true)
                                ? ColorValues.whiteColor
                                : ColorValues.blackColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(StringValue.editProfile.tr, style: fillProfileStyle),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            XFile image = await imagePicker.pickImage(
                                source: ImageSource.gallery, imageQuality: 50);
                            setState(() {
                              updateProfileImage = File(image.path);
                              getStorage.write(
                                  "updatedNewDp", updateProfileImage);
                            });
                            await fileUploadController.submit(
                                profileImage: updateProfileImage!);
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: (getStorage.read('isDarkMode') ==
                                                true)
                                            ? ColorValues.whiteColor
                                            : ColorValues.darkModeMain,
                                        width: 2),
                                    shape: BoxShape.circle),
                                child: Container(
                                  height: 115,
                                  width: 115,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        (getStorage.read('isDarkMode') == true)
                                            ? ColorValues.darkModeMain
                                            : ColorValues.whiteColor,
                                  ),
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: ClipOval(
                                      child: updateProfileImage == null
                                          ? Database.fetchProfileModel?.user
                                                      ?.image !=
                                                  null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Obx(
                                                    () => PreviewNetworkImage(
                                                      id: Database
                                                              .fetchProfileModel
                                                              ?.user
                                                              ?.id ??
                                                          "",
                                                      image: Database
                                                          .profileImage.value,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  height: 124,
                                                  width: 124,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle),
                                                  child: Image.asset(
                                                      AssetValues.noProfile,
                                                      fit: BoxFit.cover),
                                                )
                                          : Container(
                                              height: 124,
                                              width: 124,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle),
                                              child: Image.file(
                                                  updateProfileImage!,
                                                  fit: BoxFit.cover),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 3,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: getStorage.read('isDarkMode') == true
                                        ? Colors.black
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    height: 32,
                                    width: 32,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: ColorValues.redColor,
                                        shape: BoxShape.circle),
                                    child: SvgPicture.asset(
                                      MovixIcon.cameraFill,
                                      height: 18,
                                      width: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        StringValue.enterName.tr,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: (getStorage.read('isDarkMode') == true)
                              ? ColorValues.grayColorText
                              : ColorValues.blackColor,
                        ),
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        controller: nameController,
                        hintText: StringValue.name.tr,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        StringValue.lastName.tr,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: (getStorage.read('isDarkMode') == true)
                              ? ColorValues.grayColorText
                              : ColorValues.blackColor,
                        ),
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        controller: nickNameController,
                        hintText: StringValue.name.tr,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        StringValue.enterMailId.tr,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: (getStorage.read('isDarkMode') == true)
                              ? ColorValues.grayColorText
                              : ColorValues.blackColor,
                        ),
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        controller: emailController,
                        hintText: StringValue.email.tr,
                        textInputAction: TextInputAction.done,
                        readOnly: true,
                        suffixIcon: SvgPicture.asset(
                          height: 25,
                          MovixIcon.email,
                          colorFilter: ColorFilter.mode(
                            (getStorage.read('isDarkMode') == true)
                                ? ColorValues.whiteColor
                                : ColorValues.blackColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(StringValue.selectCountry.tr,
                          style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: (getStorage.read('isDarkMode') == true)
                                  ? ColorValues.grayColorText
                                  : ColorValues.blackColor)),
                      const SizedBox(height: 14),
                      CustomTextField(
                        enabled: false,
                        controller: countryController,
                        hintText: StringValue.selectCountry.tr,
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: (getStorage.read('isDarkMode') == true)
                              ? ColorValues.whiteColor
                              : ColorValues.blackColor,
                        ),
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            exclude: <String>['KN', 'MF'],
                            showPhoneCode: false,
                            onSelect: (Country country) {
                              setState(() {
                                countryController.text = country.name;
                              });
                            },
                            countryListTheme: CountryListThemeData(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40.0),
                                topRight: Radius.circular(40.0),
                              ),
                              inputDecoration: InputDecoration(
                                hintText: StringValue.search.tr,
                                prefixIcon: const Icon(Icons.search),
                                border: InputBorder.none,
                              ),
                            ),
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
      bottomNavigationBar: InkWell(
        child: Container(
          alignment: Alignment.center,
          height: 60,
          width: Get.width,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColorValues.buttonColorRed,
            borderRadius: BorderRadius.circular(30),
          ),
          child: (indicator)
              ? Text(StringValue.update.tr,
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: ColorValues.whiteColor))
              : const CircularProgressIndicator(color: ColorValues.whiteColor),
        ),
        onTap: () async {
          if (nameController.text.isEmpty || nickNameController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 300),
                backgroundColor: ColorValues.redColor,
                content: Text(
                  StringValue.fillYourDetails.tr,
                  style: const TextStyle(color: ColorValues.whiteColor),
                ),
              ),
            );
          } else {
            setState(() {
              indicator = false;
            });
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                indicator = true;
              });
            });
            Get.dialog(
              barrierColor: ColorValues.blackColor.withValues(alpha: 0.8),
              Dialog(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 60),
                child: Container(
                  height: 370,
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (getStorage.read('isDarkMode') == true)
                        ? ColorValues.darkModeSecond
                        : ColorValues.whiteColor,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Container(
                        height: 150,
                        width: 150,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AssetValues.profileDone),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringValue.congratulations.tr,
                        style: GoogleFonts.outfit(
                            color: ColorValues.redColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        StringValue.updateProfile.tr,
                        style: accountReadyStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const SpinKitCircle(
                          color: ColorValues.redColor, size: 50),
                    ],
                  ),
                ),
              ),
            );

            userEmail2 = emailController.text;
            userName2 = nameController.text;
            userNickName2 = nickNameController.text;
            userCountry2 = countryController.text;
            userGender2 = selectedValue!;

            SharedPreferences pref = await SharedPreferences.getInstance();

            log("File Upload imagge :: ${fileUploadController.updatedNewDp}");
            log("nameController :: ${nameController.text}");
            log("nickNameController :: ${nickNameController.text}");
            log("countryController :: ${countryController.text}");
            log("selectedValue :: $selectedValue");
            log("userid :: $userId");

            await updateUser.updateUserDetails(
              image: fileUploadController.updatedNewDp,
              name: nameController.text,
              nicknames: nickNameController.text,
              country: countryController.text,
              gender: selectedValue,
            );

            final userProfile =
                Provider.of<FetchProfileProvider>(context, listen: false);
            await userProfile.onGetProfile();

            await pref.setString("userName2", nameController.text);
            userName2 = pref.getString("userName2")!;
            await pref.setString("userNickName2", nickNameController.text);
            userNickName2 = pref.getString("userNickName2")!;
            await pref.setString("userCountry2", countryController.text);
            userCountry2 = pref.getString("userCountry2")!;
            await pref.setString("userGender2", selectedValue!);
            userGender2 = pref.getString("userGender2")!;

            Get.offAllNamed(Routes.tabs);
            selectedIndex = 4;
          }
        },
      ),
    );
  }
}
