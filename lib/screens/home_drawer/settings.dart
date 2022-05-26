// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/consts/text_const.dart';
import 'package:coastv1/data_layer/database_services/ads_db_services.dart';
import 'package:coastv1/data_layer/database_services/user_database_services.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/my_widgets/loading_widget.dart';
import 'package:coastv1/my_widgets/login_button.dart';
import 'package:coastv1/my_widgets/my_text_field.dart';
import 'package:coastv1/my_widgets/rolling_switch.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:coastv1/providers/selected_lang/selected_lang_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/badge/gf_button_badge.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SettingView extends StatelessWidget {
  SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ourUser = Provider.of<User?>(
        context);

    return StreamBuilder<UserData?>(
      stream:
          UserDatabaseServices(uid: ourUser!.uid.toString()).userDataFromDBU,
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          return Scaffold(body: SettingScreen(userData:userData,user: ourUser));
        } else {
          return GFLoader();
        }
      },
    );
  }
}

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key, required this.userData, this.user}) : super(key: key);

  final UserData? userData;
  final User? user;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  File _pickedImage = File('a') ;
  String _imagesUrl = '';

  Future<void> uploadImages(UserData? userData) async {
     _imagesUrl = await UserDatabaseServices().uploadImage(
      image: _pickedImage,
      cloud_path: 'users_profile_images',
      file_name: '${userData!.name.toString()} + ${Random()
          .nextInt(10000)
          .toString()}',
    );

     UserDatabaseServices().userData_collection.doc(userData.uid).update({
       'profileImage' : _imagesUrl,
     });
     await widget.user!.updatePhotoURL(_imagesUrl);

  }

  @override
  Widget build(BuildContext context) {
    final selectedLang = Provider.of<SelectedLang>(context); //lang variable


    return Directionality(
      textDirection: TextDirection.ltr,
      child: SafeArea(
        child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 65.0, 10.0, 10.0),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(16.0),
                            margin: EdgeInsets.only(top: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 105.0,),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        title: Text(
                                          widget.userData!.name.toString(),
                                          style: kProfileName,
                                        ),
                                        subtitle: Text(
                                          widget.userData!.email.toString(),
                                          style: kProfileEmail,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 106,top: 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.userData!.description.toString(),style: kProfileAboutMe,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(widget.userData!.profileImage.toString()),
                                    fit: BoxFit.cover)),
                            margin: EdgeInsets.only(left: 14.0, top: 29),
                          ),
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(8),
                              ),
                            ),
                            margin: EdgeInsets.only(left: 89.0, top: 104),
                            child: GestureDetector(
                              child: Icon(
                                Icons.edit,
                                size: 14,
                              ),
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Choose Image',
                                          style: kDialogAlert),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              child: InkWell(
                                                  splashColor:
                                                  Colors.transparent,
                                                  child: const Text(
                                                      'Camera',
                                                      style:
                                                      kDialogAlertElements),
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    _pickedImage =
                                                    await UserDatabaseServices()
                                                        .pickImage(
                                                        source: ImageSource
                                                            .camera);
                                                    await uploadImages(widget.userData);


                                                    setState(() {
                                                    });
                                                  }),
                                            ),
                                            const SizedBox(height: 20),
                                            SizedBox(
                                              height: 40,
                                              child: InkWell(
                                                splashColor:
                                                Colors.transparent,
                                                child: const Text('Gallery',
                                                    style:
                                                    kDialogAlertElements),
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  _pickedImage =
                                                  await UserDatabaseServices()
                                                      .pickImage(
                                                      source: ImageSource
                                                          .gallery);
                                                  await uploadImages(widget.userData);
                                                  setState(() { });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );



                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                "User information",
                                style: kBottomSheetLT,
                              ),
                            ),
                            ListTile(
                              title: Text("Email".tr, style: kSettingsTilesNames),
                              subtitle: Text(widget.userData!.email.toString()),
                              leading: Icon(Icons.email),
                            ),
                            ListTile(
                              title: Text("Name".tr, style: kSettingsTilesNames),
                              subtitle: Text(widget.userData!.name.toString()),
                              leading: Icon(Icons.web),
                              trailing: TextButton(
                                child: kEditText,
                                onPressed: () {
                                  showBottomSheet(context,
                                      child: SettingEdit(
                                        labelText: 'Edit your name',
                                        controller: TextEditingController(
                                            text: widget.userData!.name.toString()),
                                        field: 'name',
                                        uid: widget.userData!.uid.toString(),
                                      ));
                                },
                              ),
                            ),
                            ListTile(
                              title:
                              Text("Password".tr, style: kSettingsTilesNames),
                              subtitle: Text('********'),
                              leading: Icon(Icons.lock),
                              trailing: TextButton(
                                child: kEditText,
                                onPressed: () {
                                  showBottomSheet(context,
                                      child: SettingEdit(
                                        labelText: '',
                                        controller: TextEditingController(
                                            text: widget.userData!.password.toString()),
                                        field: 'password',
                                        uid: widget.userData!.uid.toString(),
                                      ));
                                },
                              ),
                            ),
                            ListTile(
                              title: Text("Phone".tr, style: kSettingsTilesNames),
                              subtitle: Text(widget.userData!.mob.toString()),
                              leading: Icon(Icons.phone),
                              trailing: TextButton(
                                child: kEditText,
                                onPressed: () {
                                  showBottomSheet(context,
                                      child: SettingEdit(
                                        labelText: 'Edit your phone',
                                        controller: TextEditingController(
                                            text: widget.userData!.mob.toString()),
                                        field: 'mob',
                                        uid: widget.userData!.uid.toString(),
                                      ));
                                },
                              ),
                            ),
                            ListTile(
                              title: Text("About".tr, style: kSettingsTilesNames),
                              subtitle: Text(widget.userData!.description.toString()),
                              leading: Icon(Icons.person),
                              trailing: TextButton(
                                child: kEditText,
                                onPressed: () {
                                  showBottomSheet(context,
                                      child: SettingEdit(
                                        labelText: 'Edit your status',
                                        controller: TextEditingController(
                                            text: widget.userData!.description
                                                .toString()),
                                        field: 'description',
                                        uid: widget.userData!.uid.toString(),
                                      ));
                                },
                              ),
                            ),
                            ListTile(
                              title: Text("Joined Date".tr,
                                  style: kSettingsTilesNames),
                              subtitle: Text(
                                  widget.userData!.signUPDate!.toDate().toString()),
                              leading: Icon(Icons.date_range,),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                    child: Row(
                      children: [GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          selectedLang.langToggle();
                          selectedLang.changeLanguage();
                        },
                        child: SwitchlikeCheckbox(
                          checked: selectedLang.langSwitch,
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );

  }
}



