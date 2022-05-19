// ignore_for_file: prefer_const_constructors

import 'package:coastv1/data_layer/database_services/ads_db_services.dart';
import 'package:coastv1/data_layer/database_services/user_database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class ImageGrid extends StatelessWidget {
  final List<Widget> children;
  const ImageGrid({Key? key, required this.children}) : super(key: key);
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

class GridCard extends StatelessWidget {
  // for places
  final String? location;
  final String? subtitle;
  final String? image;
  // for ads list
  final String? title;
  final String? adID;
  final double? price;
  final List<String>? likedBy;
  final VoidCallback? onTab;

  const GridCard({
    Key? key,
    this.location,
    this.subtitle,
    this.image,
    this.onTab,
    this.title,
    this.adID,
    this.price,
    this.likedBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    final ourUser = Provider.of<User>(context);
    bool isLiked = AdsDatabaseServices().isLiked(ourUser.email.toString().trim(),likedBy);
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTab,
      child: Stack(
        children: [
          Column(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toString(),
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
                      price!.round().toString(),
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
          Positioned(
            right: 0,
              child: IconButton(
                icon: isLiked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                onPressed: (){
                  isLiked ?
                  AdsDatabaseServices().removeFromListInAds(
                      ad_uid: adID.toString(),
                      List_field: 'likedBy',
                      element: ourUser.email)
                      :
                  AdsDatabaseServices().updateToListInAds(
                      ad_uid: adID.toString(),
                      List_field: 'likedBy',
                      element: ourUser.email);

                },),
          ),
        ],
      ),
    );
  }
}

class ListCard extends StatelessWidget {
  // for places
  final String? location;
  final String? subtitle;
  final String? image;
  // for ads list
  final String? title;
  final String? adID;
  final double? price;
  final int? placeReview;
  final List<String>? likedBy;
  final void Function()? onTab;

  const ListCard({
    Key? key,
    this.location,
    this.subtitle,
    this.image,
    this.onTab,
    this.title,
    this.adID,
    this.price,
    this.placeReview,
    this.likedBy,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final ourUser = Provider.of<User>(context);
    bool isLiked = AdsDatabaseServices().isLiked(ourUser.email.toString().trim(),likedBy);
    return GestureDetector(
      onTap: onTab,
      child: GFCard(
        boxFit: BoxFit.cover,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 0),
        image: Image.asset('assets/images/ob0.png'),
        showImage: true,
        elevation: 1,
        titlePosition: GFPosition.start,
        title: GFListTile(
          icon: Material(
            type: MaterialType.transparency,
            child: InkWell(
              child: Icon(
                Icons.more_vert,
              ),
              onTap: () {
                ///******
              },
            ),
          ),
          margin: EdgeInsets.all(0),
          titleText: title,
          subTitleText: location,
        ),
        content: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle.toString()),
              SizedBox(height: 15),
              Text("Price : $price USD "),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                       icon: isLiked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                    onPressed: (){
                      isLiked ?
                      AdsDatabaseServices().removeFromListInAds(
                          ad_uid: adID.toString(),
                          List_field: 'likedBy',
                          element: ourUser.email)
                      :
                      AdsDatabaseServices().updateToListInAds(
                      ad_uid: adID.toString(),
                      List_field: 'likedBy',
                      element: ourUser.email);

                    },)
                ],
              ),
            ],
          ),
        ),
        color: Colors.white,
      ),
    );
  }
}

showAlertDialog(
    {required BuildContext context, required VoidCallback function}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Delete for ever!"),
            onPressed: () {
              function();
              Navigator.of(context).pop();
              GFToast.showToast('Deleted successfully', context,
                  toastPosition: GFToastPosition.BOTTOM,
                  textStyle:
                      const TextStyle(fontSize: 16, color: GFColors.DARK),
                  backgroundColor: GFColors.LIGHT,
                  trailing: const Icon(
                    Icons.notifications,
                    color: GFColors.SUCCESS,
                  ));
            },
          )
        ],
      );
    },
  );
}

