import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as D;
import 'package:emall_app/EmallApp/api/api_util.dart';
import 'package:emall_app/EmallApp/models/Account.dart';
import 'package:emall_app/EmallApp/models/MyResponse.dart';
import 'package:emall_app/EmallApp/models/User.dart';
import 'package:emall_app/EmallApp/services/PushNotificationsManager.dart';
import 'package:emall_app/EmallApp/utils/InternetUtils.dart';
import 'package:emall_app/EmallApp/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert ;
import 'package:http/http.dart' as http;

import '../AppTheme.dart';

class AuthController {
  //--------------------- Log In ---------------------------------------------//
  static Future<MyResponse> loginUser(String email, String password) async {
    //Get FCM
    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager.instance;
    if (pushNotificationsManager == null) {
      pushNotificationsManager = PushNotificationsManager();
      pushNotificationsManager.init();
    }
    await pushNotificationsManager.init();
    String fcmToken = await pushNotificationsManager.getToken();

    //URL
    String loginUrl = ApiUtil.MAIN_API_URL + ApiUtil.AUTH_LOGIN;
    //String loginUrl = ApiUtil.MAIN_API_URL + 'app_data';
    print('---------- Url Login for : $loginUrl ----------');
    print('---------- Token : $email ----------');
    print('---------- Token : $password ----------');
    print('---------- Token : $fcmToken ----------');
    //Body Data
    Map data = {
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
    };
    //Encode
    /// var pdfText = await json.decode(json.encode(response.databody);
    var body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }
    //Response
    try {
//      D.Dio _dio;
//      D.BaseOptions options = D.BaseOptions(
//          //baseUrl: _endpoint3,
//          //receiveTimeout: 5000,
//          //connectTimeout: 5000,
//          );
//      _dio = D.Dio(options);
//      //_dio.interceptors.add(LoggingInterceptor());
//      _dio.options.contentType = D.Headers.formUrlEncodedContentType;
//      D.Response response = await _dio.post(loginUrl,
//          data: body,
//          options: D.Options(
//            followRedirects: true,
//            contentType: D.Headers.formUrlEncodedContentType,
////            validateStatus: (status) {
////              return status < 500;
////            },
//          ), onSendProgress: (int sent, int total) {
//        print('sent : $sent // total : $total');
//      }, onReceiveProgress: (v, s) {
//        print('v : $v // s : $s');
//      });

//      Response response = await http.post(
//        loginUrl,
//        headers: ApiUtil.getHeader(
//          //requestType: RequestType.Post,
//          requestType: RequestType.Post,
//        ),
//        body: body,
//      );
      Response response = await http.post(
        loginUrl,
        headers: ApiUtil.getHeader(
          //requestType: RequestType.Post,
          requestType: RequestType.Post,
        ),
        body: body,
      );
      // var res = http.Response.fromStream(response);
      MyResponse myResponse = MyResponse(response.statusCode);
      if (response.statusCode == 200) {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        //print('------- Response Body :${response.body} type of body ${response.body.runtimeType} ----------------');
        Map<String, dynamic> data = json.decode(response.body); //response.body
        //print('------- Response Body To Data :$data ----------------');
        Map<String, dynamic> user = data['user'];
        String token = data['token'];
        //print('------- get Token from LoginUser :$token ----------------');
        /// save in shared preference extrait from Map object
        print('------- HEADERS RESPONSE :${response.headers} ----------------');
        await saveUser(user);
        await sharedPreferences.setString('token', token);
        myResponse.success = true;
        print('---------- success: true ----------');
      }
      else {
        Map<String, dynamic> data = json.decode(response.body); // response.body
        myResponse.success = false;
        myResponse.setError(data);
        print('----------  Status Code else: ${response.statusCode} ----------');
        print('----------  RESPONSE BODY else: ${response.body} ----------');
        print('----------  HEADERS RESPONSE else: ${response.headers} ----------');
      }
      return myResponse;
    } catch (e) {
      Response response = await http.post(
        loginUrl,
        headers: ApiUtil.getHeader(
          //requestType: RequestType.Post,
          requestType: RequestType.Post,
        ),
         body: body,
      );
      //Map<String, dynamic> data = json.decode(response.headers);
      print('---------- Headers content file : ${response.headers} ----------');
      print('---------- Body content file : ${response.body} ----------');
      print('---------- Errors occurd when login : ${e.toString()} ----------');
      print('---------- hedears file ${HttpStatus.requestHeaderFieldsTooLarge} ----------');
      return MyResponse.makeServerProblemError();
    }
  }

  //--------------------- Register  ---------------------------------------------//
  static Future<MyResponse> registerUser(String name, String email, String password) async {
    //Add FCM Token
    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager();
    await pushNotificationsManager.init();
    String fcmToken = await pushNotificationsManager.getToken();

    //URL
    String registerUrl = ApiUtil.MAIN_API_URL + ApiUtil.AUTH_REGISTER;

    //Body
    Map data = {
      'name': name,
      'email': email,
      'password': password,
      'fcm_token': fcmToken
    };

    //Encode
    String body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    //Response
    try {
      Response response = await http.post(
        registerUrl,
        headers: ApiUtil.getHeader(requestType: RequestType.Post),
        body: body,
      );
      MyResponse myResponse = MyResponse(response.statusCode);

      if (response.statusCode == 200) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        Map<String, dynamic> data = json.decode(response.body);
        Map<String, dynamic> user = data['user'];
        String token = data['token'];

        await sharedPreferences.setString('name', user['name']);
        await sharedPreferences.setString('email', user['email']);
        await sharedPreferences.setString('avatar_url', user['avatar_url']);
        await sharedPreferences.setString('token', token);

        myResponse.success = true;
      } else {
        Map<String, dynamic> data = json.decode(response.body);
        myResponse.success = false;
        myResponse.setError(data);
      }

      return myResponse;
    } catch (e) {
      //If any server error...
      return MyResponse.makeServerProblemError();
    }
  }

  //--------------------- Forgot Password ---------------------------------------------//
  static Future<MyResponse> forgotPassword(String email) async {
    String url = ApiUtil.MAIN_API_URL + ApiUtil.FORGOT_PASSWORD;

    //Body date
    Map data = {'email': email};

    //Encode
    String body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {
      Response response = await http.post(
        url,
        headers: ApiUtil.getHeader(requestType: RequestType.Post),
        body: body,
      );

      MyResponse myResponse = MyResponse(response.statusCode);

      if (response.statusCode == 200) {
        myResponse.success = true;
      } else {
        Map<String, dynamic> data = json.decode(response.body);
        myResponse.success = false;
        myResponse.setError(data);
      }
      return myResponse;
    } catch (e) {
      return MyResponse.makeServerProblemError();
    }
  }

  //---------------------- Update user ------------------------------------------//
  static Future<MyResponse> updateUser(String password, File imageFile) async {
    //Get Token
    String token = await AuthController.getApiToken();
    String registerUrl = ApiUtil.MAIN_API_URL + ApiUtil.UPDATE_PROFILE;
    String image_url;

    Map data = {};
    print('------TOKEN : $token------');
    if (password.isNotEmpty) data['password'] = password;
    if (imageFile != null) {
      final bytes = imageFile.readAsBytesSync();
      String img64 = base64Encode(bytes);
      data['avatar_image'] = img64;
    }
    //print('------$data------');
    //Encode
    String body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {
      Response response = await http.post(
        registerUrl,
        headers: ApiUtil.getHeader(
          requestType: RequestType.PostWithAuth, //RequestType.PostWithAuth,
          token: token,
        ),
        body: body,
      );

      MyResponse myResponse = MyResponse(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await saveUser(data['user']);
        myResponse.success = true;
        print('------DATA IN RESPONSE statuscode == 200: $data------');
      } else {
        Map<String, dynamic> data = json.decode(response.body);
        myResponse.success = false;
        myResponse.setError(data);
        print(
            '------DATA IN RESPONSE else 200 : ${response.statusCode} and data : $data------');
      }
      return myResponse;
    } catch (e) {
      print('------TELL ME PLEAS WHAT IS WRONG !!: $e------');
      return MyResponse.makeServerProblemError();
    }
  }

  //------------------------ Logout -----------------------------------------//
  static Future<bool> logoutUser() async {
    //Remove FCM Token
    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager();
    await pushNotificationsManager.removeFCM();

    //Clear all Data
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.remove('name');
    await sharedPreferences.remove('email');
    await sharedPreferences.remove('avatar_url');
    await sharedPreferences.remove('token');

    return true;
  }

  //------------------------ Save user in cache -----------------------------------------//
  static saveUser(Map<String, dynamic> user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('name', user['name']);
    await sharedPreferences.setString('email', user['email']);
    await sharedPreferences.setString('avatar_url', user['avatar_url']);
  }

  static saveUserFromUser(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('name', user.name);
    await sharedPreferences.setString('email', user.email);
    await sharedPreferences.setString('avatar_url', user.avatarUrl);
  }

  //------------------------ Get user from cache -----------------------------------------//
  static Future<Account> getAccount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String name = sharedPreferences.getString('name');
    String email = sharedPreferences.getString('email');
    String token = sharedPreferences.getString('token');
    String avatarUrl = sharedPreferences.getString('avatar_url');

    return Account(name, email, token, avatarUrl);
  }

  //------------------------ Check user logged in or not -----------------------------------------//
  static Future<bool> isLoginUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    if (token == null) {
      return false;
    }
    return true;
  }

  //------------------------ Get api token -----------------------------------------//
  static Future<String> getApiToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //print('---------------- GET API TOKEN : ${sharedPreferences.getString("token")}---------------');
    //String default_token = 'dvc9bXc4QzeVPB1USffQXo:APA91bFOJZj4roHCUh2E5-8y_kLtxirwpzOKOBq7JXrHo-p7HnBt3zjkTMVe9xZ40mjWycu_0OzuVQYt04mDCvil1yPdjqNGn8Z3T6bupfIQrY2NJjD_AXNWs5RrApHt6nprbihz7jXG';
    String token = sharedPreferences.getString("token");
    return token;
  }

  //------------------------ Testing notice -------------------------------------//

  static Widget notice(ThemeData themeData) {
    return Container(
      margin: Spacing.fromLTRB(24, 36, 24, 24),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: "Note: ",
            style: AppTheme.getTextStyle(
              themeData.textTheme.subtitle2,
              color: themeData.colorScheme.primary,
              fontWeight: 600,
            ),
          ),
          TextSpan(
            text:
                "After testing please logout, because there is many user testing with same IDs so it can be possible that you can get unnecessary notifications",
            style: AppTheme.getTextStyle(
              themeData.textTheme.bodyText2,
              color: themeData.colorScheme.onBackground,
              fontWeight: 500,
              letterSpacing: 0,
            ),
          ),
        ]),
      ),
    );
  }
}
