import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth.dart';
import '../navdrawer.dart';
import 'home customer.dart';

class CustomerPage extends StatefulWidget {
  CustomerPage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text("Sign Out"));
  }

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  late bool isLoggedIn;

  late String Name = "";
  late String Vnumber = "";
  late String QuotaLimit = "";

  ShowDialog() {
    showDialog(
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

  _fetchName() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        Name = ds.data()!['username'];
      }).catchError((e) {});
    } else {
      Name = '';
    }
  }

  _fetchVnumber() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        Vnumber = ds.data()!['Vehicle Number'];
      }).catchError((e) {});
    } else {
      Vnumber = '';
    }
  }

  _fetchQuota() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        QuotaLimit = ds.data()!['quota'];
      }).catchError((e) {
        print(e);
      });
    } else {
      QuotaLimit = '';
    }
  }

  @override
  void initState() {
    _fetchQuota();
    _fetchVnumber();
    _fetchName();
    // TODO: implement initState
    super.initState();
  }

  final homecustomer = new HomeCustomer();

  var _fuelAmountController = TextEditingController();
  //
  // bool _validateName = false;
  bool _validateNumber = false;

  bool quota = false;

  bool free = true;

  _ValidateQuota() async {
    free
        ? setState(() {
            quota = true;
            showDialog(
                context: context,
                builder: (parm) {
                  return AlertDialog(
                    title: Column(
                      children: const [
                        Text(
                          'Avaliable limit',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '5 liters',
                          style: TextStyle(color: Colors.green, fontSize: 18),
                        ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // TextButton(
                        //   onPressed: () {
                        //   },
                        //   child: Text('5 liters',
                        //       style:
                        //       TextStyle(color: Colors.green, fontSize: 18)),
                        // ),
                      ],
                    ),
                  );
                });
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
      drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: const Text(
          'PowerFuel',
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
                height: 0.0,
              ),
              Row(
                children: [
                  FutureBuilder(
                      future: _fetchName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return Text("Welcome",
                              style: TextStyle(fontSize: 30));
                        return Text("Welcome " + Name,
                            style: TextStyle(fontSize: 30));
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 100.0),
                    child: IconButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueGrey,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        FirebaseAuth.instance.signOut();
                      },
                      icon: Icon(Icons.logout),
                      //child: const Text('Sign Out')),
                    ),
                  )
                ],
              ),
              // Text(
              //   "Welcome",
              //   style: TextStyle(fontSize: 30),
              // ),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Text(
                    "Vehicle number:",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  FutureBuilder(
                      future: _fetchVnumber(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return Text("Vehicle Number",
                              style: TextStyle(fontSize: 20));
                        return Text(Vnumber, style: TextStyle(fontSize: 17));
                      }),
                ],
              ),
              const SizedBox(
                height: 150.0,
              ),

              Column(
                children: [
                  const Center(
                      child: Text(
                    "Quota limit",
                    style: TextStyle(fontSize: 18),
                  )),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Center(
                    child: FutureBuilder(
                        future: _fetchQuota(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done)
                            return Text("0 litres",
                                style: TextStyle(fontSize: 40));
                          return Text(QuotaLimit + " litres",
                              style: TextStyle(fontSize: 40));
                        }),
                  ),
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
                      enabled: true,
                      controller: _fuelAmountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                      ],
                      decoration: const InputDecoration(
                        //filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter fuel amount',
                        labelText: 'Fuel amount',
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
                            onPressed: () async {
                              //ShowDialog();
                              FirebaseFirestore.instance
                                  .collection("Requests")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .set({
                                "requested amount": _fuelAmountController.text,
                                "customerId":
                                    FirebaseAuth.instance.currentUser!.uid,
                                "customerName": Name,
                                "Vehicle number": Vnumber,
                                "Status": "Pending"
                              });
                              setState(() {});
                            },
                            child: const Text('Request fuel')),
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
                  // SizedBox(
                  //   height: 750,
                  //   child: IconButton(
                  //       style: TextButton.styleFrom(
                  //           foregroundColor: Colors.white,
                  //           backgroundColor: Colors.blueGrey,
                  //           textStyle: const TextStyle(fontSize: 15)),
                  //       onPressed: () async {
                  //         FirebaseAuth.instance.signOut();
                  //       },
                  //       icon: Icon(Icons.logout),
                  //       //child: const Text('Sign Out')),
                  // ),
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
