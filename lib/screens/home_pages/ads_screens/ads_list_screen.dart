import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/data_layer/database_services/ads_db_services.dart';
import 'package:coastv1/data_layer/database_services/user_database_services.dart';
import 'package:coastv1/data_layer/models/ad_model.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/my_widgets/loading_widget.dart';
import 'package:coastv1/my_widgets/my_grid.dart';
import 'package:coastv1/screens/home_drawer/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

import 'ad_view_screen.dart';
import 'add_ad_screen.dart';

class AdsScreen extends StatelessWidget {
  final String? adType; // sell or rent
  final String? apartmentType; // apartment, villa, land, shop, or chalet
  final String? location;
  const AdsScreen({Key? key, this.adType, this.apartmentType, this.location})
      : super(key: key);

  // void _showSettings() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context){
  //         return Container(
  //           padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
  //           child: SettingsPanal(),
  //         );
  //       });
  // }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AdModel?>?>(
        stream: AdsDatabaseServices().adsListStream(),
        builder: (context, snapshot) {
          // that snapshot refere to the snapshot came from firebase
          // make sure to check if there is data on it before using it
          if (snapshot.hasData) {
            List<AdModel?>? adsList = snapshot.data;
            return adsList != null
                ? Scaffold(
                    floatingActionButton: FloatingActionButton.small(
                      backgroundColor: colorBlue,
                      child: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) => AddAdScreen()));
                      },
                    ),
                    appBar: AppBar(
                      iconTheme: const IconThemeData(color: colorBlue),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                    body: AdsList(adsList: adsList))
                : const LoadingPage();
          } else {
            return const LoadingPage();
          }
        });
  }
}

class AdsList extends StatefulWidget {
  final List<AdModel?> adsList;
  const AdsList({Key? key, required this.adsList}) : super(key: key);

  @override
  State<AdsList> createState() => _AdsListState();
}

class _AdsListState extends State<AdsList> {
  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: [
          GFListTile(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            padding: const EdgeInsets.all(0),
            icon: Material(
              type: MaterialType.transparency,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: isGrid
                    ? const Icon(Icons.grid_view_sharp)
                    : const Icon(
                        Icons.view_list,
                        size: 28,
                      ),
                onPressed: () {
                  setState(() {
                    isGrid = !isGrid;
                  });
                },
              ),
            ), // Icon(Icons.add),
          ),
          isGrid
              ? AdsByGrid(
                  adsList: widget.adsList,
                )
              : AdsByList(
                  adsList: widget.adsList,
                ),
          const SizedBox(height: 50,)
        ],
      ),
    );
  }
}

class AdsByList extends StatelessWidget {
  AdsByList({Key? key, required this.adsList}) : super(key: key);
  List<AdModel?> adsList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: adsList.length,
      shrinkWrap: true,
      // primary: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      itemBuilder: (BuildContext context, int index) {
        return ListCard(
          adID:adsList[index]?.adID,
          title: adsList[index]?.title ,
          subtitle: adsList[index]?.description,
          location: adsList[index]?.location,
          price: adsList[index]?.price,
          placeReview: adsList[index]?.placeReview,
          likedBy: adsList[index]?.likedBy,
          //image: adsList[index]!.imageSlider![0],
          onTab: () {
            // I userd PageRouteBuilder to disable transition animation
            Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        AdViewScreen(adID: adsList[index]!.adID)));
          },
        );
      },
    );
  }
}

class AdsByGrid extends StatelessWidget {
  AdsByGrid({Key? key, required this.adsList}) : super(key: key);
  List<AdModel?> adsList;
  @override
  Widget build(BuildContext context) {
    return ImageGrid(
      children: List.generate(adsList.length, (index) {
        return GridCard(
            adID:adsList[index]?.adID,
            title: adsList[index]?.title ,
            subtitle: adsList[index]?.description,
            location: adsList[index]?.location,
            price: adsList[index]?.price,
            likedBy: adsList[index]?.likedBy,
            //image: adsList[index]!.imageSlider![0],
            onTab: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          AdViewScreen(adID: adsList[index]!.adID)));
            });
      }),
    );
  }
}
