import 'dart:math';

import 'package:intl/intl.dart';

class Services {
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890#';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),

      );
  getTime(){
    var now = DateTime.now();
    print(DateFormat('yyyy-MM-dd hh:mm:ss').format(now)); /// need in : date_heure
    print(DateFormat('yyyy-MM-dd').format(now));
  }
}
