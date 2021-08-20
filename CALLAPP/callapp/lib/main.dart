import 'package:callapp/screen/intropage.dart';
import 'package:flutter/material.dart';
import 'package:callapp/constant/Constant.dart';
import 'package:callapp/screen/GridItemDetails.dart';
import 'package:callapp/screen/HomeScreen.dart';
import 'package:callapp/screen/SplashScreen.dart';

void main() => runApp(MaterialApp(
      title: 'GridView Demo',
      home: HomePage(),///SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Color(0xFF761322),
      ),
      routes: <String, WidgetBuilder>{
        SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
        HOME_SCREEN: (BuildContext context) => HomeScreen(),
        //GRID_ITEM_DETAILS_SCREEN: (BuildContext context) => GridItemDetails(),
      },
    ));
