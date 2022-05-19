// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/data_layer/database_services/ads_db_services.dart';
import 'package:coastv1/data_layer/database_services/user_database_services.dart';
import 'package:coastv1/data_layer/models/ad_model.dart';
import 'package:coastv1/my_widgets/image_slider.dart';
import 'package:coastv1/my_widgets/loading_widget.dart';
import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

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

class AdViewScreenDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var adsDataFromDB =
        Provider.of<AdModel?>(context); // stream of ads data from DB

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: colorBlue),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Transform.translate(
            offset: Offset(0,0),
            child: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            SimpleImageSlider(
              images: [
                'assets/images/ob0.png',
                'assets/images/splachlogo.png',
                'assets/images/ob0.png',
                'assets/images/splachlogo.png',
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Date : ${DateTime.now().toString().substring(0, 16)}',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: colorBlue),
                  ),
                  Divider(
                    endIndent: 20,
                    indent: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    adsDataFromDB!.title.toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBlue),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Description',
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
                    'Details',
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
                    'Address',
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
                    'Mobile',
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
                    text: 'Call',
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
          children: [
            Text('adType'),
            SizedBox(
              width: 120,
            ),
            Text(adType.toString()),
          ],
        ),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
        Row(
          children: [
            Text('apartmentType'),
            SizedBox(
              width: 60,
            ),
            Text(apartmentType.toString()),
          ],
        ),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
        Row(
          children: [
            Text('price'),
            SizedBox(
              width: 145,
            ),
            Text(price.toString()),
          ],
        ),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
        Row(
          children: [
            Text('area'),
            SizedBox(
              width: 150,
            ),
            Text(area.toString()),
          ],
        ),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
        Row(
          children: [
            Text('level'),
            SizedBox(
              width: 150,
            ),
            Text(level.toString()),
          ],
        ),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
        Row(
          children: [
            Text('rooms'),
            SizedBox(
              width: 136,
            ),
            Text(rooms.toString()),
          ],
        ),
        Divider(
          endIndent: 20,
          indent: 20,
        ),
        Row(
          children: [
            Text('wcs'),
            SizedBox(
              width: 155,
            ),
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
