// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:coastv1/consts/back_ground_const.dart';
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/consts/text_const.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/my_widgets/loading_widget.dart';
import 'package:coastv1/my_widgets/login_button.dart';
import 'package:coastv1/my_widgets/my_text_field.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:coastv1/screens/home_pages/main_page.dart';
import 'package:coastv1/utils/dismiss_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'package:get/get.dart';


class SignUPScreen extends StatefulWidget {
  static const String id = 'SignUPScreen';
  final toggleRegister;
  const SignUPScreen({Key? key,this.toggleRegister}) : super(key: key);

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  // Variables
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _mobController;
  late TextEditingController _descriptionController;
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
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _mobController = TextEditingController();
    _descriptionController = TextEditingController();
  }


  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobController.dispose();
    _descriptionController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    final ourUser = Provider.of<User?>(context,listen: true);// stream of (our UserData status) // for only user Login Status

    return SafeArea(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: Colors.white,
          //resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          elevation: 0,
            actions: [
              TextButton(
                  style: myButtonStyle,
                  onPressed: () async{
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
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
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
                      // name
                      MyTextField(
                        controller: _nameController,
                        validator: (val) {
                          if (_letsValidat) {
                            if (val!.isEmpty ) {
                              return "enter your name".tr;
                            } else {
                              return null;
                            }
                          }
                        },
                        hintText: "enter your name".tr,
                        labelText: "name".tr,
                        prefixIcon: Icon(Icons.mail),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                      // email
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
                      //Password
                      MyTextField(
                        controller: _passwordController,
                        validator: (val) {
                          if (_letsValidat) {
                            if (val!.length < 6) {
                              return 'Password too short'.tr;
                            } else {
                              return null;
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
                        textInputAction: TextInputAction.next,
                        obscureText: _obscureText,
                      ),
                      // confirm Password
                      MyTextField(
                        controller: _confirmPasswordController,
                        validator: (val) {
                          if (_letsValidat) {
                            if (val != _passwordController.text) {
                              return 'Password not match'.tr;
                            } else {
                              return null;
                            }
                          }
                        },
                        hintText: "confirm Your Password".tr,
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
                        textInputAction: TextInputAction.next,
                        obscureText: _obscureText,
                      ),
                      //mob
                      MyTextField(
                        controller: _mobController,
                        validator: (val) {
                          if (_letsValidat) {
                            if (val!.isEmpty || val.length < 11) {
                              return "enter a your mobile".tr;
                            } else {
                              return null;
                            }
                          }
                        },
                        hintText: "enter your mobile".tr,
                        labelText: "mobile".tr,
                        prefixIcon: Icon(Icons.mail),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      //description
                      MyTextField(
                        controller: _descriptionController,
                        validator: (val) {
                          if (_letsValidat) {
                              return null;
                          }
                        },
                        hintText: "description".tr,
                        labelText: "description".tr,
                        prefixIcon: Icon(Icons.mail),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      loginProvider.isLoading
                          ? LoadingWidget()
                          : LoginButton(
                              width: 210,
                              height: 60,
                              labelStyle: kLoginLabelStyle,
                              label: 'Sign up'.tr,
                              onPressed: () async {
                                FocusScope.of(context).unfocus(); // to unfocused Keyboard
                                setState(() {
                                  _letsValidat = true;
                                });
                                if (_formKey.currentState!.validate()) {
                                  User? ourNewUser = await loginProvider.register(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                      _nameController.text.trim(),
                                      _mobController.text.trim(),
                                      _descriptionController.text.trim(),
                                );
                                  print('succ signup and use is ${ourNewUser!.email}');
                                  _storeUserUid(ourNewUser.uid);
                                  // if successfully Sign up
                                  if(ourNewUser != null){
                                    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: MainPage()));
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
                              'Already have account ?'.tr,
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
                                //         child: LoginScreen()));
                              },
                              child: Text('Login'.tr, style: kSignUpStyle)),
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
                            title: Text(loginProvider.errorMessage!,
                                style: TextStyle(
                                  fontSize: 10,
                                ),),
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
