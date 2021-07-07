import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:prayer_production/controller/api_provider.dart';
import 'package:prayer_production/models/download_user_inf.dart';
import 'package:prayer_production/utils/constants.dart';
import 'package:prayer_production/views/signup.dart';
import 'package:prayer_production/widgets/bottom_scheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/profile_list_item.dart';

class ProfileScreen extends StatelessWidget {
  Future<String> getSaveID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var ID = sharedPreferences.getString('id');
    print('------ID: $ID--------');
    return ID;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);

    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: kSpacingUnit.w * 10,
            width: kSpacingUnit.w * 10,
            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: kSpacingUnit.w * 5,

                  /// men by default and change with sex after download User Information
                  backgroundImage: AssetImage('assets/images/men_avatar.png'),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: kSpacingUnit.w * 2.5,
                    width: kSpacingUnit.w * 2.5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: kSpacingUnit.w * 1.5,
                      widthFactor: kSpacingUnit.w * 1.5,
                      child: Icon(
                        LineAwesomeIcons.pen,
                        color: kDarkPrimaryColor,
                        size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          FutureBuilder<DownloadUsermModel>(
            /// GET WHEN USER ADD FROM SHARED
            future: PrayerProvider().PostToDownloadUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong ${snapshot.error}-------');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Text(
                snapshot.data.nom.toString() +
                    ' ' +
                    snapshot.data.prenom.toString(), //'Nicolas Adams',
                style: kTitleTextStyle,
              );
            },
          ),
//          Text(
//            'Nicolas Adams',
//            style: kTitleTextStyle,
//          ),
//          SizedBox(height: kSpacingUnit.w * 0.5),
//          Text(
//            'nicolasadams@gmail.com',
//            style: kCaptionTextStyle,
//          ),
          SizedBox(height: kSpacingUnit.w * 2),
//          Container(
//            height: kSpacingUnit.w * 4,
//            width: kSpacingUnit.w * 20,
//            decoration: BoxDecoration(
//              borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
//              color: Theme.of(context).accentColor,
//            ),
//            child: Center(
//              child: Text(
//                'Update',
//                style: kButtonTextStyle,
//              ),
//            ),
//          ),
        ],
      ),
    );

    var themeSwitcher = ThemeSwitcher(
      builder: (context) {
        return AnimatedCrossFade(
          duration: Duration(milliseconds: 200),
          crossFadeState:
              ThemeProvider.of(context).brightness == Brightness.dark
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
          firstChild: GestureDetector(
            onTap: () =>
                ThemeSwitcher.of(context).changeTheme(theme: kLightTheme),
            child: Icon(
              LineAwesomeIcons.sun,
              size: ScreenUtil().setSp(kSpacingUnit.w * 3),
            ),
          ),
          secondChild: GestureDetector(
            onTap: () =>
                ThemeSwitcher.of(context).changeTheme(theme: kDarkTheme),
            child: Icon(
              LineAwesomeIcons.moon,
              size: ScreenUtil().setSp(kSpacingUnit.w * 3),
            ),
          ),
        );
      },
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: kSpacingUnit.w * 3),
        GestureDetector(
          child: Icon(
            Icons.notifications_active,
            size: ScreenUtil().setSp(kSpacingUnit.w * 3),
          ),
          onTap: () async {
            String id = await getSaveID();
            await PrayerProvider().PostToDownloadUser(); //id Example // id: getSaveID ?? '72'
          },
        ),
        profileInfo,
        themeSwitcher,
        SizedBox(width: kSpacingUnit.w * 3),
      ],
    );

    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                SizedBox(height: kSpacingUnit.w * 5),
                header,
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      FutureBuilder<DownloadUsermModel>(
                        /// GET WHEN USER ADD FROM SHARED
                        future: PrayerProvider()
                            .PostToDownloadUser(), //id: getSaveID ?? '72'
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
//                              ProfileListItem(
//                                icon: LineAwesomeIcons.codepen,
//                                text: 'Postal : ${snapshot.data.codePostal}',
//                              ),
//                              ProfileListItem(
//                                icon: LineAwesomeIcons.phone,
//                                text: 'Telephone : ${snapshot.data.numTelephone}',
//                              ),
                                ProfileListItem(
                                  icon: LineAwesomeIcons.info,
                                  text: 'About Us',
                                ),
                                ProfileListItem(
                                  icon: LineAwesomeIcons.question_circle,
                                  text: 'Help & Support',
                                ),
                                ProfileListItem(
                                  icon: LineAwesomeIcons.qrcode,
                                  text: 'QR Code',
                                ),
                                DialogExample(
                                  nom: snapshot.data.nom.toString(),
                                  prenom: snapshot.data.prenom.toString(),
                                  code_postal: snapshot.data.codePostal.toString(),
                                  num_telephone: snapshot.data.numTelephone.toString(),
                                  id: snapshot.data.id,
                                  status_widget: 'update',
                                ),
//                                    await PrayerProvider().PostToUpdateUser(
//                                      nom: 'KHALED 1',//snapshot.data.nom,
//                                      prenom: snapshot.data.prenom,
//                                      code_postal: snapshot.data.codePostal,
//                                      flag_sexe: snapshot.data.sexe,
//                                      num_telephone: snapshot.data.numTelephone,
//                                      id: snapshot.data.id,
//                                    );
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
