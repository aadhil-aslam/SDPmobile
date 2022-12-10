// import 'package:flutter/cupertino.dart';
// import 'package:sdp/Customers/CustomerPage.dart';
//
// import '../auth.dart';
// import 'Login.dart';
//
// class WidgetTree extends StatefulWidget {
//   const WidgetTree({Key? key}) : super(key: key);
//
//   @override
//   State<WidgetTree> createState() => _WidgetTreeState();
// }
//
// class _WidgetTreeState extends State<WidgetTree> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: Auth().authStatechanges,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return CustomerPage();
//           } else {
//             return Login();
//           }
//         }
//     );
//   }
// }