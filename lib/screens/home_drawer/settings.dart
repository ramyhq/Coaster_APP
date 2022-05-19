// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:coastv1/data_layer/user_database_services.dart';
// import 'package:coastv1/data_layer/models/user_data.dart';
// import 'package:coastv1/my_widgets/loading_widget.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
//
// class Setting extends StatelessWidget {
//   const Setting({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final ourUser = Provider.of<User?>(context);   // stream of (our UserData status) // for only user Login Status
//     return StreamBuilder<DocumentSnapshot>(
//       stream: DatabaseServices(uid: ourUser!.uid).userDataFromDB,
//       builder: (context, snapshot){
//
//     if (snapshot.hasData) {
//       DocumentSnapshot? userData = snapshot.data;
//       return Scaffold(
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                  Text(userData!.get('name') ?? 'd'),
//                  Text(userData.get('email') ?? 'd'),
//                  Text(userData.get('mob') ?? 'd'),
//               ],
//             ),
//           ),
//         ),
//       );
//     }else {
//       return LoadingWidget();
//     }
//
//       },
//     );
//   }
// }
