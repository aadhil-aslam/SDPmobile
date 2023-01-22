import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class token {

  late String fcmT;
  updateDeviceToken() async {
    print("updateDeviceToken");
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((ds) {
        fcmT = ds.data()!['DeviceToken'];
        print("fcmT: $fcmT");
      }).catchError((e) {});
    } else {
      const SizedBox.shrink();
    }
    if (fcmToken != fcmT) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({'DeviceToken': fcmToken});
    } else {
      const SizedBox.shrink();
    }
  }
}
