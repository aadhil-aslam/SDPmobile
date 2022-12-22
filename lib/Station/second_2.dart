import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondTwo extends StatefulWidget {
  const SecondTwo({Key? key}) : super(key: key);

  @override
  State<SecondTwo> createState() => _SecondTwoState();
}

class _SecondTwoState extends State<SecondTwo> {
  var _tokenController = TextEditingController();

  bool quota = false;

  bool free = false;

  _ValidateQuota() async {
    print(free);
    free
        ? setState(() {
            quota = true;
          })
        : showDialog(
            context: context,
            builder: (parm) {
              return AlertDialog(
                title: Column(
                  children: const [
                    Text(
                      'Invalid token number',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Icon(
                      Icons.cancel_outlined,
                      size: 70,
                      color: Colors.red,
                    )
                  ],
                ),
              );
            });
  }

  String vNumber = 'Vehicle Number';
  String date = 'DateAndTime';
  String fuelAmount = 'requested amount';
  String customerId = '';
  String requestId = '';

  search() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .limit(1)
        .where('Token', isEqualTo: _tokenController.text)
        .get();

    for (var doc in querySnapshot.docs) {
      // Getting data directly
      setState(() {
        vNumber = doc.get('Vehicle Number');
        date = doc.get('DateAndTime');
        fuelAmount = doc.get('requested amount');
        customerId = doc.id;
      });
      print(vNumber);
      print(date);
      print(fuelAmount);
      print(doc.id);
    }
    setState(() {
      free = vNumber != 'Vehicle Number';
    });
    _ValidateQuota();
  }

  submit() async {
    await FirebaseFirestore.instance.collection('User').doc(customerId).update({
      'Requested': "No",
      "DateAndTime": "Pending",
      "Token": "Pending",
      "requested amount": "null",
    });
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Requests')
        .limit(1)
        .where('Token', isEqualTo: _tokenController.text)
        .get();
    for (var doc in querySnapshot.docs) {
      // Getting data directly
      setState(() {
        requestId = doc.id;
      });
      print(doc.id);
    }
    FirebaseFirestore.instance.collection('Requests').doc(requestId).update({
      'Status': 'Completed',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Fuel Station",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      //autofocus: true,
                      controller: _tokenController,
                      decoration: const InputDecoration(
                        //filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter Token Number',
                        labelText: 'Token Number',
                        //errorText: _validateName ? 'Name Can\'t Be Empty' : null,
                      ),
                      onSubmitted: (value) {
                        search();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      width: 100,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(fontSize: 15)),
                          onPressed: () {
                            search();
                          },
                          child: const Text('Check')),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 100.0,
              ),
              quota
                  ? Column(
                      children: [
                        const Text(
                          "Requested amount",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          fuelAmount + " litres",
                          style: TextStyle(fontSize: 40),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Vehicle number:",
                              style: TextStyle(fontSize: 17),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                vNumber,
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date:",
                              style: TextStyle(fontSize: 17),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                date,
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blueGrey,
                                      textStyle: const TextStyle(fontSize: 15)),
                                  onPressed: () async {
                                    submit();
                                  },
                                  child: const Text('Submit')),
                            ),
                          ],
                        )
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
