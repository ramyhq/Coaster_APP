// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coastv1/data_layer/models/ad_model.dart';
import 'package:coastv1/my_widgets/error_widget.dart';
import 'package:coastv1/my_widgets/loading_widget.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:coastv1/providers/selected_lang/selected_lang_provider.dart';
import 'package:coastv1/screens/auth/login_screen.dart';
import 'package:coastv1/screens/auth/signup_screen.dart';
import 'package:coastv1/screens/auth/auth_wrapper.dart';
import 'package:coastv1/screens/home_pages/ads_screens/ads_places_screen.dart';
import 'package:coastv1/screens/home_pages/main_page.dart';
import 'package:coastv1/screens/onboard_screen/onboard_screen.dart';
import 'package:coastv1/screens/auth/start_screen.dart';
import 'package:coastv1/utils/language/translation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'consts/colors.dart';
import 'data_layer/database_services/user_database_services.dart';
import 'data_layer/models/user_data.dart';

int? isviewed;
String? userUid;
String? favoritLanguage;
bool isGridSaved = false;
SharedPreferences? prefs2;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: colorBlue,
  )); // to make status bar transparent using flutter services  package:flutter/services.dart';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs2 = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  userUid =  prefs.getString('userUid');
  favoritLanguage =  prefs.getString('favoritLanguage');
  isGridSaved =  prefs.getBool('isGrid') ?? false;
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
    print('isviewed is $favoritLanguage **** ');

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
              theme: ThemeData().copyWith(
                textTheme: GoogleFonts.tajawalTextTheme(ThemeData().textTheme).copyWith(bodyText1: GoogleFonts.tajawal(fontSize: favoritLanguage == 'en' ? 18 : 16 ,fontWeight: FontWeight.w500,)),
              ),

            debugShowCheckedModeBanner: false ,
                title: 'Coaster',
                initialRoute: AuthWrapper.id,
                routes: {
                  AuthWrapper.id:(context) => isviewed != 0 ? OnBoardScreen() : AuthWrapper(),
                  StartScreen.id: (context) =>  StartScreen(),
                  LoginScreen.id: (context) =>  LoginScreen(),
                  SignUPScreen.id: (context) =>  SignUPScreen(),
                  MainPage.id: (context) =>  MainPage(),
                  AdsPlacesScreen.id: (context) =>  AdsPlacesScreen(),

                },
                translations: Translation(),
                locale: Locale(favoritLanguage.toString()), // this for device language -> Get.deviceLocale
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
