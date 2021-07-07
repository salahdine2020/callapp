
import 'package:manager_app/api/api_util.dart';
import 'package:manager_app/controllers/ShopRequestController.dart';
import 'package:manager_app/models/MyResponse.dart';
import 'package:manager_app/models/Shop.dart';
import 'package:manager_app/services/AppLocalizations.dart';
import 'package:manager_app/utils/ColorUtils.dart';
import 'package:manager_app/utils/Generator.dart';
import 'package:manager_app/utils/SizeConfig.dart';
import 'package:manager_app/views/auth/SettingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';
import '../LoadingScreens.dart';

class ShopRequestScreen extends StatefulWidget {
  @override
  _ShopRequestScreenState createState() => _ShopRequestScreenState();
}

class _ShopRequestScreenState extends State<ShopRequestScreen> {
  //ThemeData
  ThemeData themeData;
  CustomAppTheme customAppTheme;

  //Global Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //Other Variables
  bool isInProgress = false;
  bool requested;
  Shop shop;
  List<Shop> shops;



  @override
  void initState() {
    super.initState();
    _fetchShopRequests();
  }


  _fetchShopRequests() async {
    if (mounted) {
      setState(() {
        isInProgress = true;
      });
    }

    MyResponse<Map<String,dynamic>> myResponse = await ShopRequestController.getRequestedShop();

    if (myResponse.success) {
      requested = myResponse.data['requested'];
      if(requested){
        shop = myResponse.data['shop'];
      }else{
        shops = myResponse.data['shops'];
      }
    } else {
      ApiUtil.checkRedirectNavigation(context, myResponse.responseCode);
      showMessage(message: myResponse.errorText);
    }

    if (mounted) {
      setState(() {
        isInProgress = false;
      });
    }
  }

  _requestShop(int shopId) async {

    if (mounted) {
      setState(() {
        isInProgress = true;
      });
    }

    MyResponse<Map<String,dynamic>> myResponse = await ShopRequestController.requestShop(shopId);

    if (myResponse.success) {
     _refresh();
    } else {
      ApiUtil.checkRedirectNavigation(context, myResponse.responseCode);
      showMessage(message: myResponse.errorText);
    }

    if (mounted) {
      setState(() {
        isInProgress = false;
      });
    }
  }
  _deleteRequestShop() async {

    if (mounted) {
      setState(() {
        isInProgress = true;
      });
    }

    MyResponse<Map<String,dynamic>> myResponse = await ShopRequestController.deleteRequestShop();

    if (myResponse.success) {
     _refresh();
    } else {
      ApiUtil.checkRedirectNavigation(context, myResponse.responseCode);
      showMessage(message: myResponse.errorText);
    }

    if (mounted) {
      setState(() {
        isInProgress = false;
      });
    }
  }


  _refresh(){
    _fetchShopRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        int themeType = value.themeMode();
        themeData = AppTheme.getThemeFromThemeMode(themeType);
        customAppTheme = AppTheme.getCustomAppTheme(themeType);
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(themeType),
            home: Scaffold(
              key: _scaffoldKey,
              backgroundColor: customAppTheme.bgLayer2,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: customAppTheme.bgLayer2,
                title: Text(
                  Translator.translate("shop_request"),
                  style: AppTheme.getTextStyle(
                    themeData.textTheme.headline6,
                    color: themeData.colorScheme.onBackground,
                    fontWeight: 600,
                  ),
                ),
                centerTitle: true,
                actions: [
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SettingScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: Spacing.right(16),
                      child: Icon(MdiIcons.cogOutline,color: themeData.colorScheme.onBackground,),
                    ),
                  )
                ],
              ),
              body: Column(
                children: [
                  Container(
                    height: MySize.size3,
                    child: isInProgress
                        ? LinearProgressIndicator(
                            minHeight: MySize.size3,
                          )
                        : Container(
                            height: MySize.size3,
                          ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [_buildBody()],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  _buildBody() {
    if (isInProgress && requested == null) {
      return LoadingScreens.getOrderLoadingScreen(
          context, themeData, customAppTheme);
    } else {
      if (requested) {
        return Container(
          margin: Spacing.fromLTRB(16, 0, 16, 0),
          child: _singleShop(shop,true),
        );
      }else{
        List<Widget> list = [];
        for(Shop shop in shops)
          list.add(_singleShop(shop,false));

        return Container(
          margin: Spacing.fromLTRB(16, 0, 16, 0),

          child: Column(
            children: list,
          ),
        );
      }
    }
  }

  _singleShop(Shop shop,bool requested) {
    return Container(
      margin: Spacing.bottom(16),
      decoration: BoxDecoration(
        color: customAppTheme.bgLayer2,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: themeData.cardTheme.shadowColor.withAlpha(32),
            blurRadius: 6,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MySize.size16),
                  topRight: Radius.circular(MySize.size16)),
              child: Image.network(
                shop.imageUrl,
                width: MySize.safeWidth,
                fit: BoxFit.cover,
              )),
          Container(
            padding: Spacing.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Text(shop.name,
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.subtitle1,
                              fontWeight: 600)),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Generator.buildRatingStar(
                              rating: shop.rating,
                              activeColor: ColorUtils.getColorFromRating(
                                  shop.rating.ceil(),
                                  customAppTheme,
                                  themeData)),
                          Text(
                            "(" + shop.totalRating.toString() + ")",
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  margin: Spacing.top(8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  MdiIcons.mapMarkerOutline,
                                  color: themeData.colorScheme.onBackground,
                                  size: MySize.size14,
                                ),
                                Expanded(
                                  child: Container(
                                      margin: Spacing.left(8),
                                      child: Text(
                                        shop.address,
                                        style: AppTheme.getTextStyle(
                                            themeData.textTheme.caption,
                                            fontWeight: 500),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ),
                              ],
                            ),
                            Container(
                              margin: Spacing.top(4),
                              child: Row(
                                children: <Widget>[
                                  Icon(MdiIcons.phoneOutline,
                                      color: themeData.colorScheme.onBackground,
                                      size: 14),
                                  Container(
                                    margin: Spacing.left(8),
                                    child: Text(
                                      shop.mobile,
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.caption,
                                          color: themeData
                                              .colorScheme.onBackground),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      FlatButton(
                          padding: Spacing.horizontal(12),
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(MySize.size4)),
                          color: requested
                              ? customAppTheme.colorError.withAlpha(28)
                              : themeData.colorScheme.primary.withAlpha(28),
                          splashColor: requested
                              ? customAppTheme.colorError.withAlpha(100)
                              : themeData.colorScheme.primary.withAlpha(100),
                          highlightColor: requested
                              ? customAppTheme.colorError.withAlpha(28)
                              : themeData.colorScheme.primary.withAlpha(28),
                          onPressed: () {
                            if (requested){
                              _deleteRequestShop();
                            }else{
                              _requestShop(shop.id);
                            }
                          },
                          child: Text(
                            requested
                                ? Translator.translate("cancel").toUpperCase()
                                : Translator.translate("request").toUpperCase(),
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.caption,
                                fontWeight: 600,
                                color: requested
                                    ? customAppTheme.colorError
                                    : themeData.colorScheme.primary),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  void showMessage({String message = "Something wrong", Duration duration}) {
    if (duration == null) {
      duration = Duration(seconds: 3);
    }
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: duration,
        content: Text(message,
            style: AppTheme.getTextStyle(themeData.textTheme.subtitle2,
                letterSpacing: 0.4, color: themeData.colorScheme.onPrimary)),
        backgroundColor: themeData.colorScheme.primary,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
