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
        _showSuccessSnackbar(e.toString());
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

  _ValidateQuota() async {
    free
        ? setState(() {
            quota = true;
            // showDialog(
            //     context: context,
            //     builder: (parm) {
            //       return AlertDialog(
            //         title: Column(
            //           children: const [
            //             Text(
            //               'Avaliable limit',
            //               style:
            //                   TextStyle(color: Colors.blueGrey, fontSize: 18),
            //             ),
            //             SizedBox(
            //               height: 20,
            //             ),
            //             Text(
            //               '5 liters',
            //               style: TextStyle(color: Colors.green, fontSize: 18),
            //             ),
            //             // SizedBox(
            //             //   height: 20,
            //             // ),
            //             // TextButton(
            //             //   onPressed: () {
            //             //   },
            //             //   child: Text('5 liters',
            //             //       style:
            //             //       TextStyle(color: Colors.green, fontSize: 18)),
            //             // ),
            //           ],
            //         ),
            //       );
            //     });
          })
        : showDialog(
            context: context,
            builder: (parm) {
              return AlertDialog(
                title: Column(
                  children: const [
                    Text(
                      'No quota available',
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
              // Stack(
              //   children: [
              //     // Center(
              //     //   child: Container(
              //     //     height: 160,
              //     //     width: 160,
              //     //     decoration: BoxDecoration(
              //     //       shape: BoxShape.circle,
              //     //       //border: Border.all(width: 2, color: Colors.blueGrey)
              //     //     ),
              //     //     child:
              //     //     // ClipRRect(
              //     //     //   borderRadius: BorderRadius.circular(100.0),
              //     //     //   child: _image != null
              //     //     //       ? Image.file(
              //     //     //     _image!,
              //     //     //     fit: BoxFit.cover,
              //     //     //   )
              //     //     //       :
              //     //       Center(
              //     //         child: CircleAvatar(
              //     //           backgroundColor: Colors.blueGrey,
              //     //           radius: 80,
              //     //           child: Icon(
              //     //             Icons.add_a_photo,
              //     //             size: 30,
              //     //             color: Colors.white,
              //     //           ),
              //     //         ),
              //     //       ),
              //     //
              //     //   ),
              //     // ),
              //     // Center(
              //     //   child: CircleAvatar(
              //     //     backgroundColor: Colors.black12,
              //     //     radius: 80,
              //     //     child: IconButton(
              //     //         icon: const Icon(
              //     //           Icons.add_a_photo,
              //     //           size: 30,
              //     //         ),
              //     //         color: Colors.white,
              //     //         onPressed: () {
              //     //           Widget optionOne = SimpleDialogOption(
              //     //             child: const Text('Take new photo'),
              //     //             onPressed: () {
              //     //               Navigator.pop(context);
              //     //               //_TakePhoto();
              //     //             },
              //     //           );
              //     //           Widget optionTwo = SimpleDialogOption(
              //     //             child: const Text('Choose new photo'),
              //     //             onPressed: () {
              //     //               Navigator.pop(context);
              //     //               //_ChoosePhoto();
              //     //             },
              //     //           );
              //     //           // set up the SimpleDialog
              //     //           SimpleDialog dialog = SimpleDialog(
              //     //             title: const Text('Change photo'),
              //     //             children: <Widget>[
              //     //               optionOne,
              //     //               optionTwo,
              //     //             ],
              //     //           );
              //     //
              //     //           // show the dialog
              //     //           showDialog(
              //     //             context: context,
              //     //             builder: (BuildContext context) {
              //     //               return dialog;
              //     //             },
              //     //           );
              //     //         }
              //     //     ),
              //     //   ),
              //     // ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 40.0,
              // ),
              // Column(
              //   children: const [
              //     //Icon(Icons.person),
              //   ],
              // ),
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
                                // FirebaseAuth.instance.signInWithEmailAndPassword(
                                //     email: _emailController.text, password: _passwordController.text);
                                signInWithEmailAndPassword();
                              }
                              //   setState(() {
                              //     // _contactNameController.text.isEmpty
                              //     //     ? _validateName = true
                              //     //     : _validateName = false;
                              //     _contactNumberController.text.isEmpty
                              //         ? _validateNumber = true
                              //         : _validateNumber = false;
                              //   });
                              //   if (
                              //   //_validateName == false &&
                              //   _validateNumber == false) {
                              //     //InsertContacts
                              //     // var _contact = Contact();
                              //     // _contact.name = _contactNameController.text;
                              //     // _contact.number = _contactNumberController.text;
                              //     // _contact.email = _contactEmailController.text;
                              //     // _contact.photo = ImagePath ?? "";
                              //     // print(_contact.name);
                              //     // print(_contact.number);
                              //     // print(_contact.email);
                              //     // print(_contact.photo);
                              //     // var result =
                              //     // await _contactCommunication.saveContact(_contact);
                              //     // Navigator.pop(context, result);
                              //   };
                              //loggedIn ?
                              // Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => CustomerPage()));
                              // : SizedBox.shrink();
                            },
                            child: const Text('Login')),
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
