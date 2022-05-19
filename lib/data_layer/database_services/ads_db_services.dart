// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/ad_model.dart';

class AdsDatabaseServices {
  final String? uid; // we will pass uid with Constructor as we will use it much
  AdsDatabaseServices({this.uid});

  // FireStore collections references
  final CollectionReference ads_collection =
      FirebaseFirestore.instance.collection('ads');

  /// ### ads Section ###

  // Add Ad to 'ads' collection on FireStore
  Future addAd({
    int? adNumber,
    int? placeReview = 5,
    double? price,
    double? area,
    double? level,
    double? rooms,
    double? wcs,
    List<String?>? imageSlider,
    List<String>? likedBy,
    String? adID,
    String? createdBy,
    String? title,
    String? description,
    String? adType, // sell or rent
    String? apartmentType,
    String? location,
    String? address,
    String? mob, // will filter his ads with user mob number
    bool? saveAd = false,
    bool? userCanEditAd = true,
    bool? userCanDelAd = true,
    DateTime? adDate,
  }) async {
    try {
      await ads_collection.doc(adID.toString()).set({
        'adNumber': adNumber,
        'adID': adID,
        'createdBy': createdBy,
        'placeReview': placeReview ?? 2,
        'price': price ?? 0.0,
        'area': area ?? 0.0,
        'level': level,
        'rooms': rooms,
        'wcs': wcs,
        'imageSlider': imageSlider,
        'likedBy': likedBy ?? [],
        'title': title,
        'description': description,
        'adType': adType,
        'apartmentType': apartmentType,
        'location': location,
        'address': address,
        'mob': mob,
        'saveAd': saveAd,
        'userCanEditAd': userCanEditAd,
        'userCanDelAd': userCanDelAd,
        'adDate': Timestamp.fromDate(adDate!),
      });
    } on FirebaseException catch (e) {
      print(e.message);
    } catch (e) {
      print('# Fail to add to FireStore 505: $e');
    }
    print('# Added to FireStore Successfully ');
  }

  // Update Ad in 'ads' collection on FireStore
  Future updateAd({
    int? adNumber,
    int? placeReview = 5,
    double? price,
    double? area,
    double? level,
    double? rooms,
    double? wcs,
    List<String?>? imageSlider,
    List<String>? likedBy,
    String? adID,
    String? createdBy,
    String? title,
    String? description,
    String? adType, // sell or rent
    String? apartmentType,
    String? location,
    String? address,
    String? mob, // will filter his ads with user mob number
    bool? saveAd = false,
    bool? userCanEditAd = true,
    bool? userCanDelAd = true,
    DateTime? adDate,
  }) async {
    try {
      return await ads_collection.doc(adID.toString()).update({
        'adNumber': adNumber,
        'adID': adID,
        'createdBy': createdBy,
        'placeReview': placeReview,
        'price': price,
        'area': area,
        'level': level,
        'rooms': rooms,
        'wcs': wcs,
        'imageSlider': imageSlider,
        'likedBy': likedBy,
        'title': title,
        'description': description,
        'adType': adType,
        'apartmentType': apartmentType,
        'location': location,
        'address': address,
        'mob': mob,
        'saveAd': saveAd,
        'userCanEditAd': userCanEditAd,
        'userCanDelAd': userCanDelAd,
        'adDate': Timestamp.fromDate(adDate!),
      });
    } on FirebaseException catch (e) {
      print(e.message);
    } catch (e) {
      print('update method error 505: $e');
    }
  }

