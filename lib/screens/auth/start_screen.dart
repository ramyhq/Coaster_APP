// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:coastv1/consts/back_ground_const.dart';
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/consts/text_const.dart';
import 'package:coastv1/my_widgets/glass_card.dart';
import 'package:coastv1/my_widgets/login_button.dart';
import 'package:coastv1/my_widgets/rolling_switch.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:coastv1/providers/selected_lang/selected_lang_provider.dart';
import 'package:coastv1/utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:coastv1/my_widgets/my_text_field.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'auth_switch.dart';
import 'login_screen.dart';
import '../home_pages/main_page.dart';

class StartScreen extends StatelessWidget {
  static const String id = 'StartScreen';

  StartScreen({Key? key}) : super(key: key);

  final ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
    splashFactory: NoSplash.splashFactory,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final selectedLang = Provider.of<SelectedLang>(context); //lang variable
    final loginProvider = Provider.of<AuthServices>(context);
    print('StartScreen build is called');
    return SafeArea(
      child: DismissKeyboard(
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
                  child: Row(
                    children: [GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        selectedLang.langToggle();
                        selectedLang.changeLanguage();
                      },
                      child: SwitchlikeCheckbox(
                        checked: selectedLang.langSwitch,
                      ),
                    ),
                      ],
                  ),
                ),
              ),
              Center(
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
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                'Coast',
                                style: kLoginScreenTitle,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.home_outlined,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      LoginButton(
                        width: 210,
                        height: 60,
                        labelStyle: kLoginLabelStyle,
                        label: 'Login'.tr,
                        onPressed: () {
                          //Navigator.pushNamed(context, '/LoginScreen');
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: AuthSwitch()));
                        },
                      ),
                      OutlinedButton(
                          style: myButtonStyle,
                          onPressed: () async{
                            await loginProvider.signInAnon();
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: MainPage()));
                          },
                          child: Text('Skip Login'.tr, style: kSignUpStyle)),



                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
