
// ignore_for_file: prefer_const_constructors

import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:coastv1/my_widgets/showAlerts.dart';
import 'package:coastv1/providers/authentication_services.dart';
import 'package:coastv1/screens/home_drawer/settings.dart';
import 'package:coastv1/screens/home_pages/ads_screens/ad_view_screen.dart';
import 'package:coastv1/screens/home_pages/ads_screens/add_ad_screen.dart';
import 'package:coastv1/screens/home_pages/ads_screens/liked_ads_list_screen.dart';
import 'package:coastv1/screens/home_pages/HomePageAds.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyPagesWithBottomNavigationBar extends StatefulWidget {
  const MyPagesWithBottomNavigationBar({Key? key,}) : super(key: key);

  @override
  _MyPagesWithBottomNavigationBarState createState() =>
      _MyPagesWithBottomNavigationBarState();
}

class _MyPagesWithBottomNavigationBarState
    extends State<MyPagesWithBottomNavigationBar> with TickerProviderStateMixin {
  int currentValue = 0;

  List screens = [
    AllAdsScreen(),
    AddAdScreen(),
    LikedAdsScreen(),
  ];

  late AnimationController _controller;
  late Animation<double> _animation;

  late AnimationController _controller3;
  late Animation<double> _animation3;

  late AnimationController _controller4;
  late Animation<double> _animation4;


  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 25, end: 33).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
        reverseCurve: Curves.easeIn))
      ..addListener(() {
        setState(() {});
      });


    _controller3 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation3 = Tween<double>(begin: 25, end: 33).animate(CurvedAnimation(
        parent: _controller3,
        curve: Curves.fastLinearToSlowEaseIn,
        reverseCurve: Curves.easeIn))
      ..addListener(() {
        setState(() {});
      });

    _controller4 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation4 = Tween<double>(begin: 25, end: 33).animate(CurvedAnimation(
        parent: _controller4,
        curve: Curves.fastLinearToSlowEaseIn,
        reverseCurve: Curves.easeIn))
      ..addListener(() {
        setState(() {});
      });


  }

  @override
  void dispose() {
    _controller.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Size size = MediaQuery.of(context).size;
    return Column(
        children: [
          Expanded(
            child: SizedBox(
              width: size.width,
              child: screens.elementAt(currentValue),
            ),
          ),
          Container(
            height: size.width * .14,
            width: size.width,
            //margin: EdgeInsets.all(size.width * .04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 5),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: currentValue == 0 ? colorBlue : Colors.black38,
                    size: _animation.value,
                  ),
                  onPressed: () {
                    setState(() {
                      currentValue = 0;
                      _controller.forward();
                      _controller3.reverse();
                      _controller4.reverse();
                      HapticFeedback.lightImpact();
                    });
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_box_rounded,
                    color: currentValue == 1 ? colorBlue : Colors.black38,
                    size: _animation3.value,
                  ),
                  onPressed: () {
                    if(user.isAnonymous){
                      showLoginAlertDialog(context: context, function: () {
                      });
                      return;
                    }
                    setState(() {
                      currentValue = 1;
                      _controller3.forward();
                      _controller.reverse();
                      _controller4.reverse();
                      HapticFeedback.lightImpact();
                    });
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite_rounded,
                    color: currentValue == 2 ? colorBlue : Colors.black38,
                    size: _animation4.value,
                  ),
                  onPressed: () {
                    if(user.isAnonymous){
                      showLoginAlertDialog(context: context, function: () {
                      });
                      return;
                    }
                    setState(() {
                      currentValue = 2;
                      _controller4.forward();
                      _controller.reverse();
                      _controller3.reverse();
                      HapticFeedback.lightImpact();
                    });
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ],
            ),
          ),

        ],
      )
    ;
  }
}



