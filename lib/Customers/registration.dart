import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdp/Customers/home%20customer.dart';

import '../auth.dart';
import 'Login.dart';

class Registration extends StatefulWidget {
  Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  Future<void> createUserWithEmailAndPassword() async {
    //final fcmToken = FirebaseMessaging.instance.getToken();
    try {

      final fcmToken = await FirebaseMessaging.instance.getToken();

      await Auth().createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
          FirebaseFirestore.instance
              .collection("User")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            "username": _NameController.text,
            "email": _emailController.text,
            "Vehicle Number": _vehicleNumberController.text,
            "Vehicle type": selectedCategory,
            "quota": quotaLimit,
            "balanceQuota": quotaLimit,
            "Token": "Pending",
            "Last requested": "null",
            "Requested": "No",
            "DeviceToken" : fcmToken,
            "DateAndTime" : "Pending",
            "requested amount": "null",
            "Requested Station": "null",
            "Rescheduled Date":
            "null",
          });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeCustomer()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        _showSuccessSnackbar(e.toString());
        errorMessage = e.message;
      });
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  String? errorMessage = "";

  bool isLogin = true;

  final db = FirebaseFirestore.instance;

  var _NameController = TextEditingController();
  var _vehicleNumberController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  final now = DateTime.now();
  //final today = DateTime(now.year, now.month, now.day);

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  //
  // bool _validateName = false;
  bool _validateNumber = false;

  bool quota = false;

  bool free = true;

  String selectedCategory = 'Bike';
  String quotaLimit = '5';

  late Vehicle selectedUser;

  List<Vehicle> vehicles = <Vehicle>[
    const Vehicle("5", 'Bike'),
    const Vehicle("10", 'Car'),
    const Vehicle("15", 'Van'),
    const Vehicle("20", 'Lorry'),
    const Vehicle("25", 'Bus'),
    const Vehicle("15", 'Three wheeler')
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedUser = vehicles[0];
  }

  _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: const Text(
          'PowerFuel ',
          style: TextStyle(color: Colors.white),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //         Icons.search),
        //     onPressed: () {
        //       setState(() {
        //       });
        //     },
        //   ),
        // ],
        //centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: const Text(
                  "Register",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Column(
                children: [
                  // const SizedBox(
                  //   height: 20.0,
                  // ),
                  // TextField(
                  //     enabled: quota ? true : false,
                  //     controller: _contactNumberController,
                  //     decoration: InputDecoration(
                  //       //filled: true,
                  //       fillColor: const Color(0xFFFFFFFF),
                  //       isDense: true,
                  //       border: const OutlineInputBorder(),
                  //       hintText: 'Enter Token Number',
                  //       labelText: 'Token Number',
                  //       errorText:
                  //       _validateNumber ? 'Number Can\'t Be Empty' : null,
                  //     )),
                  SizedBox(
                    height: 18.0,
                  ),
                  TextField(
                      //enabled: quota ? true : false,
                      controller: _NameController,
                      decoration: const InputDecoration(
                        //filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter Name',
                        labelText: 'Name',
                        // errorText:
                        //      'Name Can\'t be Empty'
                      )),
                  SizedBox(
                    height: 18.0,
                  ),
                  TextField(
                      //enabled: quota ? true : false,
                      controller: _vehicleNumberController,
                      decoration: const InputDecoration(
                        //filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter Vehicle Number',
                        labelText: 'Vehicle Number',
                        // errorText:
                        // 'Number Can\'t be Empty'
                      )),
                  SizedBox(
                    height: 18.0,
                  ),
                  Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.5, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: DropdownButton<Vehicle>(
                        hint: Text("Select Vehicle"),
                        value: selectedUser,
                        onChanged: (Vehicle? newValue) {
                          setState(() {
                            selectedUser = newValue!;
                            quotaLimit = selectedUser.quota;
                            selectedCategory = selectedUser.name;
                          });
                          print(selectedCategory);
                        },
                        items: vehicles.map((Vehicle vehicles) {
                          return new DropdownMenuItem<Vehicle>(
                            value: vehicles,
                            child: new Text(
                              vehicles.name,
                              style: new TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        //borderRadius: BorderRadius.circular(10),
                        underline: SizedBox(),
                        isExpanded: true,
                      ),
                      //               DropdownButton<String>(
                      //                 items: <String>[
                      //                   "Bike",
                      //                   "Car",
                      //                   "Van",
                      //                   "Lorry",
                      //                   "Bus",
                      //                   "Three wheeler"
                      //                 ].map((String value) {
                      //                   return DropdownMenuItem<String>(
                      //                     value: value,
                      //                     child: Text(value),
                      //                   );
                      //                 }).toList(),
                      //                 hint: Text(selectedCategory.isEmpty
                      //                     ? 'Vehicle type'
                      //                     : selectedCategory),
                      //                 //borderRadius: BorderRadius.circular(10),
                      //                 underline: SizedBox(),
                      //                 isExpanded: true,
                      //                 onChanged: (value) {
                      //                   if (value != null) {
                      //                     setState(() {
                      //                       selectedCategory = value;
                      //                     });
                      //                   }
                      //                 },
                      //               ),
                    ),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  TextField(
                      //enabled: quota ? true : false,
                      controller: _emailController,
                      decoration: const InputDecoration(
                        //filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter Email',
                        labelText: 'Email',
                        // errorText:
                        // 'Email Can\'t be Empty'
                      )),
                  SizedBox(
                    height: 18.0,
                  ),
                  TextField(
                      obscureText: true,
                      //enabled: quota ? true : false,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        //filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter Password',
                        labelText: 'Password',
                        // errorText:
                        // 'Email Can\'t be Empty'
                      )),
                  SizedBox(
                    height: 10.0,
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
                            onPressed: () {
                              final fcmToken =
                                  FirebaseMessaging.instance.getToken();
                              // auth
                              //     .createUserWithEmailAndPassword(
                              //         email: _emailController.text,
                              //         password: _passwordController.text)
                              //     .then((value) {
                              //   FirebaseFirestore.instance
                              //       .collection("User")
                              //       .doc(value.user!.uid)
                              //       .set({
                              //     "username": _NameController.text,
                              //     "email": _emailController.text,
                              //     "Vehicle Number":
                              //         _vehicleNumberController.text,
                              //     "Vehicle type": selectedCategory,
                              //     "quota": quotaLimit,
                              //     "Token": "Pending",
                              //     "Last requested": "null",
                              //     "Requested": "No",
                              //     "DeviceToken": fcmToken,
                              //   });
                              // });
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => HomeCustomer()));
                              createUserWithEmailAndPassword();
                            },
                            child: const Text('Sign up')),
                      ),
                      // const SizedBox(
                      //   width: 10.0,
                      // ),
                      // Expanded(
                      //     child: TextButton(
                      //         style: TextButton.styleFrom(
                      //             foregroundColor: Colors.white,
                      //             backgroundColor: Colors.red,
                      //             textStyle: const TextStyle(fontSize: 15)),
                      //         onPressed: () {
                      //           _contactNameController.text = '';
                      //           _contactNumberController.text = '';
                      //           _contactEmailController.text = '';
                      //         },
                      //         child: const Text('Clear')))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeCustomer()));
                        },
                        child: const Text(
                          'Sign in',
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Vehicle {
  const Vehicle(this.quota, this.name);

  final String name;
  final String quota;
}
