// // ignore_for_file: unused_field
//
// import 'package:flutter/material.dart';
// import 'package:pay/pay.dart';
//
// class GooglePay extends StatefulWidget {
//   const GooglePay({Key? key}) : super(key: key);
//
//   @override
//   State<GooglePay> createState() => _GooglePayState();
// }
//
// class _GooglePayState extends State<GooglePay> {
//   static const _paymentItems = [
//     PaymentItem(
//       label: 'Total',
//       amount: '1.00',
//       status: PaymentItemStatus.final_price,
//     )
//   ];
//
//   void onApplePayResult(paymentResult) {
//     // Send the resulting Apple Pay token to your server / PSP
//   }
//
//   void onGooglePayResult(paymentResult) {
//     // Send the resulting Google Pay token to your server / PSP
//   }
//
//   bool googlepayon = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: (googlepayon == true)
//               ? GooglePayButton(
//                   onPressed: () {
//                     setState(() {
//                       googlepayon = false;
//                     });
//                   },
//                   paymentConfigurationAsset: 'gpay.json',
//                   onPaymentResult: (Map<String, dynamic> result) {},
//                   paymentItems: [],
//                   // onPressed: () {
//                   //
//                   //   print("google pay");
//                   // },
//
//                   // paymentConfigurationAsset: 'gpay.json',
//                   // paymentItems: _paymentItems,
//                   // type: GooglePayButtonType.pay,
//                   // margin: const EdgeInsets.only(top: 15.0),
//                   // onPaymentResult: onGooglePayResult,
//                   // loadingIndicator: const Center(
//                   //   child: CircularProgressIndicator(
//                   //     color: Colors.red,
//                   //   ),
//                   // ),
//                 )
//               : Container()),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:webtime_movie_ocean/main.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';

class InappPurchase extends StatefulWidget {
  const InappPurchase({super.key});

  @override
  State<InappPurchase> createState() => _InappPurchaseState();
}

class _InappPurchaseState extends State<InappPurchase> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    streamSubscription = purchaseUpdated.listen((purchaseList) {
      listenToPurchase(purchaseList, context);
    }, onDone: () {
      streamSubscription.cancel();
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(StringValue.error.tr),
      ));
    });

    initStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringValue.inAppPurchase.tr,
          style: GoogleFonts.poppins(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              buy();
            },
            child: Text(
              StringValue.pay.tr,
              style: const TextStyle(fontSize: 20),
            )),
      ),
    );
  }

  initStore() async {
    ProductDetailsResponse productDetailsResponse = await inAppPurchase.queryProductDetails(variant);

    if (productDetailsResponse.error == null) {
      setState(() {
        products = productDetailsResponse.productDetails;
      });
    }
  }

  buy() {
    if (products.isNotEmpty && products.length >= 2) {
      final PurchaseParam param = PurchaseParam(productDetails: products[1]);
      inAppPurchase.buyConsumable(purchaseParam: param);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(StringValue.noValidProductsAvailableForPurchase.tr),
      ));
    }
  }
}

listenToPurchase(List<PurchaseDetails> purchaseDetailsList, BuildContext context) {
  purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(StringValue.pending.tr),
      ));
    } else if (purchaseDetails.status == PurchaseStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(StringValue.error.tr),
      ));
    } else if (purchaseDetails.status == PurchaseStatus.purchased) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(StringValue.purchased.tr),
      ));
    }
  });
}
