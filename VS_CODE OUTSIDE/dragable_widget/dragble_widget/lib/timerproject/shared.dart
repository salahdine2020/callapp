import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{
  Future saveTime(Duration time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.remove('time_m');
    prefs.setInt('time', int.parse(time.toString()));
  }
  Future getTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.getInt('time');
    return res;
  }
  Future saveTimeMinutes(Duration time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.remove('time_m');
    /*int numMinutes = time.inMinutes - (time.inHours * 60);
    prefs.setInt('time_m', time.inMinutes);*/
    prefs.setInt('time_m', time.inMinutes);
  }
  Future saveTimeSeconds(Duration time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.remove('time_s');
    /// time.inSeconds == time.inMinutes * 60 + seconds
    int numSeconds = time.inSeconds - (time.inMinutes * 60);
    prefs.setInt('time_s', numSeconds);
  }
  Future getTimeMinutes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.getInt('time_m');
    return res;
  }
  Future getTimeSeconds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.getInt('time_s');
    return res;
  }
  Future getTimeMinutesPenalite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.getInt('time_m');
    return res + 2;
  }
  Future removeShared() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('time_s');
    prefs.remove('time_m');
  }
}