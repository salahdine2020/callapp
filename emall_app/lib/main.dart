import 'package:emall_app/EmallApp/AppTheme.dart';
import 'package:emall_app/EmallApp/AppThemeNotifier.dart';
import 'package:emall_app/EmallApp/controllers/AppDataController.dart';
import 'package:emall_app/EmallApp/controllers/AuthController.dart';
import 'package:emall_app/EmallApp/models/AppData.dart';
import 'package:emall_app/EmallApp/models/MyResponse.dart';
import 'package:emall_app/EmallApp/services/AppLocalizations.dart';
import 'package:emall_app/EmallApp/services/PushNotificationsManager.dart';
import 'package:emall_app/EmallApp/utils/SizeConfig.dart';
import 'package:emall_app/EmallApp/views/AppScreen.dart';
import 'package:emall_app/EmallApp/views/MaintenanceScreen.dart';
import 'package:emall_app/EmallApp/views/auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  ///You will need to initialize AppThemeNotifier class for theme changes.
  /// you need the binding to be initialized before the runApp method call the ensureInitialized() method of the WidgetsFlutterBinding class.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// SystemChrome: set the screen orientation and extract information about which type of orientation is currently set.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    /// methode get lang from local shared preference by getLanguage();
    String langCode = await AllLanguage.getLanguage();

    /// load lang Equivalnt to your choice
    await Translator.load(langCode);
    runApp(
      /// get Theme Update from setting User by shared preferenc and ChangeNotifire
      ChangeNotifierProvider<AppThemeNotifier>(
        create: (context) => AppThemeNotifier(),
        /// inject from init() func in AppThemeNotifier() class
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// allows more widgets rebuilds (means Important Widget)
    /// solves most BuildContext misuse (worst use)
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getThemeFromThemeMode(
            /// updated for all app life cycle and save in value accpte int value to choice between light and dark mode
            /// to acces from change notify updated value from AppThemeNotifier
            value.themeMode(),
          ),
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ThemeData themeData;

  @override
  void initState() {
    super.initState();
    initFCM();
    getAppData();
  }

  getAppData() async {
    /// MyResponse: class to identify Errors causing when internet faild or server failde
    // print('TAKE CAUSE OF PROBLEM : ${myResponse.data.user}---------');
    MyResponse<AppData> myResponse = await AppDataController.getAppData();
    if (myResponse.data.user != null) {
      /// save actuale user in speciale shared preference field
      AuthController.saveUserFromUser(myResponse.data.user);
    }
    if (!myResponse.data.isAppUpdated()) {
      //print('TAKE CAUSE OF PROBLEM : ${myResponse.data.toString()}---------');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          /// make routing with base in authentication User and u can refrech to fixe issue if user null or server problems
          builder: (BuildContext context) => MaintenanceScreen(
            isNeedUpdate: true,
            someInformation: myResponse.data.toString(),
          ),
        ),
        (route) => false,
      );
      return;
    }
  }

  initFCM() async {
    PushNotificationsManager pushNotificationsManager = PushNotificationsManager();
    await pushNotificationsManager.init(context: context);
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    themeData = Theme.of(context);
    return FutureBuilder<bool>(
      /// isLoginUser() : with http Post set user Information login and return
      /// response object from class MyResponse();
      future: AuthController.isLoginUser(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return AppScreen();
          } else {
            return LoginScreen();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
