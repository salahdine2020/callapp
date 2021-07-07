import 'dart:collection';

import 'package:emall_app/EmallApp/api/api_util.dart';
import 'package:emall_app/EmallApp/controllers/AddressController.dart';
import 'package:emall_app/EmallApp/models/MyResponse.dart';
import 'package:emall_app/EmallApp/services/AppLocalizations.dart';
import 'package:emall_app/EmallApp/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  //UI variables
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  OutlineInputBorder allTFBorder;
  TextStyle allTFStyle, allTFHintStyle;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //Google Maps
  GoogleMapController mapController;
  BitmapDescriptor pinLocationIcon;
  bool loaded = false;
  final Set<Marker> _markers = HashSet();
  final LatLng _center = const LatLng(45.521563, -122.677433);
  LatLng currentPosition;

  //Text Controller
  TextEditingController addressTFController, address2TFController, cityTFController, pincodeTFController;

  //Other
  bool isInProgress = false;

  @override
  void initState() {
    super.initState();
    currentPosition = _center;
    addressTFController = TextEditingController();
    address2TFController = TextEditingController();
    cityTFController = TextEditingController();
    pincodeTFController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => {_changeLoaded()});
  }

  _changeLoaded() {
    setState(() {
      loaded = true;
    });
  }

  _setupLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print('-----${permission.toString()}--------');
      return await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      print('-----${permission.toString()}--------');
      Geolocator.openAppSettings();
    }
    return permission;
  }

  Marker marker = Marker(
    markerId: MarkerId('1'),
    position: LatLng(45.521563, -122.677433),
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.add(marker);
    });
  }

  Future<void> gettingLocation() async {
    LocationPermission locationPermission = await _setupLocationPermission();
    if (locationPermission != LocationPermission.always && locationPermission != LocationPermission.whileInUse) {
      print('-------Navigator.pop(context, $locationPermission)------');
      Navigator.pop(context, locationPermission);
      return;
    }
    Position position;
    print('-------Navigator.pop(context, $position)------');
    try {
      print('-------Enter to try block------');
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      print('-------Get position $position ------');
      double zoom = await mapController.getZoomLevel();
      print('-------Get zoom $position ------');
      _changeLocation(
        zoom,
        LatLng(
          position.latitude,
          position.longitude,
        ),
      );
    } catch (error) {
      return LocationPermission.denied;
    }
  }

  void _onMapTap(LatLng latLong) {
    mapController.getZoomLevel().then(
          (zoom) => {
            _changeLocation(zoom, latLong),
          },
        );
  }

  void _changeLocation(double zoom, LatLng latLng) {
    double newZoom = zoom > 15 ? zoom : 15;
    currentPosition = latLng;
    setState(() {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: newZoom,
          ),
        ),
      );
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId('1'),
        position: latLng,
      ));
    });
  }

  _initUI() {
    allTFBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      borderSide: BorderSide.none,
    );
    allTFStyle = AppTheme.getTextStyle(
      themeData.textTheme.subtitle2,
      fontWeight: 500,
      letterSpacing: 0.2,
    );
    allTFHintStyle = AppTheme.getTextStyle(
      themeData.textTheme.subtitle2,
      fontWeight: 500,
      letterSpacing: 0,
      color: themeData.colorScheme.onBackground.withAlpha(180),
    );
  }

  _saveAddress() async {
    String address = addressTFController.text;
    String address2 = address2TFController.text;
    String city = cityTFController.text;
    String pincodeText = pincodeTFController.text;
    int pincode;
    if (pincodeText.isNotEmpty) {
      pincode = int.parse(pincodeTFController.text);
    }
    if (address.isEmpty) {
      showMessage(message: Translator.translate("please_fill_address"));
    } else if (city.isEmpty) {
      showMessage(message: Translator.translate("please_fill_city"));
    } else if (pincode == null) {
      showMessage(message: Translator.translate("please_fill_pincode"));
    } else {
      if (mounted) {
        setState(() {
          isInProgress = true;
        });
      }

      double latitude = currentPosition.latitude;
      double longitude = currentPosition.longitude;

      /// POST HTTP iformation of Addresses
      MyResponse myResponse = await AddressController.addAddress(
        latitude: latitude,
        address2: address2,
        address: address,
        city: city,
        longitude: longitude,
        pincode: pincode,
      );

      if (myResponse.success) {
        Navigator.pop(context, true);
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
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        int themeType = value.themeMode();
        themeData = AppTheme.getThemeFromThemeMode(themeType);
        customAppTheme = AppTheme.getCustomAppTheme(themeType);
        _initUI();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
          home: Scaffold(
            key: _scaffoldKey,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await gettingLocation();
              },
              child: Icon(
                MdiIcons.mapMarkerOutline,
                color: themeData.colorScheme.onPrimary,
              ),
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: loaded
                        ? GoogleMap(
                            onMapCreated: _onMapCreated,
                            markers: _markers,
                            onTap: _onMapTap,
                            initialCameraPosition: CameraPosition(
                              target: _center,
                              zoom: 11.0,
                            ),
                          )
                        : Container(),
                  ),
                  Container(
                    padding: Spacing.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: themeData.cardTheme.color,
                            borderRadius: BorderRadius.all(
                                Radius.circular(MySize.size16)),
                            boxShadow: [
                              BoxShadow(
                                color: themeData.cardTheme.shadowColor
                                    .withAlpha(28),
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                style: allTFStyle,
                                decoration: InputDecoration(
                                  hintStyle: allTFHintStyle,
                                  hintText:
                                      Translator.translate("address") + " 1",
                                  border: allTFBorder,
                                  enabledBorder: allTFBorder,
                                  focusedBorder: allTFBorder,
                                  prefixIcon: Icon(
                                    MdiIcons.mapMarkerOutline,
                                    size: MySize.size24,
                                  ),
                                ),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: addressTFController,
                              ),
                              Divider(
                                height: 0,
                              ),
                              TextFormField(
                                style: allTFStyle,
                                decoration: InputDecoration(
                                  hintStyle: allTFHintStyle,
                                  hintText:
                                      Translator.translate("address") + " 2",
                                  border: allTFBorder,
                                  enabledBorder: allTFBorder,
                                  focusedBorder: allTFBorder,
                                  prefixIcon: Icon(
                                    MdiIcons.mapMarkerPlusOutline,
                                    size: MySize.size24,
                                  ),
                                ),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: address2TFController,
                              ),
                              Divider(
                                height: 0,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      style: allTFStyle,
                                      decoration: InputDecoration(
                                        hintStyle: allTFHintStyle,
                                        hintText: Translator.translate("city"),
                                        border: allTFBorder,
                                        enabledBorder: allTFBorder,
                                        focusedBorder: allTFBorder,
                                        prefixIcon: Icon(
                                          MdiIcons.homeCityOutline,
                                          size: MySize.size24,
                                        ),
                                      ),
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      controller: cityTFController,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: Spacing.left(8),
                                      child: TextFormField(
                                        style: allTFStyle,
                                        decoration: InputDecoration(
                                          hintStyle: allTFHintStyle,
                                          hintText: Translator.translate("PIN"),
                                          border: allTFBorder,
                                          enabledBorder: allTFBorder,
                                          focusedBorder: allTFBorder,
                                          prefixIcon: Icon(
                                            MdiIcons.numeric,
                                            size: MySize.size24,
                                          ),
                                        ),
                                        keyboardType:
                                            TextInputType.numberWithOptions(),
                                        controller: pincodeTFController,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: Spacing.top(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  MdiIcons.chevronLeft,
                                  color: themeData.colorScheme.onBackground,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        MySize.size4,
                                      ),
                                    ),
                                    color: themeData.colorScheme.primary,
                                    splashColor: Colors.white.withAlpha(150),
                                    highlightColor:
                                        themeData.colorScheme.primary,
                                    onPressed: () {
                                      _saveAddress();
                                    },
                                    padding: Spacing.horizontal(24),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          margin: Spacing.right(16),
                                          child: isInProgress
                                              ? Container(
                                                  width: MySize.size16,
                                                  height: MySize.size16,
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      themeData.colorScheme
                                                          .onPrimary,
                                                    ),
                                                    strokeWidth: 1.4,
                                                  ),
                                                )
                                              : ClipOval(
                                                  child: Icon(
                                                    MdiIcons.check,
                                                    color: themeData
                                                        .colorScheme.onPrimary,
                                                    size: MySize.size18,
                                                  ),
                                                ),
                                        ),
                                        Text(
                                          Translator.translate("save_address")
                                              .toUpperCase(),
                                          style: AppTheme.getTextStyle(
                                            themeData.textTheme.caption,
                                            fontSize: 12,
                                            fontWeight: 600,
                                            letterSpacing: 0.5,
                                            color:
                                                themeData.colorScheme.onPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
