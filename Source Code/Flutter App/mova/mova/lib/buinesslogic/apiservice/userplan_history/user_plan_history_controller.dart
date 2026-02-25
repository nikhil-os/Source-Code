import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/userplan_history/user_plan_history_service.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/userplan_history/userplanhistrory_model.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

class UserplanController extends GetxController {
  UserplanhistroryModel? userPlanHistoryModel;
  RxBool isLoading = true.obs;
  String formattedDate = "";
  String formattedDate1 = "";

  @override
  void onInit() {
    userHistory();
    super.onInit();
  }

  void userHistory() async {
    try {
      var data = await userPlanHistoryService.callApi(userId);
      userPlanHistoryModel = data;
      log("userplanHistorylength ::: ${data?.history?.length}");
      log("UserPlanHoistory :: ${data?.history?[0].validityType} ");
      final planHistory = data?.history.toString();
      log("planHistory :: $planHistory");

      final startTime = data?.history?[0].planStartDate.toString();
      DateTime dateTime = DateFormat("M/d/yyyy, hh:mm:ss a").parse(startTime!);
      formattedDate = DateFormat("M/d/yyyy").format(dateTime);

      final endTime = data?.history?[0].planStartDate.toString();
      DateTime dateTime1 = DateFormat("M/d/yyyy, hh:mm:ss a").parse(endTime!);
      formattedDate1 = DateFormat("M/d/yyyy").format(dateTime1);

      log("start date :: $formattedDate");
      log("End Date :: $formattedDate1");
      isLoading(true);
      update();
    } catch (e) {
      isLoading(false);
      log("userPlanHistoryError  :: $e");
    }
  }
}
