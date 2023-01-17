import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:sdp/Customers/CustomerPage.dart';
import 'package:sdp/Customers/registration.dart';

import '../auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  bool _validateEmail = false;
  bool _validatePW = false;

  bool loggedIn = false;

  String? errorMessage = "";

  bool isLogin = true;

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      setState(() {
        loggedIn = true;
        print('loggedIn');
      });
      print('pass');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CustomerPage()));
    } on FirebaseAuthException catch (e) {
      print('fail');
      setState(() {
        _showSuccessSnackbar(e.message.toString());
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  var _contactNameController = TextEditingController();
  var _contactNumberController = TextEditingController();
  var _contactEmailController = TextEditingController();

  bool quota = false;

  bool free = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   appBar: AppBar(
      //   backgroundColor: Colors.red[700],
      //   title: const Text(
      //     'PowerFuel ',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   // actions: <Widget>[
      //   //   IconButton(
      //   //     icon: const Icon(
      //   //         Icons.search),
      //   //     onPressed: () {
      //   //       setState(() {
      //   //       });
      //   //     },
      //   //   ),
      //   // ],
      //   //centerTitle: true,
      //   elevation: 0.0,
      // ),
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
                  "Sign in",
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
                      controller: _emailController,
                      //keyboardType: TextInputType.number,
                      // inputFormatters: <TextInputFormatter>[
                      //   FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                      // ],
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
                    // keyboardType: TextInputType.number,
                    // inputFormatters: <TextInputFormatter>[
                    //   FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                    // ],
                    decoration: InputDecoration(
                      //filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      isDense: true,
                      border: OutlineInputBorder(),
                      hintText: 'Enter Password',
                      labelText: 'Password',
                      errorText:
                          _validatePW ? 'Password Can\'t Be Empty' : null,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextButton(
                    onPressed: () {
                      //forgot password screen
                    },
                    child: const Text(
                      'Forgot Password',
                    ),
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
                            onPressed: ()
                                //async
                                {
                              setState(() {
                                _emailController.text.isEmpty
                                    ? _validateEmail = true
                                    : _validateEmail = false;
                                _passwordController.text.isEmpty
                                    ? _validatePW = true
                                    : _validatePW = false;
                              });
                              print("click");
                              if (_validatePW == false &&
                                  _validateEmail == false) {
                                signInWithEmailAndPassword();
                              }
                            },
                            child: const Text('Login')),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Does not have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registration()));
                        },
                        child: const Text(
                          'Register',
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
