import 'package:manager_app/api/api_util.dart';
import 'package:manager_app/api/currency_api.dart';
import 'package:manager_app/controllers/ManagerController.dart';
import 'package:manager_app/models/MyResponse.dart';
import 'package:manager_app/services/AppLocalizations.dart';
import 'package:manager_app/utils/SizeConfig.dart';
import 'package:manager_app/views/chart/OrderChart.dart';
import 'package:manager_app/views/chart/RevenueChart.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../AppTheme.dart';
import '../AppThemeNotifier.dart';
import 'LoadingScreens.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //Theme Data
  ThemeData themeData;
  CustomAppTheme customAppTheme;

  //Global Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  //Other Variables
  bool isInProgress = false;

  //Variables
  int productsCount, ordersCount, totalWeeklyProducts, totalWeeklyOrders;
  List productsCountData, ordersCountData, revenueCountData;
  double revenue, totalWeeklyRevenue;

  //Chart data
  List<OrderData> orderData = [];
  List<RevenueData> revenueData = [];

  Map<String, dynamic> data;

  /// injection data into myResponse object and into OrderData & RevnueData
  _getData() async {
    if (mounted) {
      setState(() {
        isInProgress = true;
      });
    }

    MyResponse myResponse = await ManagerController.getDashboardData();

    if (myResponse.success) {
      /// this data get it is contain all information you need as a manager
      data = myResponse.data;

      /// injection data into MyResponse class.
      productsCount = int.parse(data['products_count'].toString());
      ordersCount = int.parse(data['orders_count'].toString());
      totalWeeklyProducts = int.parse(data['total_weekly_products'].toString());
      totalWeeklyOrders = int.parse(data['total_weekly_orders'].toString());
      revenue = double.parse(data['revenue'].toString());
      totalWeeklyRevenue =
          double.parse(data['total_weekly_revenue'].toString());
      productsCountData = data['products_count_data'];
      ordersCountData = data['orders_count_data'];
      revenueCountData = data['revenue_count_data'];

      for (int i = 0; i < 7; i++) {
        orderData.add(
          OrderData(
            ordersCountData[i],

            /// subtract using to work with local time
            /// kep the same time and decrease days for evry i change it
            DateTime.now().subtract(
              Duration(
                days: 6 - i,
              ),
            ),
          ),
        );
      }

      for (int i = 0; i < 7; i++) {
        revenueData.add(
          RevenueData(
            double.parse(
              revenueCountData[i].toString(),
            ),
            DateTime.now().subtract(
              Duration(days: 6 - i),
            ),
          ),
        );
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

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refresh() async {
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        themeData = AppTheme.getThemeFromThemeMode(value.themeMode());
        customAppTheme = AppTheme.getCustomAppTheme(value.themeMode());
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
          home: Scaffold(
            key: _scaffoldKey,
            backgroundColor: customAppTheme.bgLayer2,
            body: RefreshIndicator(
              onRefresh: _refresh,
              backgroundColor: customAppTheme.bgLayer1,
              color: themeData.colorScheme.primary,
              key: _refreshIndicatorKey,
              child: ListView(
                padding: Spacing.fromLTRB(16, 40, 16, 16),
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
                  buildBody(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// presentation layer of DATA :

  buildBody() {
    if (data != null) {
      ///
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: Spacing.fromLTRB(16, 6, 16, 6),
            decoration: BoxDecoration(
              color: customAppTheme.bgLayer3,
              borderRadius: BorderRadius.circular(MySize.size4),
            ),
            child: Text(
              Translator.translate("total").toUpperCase(),
              style: AppTheme.getTextStyle(
                themeData.textTheme.caption,
                fontSize: 12,
                color: themeData.colorScheme.onBackground,
                fontWeight: 700,
                muted: true,
              ),
            ),
          ),
          SizedBox(
            height: MySize.size16,
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: Spacing.all(16),
                    decoration: BoxDecoration(
                      color: customAppTheme.bgLayer1,
                      border:
                          Border.all(color: customAppTheme.bgLayer4, width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(MySize.size8),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: Spacing.all(16),
                          decoration: BoxDecoration(
                            color: themeData.colorScheme.primary.withAlpha(40),
                            borderRadius: BorderRadius.all(
                              Radius.circular(MySize.size4),
                            ),
                          ),
                          child: Icon(
                            MdiIcons.walletOutline,
                            color: themeData.colorScheme.primary,
                          ),
                        ),
                        Container(
                          margin: Spacing.top(8),
                          child: Text(
                            CurrencyApi.getSign() + revenue.toString(),
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText2,
                                fontWeight: 700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: Spacing.top(2),
                          child: Text(
                            Translator.translate("revenues"),
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText2,
                                fontWeight: 500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MySize.size24,
                ),
                Expanded(
                  child: Container(
                    padding: Spacing.all(16),
                    decoration: BoxDecoration(
                      color: customAppTheme.bgLayer1,
                      border:
                          Border.all(color: customAppTheme.bgLayer4, width: 1),
                      borderRadius:
                          BorderRadius.all(Radius.circular(MySize.size8)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: Spacing.all(16),
                          decoration: BoxDecoration(
                            color: themeData.colorScheme.primary.withAlpha(40),
                            borderRadius:
                                BorderRadius.all(Radius.circular(MySize.size4)),
                          ),
                          child: Icon(
                            MdiIcons.shoppingOutline,
                            color: themeData.colorScheme.primary,
                          ),
                        ),
                        Container(
                          margin: Spacing.top(8),
                          child: Text(
                            ordersCount.toString(),
                            style: AppTheme.getTextStyle(
                              themeData.textTheme.bodyText2,
                              fontWeight: 700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: Spacing.top(2),
                          child: Text(
                            Translator.translate("orders"),
                            style: AppTheme.getTextStyle(
                              themeData.textTheme.bodyText2,
                              fontWeight: 500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MySize.size16,
          ),
          Container(
            padding: Spacing.fromLTRB(16, 6, 16, 6),
            decoration: BoxDecoration(
                color: customAppTheme.bgLayer3,
                borderRadius: BorderRadius.circular(MySize.size4)),
            child: Text(
              Translator.translate("this_week").toUpperCase(),
              style: AppTheme.getTextStyle(
                themeData.textTheme.caption,
                fontSize: 12,
                color: themeData.colorScheme.onBackground,
                fontWeight: 700,
                muted: true,
              ),
            ),
          ),
          SizedBox(
            height: MySize.size16,
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: Spacing.all(16),
                    decoration: BoxDecoration(
                      color: customAppTheme.bgLayer1,
                      border:
                          Border.all(color: customAppTheme.bgLayer4, width: 1),
                      borderRadius:
                          BorderRadius.all(Radius.circular(MySize.size8)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: Spacing.all(16),
                          decoration: BoxDecoration(
                            color: themeData.colorScheme.primary.withAlpha(40),
                            borderRadius:
                                BorderRadius.all(Radius.circular(MySize.size4)),
                          ),
                          child: Icon(
                            MdiIcons.walletOutline,
                            color: themeData.colorScheme.primary,
                          ),
                        ),
                        Container(
                            margin: Spacing.top(8),
                            child: Text(
                              CurrencyApi.getSign() + revenue.toString(),
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.bodyText2,
                                  fontWeight: 700),
                              textAlign: TextAlign.center,
                            )),
                        Container(
                          margin: Spacing.top(2),
                          child: Text(
                            Translator.translate("revenues"),
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText2,
                                fontWeight: 500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MySize.size24,
                ),
                Expanded(
                  child: Container(
                    padding: Spacing.all(16),
                    decoration: BoxDecoration(
                      color: customAppTheme.bgLayer1,
                      border:
                          Border.all(color: customAppTheme.bgLayer4, width: 1),
                      borderRadius:
                          BorderRadius.all(Radius.circular(MySize.size8)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: Spacing.all(16),
                          decoration: BoxDecoration(
                            color: themeData.colorScheme.primary.withAlpha(40),
                            borderRadius:
                                BorderRadius.all(Radius.circular(MySize.size4)),
                          ),
                          child: Icon(
                            MdiIcons.shoppingOutline,
                            color: themeData.colorScheme.primary,
                          ),
                        ),
                        Container(
                            margin: Spacing.top(8),
                            child: Text(
                              ordersCount.toString(),
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.bodyText2,
                                  fontWeight: 700),
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            margin: Spacing.top(2),
                            child: Text(
                              Translator.translate("orders"),
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.bodyText2,
                                  fontWeight: 500),
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MySize.size16,
          ),
          Container(
            padding: Spacing.fromLTRB(16, 6, 16, 6),
            decoration: BoxDecoration(
                color: customAppTheme.bgLayer3,
                borderRadius: BorderRadius.circular(MySize.size4)),
            child: Text(
              Translator.translate("weekly_revenue").toUpperCase(),
              style: AppTheme.getTextStyle(themeData.textTheme.caption,
                  fontSize: 12,
                  color: themeData.colorScheme.onBackground,
                  fontWeight: 700,
                  muted: true),
            ),
          ),
          Container(
              height: MySize.getScaledSizeWidth(250),
              child: RevenueChart(
                revenueData,
                themeData,
                animate: true,
              )),
          SizedBox(
            height: MySize.size16,
          ),
          Container(
            padding: Spacing.fromLTRB(16, 6, 16, 6),
            decoration: BoxDecoration(
                color: customAppTheme.bgLayer3,
                borderRadius: BorderRadius.circular(MySize.size4)),
            child: Text(
              Translator.translate("weekly_orders").toUpperCase(),
              style: AppTheme.getTextStyle(themeData.textTheme.caption,
                  fontSize: 12,
                  color: themeData.colorScheme.onBackground,
                  fontWeight: 700,
                  muted: true),
            ),
          ),
          Container(
              height: MySize.getScaledSizeWidth(250),
              child: OrderChart(
                orderData,
                themeData,
                animate: true,
              )),
        ],
      );
    } else if (isInProgress) {
      return LoadingScreens.getProductLoadingScreen(
          context, themeData, customAppTheme);
    } else {
      return Center(
        child: Text("Something wrong"),
      );
    }
  }

  void showMessage({String message = "Something wrong", Duration duration}) {
    if (duration == null) {
      duration = Duration(seconds: 1);
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
