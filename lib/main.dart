import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'customer_pages/CustomerPage.dart';
import 'customer_pages/home customer.dart';
import 'firebase/firebase_services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  print("Handling a background message");
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  runApp(MyApp());

  /// background messaging handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  FirebaseServices _firebaseServices = FirebaseServices();

  late bool isLoggedIn = true;

  CheckLogin() {
    if (_firebaseServices.getUserId() != null) {
      print(FirebaseAuth.instance.currentUser?.uid);
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CheckLogin();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? CustomerPage() : HomeCustomer(),
    );
  }
}
