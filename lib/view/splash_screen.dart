import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lootfat_owner/utils/images.dart';
import 'package:lootfat_owner/view/auth/intro_screen.dart';
import 'package:lootfat_owner/view/auth/questions_screen.dart';
import 'package:lootfat_owner/view/dashboard/bottom_bar_screen.dart';
import 'package:lootfat_owner/view/dashboard/location_denied.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:permission_handler/permission_handler.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_notification');
const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future onDidReceiveLocalNotification(
  int? id,
  String? title,
  String? body,
  String? payload,
) async {
  debugPrint("iOS notification $title $body $payload");
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getPosition();
    getConnectivity();
    getMessage();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> requestNotificationPermissions() async {
    await Permission.notification.isDenied.then(
      (bool value) {
        if (value) {
          Permission.notification.request();
        }
      },
    );
  }

  void getMessage() async {
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      debugPrint("onSelectNotification Called");
      if (payload != null) {
        getLoginAlready();
      }
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null && message.data.toString() != "null") {
        getLoginAlready();
      }
    });
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification notification = message.notification!;
        AndroidNotification? android = message.notification?.android;
        if (notification.toString() != "null" && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: '@mipmap/ic_notification',
                ),
                iOS: IOSNotificationDetails(
                  subtitle: channel.description,
                  presentSound: true,
                  presentAlert: true,
                ),
              ),
              payload: jsonEncode(message.data));
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      getLoginAlready();
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  void getLoginAlready() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        ),
      );
    } else {
      bool isQuestionFilled = prefs.getBool("isQuestionsFilled") ?? false;
      if (isQuestionFilled) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const BottomBarScreen(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const QuestionsScreen(),
          ),
        );
      }
    }
  }

  Future<void> getPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LocationDenied(),
        ),
      );
    }
    if (permission != LocationPermission.deniedForever) {
      var locationData = await Geolocator.getCurrentPosition();
      FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      _firebaseMessaging.getToken().then((token) {
        storeDeviceInfo(
          token,
          locationData.latitude.toString(),
          locationData.longitude.toString(),
        );
        getLoginAlready();
      });
    }
  }

  void storeDeviceInfo(fcmToken, lat, long) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      // unique ID on iOS
      prefs.setString('deviceID', iosDeviceInfo.identifierForVendor.toString());
      prefs.setString('deviceToken', fcmToken);
      prefs.setString('deviceType', 'ios');
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      // unique ID on Android
      prefs.setString('deviceID', androidDeviceInfo.id.toString());
      prefs.setString('deviceToken', fcmToken);
      prefs.setString('deviceType', 'android');
    }
    prefs.setString('lat', lat);
    prefs.setString('long', long);
  }

  showDialogBox() => Platform.isIOS
      ? showCupertinoDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text('No Connection'),
            content: const Text('Please check your internet connectivity'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Cancel');
                  setState(() => isAlertSet = false);
                  isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                  if (!isDeviceConnected && isAlertSet == false) {
                    showDialogBox();
                    setState(() => isAlertSet = true);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        )
      : showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('No Connection'),
            content: const Text('Please check your internet connectivity'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Cancel');
                  setState(() => isAlertSet = false);
                  isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                  if (!isDeviceConnected && isAlertSet == false) {
                    showDialogBox();
                    setState(() => isAlertSet = true);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          SvgImages.logo,
        ),
      ),
    );
  }
}
