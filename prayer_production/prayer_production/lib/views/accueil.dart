import 'package:flutter/material.dart';
import 'package:prayer_production/controller/api_provider.dart';
import 'package:prayer_production/models/prayer_times_model.dart';
import 'package:prayer_production/repository/shared_base.dart';
import 'package:prayer_production/views/resarvation_prayer.dart';
import 'package:prayer_production/widgets/search_mosque.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AccueilPage extends StatefulWidget {
  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  String id_mosque;
  String designation;
  bool _resstatus;
  String _resprayer;
  String adresse;
  int _groupeindex;
  bool state_sobh = false;
  bool state_dohr = false;
  bool state_asr = false;
  bool state_maghrib = false;
  bool state_isha = false;

  Future getTestBooking() async {
    var res_status = await RepositeryShared().getBookingStatus();
    var res_prayer = await RepositeryShared().getBookingPrayer();
    setState(() {
      _resprayer = res_prayer;
      _resstatus = res_status;
    });
    print('******* status $_resstatus  prayer is $_resprayer ********');
  }

  Future getList() async {
    var list_val = await PrayerProvider().getPrayerTime();
    print('the List of values is : $list_val');
    return list_val;
  }

  Future getTimePrayer() async {
    var res_id = await RepositeryShared().getMosqueID();
    var list_prayer =
        await PrayerProvider().PostToGetTimePrayer(id_mosque: res_id);
    return list_prayer;
  }

  Future<bool> functionToChoice() async {
    var choice = await RepositeryShared().getMosqueID;
    if (choice != null) {
      return true;
    } else if (choice == null) {
      return false;
    }
  }

  Future getMosquDetail() async {
    var res_id = await RepositeryShared().getMosqueID();
    var groupe_index = await RepositeryShared().getGroupeIndex();
    var data = await PrayerProvider().PostToGetMosques(id: res_id);
    print('******* ID for Mosque is ${data[0]['id']} ********');
    print(
        '******* designation for Mosque is ${data[0]['designation']} ********');
    setState(() {
      id_mosque = data[0]['id'];
      designation = data[0]['designation'];
      adresse = data[0]['adresse'];
      _groupeindex = groupe_index + 1;
    });
  }

  Future<void> _showMyDialog({rm}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Code Bar de Resarvation'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text('Mosquee: ' + designation.toString()),
                SizedBox(
                  height: 8,
                ),
                Text('Adresse: ' + adresse.toString()),
                SizedBox(
                  height: 8,
                ),
                Text('Groupe: ' + _groupeindex.toString()),
                SizedBox(
                  height: 8,
                ),
                FutureBuilder(
                  future: RepositeryShared().getBarCode(),
                  builder: (context, snapshot) {
                    return Container(
                      width: 160,
                      height: 160,
                      child: QrImage(
                        data: snapshot.data.toString(),
                        version: QrVersions.auto,
                        //size: 200.0,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            InkWell(
              child: Container(
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      .07, //16,//kSpacingUnit.w * 5,
                  width: MediaQuery.of(context).size.width *
                      .75, //48,//kSpacingUnit.w * 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      4, //kSpacingUnit.w * 1.5,
                    ),
                    color: Theme.of(context).accentColor,
                  ),
                  child: Center(
                    child: Text(
                      'Supprime la Resarvation',
                    ),
                  ),
                ),
              ),
              onTap: () async {
                /// code to delet prayer
                await deletProceces(prayer_remove: rm);
                await deletRelation();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future deletRelation() async {
    var id_relation = await RepositeryShared().getRelationID();
    await PrayerProvider().PostToDeletInscoPrayer(id_relation: id_relation);
  }

  Future deletProceces({prayer_remove}) async {
    await BookingShared().removeBooking(prayer_remove: prayer_remove);
    //await RepositeryShared().removeBookingStatus();
    //await RepositeryShared().removeBookingPrayer();
  }

  @override
  void initState() {
    // TODO: implement initState
    getTestBooking();
    getMosquDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Accueil',
          style: TextStyle(color: Colors.teal),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              await getTestBooking();
              //await getTestBooking();
              //await getFieldInformation();
              //RepositeryShared().removeSeenScreen();
              //getMosquDetail();
              /// Go in seconde Screen to select from one mosque prayer tranche time
            },
          ),
        ],
      ),
      // backgroundColor: Colors.white.withOpacity(.9),
      body: CardPrayerWidget(context),
    );
  }

  Widget CardPrayerWidget(context) {
    double hight = MediaQuery.of(context).size.height;
    double wight = MediaQuery.of(context).size.width;
    return ListView(
      shrinkWrap: true,
      children: [
        FutureBuilder(
            future: functionToChoice(),
            builder: (context, snapshot) {
              print(
                  '****** if ID dont null ${snapshot.data.toString()} *********');
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return snapshot.data == true
                  ?
                  // for mosque favorite
                  // type : <List<Data_times>>
                  FutureBuilder(
                      future: getTimePrayer(),
                      builder: (context, snapshot) {
                        DateTime now = DateTime.now();
                        DateTime date = DateTime(now.year, now.month, now.day);
                        if (!snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.all(48),
                            child: Center(
                                child: Text(
                                    'Les heures de prière ne sont pas disponibles')),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Something went wrong'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Card(
                            elevation: 8,
                            child: Container(
                              child: Column(
                                children: [
                                  Center(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.date_range,
                                        size: 48,
                                      ),
                                      title: Text(
                                        'Aujourdhui',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Text(
                                            'Date : ' +
                                                date.year.toString() +
                                                '-' +
                                                date.month.toString() +
                                                '-' +
                                                date.day.toString(),
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.refresh,
                                          size: 32,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            getTimePrayer();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Fajr',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    trailing: Text(
                                      snapshot.data[0].heure.toString(),
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.teal,
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Dohr',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    trailing: Text(
                                      snapshot.data[1].heure.toString(),
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.teal,
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Asr',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    trailing: Text(
                                      snapshot.data[2].heure.toString(),
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.teal,
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Maghrib',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    trailing: Text(
                                      snapshot.data[3].heure.toString(),
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.teal,
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Isha',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    trailing: Text(
                                      snapshot.data[4].heure.toString(),
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  : FutureBuilder(
                      future: getList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Something went wrong'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Card(
                            elevation: 8,
                            child: Container(
                              child: Column(
                                children: [
                                  Center(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.date_range,
                                        size: 48,
                                      ),
                                      title: Text(
                                        'Aujourdhui',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Text(
                                            'Date : ' +
                                                    snapshot.data[10]
                                                        .toString() ??
                                                'null',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.refresh,
                                          size: 32,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            getList();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Fajr',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    trailing: Text(
                                      snapshot.data[2].toString(),
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.teal,
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Dohr',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    trailing: Text(
                                      snapshot.data[5].toString(),
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.teal,
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Asr',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    trailing: Text(
                                      snapshot.data[6].toString(),
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.teal,
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Maghrib',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    trailing: Text(
                                      snapshot.data[7].toString(),
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.teal,
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Isha',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    trailing: Text(
                                      snapshot.data[8].toString(),
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
              // for mosque by default
            }),
        ListPrayerWidget(context),
      ],
    );
  }

  Widget ListPrayerWidget(BuildContext context) {
    double hight = MediaQuery.of(context).size.height;
    double wight = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            InkWell(
              child: Container(
                width: wight * .19,
                height: hight * .18,
                child: Card(
                  //color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: hight * .07,
                        width: wight * .18,
                        child: Image.asset('assets/images/fajr_icon.png'),

                        ///  Image.asset('assets/images/fajr_icon.png'),
                        ///  variable
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text('Fajr'),
                      SizedBox(
                        height: 15,
                      ),
                      FutureBuilder(
                          future: BookingShared().getBookingSobh(),
                          builder: (context, snapshot) {
                            if (snapshot.data[0] == 'Sobh' &&
                                snapshot.data[1] == true) {
                              state_sobh = true;
                              return Container(
                                width: wight * .17,
                                height: hight * .009,
                                color: Colors.greenAccent,
                              );
                            } else {
                              return Container(
                                width: wight * .17,
                                height: hight * .009,
                                color: Colors.redAccent,
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ),
//              BookPrayer(
//                wight: wight,
//                hight: hight,
//                prayer_title: 'Fajr',
//                imageasset: 'assets/images/fajr_icon.png',
//              ),
              onTap: () {
                /// go into booking screen
                print('booking for Fajr');
                if (state_sobh == false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppBarSearchExample(
                        // prayer title and Image should pass it here
                        image_url: 'assets/images/fajr_icon.png',
                        prayer_name: 'Sobh',
                        tranch: 'tranche_sobh',
                      ),
                    ),
                  );
                } else if (state_sobh == true) {
                  _showMyDialog(rm: 'Sobh');
                  setState(() {
                    state_sobh = false;
                  });
                }
              },
            ),
            InkWell(
              child: Container(
                width: wight * .19,
                height: hight * .18,
                child: Card(
                  //color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: hight * .07,
                        width: wight * .18,
                        child: Image.asset('assets/images/dohr_icon.png'),

                        /// Image.asset('assets/images/fajr_icon.png'),
                        ///  variable
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text('Dohr'),
                      SizedBox(
                        height: 15,
                      ),
                      FutureBuilder(
                          future: BookingShared().getBookingDohr(),
                          builder: (context, snapshot) {
                            if (snapshot.data[0] == 'Dohr' &&
                                snapshot.data[1] == true) {
                              state_sobh = true;
                              return Container(
                                width: wight * .17,
                                height: hight * .009,
                                color: Colors.greenAccent,
                              );
                            } else {
                              return Container(
                                width: wight * .17,
                                height: hight * .009,
                                color: Colors.redAccent,
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ),
//              BookPrayer(
//                wight: wight,
//                hight: hight,
//                prayer_title: 'Dohr',
//                imageasset: 'assets/images/dohr_icon.png',
//              ),
              onTap: () {
                /// go into booking screen
                print('booking for Dohr');
                if (state_dohr == false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppBarSearchExample(
                        // prayer title and Image should pass it here
                        image_url: 'assets/images/dohr_icon.png',
                        prayer_name: 'Dohr',
                        tranch: 'tranche_dohr',
                      ),
                    ),
                  );
                } else if (state_dohr == true) {
                  _showMyDialog(rm: 'Dohr');
                  setState(() {
                    state_dohr = false;
                  });
                }
              },
            ),
            InkWell(
              child: Container(
                width: wight * .19,
                height: hight * .18,
                child: Card(
                  //color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: hight * .07,
                        width: wight * .18,
                        child: Image.asset(
                          'assets/images/asr_icon.png',
                        ), //Image.asset('assets/images/fajr_icon.png'),
                        ///  variable
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text('Asr'),
                      SizedBox(
                        height: 15,
                      ),
                      FutureBuilder(
                          future: BookingShared().getBookingAsr(),
                          builder: (context, snapshot) {
                            if (snapshot.data[0] == 'Asr' &&
                                snapshot.data[1] == true) {
                              state_sobh = true;
                              return Container(
                                width: wight * .17,
                                height: hight * .009,
                                color: Colors.greenAccent,
                              );
                            } else {
                              return Container(
                                width: wight * .17,
                                height: hight * .009,
                                color: Colors.redAccent,
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ),
//              BookPrayer(
//                wight: wight,
//                hight: hight,
//                prayer_title: 'Asr',
//                imageasset: 'assets/images/asr_icon.png',
//              ),
              onTap: () {
                /// go into booking screen
                print('booking for Asr');

                if (state_asr == false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppBarSearchExample(
                        // prayer title and Image should pass it here
                        image_url: 'assets/images/asr_icon.png',
                        prayer_name: 'Asr',
                        tranch: "tranche_asr",
                      ),
                    ),
                  );
                } else if (state_asr == true) {
                  _showMyDialog(rm: 'Asr');
                  setState(() {
                    state_asr = false;
                  });
                }
              },
            ),
            InkWell(
              child: Container(
                width: wight * .19,
                height: hight * .18,
                child: Card(
                  //color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: hight * .07,
                        width: wight * .18,
                        child: Image.asset(
                            'assets/images/maghrib_icon.png'), //Image.asset('assets/images/fajr_icon.png'),
                        ///  variable
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text('Maghrib'),
                      SizedBox(
                        height: 15,
                      ),
                      FutureBuilder(
                          future: BookingShared().getBookingMaghrib(),
                          builder: (context, snapshot) {
                            if (snapshot.data[0] == 'Maghrib' &&
                                snapshot.data[1] == true) {
                              state_sobh = true;
                              return Container(
                                width: wight * .17,
                                height: hight * .009,
                                color: Colors.greenAccent,
                              );
                            } else {
                              return Container(
                                width: wight * .17,
                                height: hight * .009,
                                color: Colors.redAccent,
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ),

//              BookPrayer(
//                wight: wight,
//                hight: hight,
//                prayer_title: 'Maghrib',
//                imageasset: 'assets/images/maghrib_icon.png',
//              ),
              onTap: () {
                /// go into booking screen
                print('booking for Maghrib');

                if (state_maghrib == false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppBarSearchExample(
                        // prayer title and Image should pass it here
                        image_url: 'assets/images/maghrib_icon.png',
                        prayer_name: 'Maghrib',
                        tranch: "tranche_maghrib",
                      ),
                    ),
                  );
                } else if (state_maghrib == true) {
                  _showMyDialog(rm: 'Maghrib');
                  setState(() {
                    state_maghrib = false;
                  });
                }
              },
            ),
            InkWell(
              child: Container(
                width: wight * .19,
                height: hight * .18,
                child: Card(
                  //color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: hight * .07,
                        width: wight * .18,
                        child: Image.asset(
                            'assets/images/ichaa_icon.png'), //Image.asset('assets/images/fajr_icon.png'),
                        ///  variable
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text('Ishaa'),
                      SizedBox(
                        height: 15,
                      ),
                      FutureBuilder(
                          future: BookingShared().getBookingIshaa(),
                          builder: (context, snapshot) {
                            if (snapshot.data[0] == 'Ishaa' &&
                                snapshot.data[1] == true) {
                              state_sobh = true;
                              return Container(
                                width: wight * .17,
                                height: hight * .009,
                                color: Colors.greenAccent,
                              );
                            } else {
                              return Container(
                                width: wight * .17,
                                height: hight * .009,
                                color: Colors.redAccent,
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ),

//              BookPrayer(
//                wight: wight,
//                hight: hight,
//                prayer_title: 'Ishaa',
//                imageasset: 'assets/images/ichaa_icon.png',
//              ),
              onTap: () {
                /// go into booking screen
                print('booking for Isha');

                if (state_isha == false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppBarSearchExample(
                        // prayer title and Image should pass it here
                        image_url: 'assets/images/ichaa_icon.png',
                        prayer_name: 'Isha',
                        tranch: "tranche_ichaa",
                      ),
                    ),
                  );
                } else if (state_isha == true) {
                  _showMyDialog(rm: 'Ishaa');
                  setState(() {
                    state_isha = false;
                  });
                }
              },
            ),
          ],
        ),
      ),
      onTap: () {
        print('card prayer clicked');
      },
    );
  }
}

class BookPrayer extends StatelessWidget {
  const BookPrayer({
    Key key,
    @required this.wight,
    @required this.hight,
    @required this.imageasset,
    @required this.prayer_title,
  }) : super(key: key);

  final double wight;
  final double hight;
  final String imageasset;
  final String prayer_title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: wight * .19,
      height: hight * .18,
      child: Card(
        //color: Colors.white,
        child: Column(
          children: [
            Container(
              height: hight * .07,
              width: wight * .18,
              child: Image.asset(
                  imageasset), //Image.asset('assets/images/fajr_icon.png'),
              ///  variable
            ),
            SizedBox(
              height: 16,
            ),
            Text(prayer_title),
            SizedBox(
              height: 15,
            ),
            Container(
              width: wight * .17,
              height: hight * .009,
              color: prayer_title == 'Isha'
                  ? Colors.greenAccent
                  : Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
