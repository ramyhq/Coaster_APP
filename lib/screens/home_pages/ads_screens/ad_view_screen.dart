// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/data_layer/database_services/ads_db_services.dart';
import 'package:coastv1/data_layer/models/ad_model.dart';
import 'package:coastv1/main.dart';
import 'package:coastv1/my_widgets/image_slider.dart';
import 'package:coastv1/my_widgets/loading_widget.dart';
import 'package:coastv1/my_widgets/my_grid.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';

class AdViewScreen extends StatelessWidget {
  final String? adID;
  AdViewScreen({Key? key, this.adID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AdModel?>(
        create: (_) =>
            AdsDatabaseServices().adDataSteamById(adID), // this for spcefic ad
        initialData: null,
        catchError: (_, err) {
          print('#101 catchError from StreamProvider ${err.toString()}');
        },
        child: Consumer<AdModel?>(
          builder: (context, data, child) {
            return data == null ? LoadingPage() : AdViewScreenDetails();
          },
        ));
  }
}

class AdViewScreenDetails extends StatefulWidget {
  @override
  State<AdViewScreenDetails> createState() => _AdViewScreenDetailsState();
}

class _AdViewScreenDetailsState extends State<AdViewScreenDetails> {
  @override
  Widget build(BuildContext context) {
    var adsDataFromDB =
        Provider.of<AdModel?>(context); // stream of ads data from DB
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: colorBlue),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            SimpleImageSlider(
              images: List<String>.from(adsDataFromDB!.imageSlider!.toList()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Date : ${DateTime.now().toString().substring(0, 16)}',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: colorBlue),
                    ),
                  ),
                  Divider(
                    endIndent: 20,
                    indent: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  !user.isAnonymous
                      ? Transform.translate(
                        offset: favoritLanguage == 'en' ?  Offset(16,-15) : Offset(-16,-15)  ,
                        child: GFListTile(
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    padding: const EdgeInsets.all(0),
                    icon: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 1) {
                              print(favoritLanguage);
                            }
                            if (value == 2) {
                              showAlertDialog(
                                  context: context,
                                  function: () async {
                                    try {
                                      Navigator.of(context).pop();
                                      await AdsDatabaseServices().deleteAdData(
                                          adID: adsDataFromDB.adID);
                                    } catch (e) {
                                      print(
                                          '#561 AdsDatabaseServices error : $e');
                                    }
                                  });
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text("edit".tr),
                              value: 1,
                            ),
                            PopupMenuItem(
                              child: Text("delete".tr),
                              value: 2,
                            )
                          ]),
                  ),
                      )
                      : Container(),
                  Text(
                    adsDataFromDB.title.toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBlue),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Description'.tr,
                    style: TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    adsDataFromDB.description.toString(),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Details'.tr,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBlue),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  getDetails(
                    adType: adsDataFromDB.adType,
                    apartmentType: adsDataFromDB.apartmentType,
                    price: adsDataFromDB.price,
                    area: adsDataFromDB.area,
                    level: adsDataFromDB.level,
                    rooms: adsDataFromDB.rooms,
                    wcs: adsDataFromDB.wcs,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Address'.tr,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBlue),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(adsDataFromDB.address.toString()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Mobile'.tr,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBlue),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(adsDataFromDB.mob.toString()),
                  SizedBox(
                    height: 20,
                  ),
                  GFButton(
                    fullWidthButton: true,
                    text: 'Call'.tr,
                    color: colorBlue,
                    onPressed: () async {
                      FlutterPhoneDirectCaller.callNumber(
                          adsDataFromDB.mob.toString());
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget getDetails({
    String? adType, // rent or sell
    String? apartmentType, // flat or villa
    double? price,
    double? area,
    double? level,
    double? rooms,
    double? wcs,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Type'.tr),

            Text(adType.toString()),
          ],
        ),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Type of property'.tr),
            Text(apartmentType.toString()),
          ],
        ),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Price'.tr),
            Text(price.toString(),textAlign: TextAlign.center,),
          ],
        ),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Area'.tr),

            Text(area.toString()),
          ],
        ),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Level'.tr),

            Text(level.toString()),
          ],
        ),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Rooms'.tr),
            Text(rooms.toString()),
          ],
        ),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Wcs'.tr),
            Text(wcs.toString()),
          ],
        ),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
      ],
    );
  }
}
