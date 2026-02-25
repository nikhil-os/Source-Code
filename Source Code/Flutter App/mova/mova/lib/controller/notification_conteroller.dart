import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:webtime_movie_ocean/firebase_options.dart';
import 'package:webtime_movie_ocean/buinesslogic/auth/notification_service.dart';

import 'package:webtime_movie_ocean/presentation/utils/app_class.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

/// Notifications ///
class NotificationController {
  static notificationActiv() async {
    FirebaseMessaging firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    firebaseMessaging.getToken().then((token) {
      if (token != null && token.isNotEmpty) {
        fcmToken = token;
        print("token is $fcmToken");
      } else {
        fcmToken = "fallback_token_${DateTime.now().millisecondsSinceEpoch}";
        print("Using fallback fcmToken");
      }
    }).catchError((e) {
      print("Error getting FCM token: $e");
      fcmToken = "fallback_token_${DateTime.now().millisecondsSinceEpoch}";
    });

    /// Notification ///
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    await FirebaseMessaging.instance.subscribeToTopic('WEBTIME_MOVIE_OCEAN');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Message data: ${message.data}");

      if (message.notification != null) {
        log("connect notification ${message.notification}");
      }
    });
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions();

    Future<void> firebaseMessagingBackgroundHandler(
        RemoteMessage message) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      log("Handling a background message: ${message.messageId}");
    }

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      log("$value");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      log("$event");
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("${message.notification!.title}");
      log("${message.notification!.body}");
      LocalNotificationServies.createandisplaynotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp;
    FirebaseMessaging.onBackgroundMessage(
        (message) => firebaseMessagingBackgroundHandler(message));
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions();
  }
}