  // Delete Ad from 'ads' collection
  Future deleteAdData({
    String? adID,
  }) async {
    return await ads_collection.doc(adID.toString()).delete();
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



  ///  Data Functions

  // Get one Document
  Future<AdModel?> getAdById({
    String? adID,
  }) async {
    try {
      return await ads_collection.doc(adID.toString()).get().then((ad) {
        return _adModelFromDocumentSnapshot(ad);
      });
    } on FirebaseException catch (e) {
      print(e.message);
    } catch (e) {
      print('update method error 505: $e');
    }
  }

  // Get List of Ads in ads_collection / return List of AdModel
  Future<List<AdModel?>?> get AdsDataList => ads_collection.get().then((ad) {
        return _adModelListFromQuerySnapshot(ad);
      });

  // this is used to add user in LikedBy List in likedBy List in FireStore
  Future updateToListInAds({
    required String ad_uid,
    required String List_field,
    dynamic element,
  }) async {
    ads_collection.doc(ad_uid).update({
      List_field: FieldValue.arrayUnion([element]),
    });
  }

  // this is used to remove user from LikedBy List in likedBy List in FireStore
  Future removeFromListInAds({
    required String ad_uid,
    required String List_field,
    required dynamic element,
  }) async {
    ads_collection.doc(ad_uid).update({
      List_field: FieldValue.arrayRemove([element]),
    });
  }

// is post is favorite or not?
  bool isLiked(String user_email, List<String>? likedBy) {
    return (likedBy!.contains(user_email)) ? true : false;
  }

  /// Get ads Streams ###

  Stream<AdModel?> adDataSteamById(adID) {
    return ads_collection
        .doc(adID)
        .snapshots()
        .map((snapshot) => _adModelFromDocumentSnapshot(snapshot));
  }

  Stream<List<AdModel?>?>? adsListStream() {
    return ads_collection
        .snapshots()
        .map((snapshot) => _adModelListFromQuerySnapshot(snapshot));
  }

  // stream of favorites ads
  Stream<List<AdModel?>?>? likedAdsListStream(String user_email) {
    return ads_collection
        .where('likedBy', arrayContainsAny: [user_email])
        .snapshots()
        .map((snapshot) => _adModelListFromQuerySnapshot(snapshot));
  }

  /// Convert Functions

  // AdModel from DocumentSnapshot
  AdModel? _adModelFromDocumentSnapshot(DocumentSnapshot snapshot) {
    try {
      return AdModel(
        //title: snapshot['title'] ,
        //title: snapshot.get('title') ,
        //title: snapshot.get(FieldPath(['title'])) ,

        //ints
        adNumber: snapshot['adNumber'] ?? 0,
        adID: snapshot['adID'] ?? '-',
        createdBy: snapshot['createdBy'] ?? '-',
        placeReview: snapshot['placeReview'] ?? 0,
        // doubles
        price: snapshot['price'] ?? 0.0,
        area: snapshot['area'] ?? 0.0,
        level: snapshot['level'] ?? 0.0,
        rooms: snapshot['rooms'] ?? 0.0,
        wcs: snapshot['wcs'] ?? 0.0,
        // Strings
        imageSlider: snapshot.get('imageSlider') ?? [],
        likedBy: List<String>.from(snapshot.get('likedBy')),
        title: snapshot['title'] ?? '-',
        description: snapshot['description'] ?? '-',
        adType: snapshot['adType'] ?? '-',
        apartmentType: snapshot['apartmentType'] ?? '-',
        location: snapshot['location'] ?? '-',
        address: snapshot['address'] ?? '-',
        mob: snapshot['mob'] ?? '-',
        saveAd: snapshot['saveAd'] ?? '-',
        userCanEditAd: snapshot['userCanEditAd'] ?? '-',
        userCanDelAd: snapshot['userCanDelAd'] ?? '-',
        adDate: snapshot['adDate'].toDate(),
      );
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // AdModel list from QuerySnapshot for Ads Feed Stream Provider
  // List<AdModel?>? _adModelListFromQuerySnapshot(QuerySnapshot snapshot) {
  //   try {
  //     return snapshot.docs.map((doc) {
  //       return AdModel(
  //         //ints
  //         adNumber: doc.get('adNumber')  ?? 0,
  //         placeReview: doc.get('placeReview') ?? 0,
  //         // doubles
  //         price: doc.get('price')  ?? 0.0,
  //         area: doc.get('area') ?? 0.0,
  //         level: doc.get('level') ?? 0.0,
  //         rooms: doc.get('rooms') ?? 0.0,
  //         wcs: doc.get('wcs') ?? 0.0,
  //         // Strings
  //         adID: doc.get('adID') ?? 'nulll',
  //         createdBy: doc.get('createdBy') ?? 'nulll',
  //         //imageSlider: snapshot.get('imageSlider') ,
  //         //likedBy: snapshot.get('likedBy') ,
  //         title: doc.get('title') ?? 'nulll',
  //         description: doc.get('description') ?? 'nulll',
  //         adType: doc.get('adType') ?? 'nulll',
  //         apartmentType: doc.get('apartmentType') ?? 'nulll',
  //         location: doc.get('location') ?? 'nulll',
  //         address: doc.get('address') ?? 'nulll',
  //         mob: doc.get('mob') ?? 'nulll',
  //         saveAd: doc.get('saveAd') ?? 'nulll',
  //         userCanEditAd: doc.get('userCanEditAd') ?? 'nulll',
  //         userCanDelAd: doc.get('userCanDelAd') ?? 'nulll',
  //         adDate: doc.get('adDate').toDate() ?? 'nulll',
  //       );
  //     }).toList();
  //   } catch (error) {
  //     print('***** ${error.toString()}');
  //     return null;
  //   }
  // }

// new way to fix issue loading data if ads info is missing
  // AdModel list from QuerySnapshot for Ads Feed Stream Provider
  List<AdModel?>? _adModelListFromQuerySnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        print(doc.data());
        return AdModel(
          //ints
          adNumber: doc.data().toString().contains('adNumber')
              ? doc.get('adNumber')
              : 0, //Number
          placeReview: doc.data().toString().contains('placeReview')
              ? doc.get('placeReview')
              : 0, //Number
          // doubles
          price: doc.data().toString().contains('price')
              ? doc.get('price')
              : 0.0, //Number
          area: doc.data().toString().contains('area')
              ? doc.get('area')
              : 0.0, //Number
          level: doc.data().toString().contains('level')
              ? doc.get('level')
              : 0.0, //Number
          rooms: doc.data().toString().contains('rooms')
              ? doc.get('rooms')
              : 0.0, //Number
          wcs: doc.data().toString().contains('wcs')
              ? doc.get('wcs')
              : 0.0, //Number

          // Strings
          adID: doc.data().toString().contains('adID')
              ? doc.get('adID')
              : '', //String
          createdBy: doc.data().toString().contains('createdBy')
              ? doc.get('createdBy')
              : '', //String
          imageSlider: doc.data().toString().contains('imageSlider')
              ? doc.get('imageSlider')
              : [], //String
          likedBy: doc.data().toString().contains('likedBy')
              ? List<String>.from(doc.get('likedBy'))
              : [], //String
          title: doc.data().toString().contains('title')
              ? doc.get('title')
              : '', //String
          description: doc.data().toString().contains('description')
              ? doc.get('description')
              : '', //String
          adType: doc.data().toString().contains('adType')
              ? doc.get('adType')
              : '', //String
          apartmentType: doc.data().toString().contains('apartmentType')
              ? doc.get('apartmentType')
              : '', //String
          location: doc.data().toString().contains('location')
              ? doc.get('location')
              : '', //String
          address: doc.data().toString().contains('address')
              ? doc.get('address')
              : '', //String
          mob: doc.data().toString().contains('mob')
              ? doc.get('mob')
              : '', //String
          saveAd: doc.data().toString().contains('saveAd')
              ? doc.get('saveAd')
              : false, //String
          userCanEditAd: doc.data().toString().contains('userCanEditAd')
              ? doc.get('userCanEditAd')
              : false, //String
          userCanDelAd: doc.data().toString().contains('userCanDelAd')
              ? doc.get('userCanDelAd')
              : false, //String
          adDate: doc.data().toString().contains('adDate')
              ? doc.get('adDate').toDate()
              : DateTime.now(), //String
        );
      }).toList();
    } catch (error) {
      print('***** ${error.toString()}');
      return null;
    }
  }
}
