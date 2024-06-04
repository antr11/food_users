import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_users/assistantMethods/cart_Item_Counter.dart';

import 'package:food_users/assistantMethods/total_amount.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'assistantMethods/address_changer.dart';

import 'global/global.dart';
import 'splashScreen/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  //add fireBase
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
      ],
      child: MaterialApp(
        title: 'Delivery food',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MySplashScreen(),
      ),
    );
  }
}
