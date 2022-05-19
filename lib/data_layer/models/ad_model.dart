import 'package:flutter/material.dart';


// class AdModel{
//
//   String? title;
//   String? address;
//   String? mob; // will filter his ads with user mob number
//   AdModel({this.title,this.mob,this.address});
//
// }

class AdModel{
  int? adNumber;
  int? placeReview;
  double? price;
  double? area;
  double? level;
  double? rooms;
  double? wcs;
  List<String?>? imageSlider = [];
  List<String>? likedBy = [];
  String? adID;
  String? createdBy;
  String? title;
  String? description;
  String? adType; // sell or rent
  String? apartmentType; // apartment, villa, land, shop, or chalet
  String? location; // apartment, villa, land, shop, or chalet
  String? address;
  String? mob; // will filter his ads with user mob number
  bool? saveAd;
  bool? userCanEditAd;
  bool? userCanDelAd;
  DateTime? adDate;

  AdModel(
      {this.adNumber,
      this.adID,
      this.createdBy,
      this.placeReview,
      this.price,
      this.area,
      this.level,
      this.rooms,
      this.wcs,
      this.imageSlider,
      this.likedBy,
      this.title,
      this.description,
      this.adType,
      this.apartmentType,
      this.location,
      this.address,
      this.mob,
      this.saveAd,
      this.userCanEditAd,
      this.userCanDelAd,
      this.adDate});
}