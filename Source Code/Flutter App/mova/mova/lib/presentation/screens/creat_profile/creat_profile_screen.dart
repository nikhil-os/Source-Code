// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/app_url.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/chekuser_api/fetch_profile_provider.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/update_user/update_user_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/file_upload/file_upload_controller.dart';
import 'package:webtime_movie_ocean/custom/custom_text_field.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/routes/app_pages.dart';
import 'package:webtime_movie_ocean/presentation/utils/theme/theme.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FillYourProfileScreen extends StatefulWidget {
  const FillYourProfileScreen({super.key});

  @override
  State<FillYourProfileScreen> createState() => _FillYourProfileScreenState();
}

class _FillYourProfileScreenState extends State<FillYourProfileScreen> {
  final List<String> genderItems = [
    'Male',
    'Female',
  ];
  String? selectedValue;
  String? selectedCountryValue;
  String? updateImage;

  @override
  void initState() {
    super.initState();
    emailController.text = userEmail;
    nameController.text = userName;
    countryController.text = userCountry;
    nickNameController.text = userNickName;
    selectedValue = userGender;
    updateImage = userImage;
    imagePicker = ImagePicker();

    // emailController.text = email;
    // nameController.text = name;
    // countryController.text = country;
    // nickNameController.text = nickName;
    // selectedValue = gender;
    // imagePicker = ImagePicker();
  }

  dynamic imagePicker;
  dynamic type;
  FileUploadController fileUploadController = Get.put(FileUploadController());

  @override
  Widget build(BuildContext context) {
    print("updateImage/*********$updateImage");
    final updateUser = Provider.of<UpdateUserProvider>(context, listen: false);
    final userprofile =
        Provider.of<FetchProfileProvider>(context, listen: false);
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: 15, right: 15, top: SizeConfig.blockSizeVertical * 5),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => Get.offAllNamed(Routes.letsYouIn),
                    child: SvgPicture.asset(
                      MovixIcon.arrowLeft,
                      width: 32,
                      height: 32,
                      color: (getStorage.read('isDarkMode') == true)
                          ? ColorValues.whiteColor
                          : ColorValues.blackColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    StringValue.fillProfile.tr,
                    style: fillProfileStyle,
                  ),
                ],
              ),
              SizedBox(height: Get.height / 30),

              /// Edit Profile Image ///
              GestureDetector(
                onTap: () async {
                  XFile image = await imagePicker.pickImage(
                      source: ImageSource.gallery, imageQuality: 50);
                  setState(() {
                    updateProfileImage = File(image.path);
                  });
                  await fileUploadController.submit(
                      profileImage: updateProfileImage!);
                },
                child: Container(
                  height: 124,
                  width: 124,
                  decoration: BoxDecoration(
                    color: (getStorage.read('isDarkMode') == true)
                        ? ColorValues.darkModeMain
                        : ColorValues.whiteColor,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      updateProfileImage == null
                          ? updateImage == null
                              ? Container(
                                  height: 124,
                                  width: 124,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: Image.asset(AssetValues.noProfile,
                                      fit: BoxFit.cover),
                                )
                              : Container(
                                  height: 124,
                                  width: 124,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: Image.network(updateImage ?? "",
                                      fit: BoxFit.cover),
                                )
                          : Container(
                              height: 124,
                              width: 124,
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: Image.file(updateProfileImage!,
                                  fit: BoxFit.cover),
                            ),
                      Positioned(
                        bottom: 20,
                        right: 0,
                        child: Container(
                          height: 22,
                          width: 22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorValues.redColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: (getStorage.read('isDarkMode') == true)
                                ? ColorValues.blackColor
                                : ColorValues.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Get.height / 20),
              CustomTextField(
                controller: nameController,
                hintText: StringValue.name.tr,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: nickNameController,
                hintText: StringValue.nickName.tr,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: TextEditingController(text: userEmail),
                hintText: StringValue.email.tr,
                textInputAction: TextInputAction.done,
                suffixIcon: SvgPicture.asset(
                  height: 25,
                  MovixIcon.email,
                  color: (getStorage.read('isDarkMode') == true)
                      ? ColorValues.whiteColor
                      : ColorValues.blackColor,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                enabled: false,
                controller: countryController,
                hintText: StringValue.selectCountry.tr,
                suffixIcon: SvgPicture.asset(
                  MovixIcon.boldArrowDown,
                  height: 25,
                  width: 25,
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
      bottomNavigationBar: InkWell(
        onTap: () async {
          log("***************** Click On Continue Button ****************");

          userprofile.onGetProfile();
          getStorage.write("updatedNewDp", userprofile.data);

          if (nameController.text.isEmpty ||
              nickNameController.text.isEmpty ||
              countryController.text.isEmpty ||
              genderItems.isEmpty) {
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
            log("image :: ${fileUploadController.updatedNewDp}");
            log("name :: ${nameController.text}");
            log("nick name :: ${nickNameController.text}");
            log("country :: ${countryController.text}");
            log("selected value  :: $selectedValue");

            await updateUser.updateUserDetails(
              image: fileUploadController.updatedNewDp,
              name: nameController.text,
              nicknames: nickNameController.text,
              country: countryController.text,
              gender: selectedValue,
            );

            SharedPreferences pref = await SharedPreferences.getInstance();

            await pref.setString(
                "userName2", updateUser.data['user']['fullName']);
            userName2 = await updateUser.data['user']['fullName'];
            await pref.setString(
                "userNickName2", updateUser.data['user']['nickName']);
            userNickName2 = await updateUser.data['user']['nickName'];
            await pref.setString(
                "userGender2", updateUser.data['user']['gender']);
            userGender2 = await updateUser.data['user']['gender'];
            await pref.setString(
                "userCountry2", updateUser.data['user']['country']);
            userCountry2 = await updateUser.data['user']['country'];
            await pref.setString(
                "userEmail2", updateUser.data['user']['email']);
            userEmail2 = await updateUser.data['user']['email'];
            await pref.setString(
                "userProfileImage", updateUser.data['user']['image']);

            userProfileImage = pref.getString("userProfileImage")!;
            log("userprofileimage  :: $userProfileImage");
            Get.dialog(
              barrierColor: ColorValues.blackColor.withValues(alpha: 0.8),
              Dialog(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 45),
                child: Container(
                  height: 400,
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
                        style: GoogleFonts.urbanist(
                            color: ColorValues.redColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        StringValue.accountReady.tr,
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
            Timer(
              const Duration(seconds: 2),
              () {
                selectedIndex = 0;
                Get.offAllNamed(Routes.tabs);
              },
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: Get.height / 15,
          width: Get.width,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
          child: (indicator)
              ? Text(
                  StringValue.Continue.tr,
                  style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: ColorValues.whiteColor),
                )
              : const CircularProgressIndicator(color: ColorValues.whiteColor),
        ),
      ),
    );
  }
}
