// ignore_for_file: prefer_const_constructors

import 'package:coastv1/consts/app_functions/looking_for_actions.dart';
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/my_widgets/my_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ads_screens/ads_places_screen.dart';

class LookForScreen extends StatelessWidget {
  const LookForScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: LookingActionsList());
  }
}

class LookingActionsList extends StatelessWidget {
  String? adType; // sell or rent
  String? apartmentType; // apartment, villa, land, shop, or chalet

  // final List<Widget> routeList = [
  //   AdsPlacesScreen(),
  //   AdsPlacesScreen(),
  //   AdsPlacesScreen(),
  //   AdsPlacesScreen(),
  //   AdsPlacesScreen(),
  //   AdsPlacesScreen(),
  // ];

  LookingActionsList({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: actionsMap.length,
        itemBuilder: (context, index) {
          return ListItem(
            title: actionsMap[index]['title'] ?? '',
            onTap: () {
              adType = actionsMap[index]['adType'];
              apartmentType = actionsMap[index]['apartmentType'];
              Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) {
                  return AdsPlacesScreen(
                      adType: adType, apartmentType: apartmentType);
                }),
              );
            },
          );
        });
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);
  final String title;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        height: 60.0,
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        child: Container(
          width: w.width / 2,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 50),
            ],
            color: colorBlue,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
