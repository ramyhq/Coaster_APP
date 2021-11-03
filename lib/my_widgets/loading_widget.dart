import 'package:coastv1/consts/colors.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              CircularProgressIndicator(color: colorBlack,),
              SizedBox(width: 10,),
              Text('Please Wait ... ',style:TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 60,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              SizedBox(width: 14,
                  height: 14,
                  child: CircularProgressIndicator(color: colorBlack,)),
              SizedBox(width: 10,),
              Text('Please Wait... ',style:TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
