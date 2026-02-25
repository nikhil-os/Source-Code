// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/handle_notification_api/handle_notification_modal.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/handle_notification_api/handle_nottification_api_controller.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

/// HandleNotification  Getx Controller ///
class HandleNotificationController extends GetxController {
  var isLoading = true.obs;
  HandleNotificationModal? notificationDataList;

  getHandleNotification(String? type) async {
    try {
      isLoading(true);
      var getHandleNotificationData = await HandleNotificationProvider.handleNotification(type);

      if (getHandleNotificationData != null) {
        notificationDataList = getHandleNotificationData;

        notification1 = notificationDataList!.user!.notification!.generalNotification!;
        notification4 = notificationDataList!.user!.notification!.newReleasesMovie!;
        notification5 = notificationDataList!.user!.notification!.appUpdate!;
        notification6 = notificationDataList!.user!.notification!.subscription!;
      }
    } finally {
      isLoading(false);
    }
  }
}
