import 'dart:convert';

import 'package:emall_app/EmallApp/api/api_util.dart';
import 'package:emall_app/EmallApp/models/AppData.dart';
import 'package:emall_app/EmallApp/models/MyResponse.dart';
import 'package:emall_app/EmallApp/utils/InternetUtils.dart';
import 'package:http/http.dart' as http;
import 'AuthController.dart';

class AppDataController {
  //-------------------- Add user address --------------------------------//
  static Future<MyResponse<AppData>> getAppData() async {
    //Get Api Token
    /// return Token from FCM and is returned succefly
    String token = await AuthController.getApiToken();
    //print('--------- CONFIRMATION TOKEN IF GET IT $token ----------------');
    if (token != null) {
      //Get Api Token
      String url = ApiUtil.MAIN_API_URL + ApiUtil.APP_DATA + ApiUtil.USER;
      //String url = 'http://emall.coderthemes.com/user';
      Map<String, String> headers = ApiUtil.getHeader(
        requestType: RequestType.GetWithAuth,
        token: token,
      );
      print('--------- get url : $url ----------------');
     // print('--------- get headers : $headers ----------------');
     //Check Internet
      bool isConnected = await InternetUtils.checkConnection();
      if (!isConnected) {
        return MyResponse.makeInternetConnectionError<AppData>();
      }
      /// I think here is the cause of the main problem
      try {
        http.Response response = await http.get(url, headers: headers);
        print('--------- get response.body outside : ${response.body} ----------------');
        MyResponse<AppData> myResponse = MyResponse(response.statusCode);
        if (response.statusCode == 200) {
          myResponse.success = true;
          myResponse.data = AppData.fromJson(
            json.decode(
              response.body,
            ),
          );
          print('--------- get response.body Inside : ${response.body} ----------------');
        }
        else {
          Map<String, dynamic> data = json.decode(response.body);
          print('--------- get data Inside : $data ----------------');
          myResponse.success = false;
          myResponse.setError(data);
        }
        return myResponse;
      } catch (e) {
        //If any server error...
        print('--------- inside catch errors $e ----------------');
        /// problem in http connection insecure note allowed.
        /// Specific IP addresses are not accepted as input.
        ///  If you would like to allow IP addresses, the only option is to allow cleartext connections in your app.
        return MyResponse.makeServerProblemError<AppData>();
      }
    } else {
      /// GET Information Without Token
      String url = ApiUtil.MAIN_API_URL + ApiUtil.APP_DATA;
      Map<String, String> headers = ApiUtil.getHeader(requestType: RequestType.Get);

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
