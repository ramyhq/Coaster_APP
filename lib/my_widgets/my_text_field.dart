
import 'package:coastv1/consts/colors.dart';
import 'package:coastv1/consts/text_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
   MyTextField({
    Key? key,
    required this.hintText,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.labelStyle = kEmailLabelStyle,
    this.hintStyleStyle = kEmailHintStyle,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
     this.obscureText = false,
     this.inputFormatters,
     this.maxLines,
     this.minLines,
     this.onFieldSubmitted,
  }) : super(key: key);

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final String labelText;
  final String? errorText;
  final TextStyle labelStyle ;
  final TextStyle hintStyleStyle ;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLines;
  void Function(String)? onFieldSubmitted;

  bool obscureText ;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
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
            floatingLabelBehavior: FloatingLabelBehavior.always,
          errorText: errorText,
          //fillColor: Colors.white,
        ),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        minLines: minLines,
        maxLines: maxLines ?? 1,
        onFieldSubmitted:onFieldSubmitted ,
      ),
    );
  }
}