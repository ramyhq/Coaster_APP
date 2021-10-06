// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:coastv1/consts/back_ground_const.dart';
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/consts/text_const.dart';
import 'package:coastv1/my_widgets/my_text_field.dart';
import 'package:coastv1/screens/signup_screen.dart';
import 'package:coastv1/utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatelessWidget {
  static const String? routeName = '/LoginScreen';
  LoginScreen({Key? key}) : super(key: key);

  final ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
  splashFactory: NoSplash.splashFactory,
  shape: const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(5)),
  ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DismissKeyboard(
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
                decoration:  BoxDecoration(
                  gradient: kBGGradient,
                ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  width:  MediaQuery.of(context).size.width / 1.15,
                  height: MediaQuery.of(context).size.height / 1.3 ,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Text('Coast',style: kLoginScreenTitle,),
                        ),
                        MyTextField(
                          hintText: "Enter Your Email",
                          labelText:  "Email",
                        ),
                        MyTextField(
                          hintText: "Enter Your Password",
                          labelText:  "Password",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: myButtonStyle,
                              onPressed: (){
                                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: LoginScreen()));
                              },
                              child: Text('Forgot password ?',style: kForgetPasswordS,),
                            ),
                            OutlinedButton(

                              style: myButtonStyle,
                                onPressed: (){
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SignUPScreen()));
                                },
                                child: Text('Sign up',style: kSignUpStyle)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}




