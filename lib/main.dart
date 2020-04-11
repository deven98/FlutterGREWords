import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gre/pages/home_page.dart';
import 'package:flutter_gre/pages/login/splash_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepPurple));

    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.configure(
      onMessage: (payload) => _handleNotification(payload, context),
      onLaunch: (payload) => _handleNotification(payload, context),
      onResume: (payload) => _handleNotification(payload, context),
      //onBackgroundMessage: Platform.isIOS ? null : handleBackgroundNotification,
    );

    return MaterialApp(
      title: 'GRE One',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          textTheme: GoogleFonts.openSansTextTheme()),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }

  /// Handles notification
  Future<void> _handleNotification(
      Map<dynamic, dynamic> message, BuildContext context) async {
    var data = message['data'] ?? message;
    print(message);

    // Try to show normal notification if app is not open
    try {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          new FlutterLocalNotificationsPlugin();

      var initializationSettingsAndroid =
          new AndroidInitializationSettings('ic_launcher');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (msg) => onSelectNotification(msg, context));

      print(data);
      //var notificationChannel = data["notification"]["notification_channel"];
      //var channelModel = getChannel(notificationChannel);
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          "1", "General Notifications", "Reminders and promos",
          importance: Importance.Max,
          priority: Priority.High,
          ticker: 'ticker');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0,
          Platform.isIOS
              ? data["notification"]["title"]
              : message["notification"]["title"],
          Platform.isIOS
              ? data["notification"]["body"]
              : message["notification"]["body"],
          platformChannelSpecifics,
          payload: 'Default_Sound');
    } catch (e) {
      print(e);
    }
  }

  Future onSelectNotification(String payload, BuildContext context) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }
}

/// Handles notification
Future<void> handleBackgroundNotification(Map<dynamic, dynamic> message) async {
  var data = message['data'] ?? message;
  print(message);

  // Try to show normal notification if app is not open
  try {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (msg) async {
//          await Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => SplashScreen()),
//          );
      },
    );

    print(data);
    //var notificationChannel = data["notification"]["notification_channel"];
    //var channelModel = getChannel(notificationChannel);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "1", "General Notifications", "Reminders and promos",
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        Platform.isIOS
            ? data["notification"]["title"]
            : message["notification"]["title"],
        Platform.isIOS
            ? data["notification"]["body"]
            : message["notification"]["body"],
        platformChannelSpecifics,
        payload: 'Default_Sound');
  } catch (e) {
    print(e);
  }
}
