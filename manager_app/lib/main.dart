import 'package:manager_app/services/AppLocalizations.dart';
import 'package:manager_app/services/PushNotificationsManager.dart';
import 'package:manager_app/utils/SizeConfig.dart';
import 'package:manager_app/views/AppScreen.dart';
import 'package:manager_app/views/MaintenanceScreen.dart';
import 'package:manager_app/views/auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'AppTheme.dart';
import 'AppThemeNotifier.dart';
import 'controllers/AppDataController.dart';
import 'controllers/AuthController.dart';
import 'models/AppData.dart';
import 'models/MyResponse.dart';

Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
    String langCode = await AllLanguage.getLanguage();
    await Translator.load(langCode);
    runApp(ChangeNotifierProvider<AppThemeNotifier>(
      create: (context) => AppThemeNotifier(),
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// using provider to get them if change intier of app
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
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
    getAppData();
    initFCM();
  }

  getAppData() async {
    /// get User if user authenticate
    MyResponse<AppData> myResponse = await AppDataController.getAppData(); ///
    print('****MyResponse in case of getAppData ${myResponse.toString()} ******');
    if (myResponse.data.manager != null) {
      AuthController.saveUserFromManager(myResponse.data.manager);
    }

    if (!myResponse.data.isAppUpdated()) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MaintenanceScreen(
            isNeedUpdate: true,
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
        future: AuthController.isLoginUser(),  /// return bool value if token != null >> true
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return AppScreen();
            } else {
              return LoginScreen();
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
