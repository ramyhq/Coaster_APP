// ignore_for_file: prefer_const_constructors

import 'package:coastv1/consts/app_functions/looking_for_actions.dart';
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/consts/text_const.dart';
import 'package:coastv1/data_layer/database_services/ads_db_services.dart';
import 'package:coastv1/data_layer/models/ad_model.dart';
import 'package:coastv1/utils/dismiss_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:coastv1/main.dart';
import 'package:coastv1/my_widgets/loading_widget.dart';
import 'package:coastv1/my_widgets/my_grid.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:coastv1/screens/home_pages/ads_screens/ad_view_screen.dart';
import 'package:coastv1/screens/home_pages/ads_screens/add_ad_screen.dart';
import 'package:coastv1/screens/home_pages/ads_screens/search_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/badge/gf_button_badge.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:getwidget/components/typography/gf_typography.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ads_screens/ads_places_screen.dart';

//This is for Find By Place
class FindByPlace extends StatelessWidget {
  const FindByPlace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: colorBlue),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: LookingActionsList()));
  }
}
class LookingActionsList extends StatelessWidget {
  String? adType; // sell or rent
  String? apartmentType; // apartment, villa, land, shop, or chalet

  LookingActionsList({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Align(
                alignment: Alignment.center,
                child: Text('For Rent'.tr,style: kProfileName)),
            SizedBox(height: 20,),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              children: List.generate(
                5,
                    (index) {
                  return ListItem(
                    title: actionsMap[index + 5]['title'] ?? '',
                    onTap: () {
                      adType = actionsMap[index + 5]['adType'];
                      apartmentType = actionsMap[index + 5]['apartmentType'];
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
                },
              ),
            ),
            SizedBox(height: 20,),
            Align(
                alignment: Alignment.center,
                child: Text('For Sell'.tr,style: kProfileName)),
            SizedBox(height: 20,),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              children: List.generate(
                5,
                (index) {
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
                },
              ),
            ),
          ],
        ),
      ),
    );
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
        margin: const EdgeInsets.symmetric(
          vertical: 0.0,horizontal: 0
        ),
        child: Container(
          height: w.width  ,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.20), blurRadius: 5),
            ],
            color: colorBlue,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10),
              bottom: Radius.circular(10),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// This is For HomeScreen
class AllAdsScreen extends StatelessWidget {
  const AllAdsScreen({Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return StreamBuilder<List<AdModel?>?>(
        stream: AdsDatabaseServices().adsListStream(),
        builder: (context, snapshot) {
          // that snapshot refere to the snapshot came from firebase
          // make sure to check if there is data on it before using it
          if (snapshot.hasData) {
            List<AdModel?>? adsList = snapshot.data;
            return adsList != null
                ? Scaffold(
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
  final List<String> adsTitlesList = [];
  _storeisGrid(isGrid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGrid', isGrid);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAdsTitlesList();
  }
  getAdsTitlesList(){
    for (var element in widget.adsList) { adsTitlesList.add(element!.title.toString());}
  }

  @override
  Widget build(BuildContext context) {
  print(adsTitlesList);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: [
          GFListTile(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            padding: const EdgeInsets.all(0),
            title: Container(
              margin: const EdgeInsets.only(top: 10,bottom: 3),
              child: DismissKeyboard(
                child: GFSearchBar(
                  searchBoxInputDecoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: colorBlue,
                      ),
                    ),
                    suffixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    hintText: 'Search here...'.tr,
                    contentPadding: const EdgeInsets.only(
                      left: 16,
                      right: 20,
                      top: 14,
                      bottom: 14,
                    ),
                  ),
                    searchList:  adsTitlesList,
                    overlaySearchListItemBuilder: (item) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          item.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    },
                    searchQueryBuilder: (query, list) {
                      return adsTitlesList
                          .where((item) =>
                          item.toString().toLowerCase().contains(query.toLowerCase()))
                          .toList();
                    },
                  onItemSelected: (item) {
                    setState(() {
                      if(item == null){
                        FocusScope.of(context)
                            .unfocus();
                      return;}
                      Navigator.of(context).push(PageRouteBuilder(pageBuilder: (c,a1,a2) => SearchResultScreen(searchKey: item.toString())));
                    });
                  },
                  //hideSearchBoxWhenItemSelected: true,
                  noItemsFoundWidget: Text('No Result match your search'.tr),

                ),
              ),
            ),
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
          GFButtonBadge(
              onPressed: (){
            Navigator.of(context).push(PageRouteBuilder(pageBuilder: (c,a,aa)=>FindByPlace()));
          }, text: 'Find by Location'.tr,
            textColor:  Colors.black45,
            color: Colors.transparent,
          icon: Icon(Icons.add_location,color: Colors.black45,),),
SizedBox(height: 12,),
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
