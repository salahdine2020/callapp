import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:prayer_production/repository/shared_base.dart';
import 'package:prayer_production/utils/constants.dart';
import 'package:prayer_production/views/accueil.dart';
import 'package:prayer_production/views/signup.dart';
import 'package:prayer_production/views/walkthrough.dart';
import 'package:prayer_production/widgets/bottom_bar_widgets.dart';
import 'package:prayer_production/widgets/search_mosque.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  Future<bool> showSeen() async{
    var result = await RepositeryShared().getSeenScreen();
    print('----- Seen result $result --------');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    //print('----- Seen result of methode ${showSeen()} --------');
    return ThemeProvider(
      initTheme: kDarkTheme,
      child: Builder(
          builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Prayer_App',
          theme: ThemeProvider.of(context),
          home: FutureBuilder<bool>(
            future: showSeen(),
            builder: (context, snapshot){
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(),);
              }
              return (snapshot.data == false || snapshot.data == null) ? MyHomePage(title: 'Flutter Demo Home Page') :  HomeMainBottomBar();
            },
          ),
          ///showSeen() ? HomeMainBottomBar() : MyHomePage(title: 'Flutter Demo Home Page'),
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 6,
      navigateAfterSeconds: OnBoardingPage(),
      /// HomeMainBottomBar(),
      /// AppBarSearchExample(),
      /// SignupPage(),
      /// AppBarSearchExample(),
      /// AccueilPage(),
      /// OnBoardingPage(),
      photoSize: 180,
      image: Image.asset('assets/images/prayer_mosque_logo.png'),
      backgroundColor: Colors.white,
      loaderColor: Colors.greenAccent,
    );
  }
}
