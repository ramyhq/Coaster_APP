// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:coastv1/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:url_launcher/url_launcher.dart';


class Terms extends StatelessWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final Uri _url = Uri.parse('https://sites.google.com/view/coastv1/home');
  void _launchUrl() async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width /2,
            child: GFButton(
              size: 50,
              fullWidthButton: true,
              color: colorBlue,
                onPressed: _launchUrl
            , child: Text('Read',style: TextStyle(fontSize: 16),)),
          ),
        ),
      ),
    );
  }
}
