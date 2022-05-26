// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:contactus/contactus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class AboutApp extends StatelessWidget {
   AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Text('Coaster'.tr,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
                child: Text('Coaster is the easiest solution to search for real estate in the coastal cities easily... Find your vacation, your apartment, or even a commercial store'.tr,style: GoogleFonts.tajawal(fontSize: 16,fontWeight: FontWeight.w700)
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ContactUs(
                  cardColor: Colors.white,
                  textColor: Colors.grey,
                  email: 'ramy.dmk@gmail.com',
                  dividerThickness: 1,
                  dividerColor: Colors.grey,
                  website: 'https://ifeps.net',
                  githubUserName: 'ramyhq',
                  linkedinURL: 'https://www.linkedin.com/in/ramyhq/',
                  taglineColor: Colors.grey,
                  instagram: 'ramy.dmk',
                  companyColor: Colors.black54,
                  companyName: 'Ramy Wahid',
                  companyFontSize: 25,
                  taglineFontWeight: FontWeight.w300,
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
