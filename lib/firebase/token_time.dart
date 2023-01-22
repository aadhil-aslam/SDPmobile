import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase/firebase_services.dart';

class tokenTime extends StatefulWidget {
  const tokenTime({Key? key}) : super(key: key);

  @override
  State<tokenTime> createState() => _tokenTimeState();
}

class _tokenTimeState extends State<tokenTime> {
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
            snapshot
                .data!['DateAndTime'],
            style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w500),
          );
        }
        return Text("Time",
            style: TextStyle(
                fontSize: 20));
      },
    );
  }
}
