// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/premiumPlancreateHistory_api/createPremium_contoller.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/tabs_screen.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';

class RazorPay extends StatefulWidget {
  String planid;

  RazorPay({super.key, required this.planid});

  @override
  State<RazorPay> createState() => _RazorPayState();
}

class _RazorPayState extends State<RazorPay> {
  final GlobalKey<FormState> payment = GlobalKey<FormState>();

  TextEditingController amountController = TextEditingController();
  CreatePremiumController createPremiumPlan =
      Get.put(CreatePremiumController());
  late Razorpay razorpay;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, paymentWallet);
    });
    razorpay = Razorpay();

    openCheckout();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void paymentSuccess() {
    createPremiumPlan.createPremiumData(userId, "Razorpay", widget.planid);
    selectedIndex = 0;
    Get.offAll(
      const TabsScreen(),
    );
    log("Payment Success");
    Toast.show(StringValue.paymentSuccess.tr);
  }

  void paymentError() {
    log("Payment Error");
    Toast.show(StringValue.paymentError.tr);
  }

  void paymentWallet() {
    log("Payment External Wallet");
    Toast.show(StringValue.paymentExternalWallet.tr);
  }

  void openCheckout() {
    var options = {
      "key": "rzp_live_QEJM1AlKufkctY",
      "amount": num.parse("1") * 100,
      "name": "WebTime Movie Ocean",
      "description": "Payment For any product",
      "prefill": {
        "contact": "",
        "email": "",
      },
      "external": {
        "wallets": ["gpay"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(StringValue.razorPay.tr),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void createOrder() async {
    // String username = razorpayCredential.keyId;
    // String password = razorpayCredential.keySecret;
  }
}
