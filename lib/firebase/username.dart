import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'firebase_services.dart';

class Username extends StatefulWidget {
  const Username({Key? key}) : super(key: key);

  @override
  State<Username> createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  FirebaseServices _firebaseServices = FirebaseServices();

  late String Vtype = "";
  bool requested = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('User')
          .doc(_firebaseServices.getUserId())
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Vtype = snapshot.data?.data()!['Vehicle type'];
          requested =
              snapshot.data?.data()?['Requested'] == "Yes";
          return Text(
              "Welcome ${snapshot.data!['username'].split(" ").elementAt(0)}",
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w500));
        }
        return const Text("Welcome",
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w500));
      },
    );
  }
}
