import 'dart:developer';

import 'package:manager_app/api/api_util.dart';
import 'package:manager_app/controllers/CategoryController.dart';
import 'package:manager_app/controllers/ProductController.dart';
import 'package:manager_app/models/Category.dart';
import 'package:manager_app/models/MyResponse.dart';
import 'package:manager_app/models/ProductItem.dart';
import 'package:manager_app/models/ProductItemFeature.dart';
import 'package:manager_app/services/AppLocalizations.dart';
import 'package:manager_app/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';
import '../LoadingScreens.dart';

class CreateProductScreen extends StatefulWidget {
  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  //ThemeData
  ThemeData themeData;
  CustomAppTheme customAppTheme;

  //Global Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey _categorySelectionKey = new GlobalKey();
  final GlobalKey _subCategorySelectionKey = new GlobalKey();

  //Other Variables
  bool isInProgress = false;
  OutlineInputBorder tfBorder;
  List<Category> categories;

  int selectedCategory, selectedSubCategory;
  List<ProductItemWidget> productItemsWidget = [];
  List<ProductItem> productItems = [];

  //TEC
  TextEditingController teName, teDescription, teOffer;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    teName = TextEditingController();
    teDescription = TextEditingController();
    teOffer = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    teName.dispose();
    teDescription.dispose();
    teOffer.dispose();
  }

  _fetchCategories() async {
    if (mounted) {
      setState(() {
        isInProgress = true;
      });
    }

    MyResponse<List<Category>> myResponse =
        await CategoryController.getAllCategory();
    if (myResponse.success) {
      categories = myResponse.data;
      if (categories.length != 0) {
        selectedCategory = 0;
        if(categories[0].subCategories.length!=0)
          selectedSubCategory = 0;
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

  _createProduct() async {
    if (mounted) {
      setState(() {
        isInProgress = true;
      });
    }

    if (teName.text.isEmpty) {
      showMessage(message: "Please fill name");
      return;
    }

    if (teDescription.text.isEmpty) {
      showMessage(message: "Please fill description");
      return;
    }

    if (teOffer.text.isEmpty) {
      showMessage(message: "Please fill offer");
      return;
    }

    for (ProductItem productItem in productItems) {
      if (!productItem.isValid()) {
        showMessage(message: "Fill other items first");
        return;
      }
    }

    if(selectedSubCategory==null || selectedCategory==null){
      showMessage(message: "Choose category");
      return;
    }





    String items = "[";
    for (int i = 0; i < productItems.length; i++) {
      items += productItems[i].toJSON();
      if (i + 1 != productItems.length) items += ",";
    }
    items += "]";

    MyResponse myResponse = await ProductController.createProduct(
        name: teName.text,
        categoryId: categories[selectedCategory].subCategories[selectedSubCategory].id,
        description: teDescription.text,
        items: items,
        offer: teOffer.text);
    if (myResponse.success) {
      if (mounted) {
        setState(() {
          isInProgress = false;
        });
      }
      Navigator.pop(context);
      return;
    } else {
      showMessage(message: myResponse.errorText);
    }
    if (mounted) {
      setState(() {
        isInProgress = false;
      });
    }
  }

  addItem() {
    for (ProductItem productItem in productItems) {
      if (!productItem.isValid()) {
        showMessage(message: "Fill other items first");
        return;
      }
    }

    ProductItem productItem = ProductItem.empty();
    productItems.add(productItem);
    productItemsWidget.add(ProductItemWidget(
      customAppTheme: customAppTheme,
      productItem: productItem,
      index: productItems.indexOf(productItem),
    ));
  }

  _initUI() {
    tfBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(MySize.size8),
        ),
        borderSide: BorderSide(color: customAppTheme.bgLayer4, width: 1.5));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        int themeType = value.themeMode();
        themeData = AppTheme.getThemeFromThemeMode(themeType);
        customAppTheme = AppTheme.getCustomAppTheme(themeType);
        _initUI();

        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(themeType),
            home: Scaffold(
              key: _scaffoldKey,
              backgroundColor: customAppTheme.bgLayer2,
              appBar: AppBar(
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    MdiIcons.chevronLeft,
                    size: MySize.size20,
                    color: themeData.colorScheme.onBackground,
                  ),
                ),
                elevation: 0,
                backgroundColor: customAppTheme.bgLayer2,
                title: Text(
                  Translator.translate("create_product"),
                  style: AppTheme.getTextStyle(
                    themeData.textTheme.headline6,
                    color: themeData.colorScheme.onBackground,
                    fontWeight: 600,
                  ),
                ),
                centerTitle: true,
                actions: [
                  InkWell(
                    onTap: () {
                      _createProduct();
                    },
                    child: Container(
                        margin: Spacing.right(16),
                        child: Icon(
                          MdiIcons.check,
                          color: themeData.colorScheme.onBackground,
                          size: MySize.size20,
                        )),
                  )
                ],
              ),
              body: ListView(
                padding: Spacing.bottom(16),
                children: [buildBody()],
              ),
            ));
      },
    );
  }

  buildBody() {
    if (isInProgress && categories == null) {
      return LoadingScreens.getOrderLoadingScreen(
          context, themeData, customAppTheme);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: Spacing.fromLTRB(24, 0, 24, 0),
            child: TextFormField(
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                  letterSpacing: 0.1,
                  color: themeData.colorScheme.onBackground,
                  fontWeight: 500),
              decoration: InputDecoration(
                  hintText: Translator.translate("name"),
                  hintStyle: AppTheme.getTextStyle(
                      themeData.textTheme.subtitle2,
                      letterSpacing: 0.1,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 500),
                  border: tfBorder,
                  enabledBorder: tfBorder,
                  focusedBorder: tfBorder,
                  prefixIcon: Icon(
                    MdiIcons.squareRoundedOutline,
                    size: MySize.size22,
                  ),
                  isDense: true,
                  contentPadding: Spacing.zero),
              keyboardType: TextInputType.text,
              controller: teName,
            ),
          ),
          Container(
            margin: Spacing.fromLTRB(24, 16, 24, 0),
            child: Row(
              children: [
                Text(
                  Translator.translate("category"),
                  style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 600,
                      xMuted: true),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      dynamic state = _categorySelectionKey.currentState;
                      state.showButtonMenu();
                    },
                    child: Container(
                      margin: Spacing.left(16),
                      padding: Spacing.left(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(MySize.size8),
                          border: Border.all(
                              color: customAppTheme.bgLayer4, width: 1.5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            categories[selectedCategory].title,
                            style: AppTheme.getTextStyle(
                              themeData.textTheme.bodyText2,
                              color: themeData.colorScheme.onBackground,
                              fontWeight: 600,
                            ),
                          ),
                          PopupMenuButton(
                            icon: Icon(
                              MdiIcons.chevronDown,
                              color: themeData.colorScheme.onBackground,
                              size: MySize.size20,
                            ),
                            onSelected: (value) async {
                              setState(() {
                                selectedCategory = value;
                                selectedSubCategory = 0;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              var list = List<PopupMenuEntry<Object>>();
                              for (int i = 0; i < categories.length; i++) {
                                list.add(PopupMenuItem(
                                  enabled: categories[i].subCategories.length!=0,
                                  value: i,
                                  child: Text(categories[i].title,
                                      style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText2,
                                        fontWeight: 600,
                                        color:
                                            themeData.colorScheme.onBackground, xMuted: categories[i].subCategories.length==0
                                      )),
                                ));
                                if (i != categories.length - 1) {
                                  list.add(
                                    PopupMenuDivider(
                                      height: MySize.size4,
                                    ),
                                  );
                                }
                              }
                              return list;
                            },
                            key: _categorySelectionKey,
                            color: themeData.backgroundColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: Spacing.fromLTRB(24, 16, 24, 0),
            child: Row(
              children: [
                Text(
                  Translator.translate("sub_category"),
                  style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 600,
                      xMuted: true),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      dynamic state = _subCategorySelectionKey.currentState;
                      state.showButtonMenu();
                    },
                    child: Container(
                      margin: Spacing.left(16),
                      padding: Spacing.left(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(MySize.size8),
                          border: Border.all(
                              color: customAppTheme.bgLayer4, width: 1.5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            categories[selectedCategory].subCategories[selectedSubCategory].title,
                            style: AppTheme.getTextStyle(
                              themeData.textTheme.bodyText2,
                              color: themeData.colorScheme.onBackground,
                              fontWeight: 600,
                            ),
                          ),
                          PopupMenuButton(
                            icon: Icon(
                              MdiIcons.chevronDown,
                              color: themeData.colorScheme.onBackground,
                              size: MySize.size20,
                            ),
                            onSelected: (value) async {
                              setState(() {
                                selectedSubCategory = value;
                              });
                            },
                            itemBuilder: (BuildContext context) {

                              var list = List<PopupMenuEntry<Object>>();
                              for (int i = 0; i < categories[selectedCategory].subCategories.length; i++) {
                                list.add(PopupMenuItem(

                                  value: i,
                                  child: Text(categories[selectedCategory].subCategories[i].title,
                                      style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText2,
                                        fontWeight: 600,
                                        color:
                                            themeData.colorScheme.onBackground,
                                      )),
                                ));
                                if (i != categories[selectedCategory].subCategories.length - 1) {
                                  list.add(
                                    PopupMenuDivider(
                                      height: MySize.size4,
                                    ),
                                  );
                                }
                              }
                              return list;
                            },
                            key: _subCategorySelectionKey,
                            color: themeData.backgroundColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: Spacing.fromLTRB(24, 24, 24, 0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: Translator.translate("description"),
                isDense: true,
                filled: true,
                fillColor: customAppTheme.bgLayer4,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              textCapitalization: TextCapitalization.sentences,
              minLines: 5,
              maxLines: 10,
              controller: teDescription,
            ),
          ),
          Container(
            margin: Spacing.fromLTRB(24, 24, 24, 0),
            child: TextFormField(
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                  letterSpacing: 0.1,
                  color: themeData.colorScheme.onBackground,
                  fontWeight: 500),
              decoration: InputDecoration(
                  hintText: Translator.translate("offer"),
                  hintStyle: AppTheme.getTextStyle(
                      themeData.textTheme.subtitle2,
                      letterSpacing: 0.1,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 500),
                  border: tfBorder,
                  enabledBorder: tfBorder,
                  focusedBorder: tfBorder,
                  prefixIcon: Icon(
                    MdiIcons.tagOutline,
                    size: MySize.size22,
                  ),
                  isDense: true,
                  contentPadding: Spacing.zero),
              keyboardType: TextInputType.number,
              controller: teOffer,
            ),
          ),
          Container(
            margin: Spacing.fromLTRB(24, 24, 24, 0),
            padding: Spacing.fromLTRB(16, 6, 16, 6),
            decoration: BoxDecoration(
                color: customAppTheme.bgLayer3,
                borderRadius: BorderRadius.circular(MySize.size4)),
            child: Text(
              Translator.translate("items"),
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                  color: themeData.colorScheme.onBackground,
                  fontWeight: 600,
                  muted: true),
            ),
          ),
          Container(
            margin: Spacing.fromLTRB(24, 8, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: productItemsWidget,
            ),
          ),
          SizedBox(height: MySize.size8,),
          Center(
            child: FlatButton(
              color: themeData.colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MySize.size4)),
              onPressed: () {
                setState(() {
                  addItem();
                });
              },
              child: Text(
                Translator.translate("add_item"),
                style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                    color: themeData.colorScheme.onPrimary),
              ),
            ),
          ),
        ],
      );
    }
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

