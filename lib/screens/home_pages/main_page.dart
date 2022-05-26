
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/my_widgets/botton_navigation_bar.dart';
import 'package:coastv1/my_widgets/loading_widget.dart';
import 'package:coastv1/my_widgets/showAlerts.dart';
import 'package:coastv1/screens/home_drawer/home_drawer.dart';
import 'package:coastv1/screens/home_drawer/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../consts/text_const.dart';


class MainPage extends StatelessWidget {
  static const String id = 'MainPage';
  const MainPage({Key? key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ourUserState = Provider.of<User?>(context); // for only user Login Status
    final userDataFromDB = Provider.of<UserData?>(context); // stream of profile user data from DB
    final user = FirebaseAuth.instance.currentUser;

    print('MainPage build is called');
      print('from user data 3 :${userDataFromDB}');
    if(userDataFromDB != null ){
    }else{
    }
    return Consumer<User?>(
  builder: (context, userDataFromDBHere, child) {
    return userDataFromDBHere == null ?  LoadingPage() :  SafeArea(
      child: Scaffold(
        drawer: HomeDrawer(),
        appBar: AppBar(
          backgroundColor: colorBlue,
          actions: [
            Container(
               margin: const EdgeInsets.only(right: 16,top: 5,left: 16),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white,
                child: GestureDetector(
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: colorBlue,
                    backgroundImage: CachedNetworkImageProvider(userDataFromDB == null ? defaultProfileImage :  userDataFromDB.profileImage.toString()),
                  ),
                  onTap: (){
                    if(ourUserState!.isAnonymous){
                      showLoginAlertDialog(context: context, function: () {
                      });
                      return;
                    }
                    Navigator.push(
                        context,PageRouteBuilder(
                        pageBuilder:(context, animation1, animation2)=> SettingView()));

                  },
                ),
              ),
            ),
          ],
        ),
        body: MyPagesWithBottomNavigationBar(),
      ),
    );
  },
);
  }
}


