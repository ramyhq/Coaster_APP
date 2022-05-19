import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedLang with ChangeNotifier {
  String _selectedLang = 'en';
  bool _langSwitch = false;

  String get selectedLang => _selectedLang;
  bool get langSwitch => _langSwitch;

// used to update _selectedLang from dropdownbutton
  void setSelectedLang(val) {
    _selectedLang = val;
  }

// used to Toggle between ar&en switch
  Future<void> langToggle() async{
    _langSwitch = !_langSwitch;
    if (_langSwitch) {
      _selectedLang = 'ar';
    } else {
      _selectedLang = 'en';
    }
    notifyListeners();
  }

// used to update App Language
  void changeLanguage(){
    Get.updateLocale(Locale(_selectedLang));
  }


}
