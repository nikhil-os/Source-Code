import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationServies {
  LocalNotificationServies._();

  static final LocalNotificationServies localNotificationServies =
      LocalNotificationServies._();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails(
    "0",
    "WebTime Movie Ocean",
    channelDescription: "hello user",
    icon: "mipmap/ic_notification",
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );

  // IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
  //   presentAlert: true,
  //   presentBadge: true,
  //   presentSound: true,
  // );

  init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("mipmap/ic_notification");

    //Initialization Settings for iOS
    // final IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    // );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
      // iOS: iosNotificationDetails,
    );
    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Notification Title',
      'This is the Notification Body',
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }

  requestIOSPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  selectNotification(String? payload) {}

  static Future<void> createandisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
              android: AndroidNotificationDetails("id", "WebTime Movie Ocean",
                  channelDescription: message.notification!.body,
                  importance: Importance.high,
                  playSound: true,
                  icon: 'mipmap/ic_notification')));
    } on Exception catch (e) {
      log("$e");
    }
  }
}