class SettingEdit extends StatelessWidget {
  const SettingEdit({
    Key? key,
    required this.labelText,
    this.controller,
    this.field,
    this.uid,
  }) : super(key: key);
  final String labelText;
  final TextEditingController? controller;
  final String? field, uid;
  @override
  Widget build(BuildContext context) {
    final ourUser = Provider.of<User?>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(labelText, style: kBottomSheetLT),
          SizedBox(
            height: 12,
          ),
          MyTextField(
            autofocus: true,
            controller: controller,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            hintText: '',
            labelText: '',
          ),
          SizedBox(
            height: 12,
          ),
          GFButton(
              color: colorBlue,
              size: 50,
              highlightElevation: 1,
              text: 'Save',
              fullWidthButton: true,
              onPressed: () async {
                if (field == 'password') {
                  String message = await AuthServices().changePassword(
                      user: ourUser,
                      newPassword: controller!.text.trim().toString());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(message), duration: Duration(seconds: 2)));
                }
                if (field == 'name') {
                  await ourUser!.updateDisplayName(controller!.text.trim().toString());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Done'), duration: Duration(seconds: 2)));
                }

                UserDatabaseServices().userData_collection.doc(uid).update({
                  field.toString(): controller!.text.trim().toString(),
                });
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}


void showBottomSheet(
    BuildContext context, {
      required Widget child,
    }) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(height: 250, child: child),
        );
      });
}