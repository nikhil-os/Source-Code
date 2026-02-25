import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/tabs_screen.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

class CardPayment extends StatefulWidget {
  const CardPayment({super.key});

  @override
  _CardPaymentState createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(StringValue.stripePayment.tr),
      ),
      body: Center(
        child: TextButton(
          child: Text(StringValue.makePayment.tr),
          onPressed: () async {
            await makePayment();
          },
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10', 'USD');
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntent!['client_secret'], style: ThemeMode.dark, merchantDisplayName: 'Adnan'),
          )
          .then((value) {});

      ///now finally display payment sheet
      displayPaymentSheet();
    } catch (e, s) {
      log('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text(StringValue.paymentSuccessfully.tr),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          selectedIndex = 0;
                          Get.offAll(
                            const TabsScreen(),
                          );
                        },
                        child: Text(StringValue.ok.tr),
                      ),
                    ],
                  ),
                ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        log('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      log('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text(StringValue.cancelled.tr),
              ));
    } catch (e) {
      log('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {'amount': calculateAmount(amount), 'currency': currency, 'payment_method_types[]': 'card'};

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {'Authorization': 'Bearer $SECRET_KEY', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      log('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      log('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
