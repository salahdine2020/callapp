import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedShema{
  savevalue({bool val}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('schema');
    await prefs.setBool('schema', val);
  }
  Future<bool> getvalue_schema()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await prefs.getBool('schema');
    return res;
  }
}