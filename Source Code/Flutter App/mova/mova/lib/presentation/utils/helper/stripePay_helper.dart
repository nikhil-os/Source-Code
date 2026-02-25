// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/buinesslogic/apiservice/premiumPlancreateHistory_api/createPremium_contoller.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/tabs_screen.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

CreatePremiumController createPremiumPlan = Get.put(CreatePremiumController());

class StripeService {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment({required String amount, required String currency, required String planId}) async {
    try {
      createPremiumPlan.isLoadingSheet.value = true;
      createPremiumPlan.update();

      debugPrint("Start Payment");
      paymentIntentData = await createPaymentIntent(amount, currency);

      debugPrint("After payment intent");
      print(paymentIntentData);
      if (paymentIntentData != null) {
        debugPrint("payment intent is not null .........");
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            customFlow: true,
            merchantDisplayName: 'Prospects',
            customerId: paymentIntentData!['customer'],
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            style: ThemeMode.dark,
          ),
        );
        debugPrint(" initPaymentSheet  .........");
        displayPaymentSheet(planId);
        log("Display method id :: $displayPaymentSheet");
      }
    } catch (e, s) {
      debugPrint("After payment intent Error: ${e.toString()}");
      debugPrint("After payment intent s Error: ${s.toString()}");
    } finally {
      createPremiumPlan.isLoadingSheet.value = false;
      createPremiumPlan.update();
    }
  }

  displayPaymentSheet(String planId) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Fluttertoast.showToast(
        msg: 'Payment Successful',
        fontSize: 15,
        backgroundColor: ColorValues.redColor,
        textColor: ColorValues.whiteColor,
      );
      updateUserPlan(planId);
    } on Exception catch (e) {
      if (e is StripeException) {
        debugPrint("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        debugPrint("Unforcen Error: $e");
      }
    } catch (e) {
      debugPrint("Exception $e");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculate(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      debugPrint("Start Payment Intent http rwq post method");

      var response = await http.post(Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body, headers: {"Authorization": "Bearer $SECRET_KEY", "Content-Type": 'application/x-www-form-urlencoded'});
      debugPrint("End Payment Intent http rwq post method");
      debugPrint("secret key :: $SECRET_KEY");
      debugPrint("creadit card response ${response.body.toString()}");

      return jsonDecode(response.body);
    } catch (e) {
      debugPrint('err charging user: ${e.toString()}');
    }
  }

  calculate(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  updateUserPlan(String planId) async {
    createPremiumPlan.isLoadingSheet.value = true;
    createPremiumPlan.update();

    createPremiumPlan.createPremiumData(userId, "Stripe Pay", planId);
    selectedIndex = 0;

    createPremiumPlan.isLoadingSheet.value = false;
    createPremiumPlan.update();

    Get.offAll(
      const TabsScreen(),
    );
  }
}
