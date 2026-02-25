import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webtime_movie_ocean/controller/api_controller/handleNotifivationController.dart';
import 'package:webtime_movie_ocean/customModal/themeModal.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/theme/theme.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';

class NotificationProfileScreen extends StatefulWidget {
  const NotificationProfileScreen({super.key});

  @override
  State<NotificationProfileScreen> createState() => _NotificationProfileScreenState();
}

class _NotificationProfileScreenState extends State<NotificationProfileScreen> {
  HandleNotificationController userNotification = Get.put(HandleNotificationController());
  GetXSwitchState getXSwitchState = Get.put(GetXSwitchState());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.scaffoldBg : ColorValues.whiteColor,
      // appBar: AppBar(
      //   toolbarHeight: 70,
      //   elevation: 0,
      //   backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.appBarColor : ColorValues.DarkMode_Third.withValues(alpha:0.03),
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
      //   title: Text(
      //     StringValue.notification.tr,
      //     style: allTitleStyle,
      //   ),
      // ),
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
              Text(
                StringValue.notification.tr,
                style: allTitleStyle,
              ),

              const SizedBox(width: 24), // This balances the row
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 4,
              right: SizeConfig.blockSizeHorizontal * 2,
              top: SizeConfig.blockSizeHorizontal * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 2,
                    ),
                    Text(
                      StringValue.generalNotification.tr,
                      style: titalstyle7,
                    ),
                    const Spacer(),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                          activeColor: ColorValues.greenColor,
                          value: temp.general,
                          onChanged: (val) {
                            temp.general = val;
                            setState(() {
                              getXSwitchState.changeSwitchState(val);
                              notification1 = val;
                              userNotification.getHandleNotification("GeneralNotification");
                            });
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 2,
                    ),
                    Text(
                      StringValue.newReleasesMovie.tr,
                      style: titalstyle7,
                    ),
                    const Spacer(),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                          activeColor: ColorValues.greenColor,
                          value: temp.release,
                          onChanged: (val) {
                            temp.release = val;
                            setState(() {
                              getXSwitchState.changeSwitchState(val);
                              notification4 = val;
                              userNotification.getHandleNotification("NewReleasesMovie");
                            });
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 2,
                    ),
                    Text(
                      StringValue.appUpdates.tr,
                      style: titalstyle7,
                    ),
                    const Spacer(),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                          activeColor: ColorValues.greenColor,
                          value: temp.appupdate,
                          onChanged: (val) {
                            temp.appupdate = val;
                            setState(() {
                              getXSwitchState.changeSwitchState(val);
                              notification5 = val;
                              userNotification.getHandleNotification("AppUpdate");
                            });
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 2,
                    ),
                    Text(
                      StringValue.subscription.tr,
                      style: titalstyle7,
                    ),
                    const Spacer(),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                          activeColor: ColorValues.greenColor,
                          value: temp.subscription,
                          onChanged: (val) {
                            temp.subscription = val;
                            setState(() {
                              getXSwitchState.changeSwitchState(val);
                              notification6 = val;
                              userNotification.getHandleNotification("Subscription");
                            });
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
