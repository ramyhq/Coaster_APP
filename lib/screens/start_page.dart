// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:coastv1/consts/back_ground_const.dart';
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/consts/text_const.dart';
import 'package:coastv1/my_widgets/glass_card.dart';
import 'package:coastv1/my_widgets/login_button.dart';
import 'package:coastv1/utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:coastv1/my_widgets/my_text_field.dart';
import 'package:page_transition/page_transition.dart';

import 'login_screen.dart';
import 'main_page.dart';

class StartScreen extends StatelessWidget {
  static const String? routeName = '/StartScreen';

  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DismissKeyboard(
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: kBGGradient,
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width / 1.15,
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: Text(
                          'Coast',
                          style: kLoginScreenTitle,
                        ),
                      ),
                      LoginButton(
                        width: 210,
                        height: 60,
                        labelStyle: kLoginLabelStyle,
                        label: 'Login',
                        onPressed: () {
                          //Navigator.pushNamed(context, '/LoginScreen');
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: LoginScreen()));
                        },
                      ),
                      LoginButton(
                        width: 120,
                        height: 50,
                        labelStyle: kSkipLabelStyle,
                        label: 'Skip',
                        onPressed: () {
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MainPage()));
                        },
                      ),
                    ],
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
