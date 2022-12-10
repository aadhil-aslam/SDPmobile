import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sdp/Customers/home%20customer.dart';

import 'Customers/CustomerPage.dart';
import 'Customers/Login.dart';
import 'Customers/widget_tree.dart';
import 'Station/home.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  late bool isLoggedIn = true;

  CheckLogin () {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
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