//
// // ignore_for_file: prefer_const_constructors
//
// import 'package:coastv1/screens/home_pages/ads_screens/ad_view_screen.dart';
// import 'package:coastv1/screens/home_pages/ads_screens/add_ad_screen.dart';
// import 'package:coastv1/screens/home_pages/HomePageAds.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class MyPagesWithBottomNavigationBar extends StatefulWidget {
//   const MyPagesWithBottomNavigationBar({Key? key}) : super(key: key);
//
//   @override
//   _MyPagesWithBottomNavigationBarState createState() =>
//       _MyPagesWithBottomNavigationBarState();
// }
//
// class _MyPagesWithBottomNavigationBarState
//     extends State<MyPagesWithBottomNavigationBar> with TickerProviderStateMixin {
//   int currentValue = 0;
//
//   List screens = [
//     LookForScreen(),
//     AdViewScreen(),
//     AddAdScreen(),
//     AdViewScreen(),
//     AddAdScreen(),
//   ];
//
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   late AnimationController _controller2;
//   late Animation<double> _animation2;
//
//   late AnimationController _controller3;
//   late Animation<double> _animation3;
//
//   late AnimationController _controller4;
//   late Animation<double> _animation4;
//
//   late AnimationController _controller5;
//   late Animation<double> _animation5;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//     _animation = Tween<double>(begin: 25, end: 33).animate(CurvedAnimation(
//         parent: _controller,
//         curve: Curves.fastLinearToSlowEaseIn,
//         reverseCurve: Curves.easeIn))
//       ..addListener(() {
//         setState(() {});
//       });
//
//     _controller2 =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//     _animation2 = Tween<double>(begin: 25, end: 33).animate(CurvedAnimation(
//         parent: _controller2,
//         curve: Curves.fastLinearToSlowEaseIn,
//         reverseCurve: Curves.easeIn))
//       ..addListener(() {
//         setState(() {});
//       });
//
//     _controller3 =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//     _animation3 = Tween<double>(begin: 25, end: 33).animate(CurvedAnimation(
//         parent: _controller3,
//         curve: Curves.fastLinearToSlowEaseIn,
//         reverseCurve: Curves.easeIn))
//       ..addListener(() {
//         setState(() {});
//       });
//
//     _controller4 =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//     _animation4 = Tween<double>(begin: 25, end: 33).animate(CurvedAnimation(
//         parent: _controller4,
//         curve: Curves.fastLinearToSlowEaseIn,
//         reverseCurve: Curves.easeIn))
//       ..addListener(() {
//         setState(() {});
//       });
//
//     _controller5 =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//     _animation5 = Tween<double>(begin: 25, end: 33).animate(CurvedAnimation(
//         parent: _controller5,
//         curve: Curves.fastLinearToSlowEaseIn,
//         reverseCurve: Curves.ease))
//       ..addListener(() {
//         setState(() {});
//       });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _controller2.dispose();
//     _controller3.dispose();
//     _controller4.dispose();
//     _controller5.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.amber,
//       body: Stack(
//         children: [
//           // HOME PAGE
//           SizedBox(
//             height: size.height,
//             width: size.width,
//             child: screens.elementAt(currentValue),
//           ),
//
//           Positioned(
//             bottom: 0,
//             right: 0,
//             left: 0,
//             child: Container(
//               height: size.width * .14,
//               width: size.width,
//               margin: EdgeInsets.all(size.width * .04),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(8),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       Icons.home,
//                       color: currentValue == 0 ? Colors.blue : Colors.black38,
//                       size: _animation.value,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         currentValue = 0;
//                         _controller.forward();
//                         _controller2.reverse();
//                         _controller3.reverse();
//                         _controller4.reverse();
//                         _controller5.reverse();
//                         HapticFeedback.lightImpact();
//                       });
//                     },
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       Icons.person_rounded,
//                       color: currentValue == 1 ? Colors.blue : Colors.black38,
//                       size: _animation2.value,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         currentValue = 1;
//                         _controller2.forward();
//                         _controller.reverse();
//                         _controller3.reverse();
//                         _controller4.reverse();
//                         _controller5.reverse();
//                         HapticFeedback.lightImpact();
//                       });
//                     },
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       Icons.add_box_rounded,
//                       color: currentValue == 2 ? Colors.blue : Colors.black38,
//                       size: _animation3.value,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         currentValue = 2;
//                         _controller3.forward();
//                         _controller.reverse();
//                         _controller2.reverse();
//                         _controller4.reverse();
//                         _controller5.reverse();
//                         HapticFeedback.lightImpact();
//                       });
//                     },
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       Icons.favorite_rounded,
//                       color: currentValue == 3 ? Colors.blue : Colors.black38,
//                       size: _animation4.value,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         currentValue = 3;
//                         _controller4.forward();
//                         _controller.reverse();
//                         _controller2.reverse();
//                         _controller3.reverse();
//                         _controller5.reverse();
//                         HapticFeedback.lightImpact();
//                       });
//                     },
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       Icons.settings_rounded,
//                       color: currentValue == 4 ? Colors.blue : Colors.black38,
//                       size: _animation5.value,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         currentValue = 4;
//                         _controller5.forward();
//                         _controller.reverse();
//                         _controller2.reverse();
//                         _controller3.reverse();
//                         _controller4.reverse();
//                         HapticFeedback.lightImpact();
//                       });
//                     },
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




























