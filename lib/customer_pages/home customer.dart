import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth/Login.dart';

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
      // drawer: NavDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red[700],
        title: const Text(
          'PowerFuel ',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
      ),
      body: Login()
    );
  }
}