import 'package:coastv1/consts/app_functions/places.dart';
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/data_layer/database_services/user_database_services.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/my_widgets/my_grid.dart';
import 'package:coastv1/screens/home_drawer/home_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ads_list_screen.dart';

class AdsPlacesScreen extends StatelessWidget {
  static const String id = 'AdsPlacesScreen';

  String? adType;  // sell or rent
  String? apartmentType;  // apartment, villa, land, shop, or chalet
  String? location;

  
  AdsPlacesScreen({Key? key,this.adType,this.apartmentType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userDataFromDB = Provider.of<UserData?>(context); // stream of profile user data from DB
    print('ccccczz$userDataFromDB');
    return SafeArea(
      child: Scaffold(
        drawer: HomeDrawer(),
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: colorBlue
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: PlacesGrid(
            children: List.generate(places.length, (index) {
          return PlacesGridCard(
              location: places[index].location,
              subtitle: places[index].subtitle,
              image: places[index].image,
              onTab: () {
                location = places[index].location;
                Navigator.push(context,
                    PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => AdsScreen(adType:adType,apartmentType:apartmentType,location:location)));
              });
        })),
      ),
    );
  }
}



class PlacesGrid extends StatelessWidget {
  final List<Widget> children;
  const PlacesGrid({Key? key, required this.children}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      primary: true,
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      crossAxisCount: 2,
      childAspectRatio: 0.850,
      mainAxisSpacing: 3.0,
      crossAxisSpacing: 3.0,
      children: children,
    );
  }
}

class PlacesGridCard extends StatelessWidget {
  // for places
  final String? location;
  final String? subtitle;
  final String? image;
  final VoidCallback? onTab;

  const PlacesGridCard({
    Key? key,
    this.location,
    this.subtitle,
    this.image,
    this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTab,
      child: Column(
        children: [
          Container(
            width: _w / 2.05,
            height: _w / 2.5, //2.6
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 50),
              ],
              color: Color(0xff5C71F3),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(image ?? 'assets/images/ob2.png'),
                    fit: BoxFit.fill),
              ),
            ),
            // Image.asset(
            //     image,
            //     fit: BoxFit.cover,
          ),
          Container(
            width: _w / 2.05,
            height: _w / 7,
            decoration: BoxDecoration(
              color: Colors.lightBlue.withOpacity(0.20),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: _w / 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  location.toString(),
                  textScaleFactor: 1.4,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.black.withOpacity(.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle.toString() ,
                  textScaleFactor: 1,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black.withOpacity(.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
