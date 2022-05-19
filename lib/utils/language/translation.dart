
import 'package:coastv1/utils/language/en.dart';
import 'package:coastv1/utils/language/ar.dart';
import 'package:get/get.dart';

class Translation extends Translations{
  @override
  Map<String, Map<String, String>> get keys => {
    'en' : en,
    'ar' : ar,
  };

}