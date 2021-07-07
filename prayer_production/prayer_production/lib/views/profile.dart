import 'package:flutter/material.dart';
import 'package:prayer_production/controller/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<String> getSaveID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var ID = sharedPreferences.getString('id');
    print('------ID: $ID--------');
    return ID;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Profile', style: TextStyle(color: Colors.teal),),
        actions: [
          IconButton(
              icon: Icon(Icons.get_app, size: 28, color: Colors.teal,),
              onPressed: () async {
              /// Get METHODE TO DOWNLOAD USERR
              String id = await getSaveID();
              await PrayerProvider().PostToDownloadUser(id: '70'); //id Example
          }),
        ],
      ),
    );
  }
}
