import 'dart:convert';

import 'package:admin_super/api/api_util.dart';
import 'package:admin_super/models/MyResponse.dart';
import 'package:admin_super/utils/InternetUtils.dart';
import 'package:http/http.dart' as http;
import 'package:admin_super/models/AppData.dart';

import 'AuthController.dart';

class AppDataController {

  //-------------------- Add user address --------------------------------//
  static Future<MyResponse<AppData>> getAppData() async {
    //Get Api Token
    String token = await AuthController.getApiToken();
    if (token!=null) {
      //Get Api Token
      String url = ApiUtil.MAIN_API_URL + ApiUtil.APP_DATA + ApiUtil.MANAGER;
      print('**** ApiUtil.MAIN_API_URL ${ApiUtil.MAIN_API_URL} ******');
      print('**** Url of App data Complet ${url.toString()} ******');
      Map<String, String> headers = ApiUtil.getHeader(requestType: RequestType.GetWithAuth,token: token);
      //Check Internet
      bool isConnected = await InternetUtils.checkConnection();
      if (!isConnected) {
        return MyResponse.makeInternetConnectionError<AppData>();
      }
      try {
        http.Response response = await http.get(url, headers: headers);
        MyResponse<AppData> myResponse = MyResponse(response.statusCode);
        if (response.statusCode == 200) {
          myResponse.success = true;
          myResponse.data = AppData.fromJson(json.decode(response.body));
        } else {
          Map<String, dynamic> data = json.decode(response.body);
          myResponse.success = false;
          myResponse.setError(data);
        }
        return myResponse;
      } catch (e) {
        //If any server error...
        return MyResponse.makeServerProblemError<AppData>();
      }
    }
    else {
      String url = ApiUtil.MAIN_API_URL + ApiUtil.APP_DATA ;
      Map<String, String> headers =
      ApiUtil.getHeader(requestType: RequestType.Get);
      //Check Internet
      bool isConnected = await InternetUtils.checkConnection();
      if (!isConnected) {
        return MyResponse.makeInternetConnectionError<AppData>();
      }
      try {
        http.Response response = await http.get(url, headers: headers);
        MyResponse<AppData> myResponse = MyResponse(response.statusCode);
        if (response.statusCode == 200) {
          myResponse.success = true;
          myResponse.data = AppData.fromJson(json.decode(response.body));
        } else {
          Map<String, dynamic> data = json.decode(response.body);
          myResponse.success = false;
          myResponse.setError(data);
        }
        return myResponse;
      } catch (e) {
        //If any server error...
        return MyResponse.makeServerProblemError<AppData>();
      }
    }
  }

}
