import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'firebase_services.dart';

class tokenDate extends StatefulWidget {
  const tokenDate({Key? key}) : super(key: key);

  @override
  State<tokenDate> createState() => _tokenDateState();
}

class _tokenDateState extends State<tokenDate> {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<
        DocumentSnapshot<
            Map<String, dynamic>>>(
      //key: Key(_uid),
      stream: FirebaseFirestore.instance
          .collection('User')
          .doc(_firebaseServices.getUserId())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!['TokenDate'],
            style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w500),
          );
        }
        return Text("Date'",
            style:
            TextStyle(fontSize: 20));
      },
    );
  }
}
