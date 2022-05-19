// ignore_for_file: prefer_const_constructors

import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:coastv1/screens/home_drawer/profile.dart';
import 'package:coastv1/screens/home_drawer/settings.dart';
import 'package:coastv1/screens/home_drawer/tems_privacy.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../auth/start_screen.dart';
import 'about_us.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);

    return SafeArea(
      right: false,
      child: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/images/profile0.png'),
            ),
            SizedBox(
              height: 80,
            ),
            Container(
              //height: MediaQuery.of(context).size.height / 2,
              //margin: const EdgeInsets.symmetric(horizontal: 50),
              // decoration: BoxDecoration(
              //   color: Color(0xffffcc00),
              //   borderRadius: BorderRadius.circular(32),
              // ),
              child: SingleChildScrollView(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DrawerItem(
                        text: 'Profile',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile()));
                        }),
                    // DrawerItem(
                    //     text: 'Setting',
                    //     onTap: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => Setting()));
                    //     }),
                    DrawerItem(
                        text: 'About App',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutApp()));
                        }),
                    DrawerItem(
                        text: 'Terms',
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Terms()));
                        }),
                    DrawerItem(
                      text: 'Log out',
                      onTap: () async {
                        await loginProvider.logout();
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString('userUid', '_');
                        print('logout succ and UID is reset :${prefs.getString('userUid')}');
                        userUid = '';
                        print('logout succ and UID var is  :$userUid');
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: StartScreen()));

                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: colorBlue.withOpacity(0.8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        onTap: onTap,
      ),
    );
  }

}
