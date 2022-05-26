import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class SimpleImageSlider extends StatefulWidget {
  final List<String> images;
  const SimpleImageSlider({Key? key,required this.images}) : super(key: key);
  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SimpleImageSlider> {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentIndex = 1;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    List addedImages = [];
    if (widget.images.length > 0) {
      addedImages
        ..add(widget.images[widget.images.length - 1])
        ..addAll(widget.images)
        ..add(widget.images[0]);
    }
    return Container(
      // decoration: BoxDecoration(
      //   boxShadow: [
      //     //BoxShadow(color: Colors.black.withOpacity(.10), blurRadius: 1),
      //     BoxShadow(color: Colors.black.withOpacity(.10), blurRadius: 10,spreadRadius: -12,offset: const Offset(0, 0),
      //     ),
      //   ],
      // ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            widget.images.length > 0
                ? PageView(
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              onPageChanged: (page) {
                int newIndex;
                if (page == addedImages.length - 1) {
                  newIndex = 1;
                  _pageController.jumpToPage(newIndex);
                } else if (page == 0) {
                  newIndex = addedImages.length - 2;
                  _pageController.jumpToPage(newIndex);
                } else {
                  newIndex = page;
                }
                setState(() {
                  _currentIndex = newIndex;
                });
              },
              children: addedImages
                  .map((item) => Container(
                margin: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: GestureDetector(
                    child: CachedNetworkImage(
                        imageUrl: item,
                      fit: BoxFit.fill,
                    ),
                    onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (c)=> ImageView(images: widget.images)));

                    },
                  ),
                ),
              ))
                  .toList(),
            )
                : Container(),
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.images
                    .asMap()
                    .map((i, v) => MapEntry(
                    i,
                    Container(
                      width: 6,
                      height: 6,
                      margin: EdgeInsets.only(left: 2, right: 2),
                      decoration: ShapeDecoration(
                        color: _currentIndex == i + 1 ? Colors.red : Colors.white,
                        shape: CircleBorder(),
                      ),
                    )))
                    .values
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }


}




class ImageView extends StatelessWidget {
   ImageView({Key? key,required this.images}) : super(key: key);
   List<String> images;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: PhotoViewGallery.builder(
          itemCount: images.length,
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(images[index]),
              initialScale: PhotoViewComputedScale.contained * 1,
              heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
            );
          },
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!.toInt(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



//
//
//
//
// //// We are using this plugin => flutter_swiper
// //// Search it on google For more information.
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
//
// class MyPlugin extends StatelessWidget {
//   static const routeName = '/SlidersPage_1';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white.withOpacity(0.9),
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: 300,
//               padding: EdgeInsets.all(16.0),
//               child: Swiper(
//                 itemBuilder: (BuildContext context, int index) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(10.0),
//                     child: Container(
//                       color: Colors.blueGrey,
//                       child: Image.asset(
//                         'assets/images/sample_image.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 },
//                 itemCount: 10,
//                 viewportFraction: 0.8,
//                 scale: 0.9,
//                 pagination: SwiperPagination(),
//               ),
//             ),
//             SizedBox(height: 20.0),
//             Container(
//               height: 300,
//               padding: EdgeInsets.all(16.0),
//               child: Swiper(
//                 itemBuilder: (BuildContext context, int index) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(10.0),
//                     child: Container(
//                       color: Colors.blueGrey,
//                       child: Image.asset(
//                         'assets/images/sample_image.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 },
//                 itemWidth: 300,
//                 itemCount: 10,
//                 layout: SwiperLayout.STACK,
//               ),
//             ),
//             SizedBox(height: 20.0),
//             Container(
//               height: 340,
//               padding: EdgeInsets.all(16.0),
//               child: Swiper(
//                 fade: 0.0,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Column(
//                     children: <Widget>[
//                       Container(
//                         height: 200,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10.0),
//                             topRight: Radius.circular(10.0),
//                           ),
//                           color: Colors.blueGrey,
//                         ),
//                         child: Image.asset(
//                           'assets/images/sample_image.png',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(10.0),
//                             bottomRight: Radius.circular(10.0),
//                           ),
//                         ),
//                         child: ListTile(
//                           subtitle: Text("amazing application"),
//                           title: Text("Flutter Plugin"),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//                 itemCount: 10,
//                 scale: 0.9,
//                 pagination: SwiperPagination(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//









