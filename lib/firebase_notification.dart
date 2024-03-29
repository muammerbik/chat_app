import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMMethods {
  static void initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    

    messaging.getToken().then((value) => debugPrint('fcm token====== $value'));

    if (Platform.isIOS) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      } else if (settings.authorizationStatus !=
          AuthorizationStatus.provisional) {
        print('permission denied');
      }
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      print("Handling a foreground message: ${msg.messageId}");
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }


}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");

}
