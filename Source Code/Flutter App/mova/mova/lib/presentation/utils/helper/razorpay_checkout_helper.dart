import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

typedef PaymentSuccessCallback = void Function(PaymentSuccessResponse response);
typedef PaymentErrorCallback = void Function(PaymentFailureResponse response);

class RazorpayCheckoutHelper {
  late Razorpay _razorpay;
  final PaymentSuccessCallback onSuccess;
  final PaymentErrorCallback onError;

  RazorpayCheckoutHelper({required this.onSuccess, required this.onError}) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    onSuccess(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    onError(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External Wallet: ${response.walletName}",
      timeInSecForIosWeb: 4,
    );
  }

  void openCheckout({
    required String amount,
    required String description,
    String contact = "",
    String email = "",
  }) {
    var options = {
      "key": razorPaySecretKey,
      "amount": (double.parse(amount) * 100).toInt(), // Razorpay expects amount in paise (100 paise = 1 unit)
      "name": "WebTime Movie Ocean",
      "description": description,
      "prefill": {
        "contact": contact,
        "email": email,
      },
      "external": {
        "wallets": ["gpay"]
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      log("Razorpay error: ${e.toString()}");
      Fluttertoast.showToast(
        msg: "Error opening checkout: $e",
        backgroundColor: ColorValues.redColor,
        textColor: ColorValues.whiteColor,
      );
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
