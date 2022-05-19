import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.error,size: 45,),
            SizedBox(width: 10,),
            Text('Error',style:TextStyle(fontSize: 40)),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorWidget2 extends StatelessWidget {
  const ErrorWidget2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.error,size: 22,),
              SizedBox(width: 10,),
              Text('Error',style:TextStyle(fontSize: 22)),
            ],
          ),
        )
      ;
  }
}
