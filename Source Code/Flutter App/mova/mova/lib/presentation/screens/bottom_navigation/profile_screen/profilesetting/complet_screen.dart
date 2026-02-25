import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/complain_api/controller/complent_controller.dart';
import 'package:webtime_movie_ocean/controller/api_controller/file_upload/file_upload_controller.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:provider/provider.dart';

class ComplainScreen extends StatefulWidget {
  const ComplainScreen({super.key});

  @override
  State<ComplainScreen> createState() => _Complain_ScreenState();
}

class _Complain_ScreenState extends State<ComplainScreen> {
  TextEditingController userMessageController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  FileUploadController fileuploadController = Get.put(FileUploadController());

  ImagePicker picker = ImagePicker();
  @override
  void initState() {
    updateProfileImage = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userComplain =
        Provider.of<userComplainProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: SvgPicture.asset(
            MovixIcon.arrowLeft,
            color: (getStorage.read('isDarkMode') == true)
                ? ColorValues.whiteColor
                : ColorValues.blackColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          StringValue.complainRequest.tr,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: (getStorage.read('isDarkMode') == true)
                ? ColorValues.whiteColor
                : ColorValues.blackColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        setState(() {
                          updateProfileImage = File(image!.path);
                        });
                        await fileuploadController.submit(
                            profileImage: updateProfileImage!);
                      },
                      child: updateProfileImage == null
                          ? DottedBorder(
                              color: ColorValues.redColor,
                              radius: const Radius.circular(20.0),
                              borderType: BorderType.RRect,
                              child: Container(
                                  height: 230,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Image(
                                        image: AssetImage(
                                            IconAssetValues.uploadImage),
                                        height: 45,
                                        width: 45,
                                      ),
                                      Text(
                                        StringValue.uploadScreenshot.tr,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: (getStorage
                                                        .read('isDarkMode') ==
                                                    true)
                                                ? ColorValues.redColor
                                                : ColorValues.redColor,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Urbanist"),
                                      )
                                    ],
                                  )),
                            )
                          : Container(
                              height: 200,
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(updateProfileImage!),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: (getStorage.read('isDarkMode') == true)
                            ? ColorValues.whiteColor
                            : const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        cursorColor: const Color(0xff979797),
                        controller: phoneNumberController,
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                          color: Color(0xff979797),
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: StringValue.enterYourMobileNumber.tr,
                          hintStyle: const TextStyle(
                            color: Color(0xff979797),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: (getStorage.read('isDarkMode') == true)
                            ? ColorValues.whiteColor
                            : const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        cursorColor: const Color(0xff979797),
                        controller: userMessageController,
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                          color: Color(0xff979797),
                          fontSize: 15,
                        ),
                        maxLines: 6,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                            top: 10,
                          ),
                          border: InputBorder.none,
                          hintText: StringValue.enterTheQuery.tr,
                          hintStyle: const TextStyle(
                            color: Color(0xff979797),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (userMessageController.text.isEmpty ||
                            phoneNumberController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: ColorValues.redColor,
                              duration: const Duration(
                                milliseconds: 1000,
                              ),
                              content: Text(StringValue.pleaseEnterTheFields.tr,
                                  style: const TextStyle(
                                      color: ColorValues.whiteColor)),
                            ),
                          );
                        } else {
                          await Fluttertoast.showToast(
                            msg: StringValue.pleaseWait.tr,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.SNACKBAR,
                            timeInSecForIosWeb: 1,
                            backgroundColor: ColorValues.redColor,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );

                          log("image :: ${fileuploadController.updatedNewDp}");
                          log("message :: ${userMessageController.text.toString()}");
                          log("contact :: ${phoneNumberController.text.toString()}");

                          await userComplain.updateUserComplainDetails(
                            image: fileuploadController.updatedNewDp,
                            contactNumber:
                                phoneNumberController.text.toString(),
                            description: userMessageController.text.toString(),
                          );
                          phoneNumberController.clear();
                          userMessageController.clear();
                          updateProfileImage = null;
                          setState(() {});

                          Fluttertoast.showToast(
                            msg: StringValue.ticketHasBeenSentSuccessfully.tr,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.SNACKBAR,
                            timeInSecForIosWeb: 1,
                            backgroundColor: ColorValues.redColor,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: Get.height / 15.10,
                        width: Get.width / 1.1,
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
                                StringValue.submit.tr,
                                style: const TextStyle(
                                  color: ColorValues.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : const CircularProgressIndicator(
                                color: ColorValues.whiteColor,
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
    );
  }
}
