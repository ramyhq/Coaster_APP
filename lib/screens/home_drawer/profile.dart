// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';


class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Container(
              //   width: 160,
              //   height: 260,
              //   child: _pickedImage != null
              //       ? Image.file(_pickedImage!)
              //       : FlutterLogo(
              //     size: 80,
              //   ),
              // ),
              //
            ],
          ),
        ),
      ),
    );
  }
}


