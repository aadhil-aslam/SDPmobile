import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../auth.dart';

class Registration extends StatefulWidget {
  Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  FirebaseAuth auth = FirebaseAuth.instance;

  String? errorMessage = "";

  bool isLogin = true;

  final db = FirebaseFirestore.instance;

  var _NameController = TextEditingController();
  var _vehicleNumberController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  // Future createUserWithEmailAndPassword() async {
  //   await auth.createUserWithEmailAndPassword(
  //       email: _emailController.text, password: _passwordController.text);
  //   addUserDetails(_NameController.text,
  //       _emailController.text,
  //       _vehicleNumberController.text,
  //       selectedCategory);
  // }
  //
  //
  // Future<void> addUserDetails(
  //     String username, String email, String VN, String VT) async {
  //   FirebaseFirestore.instance.collection("User").add({
  //     "username": username,
  //     "email": email,
  //     "Vehicle Number": VN,
  //     "Vehicle type": VT
  //   });
  // }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  //
  // bool _validateName = false;
  bool _validateNumber = false;

  bool quota = false;

  bool free = true;

  var _vehicleType = ["Bike", "Car", "Van", "Lorry", "Bus", "Three wheeler"];

  String selectedCategory = '';
  String quotaLimit = "";

  late Vehicle selectedUser;

  List<Vehicle> vehicles = <Vehicle>[
    const Vehicle("5",'Bike'),
    const Vehicle("10",'Car'),
    const Vehicle("15",'Van'),
    const Vehicle("20",'Lorry'),
    const Vehicle("25",'Bus'),
    const Vehicle("15",'Three wheeler')
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedUser = vehicles[0];
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
                height:30.0,
              ),
              Center(
                child: const Text(
                  "Register",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(
                height: 30.0,
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
                          errorText:
                               'Name Can\'t be Empty'
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
                          errorText:
                          'Number Can\'t be Empty'
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
                    child:
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child:
                      DropdownButton<Vehicle>(
                        value: selectedUser,
                        onChanged: (Vehicle?
                        newValue) {
                          setState(() {
                            selectedUser = newValue!;
                            quotaLimit = selectedUser.quota;
                            selectedCategory = selectedUser.name;
                          });
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
                          errorText:
                          'Email Can\'t be Empty'
                      )),
                  SizedBox(
                    height: 18.0,
                  ),
                  TextField(
                      //enabled: quota ? true : false,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        //filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter Password',
                        labelText: 'Password',
                          errorText:
                          'Email Can\'t be Empty'
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
                              auth
                                  .createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text)
                                  .then((value) {
                                FirebaseFirestore.instance
                                    .collection("User")
                                    .doc(value.user!.uid)
                                    .set({
                                  "username": _NameController.text,
                                  "email": _emailController.text,
                                  "Vehicle Number":
                                      _vehicleNumberController.text,
                                  "Vehicle type": selectedCategory,
                                  "quota" : quotaLimit
                                });
                              });
                              //createUserWithEmailAndPassword();
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
  const Vehicle(this.quota,this.name);

  final String name;
  final String quota;
}