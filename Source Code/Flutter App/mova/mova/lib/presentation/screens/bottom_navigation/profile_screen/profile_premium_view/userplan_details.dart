import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/userplan_history/user_plan_history_controller.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';

import '../../../../utils/app_colors.dart';

class UserPlanHistory extends StatefulWidget {
  const UserPlanHistory({super.key});

  @override
  State<UserPlanHistory> createState() => _UserPlanHistoryState();
}

class _UserPlanHistoryState extends State<UserPlanHistory> {
  @override
  Widget build(BuildContext context) {
    UserplanController userPlanController = Get.put(UserplanController());
    setState(() {
      userPlanController.userHistory();
    });

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
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
            StringValue.purchaseHistory.tr,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
            ),
          ),
        ),
        body: GetBuilder<UserplanController>(builder: (controller) {
          return userPlanController.formattedDate.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: userPlanController.userPlanHistoryModel?.history?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            MovixIcon.king,
                            color: ColorValues.redColor,
                            height: SizeConfig.blockSizeVertical * 6,
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 2,
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: "\$${userPlanController.userPlanHistoryModel?.history?[0].dollar.toString() ?? ''}",
                                style: GoogleFonts.urbanist(
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "\\${userPlanController.userPlanHistoryModel?.history?[0].validityType.toString() ?? ''}",
                                style: GoogleFonts.urbanist(
                                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : const Color(0xFF607D8A),
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Image(
                                image: AssetImage(ProfileAssetValues.calender2),
                                height: 20,
                                width: 20,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                userPlanController.formattedDate,
                                style: GoogleFonts.urbanist(
                                  color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.redColor,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.blockSizeVertical * 1,
                              ),
                              const Image(
                                image: AssetImage(ProfileAssetValues.endDate),
                                height: 20,
                                width: 20,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                userPlanController.formattedDate,
                                style: GoogleFonts.urbanist(
                                  color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.redColor,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Container(
                                  height: 30,
                                  width: Get.width / 4.5,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: const Color(0xFFFFF5F6),
                                  ),
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    StringValue.expirePlanDate.tr,
                                    style: GoogleFonts.urbanist(
                                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.redColor : ColorValues.redColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          for (int i = 0; i < (userPlanController.userPlanHistoryModel?.history?[0].planBenefit?.length ?? 0); i++)
                            Row(
                              children: [
                                const Icon(
                                  Icons.done,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: SizeConfig.blockSizeHorizontal * 5,
                                ),
                                SizedBox(
                                  width: 235,
                                  child: Text(
                                    userPlanController.userPlanHistoryModel?.history?[0].planBenefit?[i] ?? '',
                                    overflow: TextOverflow.clip,
                                    maxLines: 4,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 2,
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: ColorValues.redColor,
                  ),
                );
        }));
  }
}
