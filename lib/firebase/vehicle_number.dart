import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'firebase_services.dart';

class vNumber extends StatefulWidget {
  const vNumber({Key? key}) : super(key: key);

  @override
  State<vNumber> createState() => _vNumberState();
}

class _vNumberState extends State<vNumber> {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('User')
          .doc(_firebaseServices.getUserId())
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!['Vehicle Number'],
              style: TextStyle(fontSize: 17));
        }
        return Text("Vehicle Number",
            style: TextStyle(fontSize: 20));
      },
    );
  }
}
