import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'firebase_services.dart';

class tokenNumber extends StatefulWidget {
  const tokenNumber({Key? key}) : super(key: key);

  @override
  State<tokenNumber> createState() => _tokenNumberState();
}

class _tokenNumberState extends State<tokenNumber> {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<
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
              snapshot.data!['Token'],
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.w500),
            );
          }
          return const Text("Token'",
              style: TextStyle(fontSize: 20));
        },
      ),
    );
  }
}
