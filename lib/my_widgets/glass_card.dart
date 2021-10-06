import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({Key? key, this.width, this.height, required this.child}) : super(key: key);

  final double? width ;
  final double? height ;
  final Widget child ;

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 8,
              color: Colors.black87.withOpacity(0.1),
            )
          ],),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20.0,
                sigmaY: 20.0,
              ),
              child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.white.withOpacity(0.2),
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: child,
                  )
              ),
            ),
          ),
        ),
      );
  }
}