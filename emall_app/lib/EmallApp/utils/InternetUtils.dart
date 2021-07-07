import 'package:connectivity/connectivity.dart';

class InternetUtils{

  static Future<bool> checkConnection() async{
    /// Instead listen for connectivity changes via [onConnectivityChanged] stream.
    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}