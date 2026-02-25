// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'dart:developer';

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/premiumPlancreateHistory_api/premium_plan_create_history_controller.dart';

/// commentsList Getx Controller ///
class CreatePremiumController extends GetxController {
  var isLoading = true.obs;
  RxBool isLoadingSheet = false.obs;

  createPremiumData(String userId, String paymentGateway, String premiumPlanId) async {
    try {
      isLoading(true);
      var commentsListData = await PremiumPlanCreateHistoryProvider.premiumPlanCreateHistoryProvider(userId, paymentGateway, premiumPlanId);
      log("commentsListData $commentsListData");
    } finally {
      isLoading(false);
    }
  }
}
