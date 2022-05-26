import 'dart:io';
import 'package:coastv1/data_layer/database_services/user_database_services.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;
  bool? isGuest ;
  String? _errorMessage;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? ourUser;
  String defaultProfileImage = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsuKHtQ3e0QWhO0esSv8cafAxx9iYVpRsP8g&usqp=CAU';
  DateTime currentTime = DateTime.now();

  //AuthServices({this.ourUser});

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  void setIsLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(message) {
    _errorMessage = message;
    notifyListeners();
  }


  // sign in anon for guest
  Future signInAnon() async {
    setIsLoading(true);
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      ourUser = result.user;
      setIsLoading(false);
      //create empty doc for the Guest with his unique uid (for later)
      await UserDatabaseServices(uid: ourUser!.uid).updateGuestDate(ourUser!.uid);
      isGuest = true;
      print('2qqq$isGuest');

      return _ourUserDataFromFirebaseUser(ourUser);
    } on SocketException {
      setIsLoading(false);
      setMessage('No internet');
      print('OHH!! No internet');
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      setMessage('OHH!! ${e.message}');
      print('OHH!! ${e.message}');
    }
    notifyListeners();

  }

  // register
  Future register(
  String email,
  String password,
  String? name,
  String? mob,
  String? description,
  //DateTime? signUPDate,
      ) async {
    setIsLoading(true);
    try {
      UserCredential authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password,);
      ourUser = authResult.user;
      setIsLoading(false);
      //create new doc for the user with his unique uid
      await UserDatabaseServices(uid: ourUser!.uid)
          .addUserData(ourUser!.uid,email,password,name,mob,description,currentTime);
      notifyListeners();
      await ourUser!.updatePhotoURL(defaultProfileImage);
      await ourUser!.updateDisplayName(name);
      isGuest = false;
      return ourUser;
    } on SocketException {
      setIsLoading(false);
      setMessage('No internet');
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      setMessage(e.message);
    }
  }

  // login
  Future login(String email, String password) async {
    setIsLoading(true);
    try {
      UserCredential authResult = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      ourUser = authResult.user;
      setIsLoading(false);
      isGuest = false;
      return ourUser;
    } on SocketException {
      setIsLoading(false);
      setMessage('No internet');
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      setMessage(e.message);
    }
    notifyListeners();
  }

  Future logout() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }

  //Func convert firebaseUser (user) to user_data model to use it in all app
  UserData? _ourUserDataFromFirebaseUser(User? user) {
    return user != null ? UserData(uid: user.uid) : null;
  }

  Future<String> changePassword({required String newPassword,User? user}) async {
    try {
      print('#5565 $user');
     await user!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      setMessage(e.message);
      return e.message.toString();
    }
     print('#549 newPassword changed successfully');
     return 'changed successfully';
  }


  /// ### streams ####

  // stream of (our UserData status)
  Stream<User?> get ourUserStatusStream => _firebaseAuth.authStateChanges()
      .map((User? user) => user);


}
