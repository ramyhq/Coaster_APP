import 'dart:io';
import 'package:coastv1/data_layer/database_services/user_database_services.dart';
import 'package:coastv1/data_layer/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? ourUser;
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
      return _ourUserDataFromFirebaseUser(ourUser);
    } on SocketException {
      setIsLoading(false);
      setMessage('No internet');
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      setMessage(e.message);
    }
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
          .createUserWithEmailAndPassword(email: email, password: password);
      ourUser = authResult.user;
      setIsLoading(false);
      //create new doc for the user with his unique uid
      await UserDatabaseServices(uid: ourUser!.uid)
          .addUserDate(ourUser!.uid,email,password,name,mob,description,currentTime);
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

  // login
  Future login(String email, String password) async {
    setIsLoading(true);
    try {
      UserCredential authResult = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      ourUser = authResult.user;
      setIsLoading(false);
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


  /// ### streams ####

  // stream of (our UserData status)
  Stream<User?> get ourUserStatusStream => _firebaseAuth.authStateChanges()
      .map((User? user) => user);
}
