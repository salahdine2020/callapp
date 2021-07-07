import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllLanguage {
  static List<String> supportedLanguages = ['English', 'हिन्दी','中文','Española','français'];

  static List<String> supportedLanguagesCode = ['en', 'hi','zh','es','fr'];


  //If you use app localization packages
  static List<Locale> supportedLocales = [
    const Locale('en', ''),
    const Locale('hi', ''),
    const Locale('zh', ''),
    const Locale('es', ''),
    const Locale('fr', ''),
  ];

  /// fnct to save lang
  static Future<void> changeLanguage(String langCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("langCode", langCode);
  }

  static Future<String> getLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String langCode = sharedPreferences.getString("langCode");
    if (langCode == null) {
      langCode = supportedLanguagesCode.first;
    }
    return langCode;
  }
}

class Translator {
  static Map<String, String> _localizedStrings;

  static Future<bool> load(String langCode) async {
    /// change and save lang
    AllLanguage.changeLanguage(langCode);
    String jsonString = await rootBundle.loadString('assets/lang/$langCode.json');
    Map<String, dynamic> jsonLanguageMap = json.decode(jsonString);
    _localizedStrings = jsonLanguageMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }
  // called from every screens which needs a localized text
  static String translate(String text) {
    if (_localizedStrings != null) {
      String value = _localizedStrings[text];
      print('----------- value of _localizedStrings[text] is $value --------------');
      return value == null ? autoTranslate(text) : value;
    }
    return text;
  }

  static String autoTranslate(String text) {
    log("You need to translate this text : " + text);
    try {
      List<String> texts = text.split("_");
      StringBuffer stringBuffer = StringBuffer();
      for (String singleText in texts) {
        stringBuffer.write(
            singleText[0].toUpperCase() + singleText.substring(1) + " ");
      }
      return stringBuffer.toString();
    }catch(err){
      return text;
    }
  }


}
