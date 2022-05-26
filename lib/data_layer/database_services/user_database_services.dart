// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../models/ad_model.dart';

class UserDatabaseServices with ChangeNotifier {
  final String? uid; // we will pass uid with Constructor as we will use it much
  UserDatabaseServices({this.uid});

  // FireStore collections references
  final CollectionReference userData_collection =
      FirebaseFirestore.instance.collection('userData');
  final CollectionReference guestData_collection =
      FirebaseFirestore.instance.collection('guestData');

  /// ### userData Section ###

  // Add userData to 'userData' collection on FireStore
  Future addUserData(String? uid, String? email, String? password, String? name,
      String? mob, String? description, DateTime? signUPDate) async {
    try {
      await userData_collection.doc(uid).set({
        'uid': uid,
        'email': email,
        'password': password,
        'name': name,
        'mob': mob,
        'description': description,
        'signUPDate': signUPDate,
        //defaults for - user will change
        'profileImage':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsuKHtQ3e0QWhO0esSv8cafAxx9iYVpRsP8g&usqp=CAU',
        'favoriteAds': [],
      });
    } on FirebaseException catch (e) {
      print(e.message);
    } catch (e) {
      print('# Fail to add to FireStore 505: $e');
    }
    print('# Added to FireStore Successfully ');
  }

  // Update userData in 'userData' collection on FireStore
  Future updateUserData(
      {String? uid,
      String? email,
      String? password,
      String? name,
      String? mob,
      String? description,
      String? profileImage,
      List<AdModel>? favoriteAds,
      DateTime? signUPDate}) async {
    try {
      await userData_collection.doc(uid).update({
        'uid': uid,
        'email': email,
        'password': password,
        'name': name,
        'mob': mob,
        'description': description,
        'signUPDate': signUPDate,
        'profileImage': profileImage,
        'favoriteAds': favoriteAds,
      });
    } on FirebaseException catch (e) {
      print(e.message);
    } catch (e) {
      print('# Fail to update to FireStore 506: $e');
    }
    print('# updated to FireStore Successfully ');
  }

  // Delete userData from 'userData' collection
  Future deleteUserData({
    String? uid,
  }) async {
    try {
      await userData_collection.doc(uid.toString()).delete();
    } on FirebaseException catch (e) {
      print(e.message);
    } catch (e) {
      print('# Fail to delete to FireStore 507: $e');
    }
    print('# deleted to FireStore Successfully ');
  }

  // upload single image to firebase Storage
  Future<String> uploadImage({required File image, required String cloud_path,required String file_name}) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child(cloud_path)
        .child(file_name);
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }


  Future pickImage({required ImageSource source}) async {
    try {
      final pickedImage =
      await ImagePicker().pickImage(source: source,imageQuality: 50 );
      if (pickedImage == null) return;
      return File(pickedImage.path);
    } catch (e) {
      print('#514 Fail to pick image ');
    }
  }


  /// Getting Data Functions

  // Get one userData Document
  Future<UserData?> getUserById({
    String? uid,
  }) async {
    try {
      await userData_collection.doc(uid.toString()).get().then((user) {
        return _userDataFromDocumentSnapshot(user);
      });
    } on FirebaseException catch (e) {
      print(e.message.toString());
    } catch (e) {
      print('#801 update method error: ${e.toString()}');
    }
  }
// this is used to add favorite ads in favoriteAds List in FireStore
  Future updateToListInUserData({
    required String user_uid,
    required String List_field,
    dynamic element,
  }) async {
    userData_collection.doc(user_uid).update({
      List_field: FieldValue.arrayUnion([element]),
    });
  }
// this is used to remove favorite ads in favoriteAds List in FireStore
  Future removeFromListInUserData({
    required String user_uid,
    required String List_field,
    required dynamic element,
  }) async {
    userData_collection.doc(user_uid).update({
      List_field: FieldValue.arrayRemove([element]),
    });
  }

  /// Get ads Streams ###

  Stream<UserData?> get userDataFromDBU {
    return userData_collection
        .doc(uid)
        .snapshots()
        .map((user) => _userDataFromDocumentSnapshot(user));
  }

  // Stream<DocumentSnapshot> get userDataFromDB {
  //   //var a = userData_collection.doc(uid).snapshots().map((doc) => UserData.fromDoc(doc.data()));
  //   return userData_collection.doc(uid).snapshots().map((doc) => UserData.fromDoc(doc);
  //
  // }

  Stream<UserData?> userDataFromDB(userUid) {
    return userData_collection
        .doc(userUid)
        .snapshots()
        .map((doc) => UserData.fromDoc(doc.data() as Map<String, dynamic>));
  }

  /// Convert Functions

  // to convert snapshot to user data (from DocumentSnapshot)
  UserData? _userDataFromDocumentSnapshot(DocumentSnapshot snapshot) {
    try {
      return UserData(
        uid: snapshot['uid'] ?? '-',
        email: snapshot['email'] ?? '-',
        password: snapshot['password'] ?? '-',
        name: snapshot['name'] ?? '-',
        mob: snapshot.get('mob') ?? '-',
        description: snapshot['description'] ?? '-',
        profileImage: snapshot['profileImage'] ?? '-',
        signUPDate: snapshot['signUPDate'] ?? DateTime.now(),
        favoriteAds:List<String>.from( snapshot['favoriteAds']).toList() ,
        //title: snapshot['title'] ,
        //title: snapshot.get('title') ,
        //title: snapshot.get(FieldPath(['title'])) ,
      );
    } catch (error) {
      print('#509 in _userDataFromDocumentSnapshot : ${error.toString()}');
      return null;
    }
  }

// new way to fix issue loading data if ads info is missing
  // UserData list from QuerySnapshot for Ads Feed Stream Provider
  List<UserData?>? _userDataListFromQuerySnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        print(doc.data());
        return UserData(
          uid: doc.data().toString().contains('uid') ? doc.get('uid') : '-',
          email:
              doc.data().toString().contains('email') ? doc.get('email') : '-',
          password: doc.data().toString().contains('password')
              ? doc.get('password')
              : '-',
          name: doc.data().toString().contains('name') ? doc.get('name') : '-',
          mob: doc.data().toString().contains('mob') ? doc.get('mob') : '-',
          description: doc.data().toString().contains('description')
              ? doc.get('description')
              : '-',
          profileImage: doc.data().toString().contains('profileImage')
              ? doc.get('profileImage')
              : '-',
          signUPDate: doc.data().toString().contains('signUPDate')
              ? doc.get('signUPDate').toDate()
              : DateTime.now(),
          favoriteAds: doc.data().toString().contains('favoriteAds')
              ? doc.get('favoriteAds')
              : [],
        );
      }).toList();
    } catch (error) {
      print('#510 in _userDataListFromQuerySnapshot : ${error.toString()}');
      return null;
    }
  }

  /// ### Guest Data Section ###

  // add Guest data (for later to add devices info and etc... )
  Future updateGuestDate(
    String? uid,
  ) async {
    return await guestData_collection.doc(uid.toString()).set({
      'uid': uid,
    });
  }
}
