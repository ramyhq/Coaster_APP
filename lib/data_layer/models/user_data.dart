// User Data Model on firestore database
import 'package:coastv1/data_layer/models/ad_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? uid;
  String? email;
  String? password;
  String? name;
  String? mob;
  String? description;
  String? profileImage;
  Timestamp? signUPDate;
  List<String>? favoriteAds;

  UserData(
      {required this.uid,
      this.email,
      this.password,
      this.name,
      this.mob,
      this.description,
      this.profileImage,
      this.signUPDate,
      this.favoriteAds});

  UserData.fromDoc(Map<String, dynamic> doc) {
    uid = doc['uid'];
    email = doc['email'];
    password = doc['password'];
    name = doc['name'];
    mob = doc['mob'];
    description = doc['description'];
    profileImage = doc['profileImage'];
    signUPDate = doc['signUPDate'];
    favoriteAds =List<String>.from(doc['favoriteAds']).toList() ;
  }
}
