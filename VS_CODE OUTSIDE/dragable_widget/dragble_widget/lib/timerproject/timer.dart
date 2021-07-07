import 'dart:async';
import 'package:dragble_widget/timerproject/shared.dart';

import './timermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer {
  double _radius = 1;
  bool _isActive = true;
  Timer timer;
  Duration _time;
  Duration _fullTime;
  int work = 30;//30;
  int shortBreak = 5;
  int longBreak = 20;

  String returnTime(Duration t) {
    // ex: if time is 4:52 >> 04:52
    String hours = (t.inHours < 10)
        ? '0' + t.inHours.toString()
        : t.inHours.toString();
    int numMinutes = t.inMinutes - (t.inHours * 60);
    String minutes = (numMinutes < 10)
        ? '0' + numMinutes.toString()
        : numMinutes.toString();
    // ex: (t.inSeconds - (t.inMinutes * 60)) == 220s - 3*60 = 40s this snippet of code to calculate 40s
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    // ex: if time is 4:5 >> 04:05
    String seconds =
        (numSeconds < 10) ? '0' + numSeconds.toString() : numSeconds.toString();

    String formattedTime = hours + ":" + minutes + ":" + seconds;
    return formattedTime;
  }

  Stream<TimerModel> streamTimer() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String time;
      if (this._isActive) {
        ///_time = _time - Duration(seconds: 1); // ex: work != 30 >> 29:59

        _time = _time + Duration(seconds: 1);
        _radius = _time.inSeconds / _fullTime.inSeconds; // percentage %
        if (_time.inSeconds <= 0) {
          // when finich time
          _isActive = false;
        }
      }
      // save time
      time = returnTime(_time);
      return TimerModel(time, _radius);
    });
  }

  Future readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    work =
        prefs.getInt('workTime') == null ? 30 : prefs.getInt('workTime');
    shortBreak =
        prefs.getInt('shortBreak') == null ? 30 : prefs.getInt('shortBreak');
    longBreak =
        prefs.getInt('longBreak') == null ? 30 : prefs.getInt('longBreak');
  }

  Future readSettingsWork() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    work = prefs.getInt('workTime') == null ? 30 : prefs.getInt('workTime');
    return work;
  }

  void stopTimer() {
    this._isActive = false;
    SharedPrefs().saveTimeMinutes(_time);
    SharedPrefs().saveTimeSeconds(_time);
    print('time when stop is $_time');
  }

  void continueTimer() async{
    this._isActive = true;
    print('time when contiue press is $_time');
    print('time Continue : ${_time.inMinutes} : ${_time.inSeconds}');
  }

  void startWork() async {
    var minutes = await SharedPrefs().getTimeMinutes();
    var seconds = await SharedPrefs().getTimeSeconds();
    print('check value of time >>>> $minutes : $seconds');
    _radius = 1;
    _time = Duration(minutes: minutes ?? 0, seconds: seconds ?? 0);
    _fullTime = _time;
  }

  void startWork2()  {
    SharedPrefs().removeShared();
    _radius = 1;
    _time = Duration(minutes: 0, seconds: 0);
    _fullTime = _time;
  }

  void pinalite() async {
    int minutes = _time.inMinutes + 2;
    // t.inSeconds - (t.inMinutes * 60);
    int seconds = _time.inSeconds - (_time.inMinutes * 60);
    _time = Duration(minutes: minutes, seconds: seconds);
    _fullTime = _time;
  }

  void startBreak(bool isShort) {
    _radius = 1;
    _time = Duration(minutes: (isShort) ? shortBreak : longBreak, seconds: 0);
    _fullTime = _time;
  }
}
