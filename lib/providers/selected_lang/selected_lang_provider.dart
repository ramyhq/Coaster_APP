import 'package:coastv1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedLang with ChangeNotifier {
  String _selectedLang = favoritLanguage ?? 'en';
  bool _langSwitch = favoritLanguage.toString() == 'en'? false : true ;

  String get selectedLang => _selectedLang;
  bool get langSwitch => _langSwitch;

// used to update _selectedLang from dropdownbutton
  void setSelectedLang(val) {
    _selectedLang = val;
  }

// used to Toggle between ar&en switch
  Future<void> langToggle() async{
    //SharedPreferences prefs = await SharedPreferences.getInstance();

    _langSwitch = !_langSwitch;
    if (_langSwitch) {
      _selectedLang = 'ar';
      await prefs2!.setString('favoritLanguage',_selectedLang);
      favoritLanguage = prefs2!.getString('favoritLanguage');

    } else {
      _selectedLang = 'en';
      await prefs2!.setString('favoritLanguage',_selectedLang);
      favoritLanguage = prefs2!.getString('favoritLanguage');

    }
    notifyListeners();
  }

// used to update App Language
  void changeLanguage(){
    Get.updateLocale(Locale(_selectedLang));
  }


}
