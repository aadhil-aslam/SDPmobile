import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sdp/Customers/Login.dart';
import '../auth.dart';
import '../navdrawer.dart';
import 'home customer.dart';

enum FuelType { petrol, diesel }

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
  FuelType? _fueltype = FuelType.petrol;

  String selectedStationName = 'Colombo';
  String stationID = '001';
  String selectedFuelType = '';

  late Station selectedStation;

  List<Station> station = <Station>[
    const Station("PF001", 'Colombo'),
    const Station("PF002", 'Kalutara'),
    const Station("PF003", 'Jaffna'),
    const Station("PF004", 'Kandy'),
    const Station("PF005", 'Hatton'),
    const Station("PF006", 'Batticalo')
  ];

  _logoutAlert() {
    return showDialog(
        context: context,
        builder: (parm) {
          return AlertDialog(
            title: const Text(
              'Do you want to logout?',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    //backgroundColor: Colors.blueGrey,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel', style: TextStyle(fontSize: 17))),
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    //backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeCustomer()));
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 17),
                  )),
            ],
          );
        });
  }

  late String fcmT;
  updateDeviceToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((ds) {
        fcmT = ds.data()!['DeviceToken'];
      }).catchError((e) {});
    } else {
      const SizedBox.shrink();
    }
    if (fcmToken != fcmT) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({'DeviceToken': fcmToken});
    } else {
      const SizedBox.shrink();
    }
  }

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    await Firebase.initializeApp();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  DeviceToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    //print(fcmToken);
  }

  final _formKey = GlobalKey<FormState>();

  String Token = "Pending";

  bool requested = false;

  int currentLimit = 1;
  double percentage = 0.1;
  int Limit = 1;

  late bool isLoggedIn;

  late String Name = "";
  late String Vnumber = "";
  late String isRequested = "";

  ShowDialog() {
    showDialog(
        context: context,
        builder: (parm) {
          return AlertDialog(
            title: Column(
              children: const [
                Text(
                  textAlign: TextAlign.center,
                  'Please request within available limit',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.cancel_outlined,
                  size: 50,
                  color: Colors.red,
                )
              ],
            ),
          );
        });
  }

  requestedDialog() {
    showDialog(
        context: context,
        builder: (parm) {
          return AlertDialog(
            title: Column(
              children: const [
                Text(
                  textAlign: TextAlign.center,
                  'Please request after previous order completed',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.cancel_outlined,
                  size: 50,
                  color: Colors.red,
                )
              ],
            ),
          );
        });
  }

  final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
      .collection("User")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  _fetchName() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        Name = ds.data()!['username'];
        Vnumber = ds.data()!['Vehicle Number'];
        isRequested = ds.data()!['Requested'];
        currentLimit = int.parse(ds.data()!['balanceQuota']);
        Limit = int.parse(ds.data()!['quota']);
        percentage = (currentLimit * Limit / 100);
        setState(() {
          requested = isRequested == "Yes";
        });
      }).catchError((e) {});
    } else {
      Name = '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchName();
    selectedStation = station[0];
    requestPermission();
    updateDeviceToken();
    super.initState();
  }

  final homecustomer = new HomeCustomer();

  var _fuelAmountController = TextEditingController();
  //
  // bool _validateName = false;
  bool _validateNumber = false;

  bool quota = false;

  late bool free;

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
                      style: TextStyle(color: Colors.black, fontSize: 18),
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
    DeviceToken();

    // final _uid = FirebaseAuth.instance.currentUser!.uid;
    //
    // final Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream =
    // FirebaseFirestore.instance
    //     .collection('UserData')
    //     .doc(_uid)
    //     .snapshots();

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
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance.collection('User').snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       return ListView.builder(
                  //           itemCount: snapshot.data!.docs.length,
                  //           itemBuilder: (context, index) {
                  //             DocumentSnapshot doc = snapshot.data!.docs[index];
                  //             return Text(doc['username']);
                  //           });
                  //     } else {
                  //       return Text("No data");
                  //     }
                  //   },
                  // ),
                  Expanded(
                    child:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      //key: Key(_uid),
                      stream: FirebaseFirestore.instance
                          .collection('User')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          //String username = snapshot.data?.data()?['username'];
                          //Token = snapshot.data?.data()?['Token'];
                          requested =
                              snapshot.data?.data()?['Requested'] == "Yes";
                          //print(snapshot.data?.data()?['username']);
                          return Text(
                              "Welcome " +
                                  snapshot.data!['username']
                                      .split(" ")
                                      .elementAt(0),
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w500));
                        }
                        return Text("Welcome",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500));
                      },
                    ),
                  ),

                  // FutureBuilder(
                  //     future: _fetchName(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState != ConnectionState.done)
                  //         return Text("Welcome",
                  //             style: TextStyle(fontSize: 30));
                  //       return Text("Welcome " + Name,
                  //           style: TextStyle(fontSize: 30));
                  //     }),

                  Padding(
                    padding: const EdgeInsets.only(left: 100.0),
                    child: IconButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueGrey,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        // var collection = FirebaseFirestore.instance.collection('User');
                        // var querySnapshots = await collection.get();
                        // for (var doc in querySnapshots.docs) {
                        //   await doc.reference.update({
                        //     'Requested': 'No', 'Token': 'Pending',
                        //   });
                        // }
                        _logoutAlert();
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

              // Card(
              //   child: ListTile(
              //     title: Text('Vehicle number:',
              //         style: TextStyle(fontSize: 17)),
              //     trailing: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              //       //key: Key(_uid),
              //       stream: FirebaseFirestore.instance
              //           .collection('User')
              //           .doc(FirebaseAuth.instance.currentUser!.uid)
              //           .snapshots(),
              //       builder: (context, snapshot) {
              //         if (snapshot.hasData) {
              //           //String username = snapshot.data?.data()?['username'];
              //           //print(snapshot.data?.data()?['Vehicle Number']);
              //           return Text(snapshot.data!['Vehicle Number'],
              //               style: TextStyle(fontSize: 17));
              //         }
              //         return Text("Vehicle Number",
              //             style: TextStyle(fontSize: 20));
              //       },
              //     ),
              //   ),
              // ),

              Row(
                children: [
                  Text(
                    "Vehicle number:",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    //key: Key(_uid),
                    stream: FirebaseFirestore.instance
                        .collection('User')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        //String username = snapshot.data?.data()?['username'];
                        //print(snapshot.data?.data()?['Vehicle Number']);
                        return Text(snapshot.data!['Vehicle Number'],
                            style: TextStyle(fontSize: 17));
                      }
                      return Text("Vehicle Number",
                          style: TextStyle(fontSize: 20));
                    },
                  ),
                  // FutureBuilder(
                  //     future: _fetchVnumber(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState != ConnectionState.done)
                  //         return Text("Vehicle Number",
                  //             style: TextStyle(fontSize: 20));
                  //       return Text(Vnumber, style: TextStyle(fontSize: 17));
                  //     }),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              requested
                  ? Column(
                      children: [
                        // Card(
                        //   child: ListTile(
                        //     title: Text('Token Number:',
                        //         style: TextStyle(fontSize: 17)),
                        //     trailing: StreamBuilder<
                        //         DocumentSnapshot<Map<String, dynamic>>>(
                        //       //key: Key(_uid),
                        //       stream: FirebaseFirestore.instance
                        //           .collection('User')
                        //           .doc(FirebaseAuth.instance.currentUser!.uid)
                        //           .snapshots(),
                        //       builder: (context, snapshot) {
                        //         if (snapshot.hasData) {
                        //           //String username = snapshot.data?.data()?['username'];
                        //           //print(snapshot.data?.data()?['Token Number']);
                        //           return Text(snapshot.data?.data()?['Token'],
                        //               style: TextStyle(fontSize: 17));
                        //         }
                        //         return Text("Token Number",
                        //             style: TextStyle(fontSize: 20));
                        //       },
                        //     ),
                        //   ),
                        // ),

                        Row(
                          children: [
                            Text(
                              "Token Number:",
                              style: TextStyle(fontSize: 17),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              //key: Key(_uid),
                              stream: FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  //String username = snapshot.data?.data()?['username'];
                                  //print(snapshot.data?.data()?['Token Number']);
                                  return Text(snapshot.data?.data()?['Token'],
                                      style: TextStyle(fontSize: 17));
                                }
                                return Text("Token Number",
                                    style: TextStyle(fontSize: 20));
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        // Card(
                        //   child: ListTile(
                        //     title: Text('Date and Time:',
                        //         style: TextStyle(fontSize: 17)),
                        //     trailing: StreamBuilder<
                        //         DocumentSnapshot<Map<String, dynamic>>>(
                        //       //key: Key(_uid),
                        //       stream: FirebaseFirestore.instance
                        //           .collection('User')
                        //           .doc(FirebaseAuth.instance.currentUser!.uid)
                        //           .snapshots(),
                        //       builder: (context, snapshot) {
                        //         if (snapshot.hasData) {
                        //           //String username = snapshot.data?.data()?['username'];
                        //           //print(snapshot.data?.data()?['Token Number']);
                        //           return Text(
                        //               snapshot.data?.data()?['DateAndTime'],
                        //               style: TextStyle(fontSize: 17));
                        //         }
                        //         return Text("Date and Time",
                        //             style: TextStyle(fontSize: 20));
                        //       },
                        //     ),
                        //   ),
                        // ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date:",
                              style: TextStyle(fontSize: 17),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              //key: Key(_uid),
                              stream: FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  //String username = snapshot.data?.data()?['username'];
                                  //print(snapshot.data?.data()?['Token Number']);
                                  return Text(
                                      snapshot.data?.data()?['DateAndTime'],
                                      style: TextStyle(fontSize: 17));
                                }
                                return Text("Date and Time",
                                    style: TextStyle(fontSize: 20));
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              const SizedBox(
                height: 120.0,
              ),

              ///graph
              // Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(8.0),
              //       color: Colors.white,
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black12,
              //           blurRadius: 2.0,
              //           spreadRadius: 1.0,
              //           offset: Offset(
              //               2.0, 2.0), // shadow direction: bottom right
              //         )
              //       ],
              //     ),
              //     child: Container(
              //         width: MediaQuery.of(context).size.width,
              //         height: 110,
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //
              //             Padding(
              //               padding: const EdgeInsets.all(12.0),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Center(
              //                       child: Text(
              //                         "Quota limit",
              //                         style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
              //                       )),
              //                   Center(
              //                       child: Text(
              //                         "${Limit} litres",
              //                         style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
              //                       )),
              //                 ],
              //               ),
              //             ),
              //             LinearPercentIndicator(
              //               width: MediaQuery.of(context).size.width - 40,
              //               animation: true,
              //               lineHeight: 15.0,
              //               animationDuration: 2000,
              //               percent: percentage,
              //               center: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              //                 //key: Key(_uid),
              //                 stream: FirebaseFirestore.instance
              //                     .collection('User')
              //                     .doc(FirebaseAuth.instance.currentUser!.uid)
              //                     .snapshots(),
              //                 builder: (context, snapshot) {
              //                   //print(FirebaseAuth.instance.currentUser!.uid);
              //                   if (snapshot.hasData) {
              //                     //String username = snapshot.data?.data()?['username'];
              //                     currentLimit = int.parse(snapshot.data?.data()?['balanceQuota']);
              //                     Limit = int.parse(snapshot.data?.data()?['quota']);
              //                     percentage = (currentLimit*Limit/100);
              //                     return Text(snapshot.data!['balanceQuota'] + " litres",
              //                         style: TextStyle(fontSize: 10, color: Colors.grey.shade700));
              //                   }
              //                   return Text("0 litres", style: TextStyle(fontSize: 40));
              //                 },
              //               ),
              //               barRadius: const Radius.circular(16),
              //               progressColor: Colors.red.shade700,
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.all(12.0),
              //               child: Text(
              //                 "${currentLimit} litres remaining",
              //                 style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
              //               ),
              //             ),
              //           ],
              //         ),)),
              ///graph

              Column(
                children: [
                  const Center(
                      child: Text(
                    "Quota limit",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  )),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Center(
                    child:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      //key: Key(_uid),
                      stream: FirebaseFirestore.instance
                          .collection('User')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        //print(FirebaseAuth.instance.currentUser!.uid);
                        if (snapshot.hasData) {
                          //String username = snapshot.data?.data()?['username'];
                          currentLimit =
                              int.parse(snapshot.data?.data()?['balanceQuota']);
                          Limit = int.parse(snapshot.data?.data()?['quota']);
                          percentage = (currentLimit * Limit / 100);
                          return Text(
                              snapshot.data!['balanceQuota'] + " litres",
                              style: TextStyle(fontSize: 40));
                        }
                        return Text("0 litres", style: TextStyle(fontSize: 40));
                      },
                    ),
                  ),

                  /// CircularPercentIndicator
                  // const SizedBox(
                  //   height: 8.0,
                  // ),
                  // Center(
                  //   child:
                  //   CircularPercentIndicator(
                  //     radius: 80.0,
                  //     lineWidth: 13.0,
                  //     animation: true,
                  //     percent: percentage,
                  //     center: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  //       //key: Key(_uid),
                  //       stream: FirebaseFirestore.instance
                  //           .collection('User')
                  //           .doc(FirebaseAuth.instance.currentUser!.uid)
                  //           .snapshots(),
                  //       builder: (context, snapshot) {
                  //         //print(FirebaseAuth.instance.currentUser!.uid);
                  //         if (snapshot.hasData) {
                  //           //String username = snapshot.data?.data()?['username'];
                  //           currentLimit = int.parse(snapshot.data?.data()?['balanceQuota']);
                  //           Limit = int.parse(snapshot.data?.data()?['quota']);
                  //           percentage = (currentLimit*Limit/100);
                  //           return Text(snapshot.data!['balanceQuota'] + " litres",
                  //               style: TextStyle(fontSize: 30));
                  //         }
                  //         return Text("0 litres", style: TextStyle(fontSize: 30));
                  //       },
                  //     ),
                  //     circularStrokeCap: CircularStrokeCap.round,
                  //     progressColor: Colors.red.shade700,
                  //   ),
                  //  ),
                  /// CircularPercentIndicator

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
                  //     )
                  //     ),
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
                      child: DropdownButton<Station>(
                        hint: Text("Select Vehicle"),
                        value: selectedStation,
                        onChanged: (Station? newValue) {
                          setState(() {
                            selectedStation = newValue!;
                            stationID = selectedStation.id;
                            selectedStationName = selectedStation.name;
                          });
                          print(selectedStationName);
                        },
                        items: station.map((Station vehicles) {
                          return new DropdownMenuItem<Station>(
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
                    height: 18.0,),
                  // Container(
                  //   decoration: ShapeDecoration(
                  //     shape: RoundedRectangleBorder(
                  //       side: BorderSide(width: 0.5, style: BorderStyle.solid),
                  //       borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  //     ),
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //     child:
                  //                   DropdownButton<String>(
                  //                     items: <String>[
                  //                       "Petrol",
                  //                       "Diesel"
                  //                     ].map((String value) {
                  //                       return DropdownMenuItem<String>(
                  //                         value: value,
                  //                         child: Text(value),
                  //                       );
                  //                     }).toList(),
                  //                     hint: Text(selectedFuelType.isEmpty
                  //                         ? 'Fuel type'
                  //                         : selectedFuelType),
                  //                     //borderRadius: BorderRadius.circular(10),
                  //                     underline: SizedBox(),
                  //                     isExpanded: true,
                  //                     onChanged: (value) {
                  //                       if (value != null) {
                  //                         setState(() {
                  //                           selectedFuelType = value;
                  //                         });
                  //                       }
                  //                     },
                  //                   ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 18.0,
                  // ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                        validator: (value) {
                          if (value == "0" || value!.isEmpty) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                        enabled: true,
                        controller: _fuelAmountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                        ],
                        decoration: InputDecoration(
                          //filled: true,
                          fillColor: const Color(0xFFFFFFFF),
                          isDense: true,
                          border: OutlineInputBorder(),
                          hintText: 'Enter fuel amount',
                          labelText: 'Fuel amount',
                        )),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('Fuel type:', style: TextStyle(fontSize: 16),),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Radio<FuelType>(
                                value: FuelType.petrol,
                                groupValue: _fueltype,
                                onChanged: (FuelType? value) {
                                  setState(() {
                                    _fueltype = value;
                                  });
                                },
                              ),
                              const Expanded(child: Text('Petrol'))
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Radio<FuelType>(
                                value: FuelType.diesel,
                                groupValue: _fueltype,
                                onChanged: (FuelType? value) {
                                  setState(() {
                                    _fueltype = value;
                                  });
                                },
                              ),
                              const Expanded(child: Text('Diesel'))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
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
                              if (_formKey.currentState!.validate()) {
                                if (currentLimit >=
                                    int.parse(_fuelAmountController.text)) {
                                  if (requested == false) {
                                    var dateFormat =
                                        DateFormat('MM/dd/yyyy hh:mm a');
                                    var now = dateFormat.format(DateTime.now());

                                    DocumentReference docRef =
                                        await FirebaseFirestore.instance
                                            .collection("Requests")
                                            .add({
                                      "requested amount":
                                          _fuelAmountController.text,
                                      "customerId": FirebaseAuth
                                          .instance.currentUser!.uid,
                                      "customerName": Name,
                                      "Vehicle number": Vnumber,
                                      "Status": "Pending",
                                      "Token": "Pending",
                                      "Requested time": now.toString(),
                                      "DateAndTime": "Pending",
                                      "stationID": stationID,
                                      "stationName": selectedStationName,
                                      "Ordered": false,
                                      "fuelType": selectedFuelType,
                                    });
                                    print(Name);
                                    String docId = docRef.id;
                                    await FirebaseFirestore.instance
                                        .collection("Requests")
                                        .doc(docId)
                                        .update({'id': docId});
                                    currentLimit = currentLimit -
                                        int.parse(_fuelAmountController.text);

                                    await FirebaseFirestore.instance
                                        .collection("User")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      'Requested': "Yes",
                                      'balanceQuota': currentLimit.toString(),
                                      'Last requested': now.toString(),
                                      "DateAndTime": "Pending",
                                      "Token": "Pending",
                                      "requested amount":
                                          _fuelAmountController.text,
                                      "Requested Station": selectedStationName,
                                      "Rescheduled Date": "null",
                                    });
                                    setState(() {
                                      requested = true;
                                    });
                                  } else {
                                    requestedDialog();
                                  }
                                } else {
                                  ShowDialog();
                                }
                                //ShowDialog();
                                // FirebaseFirestore.instance.collection("Requests")//     //.doc(FirebaseAuth.instance.currentUser!.uid)
                                //     .add({
                                //   "requested amount": _fuelAmountController.text,
                                //   "customerId":
                                //       FirebaseAuth.instance.currentUser!.uid,
                                //   "customerName": Name,
                                //   "Vehicle number": Vnumber,
                                //   "Status": "Pending",
                                // "Token": "Pending"
                                // });
                                // setState(() {});
                                _fuelAmountController.text = "";
                              }
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

class Station {
  const Station(this.id, this.name);

  final String id;
  final String name;
}
