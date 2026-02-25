import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PreviewNetworkImage extends StatelessWidget {
  const PreviewNetworkImage({super.key, required this.id, required this.image, this.fit});

  final String id;
  final String image;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    log("****** Converting Image ****** ID => $id ********* Image => $image");
    return (image == "")
        ? const Offstage()
        : Image.network(
            image,
            fit: fit ?? BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Offstage(),
          );
  }
}

Future<String> generatePresignedURL(String path) async => path; // This is old ews convert function...

class IAPConnection {
  static InAppPurchase? _instance;

  static set instance(InAppPurchase value) {
    _instance = value;
  }

  static InAppPurchase get instance {
    _instance ??= InAppPurchase.instance;
    return _instance!;
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {
  log(message.data.toString());
  log("${message.notification!.title}");
}
