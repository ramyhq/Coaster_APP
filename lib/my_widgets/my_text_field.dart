
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/consts/text_const.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.hintText,
    required this.labelText,
    this.labelStyle = kEmailLabelStyle,
    this.hintStyleStyle = kEmailHintStyle,
  }) : super(key: key);

  final String hintText;
  final String labelText;
  final TextStyle labelStyle ;
  final TextStyle hintStyleStyle ;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius:  BorderRadius.circular(5.0),
              borderSide: BorderSide(width: 1,color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:  BorderRadius.circular(5.0),
              borderSide: BorderSide(width: 2.5,color: colorBlue),
            ),
            border: OutlineInputBorder(),
            hintText: hintText,
            hintStyle: kEmailHintStyle,
            labelText: labelText,
            labelStyle: labelStyle ,
            alignLabelWithHint: false,
            filled: false,
            floatingLabelBehavior: FloatingLabelBehavior.always
          //fillColor: Colors.white,
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
      ),
    );
  }
}