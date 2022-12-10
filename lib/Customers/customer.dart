import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sdp/Customers/home%20customer.dart';

import 'CustomerPage.dart';


Future <void> customer() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Customer());

}

class Customer extends StatelessWidget {
  Customer({super.key});

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