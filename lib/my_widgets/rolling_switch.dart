// it use external packages
// #for rolling switch
// simple_animations: ^4.0.1
// supercharged: ^2.1.1

import 'dart:math';
import 'package:coastv1/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';


enum _CheckboxProps { paddingLeft, color, text, rotation }

class SwitchlikeCheckbox extends StatelessWidget {
  final bool checked;


  const SwitchlikeCheckbox({Key? key, required this.checked,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tween = MultiTween<_CheckboxProps>()
      ..add(_CheckboxProps.paddingLeft, 0.0.tweenTo(30.0), 1.seconds)
      ..add(_CheckboxProps.color, colorBlue.tweenTo(colorBlue), 1.seconds)
      ..add(_CheckboxProps.text, ConstantTween("En"), 200.milliseconds)
      ..add(_CheckboxProps.text, ConstantTween("Ar"), 200.milliseconds)
      ..add(_CheckboxProps.rotation, (-2 * pi).tweenTo(0.0), 1.seconds);

    return CustomAnimation<MultiTweenValues<_CheckboxProps>>(
      control: checked
          ? CustomAnimationControl.play
          : CustomAnimationControl.playReverse,
      startPosition: checked ? 1.0 : 0.0,
      duration: tween.duration * 1.2,
      tween: tween,
      curve: Curves.easeInOut,
      builder: _buildCheckbox,
    );
  }

  Widget _buildCheckbox(
      context, child, MultiTweenValues<_CheckboxProps> value) {
    return Container(
      decoration: _outerBoxDecoration(value.get(_CheckboxProps.color)),
      width: 75,
      height: 45,
      padding: const EdgeInsets.all(3.0),
      child: Stack(
        children: [
          Positioned(
              child: Padding(
                padding:
                EdgeInsets.only(left: value.get(_CheckboxProps.paddingLeft)),
                child: Transform.rotate(
                  angle: value.get(_CheckboxProps.rotation),
                  child: Container(
                    decoration:
                    _innerBoxDecoration(value.get(_CheckboxProps.color)),
                    width: 35,
                    child: Center(
                        child: Text(value.get(_CheckboxProps.text),
                            style: labelStyle)),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  BoxDecoration _innerBoxDecoration(Color color) => BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(25)), color: color);

  BoxDecoration _outerBoxDecoration(Color color) => BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    border: Border.all(
      width: 2,
      color: color,
    ),
  );

  static final labelStyle = TextStyle(
      height: 1.2,
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.white);
}

