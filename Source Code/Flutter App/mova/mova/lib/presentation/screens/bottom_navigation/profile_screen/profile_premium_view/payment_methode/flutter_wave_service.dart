import 'dart:developer';

import 'package:flutterwave_standard/flutterwave.dart';
import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/premiumPlancreateHistory_api/createPremium_contoller.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

class FlutterWaveService {
  CreatePremiumController createPremiumPlan =
      Get.put(CreatePremiumController());

  Future handlePaymentSuccess(String planId) async {
    String? selectTime;
    createPremiumPlan.createPremiumData(userId, "Flutter Wave", planId);

    log("selectTime :: $selectTime");
  }

  void handlePaymentInitialization(
      {required String amount,
      required String currency,
      required String planId}) async {
    createPremiumPlan.isLoadingSheet.value = true;
    createPremiumPlan.update();

    final Customer customer =
        Customer(name: "Flutterwave Developer", email: "customer@customer.com");

    log("Flutter Wave Start");
    final Flutterwave flutterwave = Flutterwave(
        publicKey: flutterWaveId,
        currency: currency,
        redirectUrl: "https://www.google.com/",
        txRef: DateTime.now().microsecond.toString(),
        amount: amount,
        customer: customer,
        paymentOptions: "ussd, card, barter, payattitude",
        customization: Customization(title: "WebTime Movie Ocean"),
        isTestMode: true);
    log("Flutter Wave Finish");
    final ChargeResponse response = await flutterwave.charge(Get.context!);
    log("Flutter Wave ----------- ");
    log("Payment ${response.status.toString()}");

    if (response.success == true) {
      handlePaymentSuccess(planId);
    }
    log("Flutter Wave Response :: ${response.toString()}");

    createPremiumPlan.isLoadingSheet.value = false;
    createPremiumPlan.update();
  }
}
