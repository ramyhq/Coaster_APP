import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/consts/text_const.dart';
import 'package:flutter/material.dart';


class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.width = 200,
    this.height = 50,
    this.color = colorBlue,
    this.labelColor = colorWhite,
    this.labelStyle = kLoginLabelStyle
  }) : super(key: key);

  final double width ;
  final double height ;
  final String label ;
  final Color color ;
  final Color labelColor ;
  final TextStyle labelStyle ;
  final VoidCallback onPressed ;


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: MaterialButton(
        elevation: 5,
        height: height,
        minWidth: width,
        color: color,
        textColor: labelColor,
        shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: onPressed,
        child: Text(label,style: labelStyle,),
      ),
    )
    ;
  }
}





