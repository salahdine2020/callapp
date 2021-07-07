import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prayer_production/controller/api_provider.dart';
import 'package:prayer_production/models/servicesbymosque_model.dart';
import 'package:prayer_production/repository/shared_base.dart';
import 'package:prayer_production/services/services.dart';

class BookingPrayer extends StatefulWidget {
  final String image_url;
  final String mosque_name;
  final String id;
  final String prayer;
  final String tranch;

  BookingPrayer(
      {this.mosque_name, this.id, this.prayer, this.image_url, this.tranch});
  @override
  _BookingPrayerState createState() => _BookingPrayerState();
}

class _BookingPrayerState extends State<BookingPrayer> {
  bool _can_booking = false;
  int number_groupe;
  bool booking;
  int _id_relation;

  Future getInfMosque() async {
    var id_mosque = await RepositeryShared().getMosqueID();
    var data = await PrayerProvider().PostToGetMosques(id: id_mosque);
    print(
        '**** data of Get Mosque is tranch Dohr : ${data[0][widget.tranch ?? 'tranche_sobh'].toString()} *****');
    setState(() {
      number_groupe =
          int.parse(data[0][widget.tranch ?? 'tranche_sobh'].toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getInfMosque();
    // getIdGroupe();
    super.initState();
  }

  Future postInscriptionPrayer({int id_tranch}) async {
    var id_mosque = await RepositeryShared().getMosqueID();
    var id_person = await RepositeryShared().getUserID();
    String gen_codebar = Services().getRandomString(21);
    print('-------generate the code bar is : $gen_codebar ------');
    var data = await PrayerProvider().PostToInscriptioPrayer(
      id_mosque: int.parse(id_mosque),
      id_person: int.parse(id_person),
      id_prayer: idPrayer(),
      id_tranche: id_tranch, // probleme mybe is eqaul to i
      date: DateFormat('yyyy-MM-dd')
          .format(DateTime.now()), //'2021-02-26',
      date_heure: DateFormat('yyyy-MM-dd hh:mm:ss')
          .format(DateTime.now()),
      code: gen_codebar, //'RQ#ADCfgC0CHyG8Q#eW0',
    );
    setState(() {
      booking = true;
    });
    //await RepositeryShared().saveRelaionID(id_relation: data['id']);
    await saveRelation(id: data['id']);
    await saveQrCode(id: gen_codebar);
    //await RepositeryShared().saveBarCode(barcode: gen_codebar); /// probleme here in map
    return data;
  }

  Future deletRelation() async {
    var id_relation = await RepositeryShared().getRelationID();
    await PrayerProvider().PostToDeletInscoPrayer(id_relation: id_relation);
    setState(() {
      booking = false;
    });
  }

  Future getIdGroupe() async {
    var id_relation = await RepositeryShared().getGroupeIndex();
    print('Id_relation pleas is : $_id_relation ********');
    return id_relation;
  }

  int idPrayer() {
    switch (widget.tranch) {
      case 'tranche_sobh':
        return 1;
      case 'tranche_dohr':
        return 2;
      case "tranche_asr":
        return 3;
      case "tranche_maghrib":
        return 4;
      case "tranche_ichaa":
        return 5;
    }
  }

  Future saveBooking({bool book}) async {
    switch (widget.prayer) {
      /// prayer name in constructor
      case 'Sobh':
        return await BookingShared().saveBookingSobh(book: book);
      case 'Dohr':
        return await BookingShared().saveBookingDohr(book: book);
      case "Asr":
        return await BookingShared().saveBookingAsr(book: book);
      case "Maghrib":
        return await BookingShared().saveBookingMaghrib(book: book);
      case "Ishaa":
        return await BookingShared().saveBookingIshaa(book: book);
    }
  }

  Future saveRelation({id}) async {
    switch (widget.prayer) {
    /// prayer name in constructor
      case 'Sobh':
        return await RelationShared().saveRelaionIdSobh(id_r: id);
      case 'Dohr':
        return await RelationShared().saveRelaionIdDohr(id_r: id);
      case "Asr":
        return await RelationShared().saveRelaionIdAsr(id_r: id);
      case "Maghrib":
        return await RelationShared().saveRelaionIdMaghrib(id_r: id);
      case "Ishaa":
        return await RelationShared().saveRelaionIdIshaa(id_r: id);
    }
  }

  Future saveQrCode({id}) async {
    switch (widget.prayer) {
    /// prayer name in constructor
      case 'Sobh':
        return await QrCodeShared().saveqrSobh(id_r: id);
      case 'Dohr':
        return await QrCodeShared().saveqrDohr(id_r: id);
      case "Asr":
        return await QrCodeShared().saveqrAsr(id_r: id);
      case "Maghrib":
        return await QrCodeShared().saveqrMaghrib(id_r: id);
      case "Ishaa":
        return await QrCodeShared().saveqrIshaa(id_r: id);
    }
  }


  Future getFieldInformation({id_mosque, id_prayer}) async {
    await PrayerProvider().PostToGetPrayerItemInformation(
      id_mosque: id_mosque,
      id_prayer: id_prayer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white.withOpacity(.9),
      appBar: AppBar(
        //backgroundColor: Colors.teal,
        title: Text('Resarvation'),
        actions: [
          IconButton(
              icon: Icon(Icons.get_app),
              onPressed: () async {
                var result = await BookingShared().getBookingSobh();
//                var prayer = await RepositeryShared().getBookingPrayer();
//                var status = await RepositeryShared().getBookingStatus();
                //await getFieldInformation(id_prayer: 1, id_mosque: 10);
                print('******* List : ${result[1]} ****');
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Text(
                widget.mosque_name.toString(),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 12,
              ),
              Expanded(
                child: FutureBuilder<List<Data>>(
                  future: PrayerProvider().PostToGetServices(id_mosque: widget.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,

                        /// u should change by list get it from method
                        itemBuilder: (context, i) {
                          //double opacity = 1/i;
                          return Container(
                            //color: Colors.teal,
                            height: MediaQuery.of(context).size.height * .08,
                            width: MediaQuery.of(context).size.width * .15,
                            child: Image.network(
                                'https://allocomcompany.com/prayer_organizer/images/services/${snapshot.data[i].logo}'),
                          );
                        });
                  },
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(widget.prayer),
                    Spacer(),
                    Image.asset(
                      widget.image_url,
                      width: 28,
                      height: 28,
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.lightGreenAccent,
                height: MediaQuery.of(context).size.height * .6,
                width: MediaQuery.of(context).size.width * 1,
                child: ListView.builder(
                    itemCount: number_groupe,
                    itemBuilder: (context, i) {
                      return Card(
                        //color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text('Groupe ${i + 1}'),
                            trailing: FutureBuilder(
                                future: PrayerProvider().PostToGetPrayerItemInformation( id_mosque: 10, id_prayer: 1 ),
                                builder: (context, snapshot) {
                                 // int count = int.parse(snapshot.data['count'].toString());
                                 // int place_libre = 15 - int.parse(snapshot.data['data'][0]['nombre'].toString());
                                 // String tranche = snapshot.data['data'][i]['tranche'].toString();
                                  if(!snapshot.hasData) return Text('');
                                  return Text(
                                    //place_libre.toString(),
                                    snapshot.data['data'].toString() ?? '',
                                  );
                                }),
                            leading: FutureBuilder(
                              future: getIdGroupe(),
                              builder: (context, snapshot1) {
                                if(!snapshot1.hasData) return Text('');
                                return IconButton(
                                  icon: snapshot1.data == i && booking == true
                                  /// && booking == true
                                      ? Icon(
                                    Icons.beenhere,
                                    color: Colors.greenAccent,
                                  ) : Icon(Icons.beenhere),
                                );
                              },
                            ),
                            // maybe add inside future builder
//                            IconButton(
//                              icon: _id_relation == i ? Icon(Icons.beenhere, color: Colors.greenAccent,) : Icon(Icons.beenhere),
//                            ),
                            onTap: () async {
                              /// can booking here :
                              print(i);
                              await RepositeryShared().saveGroupeIndex(id_groupe: i);
                              booking == false || booking == null
                                  ? await postInscriptionPrayer(id_tranch: i)
                                  : await deletRelation();
                              print('---- pleas print booking $booking ------');
                              await saveBooking(
                                  book: booking,
                              );
                              // if true make delete
                              //print('---result when user subscribe ${res} -----');
                            },
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
