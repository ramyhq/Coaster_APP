import 'package:coastv1/data_layer/database_services/ads_db_services.dart';
import 'package:coastv1/data_layer/database_services/user_database_services.dart';
import 'package:coastv1/data_layer/models/ad_model.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:coastv1/screens/auth/login_screen.dart';
import 'package:coastv1/screens/home_pages/main_page.dart';
import 'package:coastv1/screens/auth/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  static const String id = 'AuthWrapper';
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('AuthWrapper build is called');
    final ourUserState = Provider.of<User?>(context); // stream of (our UserData status) // for only user Login Status
    if (ourUserState == null || ourUserState.isAnonymous) {
      print('if called in AuthWrapper');
      return StartScreen();
    } else {
      print('else called in AuthWrapper');
      return MultiProvider(providers: [
        StreamProvider<UserData?>(
          create: (_) =>
              UserDatabaseServices().userDataFromDB(ourUserState.uid),
          initialData: null,
          catchError: (_, err) {
            print(err.toString());
          },
        ),
        StreamProvider<List<AdModel?>?>(
            create: (_) => AdsDatabaseServices().adsListStream(), // this is for all ads
            initialData: null,
            catchError: (_, err) {
              print('catchError from StreamProvider ** ${err.toString()}');
            }),

      ], child: MainPage());
    }
  }
}
