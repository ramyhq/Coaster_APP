


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/data_layer/database_services.dart';
import 'package:coastv1/data_layer/models/ad_model.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/my_widgets/botton_navigation_bar.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:coastv1/screens/auth/login_screen.dart';
import 'package:coastv1/screens/home_drawer/home_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../start_screen.dart';
import 'look_for_screen.dart';

class MainPage extends StatelessWidget {
  static const String id = 'MainPage';

  const MainPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ourUserState = Provider.of<User?>(context); // for only user Login Status
    final userDataFromDB = Provider.of<UserData?>(context); // stream of profile user data from DB
    final adsDataFromDB = Provider.of<AdModel?>(context); // stream of profile user data from DB
    print('MainPage build is called');
    if(userDataFromDB != null ){
      print('from user data :${userDataFromDB.email}');
      print('the uid ddddddddddddd ${userUid}');
    }else{
    }

    return SafeArea(
      child: Scaffold(
        drawer: HomeDrawer(),
        appBar: AppBar(
          title: ourUserState == null ? const Text('Hey there :)'): Text('Hi ${ourUserState.email}'),
          backgroundColor: colorBlue,
        ),
        body: MyPagesWithBottomNavigationBar(),
      ),
    );
  }
}