//
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class MyCustomUI extends StatefulWidget {
//   @override
//   _MyCustomUIState createState() => _MyCustomUIState();
// }
//
// class _MyCustomUIState extends State<MyCustomUI>
//     with SingleTickerProviderStateMixin {
//   AnimationController _controller;
//   Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//     );
//
//     _animation = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
//       ..addListener(() {
//         setState(() {});
//       });
//
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double _w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Color(0xffF5F5F5),
//       body: Stack(
//         children: [
//           ListView(
//             physics:
//             BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//             children: [
//               searchBar(),
//               SizedBox(height: _w / 20),
//               groupOfCards(
//                   'Example Text',
//                   'Example Text',
//                   'assets/images/file_name.png',
//                   RouteWhereYouGo(),
//                   'Example Text',
//                   'Example Text',
//                   'assets/images/file_name.png',
//                   RouteWhereYouGo()),
//               groupOfCards(
//                   'Example Text',
//                   'Example Text',
//                   'assets/images/file_name.png',
//                   RouteWhereYouGo(),
//                   'Example Text',
//                   'Example Text',
//                   'assets/images/file_name.png',
//                   RouteWhereYouGo()),
//               groupOfCards(
//                   'Example Text',
//                   'Example Text',
//                   'assets/images/file_name.png',
//                   RouteWhereYouGo(),
//                   'Example Text',
//                   'Example Text',
//                   'assets/images/file_name.png',
//                   RouteWhereYouGo()),
//               groupOfCards(
//                   'Example Text',
//                   'Example Text',
//                   'assets/images/file_name.png',
//                   RouteWhereYouGo(),
//                   'Example Text',
//                   'Example Text',
//                   'assets/images/file_name.png',
//                   RouteWhereYouGo()),
//               groupOfCards(
//                   'Example Text',
//                   'Example Text',
//                   'assets/images/file_name.png',
//                   RouteWhereYouGo(),
//                   'Example Text',
//                   'Example Text',
//                   'assets/images/file_name.png',
//                   RouteWhereYouGo()),
//               groupOfCards(
//                   'Example Text',
//                   'Example Text',
//                   'assets/images/file_name.png',
//                   RouteWhereYouGo(),
//                   'Example Text',
//                   'Example Text',
//                   'assets/images/file_name.png',
//                   RouteWhereYouGo()),
//             ],
//           ),
//           settingIcon(),
//         ],
//       ),
//     );
//   }
//
//   Widget settingIcon() {
//     double _w = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: EdgeInsets.fromLTRB(0, _w / 10, _w / 20, 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Container(
//             height: _w / 8.5,
//             width: _w / 8.5,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(.1),
//                   blurRadius: 30,
//                   offset: Offset(0, 15),
//                 ),
//               ],
//               shape: BoxShape.circle,
//             ),
//             child: IconButton(
//               splashColor: Colors.transparent,
//               highlightColor: Colors.transparent,
//               tooltip: 'Settings',
//               icon: Icon(Icons.settings,
//                   size: _w / 17, color: Colors.black.withOpacity(.6)),
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MyFadeRoute(
//                     route: RouteWhereYouGo(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget searchBar() {
//     double _w = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: EdgeInsets.fromLTRB(_w / 20, _w / 25, _w / 20, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             alignment: Alignment.center,
//             height: _w / 8.5,
//             width: _w / 1.36,
//             padding: EdgeInsets.symmetric(horizontal: _w / 60),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(99),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(.1),
//                   blurRadius: 30,
//                   offset: Offset(0, 15),
//                 ),
//               ],
//             ),
//             child: TextField(
//               maxLines: 1,
//               decoration: InputDecoration(
//                 fillColor: Colors.transparent,
//                 filled: true,
//                 hintStyle: TextStyle(
//                     color: Colors.black.withOpacity(.4),
//                     fontWeight: FontWeight.w600,
//                     fontSize: _w / 22),
//                 prefixIcon:
//                 Icon(Icons.search, color: Colors.black.withOpacity(.6)),
//                 hintText: 'Search anything.....',
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide.none),
//                 contentPadding: EdgeInsets.zero,
//               ),
//             ),
//           ),
//           SizedBox(height: _w / 14),
//           Container(
//             width: _w / 1.15,
//             child: Text(
//               'Example Text',
//               textScaleFactor: 1.4,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black.withOpacity(.7),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget groupOfCards(
//       String title1,
//       String subtitle1,
//       String image1,
//       Widget route1,
//       String title2,
//       String subtitle2,
//       String image2,
//       Widget route2) {
//     double _w = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: EdgeInsets.fromLTRB(_w / 20, 0, _w / 20, _w / 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           card(title1, subtitle1, image1, route1),
//           card(title2, subtitle2, image2, route2),
//         ],
//       ),
//     );
//   }
//
//   Widget card(String title, String subtitle, String image, Widget route) {
//     double _w = MediaQuery.of(context).size.width;
//     return Opacity(
//       opacity: _animation.value,
//       child: InkWell(
//         highlightColor: Colors.transparent,
//         splashColor: Colors.transparent,
//         onTap: () {
//           Navigator.of(context).push(MyFadeRoute(route: route));
//         },
//         child: Container(
//           width: _w / 2.36,
//           height: _w / 1.8,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 50),
//             ],
//           ),
//           child: Column(
//             children: [
//               Container(
//                 width: _w / 2.36,
//                 height: _w / 2.6,
//                 decoration: BoxDecoration(
//                   color: Color(0xff5C71F3),
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(20),
//                   ),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   'Add image here',
//                   textScaleFactor: 1.2,
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               // Image.asset(
//               //   image,
//               //   fit: BoxFit.cover,
//               //   width: _w / 2.36,
//               //   height: _w / 2.6),
//               Container(
//                 height: _w / 6,
//                 width: _w / 2.36,
//                 padding: EdgeInsets.symmetric(horizontal: _w / 25),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       textScaleFactor: 1.4,
//                       maxLines: 1,
//                       softWrap: true,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.black.withOpacity(.8),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Text(
//                       subtitle,
//                       textScaleFactor: 1,
//                       maxLines: 1,
//                       softWrap: true,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black.withOpacity(.7),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class MyFadeRoute extends PageRouteBuilder {
//   final Widget page;
//   final Widget route;
//
//   MyFadeRoute({this.page, this.route})
//       : super(
//     pageBuilder: (
//         BuildContext context,
//         Animation<double> animation,
//         Animation<double> secondaryAnimation,
//         ) =>
//     page,
//     transitionsBuilder: (
//         BuildContext context,
//         Animation<double> animation,
//         Animation<double> secondaryAnimation,
//         Widget child,
//         ) =>
//         FadeTransition(
//           opacity: animation,
//           child: route,
//         ),
//   );
// }
//
// class RouteWhereYouGo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         brightness: Brightness.light,
//         backgroundColor: Colors.white,
//         elevation: 50,
//         centerTitle: true,
//         shadowColor: Colors.black.withOpacity(.5),
//         title: Text('EXAMPLE  PAGE',
//             style: TextStyle(
//                 color: Colors.black.withOpacity(.7),
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 1)),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.black.withOpacity(.8),
//           ),
//           onPressed: () => Navigator.maybePop(context),
//         ),
//       ),
//     );
//   }
// }
