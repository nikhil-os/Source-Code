import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/premiumPlancreateHistory_api/createPremium_contoller.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profile_premium_view/payment_methode/flutter_wave_service.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/profile_screen/profile_premium_view/payment_methode/in_app_purchase/in_app_purchase_helper.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/tabs_screen.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/helper/stripePay_helper.dart';
import 'package:webtime_movie_ocean/presentation/utils/theme/theme.dart';
import 'package:webtime_movie_ocean/presentation/widget/nativads.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethod extends StatefulWidget {
  final String planId;
  final String planPrice;
  final String productKey;

  const PaymentMethod(
      {super.key,
      required this.planId,
      required this.planPrice,
      required this.productKey});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> implements IAPCallback {
  String? payment;
  Map<String, dynamic>? paymentIntent;
  late Razorpay razorpay;
  CreatePremiumController createPremiumPlan =
      Get.put(CreatePremiumController());
  CardEditController cardEditController = CardEditController();

  var stripePayController = StripeService();

  @override
  void initState() {
    super.initState();
    cardEditController.addListener(update);

    ///  Razor Pay all Event ///
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void update() => setState(() {});

  @override
  void dispose() {
    cardEditController.removeListener(update);
    cardEditController.dispose();
    super.dispose();
    razorpay.clear();
  }

  @override
  void onBillingError(error) {
    log("IAP Billing Error: $error");
    Fluttertoast.showToast(
      msg: 'Payment failed: $error',
      fontSize: 15,
      backgroundColor: ColorValues.redColor,
      textColor: ColorValues.whiteColor,
    );
  }

  @override
  void onLoaded(bool initialized) {
    log("IAP Loaded: $initialized");
  }

  @override
  void onPending(PurchaseDetails product) {
    log("IAP Pending: ${product.productID}");
    Fluttertoast.showToast(
      msg: 'Payment is pending...',
      fontSize: 15,
      backgroundColor: ColorValues.redColor,
      textColor: ColorValues.whiteColor,
    );
  }

  @override
  void onSuccessPurchase(PurchaseDetails product) async {
    log("IAP Success: ${product.productID}");

    try {
      Fluttertoast.showToast(msg: "Payment Successful", timeInSecForIosWeb: 4);
      createPremiumPlan.createPremiumData(
          userId, "In app purchase", widget.planId);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("isPremiumPlan", true);
      setState(() {
        isPremiumPlan = true;
      });
      log("User is after Premium $isPremiumPlan");
      selectedIndex = 0;
      Get.offAll(
        const TabsScreen(),
      );
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      log("API call failed: $e");
      Fluttertoast.showToast(
        msg: 'Payment error $e',
        fontSize: 15,
        backgroundColor: ColorValues.redColor,
        textColor: ColorValues.whiteColor,
      );
    }
  }

  /// Razor Pay Success function ///
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(msg: "Payment Successful", timeInSecForIosWeb: 4);
    createPremiumPlan.createPremiumData(userId, "Razorpay", widget.planId);
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("isPremiumPlan", true);
    setState(() {
      isPremiumPlan = true;
    });
    log("User is after Premium $isPremiumPlan");
    selectedIndex = 0;
    Get.offAll(
      const TabsScreen(),
    );
  }

  /// Razor Pay error function ///
  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "${StringValue.error.tr}: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
  }

  /// Razor Pay Wallet  function ///
  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "${StringValue.externalWallet.tr} : ${response.walletName}",
      timeInSecForIosWeb: 4,
    );
  }

  /// Razor Pay ///
  void openCheckout() {
    var options = {
      "key": razorPaySecretKey,
      "amount": num.parse(widget.planPrice) * 100,
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

  Map<String, PurchaseDetails>? purchases;

  @override
  Widget build(BuildContext context) {
    log(widget.planPrice);
    log(razorPaySecretKey);
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: (getStorage.read('isDarkMode') == true)
          ? ColorValues.darkModeMain
          : Colors.grey.shade100,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                        .copyWith(top: 38),
                color: (getStorage.read('isDarkMode') == true)
                    ? ColorValues.darkModeThird.withValues(alpha: 0.10)
                    : ColorValues.darkModeThird.withValues(alpha: 0.03),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                            color: (getStorage.read('isDarkMode') == true)
                                ? ColorValues.darkModeThird
                                    .withValues(alpha: 0.20)
                                : ColorValues.darkModeThird
                                    .withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(14)),
                        child: Center(
                          child: SvgPicture.asset(
                            MovixIcon.backArrowIcon,
                            height: 30,
                            color: (getStorage.read('isDarkMode') == true)
                                ? ColorValues.whiteColor
                                : ColorValues.blackColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(StringValue.payment.tr, style: allTitleStyle),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text("Select the payment method you want to use.",
                      style: GoogleFonts.outfit(
                          color: (getStorage.read('isDarkMode') == true)
                              ? ColorValues.whiteColor
                              : ColorValues.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400))
                  .paddingOnly(left: 15),
              const SizedBox(height: 10),

              /// Razor Pay ///
              isRazorpay
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 1,
                        bottom: SizeConfig.blockSizeVertical * 1,
                        left: 15,
                        right: 15,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            payment = "Razorpay";
                          });
                        },
                        child: Container(
                          height: SizeConfig.screenHeight / 11,
                          decoration: BoxDecoration(
                            color: (getStorage.read('isDarkMode') == true)
                                ? ColorValues.darkModeThird
                                    .withValues(alpha: 0.10)
                                : ColorValues.darkModeThird
                                    .withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: ListTile(
                            leading: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                  color: (getStorage.read('isDarkMode') == true)
                                      ? ColorValues.darkModeThird
                                          .withValues(alpha: 0.20)
                                      : ColorValues.darkModeThird
                                          .withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(14)),
                              child: Center(
                                child: Image.asset(
                                  AssetValues.razorpay,
                                  height: SizeConfig.blockSizeVertical * 6,
                                ),
                              ),
                            ),
                            title: Text(
                              StringValue.razorpay.tr,
                              style: GoogleFonts.urbanist(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            trailing: Radio(
                              fillColor: WidgetStateColor.resolveWith(
                                  (states) => ColorValues.redColor),
                              activeColor: ColorValues.redColor,
                              value: "Razorpay",
                              groupValue: payment,
                              onChanged: (value) {
                                setState(() {
                                  payment = value.toString();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),

              /// Card Payments ///
              isStripe
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 1,
                        bottom: SizeConfig.blockSizeVertical * 1,
                        left: 15,
                        right: 15,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            payment = "Select Card";
                          });
                        },
                        child: Container(
                          height: SizeConfig.screenHeight / 11,
                          decoration: BoxDecoration(
                              color: (getStorage.read('isDarkMode') == true)
                                  ? ColorValues.darkModeThird
                                      .withValues(alpha: 0.10)
                                  : ColorValues.darkModeThird
                                      .withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: ListTile(
                            leading: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                  color: (getStorage.read('isDarkMode') == true)
                                      ? ColorValues.darkModeThird
                                          .withValues(alpha: 0.20)
                                      : ColorValues.darkModeThird
                                          .withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(14)),
                              child: Center(
                                child: Image.asset(
                                  AssetValues.card,
                                  fit: BoxFit.cover,
                                  height: SizeConfig.blockSizeVertical * 3,
                                ),
                              ),
                            ),
                            title: Text(
                              StringValue.creditDebitCard.tr,
                              style: GoogleFonts.urbanist(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            trailing: Radio(
                              fillColor: WidgetStateColor.resolveWith(
                                  (states) => ColorValues.redColor),
                              value: "Select Card",
                              groupValue: payment,
                              activeColor: ColorValues.redColor,
                              onChanged: (value) {
                                setState(() {
                                  payment = value.toString();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),

              /// Flutter waves Payments ///
              isFlutterWave
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 1,
                        bottom: SizeConfig.blockSizeVertical * 1,
                        left: 15,
                        right: 15,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            payment = "FlutterWave";
                          });
                        },
                        child: Container(
                          height: SizeConfig.screenHeight / 11,
                          decoration: BoxDecoration(
                              color: (getStorage.read('isDarkMode') == true)
                                  ? ColorValues.darkModeThird
                                      .withValues(alpha: 0.10)
                                  : ColorValues.darkModeThird
                                      .withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: ListTile(
                            leading: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                  color: (getStorage.read('isDarkMode') == true)
                                      ? ColorValues.darkModeThird
                                          .withValues(alpha: 0.20)
                                      : ColorValues.darkModeThird
                                          .withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(14)),
                              child: Center(
                                child: Image.asset(
                                  AssetValues.flutterWave,
                                  fit: BoxFit.cover,
                                  height: SizeConfig.blockSizeVertical * 3,
                                ),
                              ),
                            ),
                            title: Text(
                              "Flutter Wave",
                              style: GoogleFonts.urbanist(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            trailing: Radio(
                              fillColor: WidgetStateColor.resolveWith(
                                  (states) => ColorValues.redColor),
                              value: "FlutterWave",
                              groupValue: payment,
                              activeColor: ColorValues.redColor,
                              onChanged: (value) {
                                setState(() {
                                  payment = value.toString();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),

              /// Google pay ///
              isGooglePlaySwitch
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 1,
                        bottom: 0,
                        left: 15,
                        right: 15,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            payment = "In app purchase";
                          });
                        },
                        child: Container(
                          height: SizeConfig.screenHeight / 11,
                          decoration: BoxDecoration(
                            color: (getStorage.read('isDarkMode') == true)
                                ? ColorValues.darkModeThird
                                    .withValues(alpha: 0.10)
                                : ColorValues.darkModeThird
                                    .withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: ListTile(
                            leading: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                  color: (getStorage.read('isDarkMode') == true)
                                      ? ColorValues.darkModeThird
                                          .withValues(alpha: 0.20)
                                      : ColorValues.darkModeThird
                                          .withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(14)),
                              child: Center(
                                child: Platform.isIOS
                                    ? ImageIcon(
                                        const AssetImage(
                                            IconAssetValues.appleIcon),
                                        size: SizeConfig.blockSizeVertical * 4,
                                      )
                                    : SvgPicture.asset(
                                        MovixIcon.google,
                                        height:
                                            SizeConfig.blockSizeVertical * 4,
                                      ),
                              ),
                            ),
                            title: Text(
                              StringValue.inAppPurchase.tr,
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Radio(
                              fillColor: WidgetStateColor.resolveWith(
                                  (states) => ColorValues.redColor),
                              activeColor: ColorValues.redColor,
                              value: "In app purchase",
                              groupValue: payment,
                              onChanged: (value) {
                                setState(() {
                                  payment = value.toString();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),

              const NativAdsScreen(),
              const SizedBox(height: 10),

              const Spacer(),
              AbsorbPointer(
                absorbing: !enabled,
                child: InkWell(
                  onTap: () async {
                    log('buttonClicked');
                    setState(() {
                      enabled = false;
                      Future.delayed(const Duration(seconds: 3), () {
                        setState(() {
                          enabled = true;
                        });
                      });
                    });
                    if (payment == "Razorpay") {
                      openCheckout();
                    } else if (payment == "In app purchase") {
                      log("In App Purchase Payment Working....");

                      List<String> kProductIds = <String>[widget.productKey];

                      log("Starting IAP with product: ${widget.productKey}");

                      try {
                        await InAppPurchaseHelper().init(
                          paymentType: "In App Purchase",
                          userId: userId,
                          productKey: kProductIds,
                          rupee: double.parse(widget.planPrice),
                          callBack: () async {
                            log("In App Purchase Payment Successfully");
                          },
                        );

                        // Add debug logging
                        await InAppPurchaseHelper().debugProductLoading();

                        InAppPurchaseHelper().initStoreInfo();
                        await Future.delayed(
                            const Duration(seconds: 3)); // Increased delay

                        ProductDetails? product = InAppPurchaseHelper()
                            .getProductDetail(widget.productKey);

                        if (product != null) {
                          log("Product found: ${product.title} - ${product.price}");
                          InAppPurchaseHelper()
                              .buySubscription(product, purchases!);
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Product not found: ${widget.productKey}',
                            fontSize: 15,
                            backgroundColor: ColorValues.redColor,
                            textColor: ColorValues.whiteColor,
                          );
                          log("Available products: ${InAppPurchaseHelper().getAvailableProducts()}");
                        }
                      } catch (e) {
                        log("Flutter Wave Payment Failed => $e");
                      }
                    } else if (payment == "Apple Pay") {
                      log("Apple Pay");
                    } else if (payment == "Select Card") {
                      log("login type 4 :: creditcard use in payments");

                      stripePayController.makePayment(
                          amount: widget.planPrice,
                          currency: "USD",
                          planId: widget.planId);
                      log("Select Card");
                    } else if (payment == "FlutterWave") {
                      log("Flutter Wave");

                      FlutterWaveService().handlePaymentInitialization(
                          amount: widget.planPrice,
                          currency: "USD",
                          planId: widget.planId);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(milliseconds: 500),
                          backgroundColor: ColorValues.redColor,
                          content: Text(
                            StringValue.pleaseSelectAnyPaymentOption.tr,
                            style: const TextStyle(
                              color: ColorValues.whiteColor,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 54,
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: ColorValues.redColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      StringValue.Continue.tr,
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorValues.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
          Obx(
            () => createPremiumPlan.isLoadingSheet.value == true
                ? Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    top: 0,
                    child: Container(
                      height: Get.height,
                      width: Get.width,
                      color: ColorValues.blackColor.withValues(alpha: 0.4),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ColorValues.redColor,
                          backgroundColor: WidgetStateColor.transparent,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(widget.planPrice, 'USD');

      /// Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              style: ThemeMode.dark,
              merchantDisplayName: 'Adnan',
            ),
          )
          .then((value) {});

      /// now finally display payment sheet
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
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 3,
                    ),
                    Text(StringValue.paymentSuccessfully.tr),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(ColorValues.redColor),
                  ),
                  onPressed: () async {
                    createPremiumPlan.createPremiumData(
                        userId, "Stripe Pay", widget.planId);
                    selectedIndex = 0;
                    Get.offAll(
                      const TabsScreen(),
                    );
                  },
                  child: Text(StringValue.ok.tr),
                ),
              ],
            ),
          ),
        );

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
        ),
      );
    } catch (e) {
      log('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
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

abstract class IAPCallback {
  void onBillingError(error);
  void onLoaded(bool initialized);
  void onPending(PurchaseDetails product);
  void onSuccessPurchase(PurchaseDetails product);
}