class ProductItemWidget extends StatefulWidget {
  final CustomAppTheme customAppTheme;
  final ProductItem productItem;
  final int index;

  const ProductItemWidget(
      {Key key, this.customAppTheme, this.productItem, this.index})
      : super(key: key);

  @override
  _ProductItemWidgetState createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  List<ProductItemFeatureWidget> productItemFeaturesWidget = [];
  List<ProductItemFeature> productItemFeatures = [];
  ProductItem productItem;

  ThemeData themeData;
  CustomAppTheme customAppTheme;

  //UI
  OutlineInputBorder tfBorder;

  //TEC
  TextEditingController tePrice, teRevenue, teQuantity;

  @override
  void initState() {
    super.initState();
    customAppTheme = widget.customAppTheme;
    productItem = widget.productItem;
    tePrice = TextEditingController();
    teRevenue = TextEditingController();
    teQuantity = TextEditingController();

    tePrice.addListener(() {
      if (tePrice.text.isNotEmpty) productItem.price = int.parse(tePrice.text);
    });

    teRevenue.addListener(() {
      if (teRevenue.text.isNotEmpty)
        productItem.revenue = int.parse(teRevenue.text);
    });

    teQuantity.addListener(() {
      if (teQuantity.text.isNotEmpty)
        productItem.quantity = int.parse(teQuantity.text);
    });
  }

