// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/data_layer/database_services/user_database_services.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/my_widgets/showAlerts.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:coastv1/screens/home_drawer/settings.dart';
import 'package:coastv1/screens/home_drawer/tems_privacy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../auth/start_screen.dart';
import 'about_us.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    final user = FirebaseAuth.instance.currentUser;
    final Uri _url = Uri.parse('https://sites.google.com/view/coastv1/home');
    void _launchUrl() async {
      if (!await launchUrl(_url)) throw 'Could not launch $_url';
    }

    return SafeArea(
      right: false,
      child: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundColor: colorBlue,
              backgroundImage: CachedNetworkImageProvider(user == null ? defaultProfileImage : user.photoURL.toString() != 'null' ? user.photoURL.toString() :defaultProfileImage ),
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
                        text: 'Settings'.tr,
                        onTap: () {
                          if(user!.isAnonymous){
                            showLoginAlertDialog(context: context, function: () {
                            });
                            return;
                          }
                          Navigator.push(
                              context,PageRouteBuilder(
                              pageBuilder:(context, animation1, animation2)=> SettingView()));


                        }),

                    DrawerItem(
                        text: 'About App'.tr,
                        onTap: () {
                          Navigator.push(
                              context,PageRouteBuilder(
                              pageBuilder:(context, animation1, animation2)=>  AboutApp()));
                        }),
                    DrawerItem(
                        text: 'Terms'.tr,
                        onTap: _launchUrl
                    ),
                    DrawerItem(
                      text: 'Logout'.tr,
                      onTap: () async {
                        Navigator.pushReplacement(
                            context,PageRouteBuilder(
                            pageBuilder:(context, animation1, animation2)=> StartScreen()));

                        await loginProvider.logout();
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString('userUid', '_');
                        print('logout succ and UID is reset :${prefs.getString('userUid')}');
                        userUid = '';
                        print('logout succ and UID var is  :$userUid');


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
        contentPadding: EdgeInsets.only(top: 0),
        title: Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

}
