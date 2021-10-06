// ignore_for_file: prefer_const_constructors

import 'package:coastv1/screens/login_screen.dart';
import 'package:coastv1/screens/start_page.dart';
import 'package:flutter/material.dart';

import 'my_widgets/glass_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false ,
      title: 'Flutter Demo',
      //home: StartScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) =>  StartScreen(),
        '/LoginScreen': (context) =>  LoginScreen(),
      },
    );
  }
}