  _initUI() {
    tfBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(MySize.size8),
        ),
        borderSide: BorderSide(color: customAppTheme.bgLayer4, width: 1.5));
  }

  @override
  void dispose() {
    super.dispose();
    tePrice.dispose();
    teRevenue.dispose();
    teQuantity.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initUI();
    themeData = Theme.of(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Spacing.vertical(12),
            child: Divider(
              height: MySize.size4,
              thickness: 1.2,
            ),
          ),
          Container(
            child: Text(
              Translator.translate("item") + " # " + (widget.index + 1).toString(),
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                  color: themeData.colorScheme.onBackground, fontWeight: 600),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: productItemFeaturesWidget,
            ),
          ),
          SizedBox(
            height: MySize.size8,
          ),
          FlatButton(
            color: themeData.colorScheme.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySize.size4)),
            onPressed: () {
              setState(() {
                ProductItemFeature productItemFeature =
                    ProductItemFeature.fill();
                productItem.productItemFeatures.add(productItemFeature);
                productItemFeaturesWidget.add(ProductItemFeatureWidget(
                  customAppTheme: customAppTheme,
                  productItemFeature: productItemFeature,
                ));
              });
            },
            child: Text(
              Translator.translate("add_feature"),
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                  color: themeData.colorScheme.onPrimary),
            ),
          ),
          Container(
            margin: Spacing.top(8),
            child: Row(
              children: [
                Container(width: MySize.size72,
                    child: Text(Translator.translate("price"),style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,color: themeData.colorScheme.onBackground,fontWeight: 600,),)),
                Expanded(
                  child: TextFormField(
                    style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                        letterSpacing: 0.1,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                        hintText: Translator.translate("price"),
                        hintStyle: AppTheme.getTextStyle(
                            themeData.textTheme.subtitle2,
                            letterSpacing: 0.1,
                            color: themeData.colorScheme.onBackground,
                            fontWeight: 500),
                        border: tfBorder,
                        enabledBorder: tfBorder,
                        focusedBorder: tfBorder,
                        contentPadding: Spacing.fromLTRB(16, 6, 8, 6)),
                    keyboardType: TextInputType.number,
                    controller: tePrice,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: Spacing.top(8),
            child: Row(
              children: [
                Container(width: MySize.size72,
                    child: Text(Translator.translate("revenue"),style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,color: themeData.colorScheme.onBackground,fontWeight: 600,),)),
                Expanded(
                  child: TextFormField(
                    style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                        letterSpacing: 0.1,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                        hintText: Translator.translate("revenue"),
                        hintStyle: AppTheme.getTextStyle(
                            themeData.textTheme.subtitle2,
                            letterSpacing: 0.1,
                            color: themeData.colorScheme.onBackground,
                            fontWeight: 500),
                        border: tfBorder,
                        enabledBorder: tfBorder,
                        focusedBorder: tfBorder,
                        contentPadding: Spacing.fromLTRB(16, 6, 8, 6)),
                    keyboardType: TextInputType.number,
                    controller: teRevenue,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: Spacing.top(8),
            child: Row(
              children: [
                Container(width: MySize.size72,
                    child: Text(Translator.translate("quantity"),style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,color: themeData.colorScheme.onBackground,fontWeight: 600,),)),
                Expanded(
                  child: TextFormField(
                    style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                        letterSpacing: 0.1,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                        hintText: Translator.translate("quantity"),
                        hintStyle: AppTheme.getTextStyle(
                            themeData.textTheme.subtitle2,
                            letterSpacing: 0.1,
                            color: themeData.colorScheme.onBackground,
                            fontWeight: 500),
                        border: tfBorder,
                        enabledBorder: tfBorder,
                        focusedBorder: tfBorder,
                        contentPadding: Spacing.fromLTRB(16, 6, 8, 6)),
                    keyboardType: TextInputType.number,
                    controller: teQuantity,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItemFeatureWidget extends StatefulWidget {
  final CustomAppTheme customAppTheme;
  final ProductItemFeature productItemFeature;

  const ProductItemFeatureWidget(
      {Key key, this.customAppTheme, this.productItemFeature})
      : super(key: key);

  @override
  _ProductItemFeatureWidgetState createState() =>
      _ProductItemFeatureWidgetState();
}

class _ProductItemFeatureWidgetState extends State<ProductItemFeatureWidget> {
  CustomAppTheme customAppTheme;
  ThemeData themeData;
  List<String> features = ["Color", "Size", "Gram", "Other"];
  ProductItemFeature productItemFeature;

  //UI
  OutlineInputBorder tfBorder;
  TextEditingController teFeatureValue;

  int selectedFeature = 0;

  @override
  void initState() {
    super.initState();
    customAppTheme = widget.customAppTheme;
    productItemFeature = widget.productItemFeature;
    teFeatureValue = new TextEditingController();
    teFeatureValue.addListener(() {
      productItemFeature.value = teFeatureValue.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    teFeatureValue.removeListener(() {});
    teFeatureValue.dispose();
  }

  _initUI() {
    tfBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(MySize.size8),
        ),
        borderSide: BorderSide(color: customAppTheme.bgLayer4, width: 1.5));
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    _initUI();
    return Container(
      margin: Spacing.top(8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: Spacing.left(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(MySize.size8),
                    border:
                        Border.all(color: customAppTheme.bgLayer4, width: 1.5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      features[selectedFeature],
                      style: AppTheme.getTextStyle(
                        themeData.textTheme.caption,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 600,
                      ),
                    ),
                    PopupMenuButton(
                      icon: Icon(
                        MdiIcons.chevronDown,
                        color: themeData.colorScheme.onBackground,
                        size: MySize.size16,
                      ),
                      onSelected: (value) async {
                        setState(() {
                          selectedFeature = value;
                          productItemFeature.feature = features[value];
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        var list = List<PopupMenuEntry<Object>>();
                        for (int i = 0; i < features.length; i++) {
                          list.add(PopupMenuItem(
                            value: i,
                            child: Text(features[i],
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.caption,
                                  fontWeight: 600,
                                  color: themeData.colorScheme.onBackground,
                                )),
                          ));
                          if (i != features.length - 1) {
                            list.add(
                              PopupMenuDivider(
                                height: MySize.size4,
                              ),
                            );
                          }
                        }
                        return list;
                      },
                      padding: Spacing.zero,
                      color: themeData.backgroundColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: MySize.size16,
          ),
          Expanded(
            child: TextFormField(
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                  letterSpacing: 0.1,
                  color: themeData.colorScheme.onBackground,
                  fontWeight: 500),
              decoration: InputDecoration(
                  hintText: Translator.translate("value"),
                  hintStyle: AppTheme.getTextStyle(
                      themeData.textTheme.subtitle2,
                      letterSpacing: 0.1,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 500),
                  border: tfBorder,
                  enabledBorder: tfBorder,
                  focusedBorder: tfBorder,
                  contentPadding: Spacing.fromLTRB(16, 6, 8, 6)),
              keyboardType: TextInputType.text,
              controller: teFeatureValue,
            ),
          )
        ],
      ),
    );
  }
}
