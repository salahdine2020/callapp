import 'dart:convert';

import 'package:emall_app/EmallApp/api/api_util.dart';
import 'package:emall_app/EmallApp/controllers/AuthController.dart';
import 'package:emall_app/EmallApp/models/Filter.dart';
import 'package:emall_app/EmallApp/models/MyResponse.dart';
import 'package:emall_app/EmallApp/models/Product.dart';
import 'package:emall_app/EmallApp/utils/InternetUtils.dart';

import 'package:http/http.dart' as http;


class ProductController{

  //------------------------ Get all products -----------------------------------------//
  static Future<MyResponse<List<Product>>> getAllProduct() async {
    //Get Api Token
    String token = await AuthController.getApiToken();
    String url = ApiUtil.MAIN_API_URL + ApiUtil.PRODUCTS;
    Map<String, String> headers = ApiUtil.getHeader(
        requestType: RequestType.GetWithAuth, token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError<List<Product>>();
    }

    try {
      http.Response response = await http.get(url, headers: headers);
      MyResponse<List<Product>> myResponse = MyResponse(response.statusCode);
      if (response.statusCode == 200) {
        List<Product> list = Product.getListFromJson(
            json.decode(response.body));
        myResponse.success = true;
        myResponse.data = list;
      } else {
        myResponse.setError(json.decode(response.body));
      }

      return myResponse;
    }catch(e){
      //If any server error...
      return MyResponse.makeServerProblemError<List<Product>>();
    }
  }


  //------------------------ Get filtered product with shops -----------------------------------------//
  static Future<MyResponse<List<Product>>> getFilteredProduct(Filter filter) async {

    //Create some body data
    String subCategoryIds = "";
    if (filter.subCategories.length != 0) {
      subCategoryIds = "sub_category_ids=";
      for (int i = 0; i < filter.subCategories.length; i++) {
        subCategoryIds += filter.subCategories[i].toString();
        if (i < filter.subCategories.length - 1) {
          subCategoryIds += ",";
        }
      }
    }

    String name = "";
    if (filter.name.length != 0) {
      name = "name=" + filter.name;
    }

    String offer = "";
    if(filter.isInOffer){
      offer = "offer="+filter.isInOffer.toString();
    }

    //Getting User Api Token
    String token = await AuthController.getApiToken();
    String url = ApiUtil.MAIN_API_URL + ApiUtil.PRODUCTS + "?" + subCategoryIds +
        "&" + name + "&" + offer;
    Map<String, String> headers = ApiUtil.getHeader(
        requestType: RequestType.GetWithAuth, token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if(!isConnected){
      return MyResponse.makeInternetConnectionError<List<Product>>();
    }

    try {
      http.Response response = await http.get(url, headers: headers);
      MyResponse<List<Product>> myResponse = MyResponse(response.statusCode);
      if (response.statusCode == 200) {
        List<Product> list = Product.getListFromJson(json.decode(response.body));
        myResponse.success = true;
        myResponse.data = list;
      } else {
        myResponse.setError(json.decode(response.body));
      }
      return myResponse;
    }catch(e){
      //If any server error...
      return MyResponse.makeServerProblemError<List<Product>>();
    }
  }


  //------------------------ Get single product -----------------------------------------//
  static Future<MyResponse<Product>> getSingleProduct(int productId) async {

    //Getting User Api Token
    String token = await AuthController.getApiToken();
    String url = ApiUtil.MAIN_API_URL + ApiUtil.PRODUCTS + productId.toString();
    Map<String,String> headers = ApiUtil.getHeader(requestType: RequestType.GetWithAuth,token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if(!isConnected){
      return MyResponse.makeInternetConnectionError<Product>();
    }

    try {
      http.Response response = await http.get(url, headers: headers);
      MyResponse<Product> myResponse = MyResponse(response.statusCode);
      if (ApiUtil.isResponseSuccess(response.statusCode)) {
        Product product = Product.fromJson(json.decode(response.body));
        myResponse.success = true;
        myResponse.data = product;
      } else {
        myResponse.setError(json.decode(response.body));
      }

      return myResponse;
    }catch(e){
      //If any server error...
      return MyResponse.makeServerProblemError<Product>();
    }
  }


  static Future<MyResponse<Product>> getSingleProductReviews(int productId) async {

    //Getting User Api Token
    String token = await AuthController.getApiToken();
    String url = ApiUtil.MAIN_API_URL + ApiUtil.PRODUCTS + productId.toString() + "/" + ApiUtil.REVIEWS;
    Map<String,String> headers = ApiUtil.getHeader(requestType: RequestType.GetWithAuth,token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if(!isConnected){
      return MyResponse.makeInternetConnectionError<Product>();
    }

    try {
      http.Response response = await http.get(url, headers: headers);
      MyResponse<Product> myResponse = MyResponse(response.statusCode);
      if (ApiUtil.isResponseSuccess(response.statusCode)) {
        Product product = Product.fromJson(json.decode(response.body));
        myResponse.success = true;
        myResponse.data = product;
      } else {
        myResponse.setError(json.decode(response.body));
      }

      return myResponse;
    }catch(e){
      //If any server error...
      return MyResponse.makeServerProblemError<Product>();
    }
  }




}