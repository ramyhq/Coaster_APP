

import 'package:coastv1/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoginAlertDialog(
    {required BuildContext context, required VoidCallback function}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text("Login".tr),
        content: Text("you need to login to use this page".tr),
        actions: [
          TextButton(
            child:  Text("Cancel".tr),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child:  Text("Login".tr),
            onPressed: () {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                  pageBuilder:(context, animation1, animation2)=> const LoginScreen()));
            },
          )
        ],
      );
    },
  );
}
