// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:contactus/contactus.dart';


class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  static const String aboutText =
      ' الهدف من التطبيق هو طرد الفئران والحشرات الغير مرغوب بها في بعض الاماكن التي تصعب طردها منها مثل لو كنت في الجيش او في سكن الشغل';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'طارد الفئران',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.white.withOpacity(0.8),
                elevation: 10,
                margin: EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(aboutText,
                    textAlign: TextAlign.center,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: ContactUs(
                  cardColor: Colors.white,
                  textColor: Colors.teal.shade900,
                  email: 'ramy.dmk@gmail.com',
                  dividerThickness: 2,
                  dividerColor: Colors.black87,
                  website: 'https://ifeps.net',
                  githubUserName: 'ramyhq',
                  linkedinURL: 'https://www.linkedin.com/in/ramyhq/',
                  taglineColor: Colors.black87,
                  instagram: 'ramy.dmk',
                  companyColor: Colors.black87,
                  companyName: 'Ramy Wahid',
                  companyFontSize: 35,
                  tagLine: 'Flutter Developer',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
