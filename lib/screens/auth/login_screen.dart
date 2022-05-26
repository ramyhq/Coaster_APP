// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:coastv1/consts/back_ground_const.dart';
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/consts/text_const.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/my_widgets/error_widget.dart';
import 'package:coastv1/my_widgets/loading_widget.dart';
import 'package:coastv1/my_widgets/login_button.dart';
import 'package:coastv1/my_widgets/my_text_field.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:coastv1/screens/auth/auth_wrapper.dart';
import 'package:coastv1/screens/auth/signup_screen.dart';
import 'package:coastv1/screens/home_pages/main_page.dart';
import 'package:coastv1/utils/dismiss_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';
  final toggleRegister;
  const LoginScreen({Key? key,this.toggleRegister}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variables
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _letsValidat = false;

  final ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
    splashFactory: NoSplash.splashFactory,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
  );

  _storeUserUid(uid) async {
    print("Shared pref called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userUid', uid);
    await prefs.setBool('isGrid', false);
    print('after succ login UID is :${prefs.getString('userUid')}');
  }
  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    final ourUser = Provider.of<AuthServices>(context);

    return SafeArea(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              TextButton(
                  style: myButtonStyle,
                  onPressed: () async {
                    await loginProvider.signInAnon();
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: MainPage()));
                  },
                  child: Text('Skip'.tr, style: kSignUpStyle))
            ],
          ),
          //resizeToAvoidBottomInset: false,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: Text(
                          'Coaster',
                          style: kLoginScreenTitle,
                        ),
                      ),
                      MyTextField(
                        controller: _emailController,
                        validator: (val) {
                          if (_letsValidat) {
                            if (val!.isEmpty || !val.contains("@")) {
                              return "enter a valid email".tr;
                            } else {
                              return null;
                            }
                          }
                        },
                        hintText: "Enter Your Email".tr,
                        labelText: "Email".tr,
                        prefixIcon: Icon(Icons.mail),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      MyTextField(
                        controller: _passwordController,
                        validator: (val) {
                          if (_letsValidat) {
                            if (val!.length >= 6) {
                              return null;
                            } else {
                              return 'Password too short ... min is 6 char'
                                  .tr;
                            }
                          }
                        },
                        hintText: "Enter Your Password".tr,
                        labelText: "Password".tr,
                        prefixIcon: Icon(Icons.vpn_key),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: _obscureText
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off)),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        obscureText: _obscureText,
                      ),
                      loginProvider.isLoading
                          ? LoadingWidget()
                          : LoginButton(
                              width: 210,
                              height: 60,
                              labelStyle: kLoginLabelStyle,
                              label: 'Login'.tr,
                              onPressed: () async {
                                FocusScope.of(context)
                                    .unfocus(); // to unfocused Keyboard
                                setState(() {
                                  _letsValidat = true;
                                });

                                if (_formKey.currentState!.validate()) {
                                  User? ourNewUser = await loginProvider.login(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim());
                                  print('succ login and use is ${ourNewUser!.email}');
                                  _storeUserUid(ourNewUser.uid);
                                  if (ourNewUser != null) {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child: AuthWrapper()));
                                  }
                                }
                              },
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: myButtonStyle,
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: LoginScreen()));
                            },
                            child: Text(
                              'Forgot password ?'.tr,
                              style: kForgetPasswordS,
                            ),
                          ),
                          OutlinedButton(
                              style: myButtonStyle,
                              onPressed: () {
                                widget.toggleRegister();
                                // Navigator.pushReplacement(
                                //     context,
                                //     PageTransition(
                                //         type: PageTransitionType.fade,
                                //         child: SignUPScreen()));
                              },
                              child: Text('Sign up'.tr, style: kSignUpStyle)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (loginProvider.errorMessage != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0,
                          ),
                          width: double.infinity,
                          color: Colors.amber,
                          child: ListTile(
                            trailing: IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 20,
                              ),
                              onPressed: () {
                                loginProvider.setMessage(null);
                              },
                            ),
                            title: Text(
                              loginProvider.errorMessage!,
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
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
