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
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      shadowColor: Colors.white,
      splashFactory: NoSplash.splashFactory,
      onPrimary: labelColor,
      primary: color,
      minimumSize: Size(width, height), //Size(88, 36)
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: raisedButtonStyle,
          onPressed: onPressed,
          child: Container(
              margin: EdgeInsets.only(top: 7),
              child: Text(label,style: labelStyle,)),
        ),
    )
    ;
  }
}





