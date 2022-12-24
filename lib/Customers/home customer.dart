import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../navdrawer.dart';
import 'CustomerPage.dart';
import 'Login.dart';

class HomeCustomer extends StatefulWidget {
  const HomeCustomer({Key? key}) : super(key: key);

  @override
  State<HomeCustomer> createState() => _HomeCustomerState();
}

class _HomeCustomerState extends State<HomeCustomer> {

  int pageIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
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
      body: Login()
      // PageTransitionSwitcher(
      //     transitionBuilder: (child, primaryAnimation, secondaryAnimaion) =>
      //         FadeThroughTransition(
      //             animation: primaryAnimation,
      //             secondaryAnimation: secondaryAnimaion,
      //             child: child),
      //     child: pages[pageIndex]),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home_outlined, size: 30,),
      //       activeIcon: Icon(Icons.home, size: 30,),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add_circle_outline,size: 30,),
      //       activeIcon: Icon(Icons.add_circle_outlined, size: 30,),
      //       label: 'Pump',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.local_gas_station_outlined,size: 30,),
      //       activeIcon: Icon(Icons.local_gas_station_rounded, size: 30,),
      //       label: 'Fuel',
      //     ),
      //   ],
      //   currentIndex: pageIndex,
      //   selectedItemColor: Colors.red[700],
      //   onTap: _onItemTapped,
      //   unselectedItemColor: Colors.black54,
      // ),
    );
  }
}