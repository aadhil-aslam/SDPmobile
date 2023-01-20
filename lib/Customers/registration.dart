import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdp/Customers/home%20customer.dart';
import '../auth.dart';

class Registration extends StatefulWidget {
  Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool _validateEmail = false;
  bool _validateName = false;
  bool _validateVno = false;
  bool _validatePW = false;

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
        "DeviceToken": fcmToken,
        "DateAndTime": "Pending",
        "requested amount": "null",
        "Requested Station": "null",
        "Rescheduled Date": "null",
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeCustomer()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        _showSuccessSnackbar(e.message.toString());
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
                  SizedBox(
                    height: 18.0,
                  ),
                  TextField(
                      //enabled: quota ? true : false,
                      controller: _NameController,
                      decoration: InputDecoration(
                        //filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter Name',
                        labelText: 'Name',
                        errorText:
                            _validateName ? 'Name Can\'t Be Empty' : null,
                      )),
                  SizedBox(
                    height: 18.0,
                  ),
                  TextField(
                      //enabled: quota ? true : false,
                      controller: _vehicleNumberController,
                      decoration: InputDecoration(
                        //filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter Vehicle Number',
                        labelText: 'Vehicle Number',
                        errorText:
                            _validateVno ? 'Vehicle Number Can\'t Be Empty' : null,
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
                    ),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  TextField(
                      //enabled: quota ? true : false,
                      controller: _emailController,
                      decoration: InputDecoration(
                        //filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter Email',
                        labelText: 'Email',
                        errorText:
                            _validateEmail ? 'Email Can\'t Be Empty' : null,
                      )),
                  SizedBox(
                    height: 18.0,
                  ),
                  TextField(
                      obscureText: true,
                      //enabled: quota ? true : false,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        //filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter Password',
                        labelText: 'Password',
                        errorText: _validatePW ? 'Password Can\'t Be Empty' : null,
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
                              setState(() {
                                _emailController.text.isEmpty
                                    ? _validateEmail = true
                                    : _validateEmail = false;
                                _passwordController.text.isEmpty
                                    ? _validatePW = true
                                    : _validatePW = false;
                                _NameController.text.isEmpty
                                    ? _validateName = true
                                    : _validateName = false;
                                _vehicleNumberController.text.isEmpty
                                    ? _validateVno = true
                                    : _validateVno = false;
                              });
                              if (_validatePW == false &&
                                  _validateEmail == false &&
                                  _validateVno == false &&
                                  _validateName == false) {
                                createUserWithEmailAndPassword();
                              }
                            },
                            child: const Text('Sign up')),
                      ),
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
