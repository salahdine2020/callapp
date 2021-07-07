import 'dart:convert';
import 'package:emall_app/EmallApp/api/api_util.dart';
import 'package:emall_app/EmallApp/models/MyResponse.dart';
import 'package:emall_app/EmallApp/models/Shop.dart';
import 'package:emall_app/EmallApp/utils/InternetUtils.dart';
import 'package:http/http.dart' as http;
import 'AuthController.dart';

class ShopController {
  //------------------------ Get single shop -----------------------------------------//
  static Future<MyResponse<Shop>> getSingleShop(int shopId) async {
    //Getting User Api Token
    String token = await AuthController.getApiToken();
    String url = ApiUtil.MAIN_API_URL + ApiUtil.SHOPS + shopId.toString();
    Map<String, String> headers =
        ApiUtil.getHeader(requestType: RequestType.GetWithAuth, token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError<Shop>();
    }

    try {
      http.Response response = await http.get(url, headers: headers);
      MyResponse<Shop> myResponse = MyResponse(response.statusCode);
      if (ApiUtil.isResponseSuccess(response.statusCode)) {
        myResponse.success = true;
        myResponse.data = Shop.fromJson(json.decode(response.body));
      } else {
        myResponse.success = false;
        myResponse.setError(json.decode(response.body));
      }
      return myResponse;
    } catch (e) {
      //If any server error...
      return MyResponse.makeServerProblemError<Shop>();
    }
  }

  //------------------------ Get all shop -----------------------------------------//
  static Future<MyResponse<List<Shop>>> getAllShop() async {
    /// Shop is model class contain the store information
    //Getting User Api Token
    /// get Token form shop owner ?? maybe !!
    String token = await AuthController.getApiToken();
    String url = ApiUtil.MAIN_API_URL + ApiUtil.SHOPS;
    Map<String, String> headers =
        ApiUtil.getHeader(requestType: RequestType.GetWithAuth, token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError<List<Shop>>();
    }

    try {
      http.Response response = await http.get(url, headers: headers);
      MyResponse<List<Shop>> myResponse = MyResponse(response.statusCode);

      /// check if isResponseSuccess() status code == 200
      if (ApiUtil.isResponseSuccess(response.statusCode)) {
        // check if true
        myResponse.success = true;
        myResponse.data = Shop.getListFromJson(
          json.decode(
            response.body, /// list of dynamic values
          ),
        );
        /// when finiched return list contain Information from shop or store
      } else {
        myResponse.success = false;
        myResponse.setError(
          json.decode(
            response.body,
          ),
        );
      }
      return myResponse;
    } catch (e) {
      //If any server error...
      return MyResponse.makeServerProblemError<List<Shop>>();
    }
  }
}
