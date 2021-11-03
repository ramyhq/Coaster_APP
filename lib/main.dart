// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coastv1/data_layer/models/ad_model.dart';
import 'package:coastv1/my_widgets/error_widget.dart';
import 'package:coastv1/my_widgets/loading_widget.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:coastv1/providers/selected_lang/selected_lang_provider.dart';
import 'package:coastv1/screens/auth/login_screen.dart';
import 'package:coastv1/screens/auth/signup_screen.dart';
import 'package:coastv1/screens/auth_wrapper.dart';
import 'package:coastv1/screens/home_pages/main_page.dart';
import 'package:coastv1/screens/onboard_screen/onboard_screen.dart';
import 'package:coastv1/screens/start_screen.dart';
import 'package:coastv1/utils/language/translation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_layer/database_services.dart';
import 'data_layer/models/user_data.dart';

int? isviewed;
String? userUid;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  )); // to make status bar transparent useing flutter services  package:flutter/services.dart';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  userUid =  prefs.getString('userUid');
  print('userUid from Main() is :$userUid');

  final Future<FirebaseApp> init =  Firebase.initializeApp();

  // to disable Rotate Orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);

  runApp( MyApp(init: init));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp>? init;
  const MyApp({Key? key, this.init}) : super(key: key);
  @override
  Widget build(BuildContext context)  {
    print('MyApp build is called ');

    return  FutureBuilder(
      future: init,
      builder: (context,snapshot){
        if (snapshot.hasData){
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthServices>.value(value: AuthServices()),
              ChangeNotifierProvider<SelectedLang>(
                create: (_)=> SelectedLang(),
              ),
               //StreamProvider<UserData?>.value(value: AuthServices().ourUserStatusStream, initialData: null),
              StreamProvider<User?>(
                  create: (_) => AuthServices().ourUserStatusStream , // for only user Login Status
                  initialData: null),

            ],
            child: GetMaterialApp(
                debugShowCheckedModeBanner: false ,
                title: 'Coast',
                initialRoute: AuthWrapper.id,
                routes: {
                  AuthWrapper.id:(context) => isviewed != 0 ? OnBoardScreen() : AuthWrapper(),
                  StartScreen.id: (context) =>  StartScreen(),
                  LoginScreen.id: (context) =>  LoginScreen(),
                  SignUPScreen.id: (context) =>  SignUPScreen(),
                  MainPage.id: (context) =>  MainPage(),
                },
                translations: Translation(),
                locale: Locale('en'), // this for device language -> Get.deviceLocale
                //fallbackLocale: Locale('en'),

            ),
          );
        } else if (snapshot.hasError){
          return ErrorPage();
        }else {
          return LoadingPage();
        }
      }
    );
  }
}
