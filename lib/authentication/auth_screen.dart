import 'package:flutter/material.dart';

import 'login.dart';
import 'register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.cyan),
          ),
          automaticallyImplyLeading: false,
          title: const Text(
            "KatGo",
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
              fontFamily: "Bea",
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Đăng Nhập",
              ),
              Tab(
                text: "Đăng kí",
              ),
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 6,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: const TabBarView(
            children: [
              LoginScreen(),
              RegisterScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
