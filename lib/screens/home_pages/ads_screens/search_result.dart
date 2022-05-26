import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/main.dart';
import 'package:coastv1/my_widgets/loading_widget.dart';
import 'package:coastv1/my_widgets/my_grid.dart';
import 'package:coastv1/screens/home_pages/ads_screens/ad_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data_layer/database_services/ads_db_services.dart';
import '../../../data_layer/models/ad_model.dart';
import '../../../providers/authentication_services.dart';
import 'add_ad_screen.dart';

class SearchResultScreen extends StatelessWidget {
   SearchResultScreen({Key? key, required this.searchKey,})
      : super(key: key);
final String searchKey;
  @override
  Widget build(BuildContext context) {
    final isGuest = Provider.of<AuthServices>(context).isGuest;

    return FutureBuilder<List<AdModel?>?>(
      future: AdsDatabaseServices().AdsDataListBySearchKey(searchKey),
        builder: (context, snapshot) {
          // that snapshot refere to the snapshot came from firebase
          // make sure to check if there is data on it before using it
          if (snapshot.hasData) {
            List<AdModel?>? adsList = snapshot.data;
            return adsList != null
                ? Scaffold(
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
  bool isGrid = isGridSaved;
  List<AdModel?>? adsList = [];
  _storeisGrid(isGrid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGrid', isGrid);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
      adsList = await AdsDatabaseServices().AdsDataList;
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
        print(adsList);
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
                    _storeisGrid(isGrid);
                    isGridSaved =isGrid;
                  });
                },
              ),
            ), // Icon(Icons.add),
          ),
          //  LookForScreen(),
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
          image: adsList[index]!.imageSlider![0],
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
            image: adsList[index]!.imageSlider![0],
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
