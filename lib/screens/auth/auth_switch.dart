// ignore_for_file: prefer_const_constructors
import 'package:coastv1/screens/auth/login_screen.dart';
import 'package:coastv1/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';


class AuthSwitch extends StatefulWidget {
  const AuthSwitch({Key? key}) : super(key: key);

  @override
  _AuthSwitchState createState() => _AuthSwitchState();
}

class _AuthSwitchState extends State<AuthSwitch> {

  bool showRegister = false;
  void toggleRegister(){
    setState(() {
      showRegister = !showRegister;
      print('toggleRegister called');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showRegister){
      return SignUPScreen(toggleRegister: toggleRegister);
    }else {
      return LoginScreen(toggleRegister: toggleRegister);
    }

  }
}
