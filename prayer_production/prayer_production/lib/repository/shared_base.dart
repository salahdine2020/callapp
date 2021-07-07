import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositeryShared {

    saveSeenScreen({bool seen}) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setBool('seen', seen);
    }

    Future<bool> getSeenScreen() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        var seen = await sharedPreferences.getBool('seen');
        return seen;
    }

    Future<bool> removeSeenScreen() async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.remove('seen');
    }

    saveUserID(Map<String, dynamic> user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('id', user['id'].toString());
    }

    saveUserGender(Map<String, dynamic> user) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setString('flag_sexe ', user['id'].toString());
    }

    getUserID() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id = sharedPreferences.getString('id');
        print('------ GET ID $id ---------');
        return id;
    }

    saveMosqueID({String id_mosque}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('id_mosque');
        await sharedPreferences.setString('id_mosque', id_mosque);
    }

    getMosqueID() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id = sharedPreferences.getString('id_mosque');
        return id;
    }

    saveRelaionID({String id_relation}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('id_relation');
        await sharedPreferences.setString('id_relation', id_relation);
    }

    getRelationID() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id = sharedPreferences.getString('id_relation');
        return id;
    }

    saveGroupeIndex({int id_groupe}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('id_groupe');
        await sharedPreferences.setInt('id_groupe', id_groupe);
    }

    getGroupeIndex() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        int id = sharedPreferences.getInt('id_groupe');
        return id;
    }

    saveBooking({String prayername, bool book}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('book');
        await sharedPreferences.remove('prayername');
        await sharedPreferences.setBool('book', book);
        await sharedPreferences.setString('prayername', prayername);
    }

    getBookingPrayer() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String prayername = sharedPreferences.getString('prayername');
        return prayername;
    }

    getBookingStatus() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        bool book = sharedPreferences.getBool('book');
        return book;
    }

    removeBookingPrayer() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('prayername');
    }

    removeBookingStatus() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('book');
    }
    saveBarCode({String barcode}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('barcode');
        await sharedPreferences.setString('barcode', barcode);
    }

    getBarCode() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String barcode = sharedPreferences.getString('barcode');
        return barcode;
    }
}

class BookingShared {

    saveBookingSobh({bool book}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('book_sobh');
        await sharedPreferences.remove('Sobh');
        await sharedPreferences.setBool('book_sobh', book);
        await sharedPreferences.setString('Sobh', 'Sobh');
    }

    Future getBookingSobh() async {
        List<dynamic> result = [];
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        var prayer = await sharedPreferences.getString('Sobh');
        var status = await sharedPreferences.getBool('book_sobh');
        result.add(prayer);
        result.add(status);
        return result;
    }

    saveBookingDohr({bool book}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('book_dohr');
        await sharedPreferences.remove('Dohr');
        await sharedPreferences.setBool('book_dohr', book);
        await sharedPreferences.setString('Dohr', 'Dohr');
    }

    Future getBookingDohr() async {
        List<dynamic> result = [];
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        var prayer = await sharedPreferences.getString('Dohr');
        var status = await sharedPreferences.getBool('book_dohr');
        result.add(prayer);
        result.add(status);
        return result;
    }

    saveBookingAsr({bool book}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('book_asr');
        await sharedPreferences.remove('Asr');
        await sharedPreferences.setBool('book_asr', book);
        await sharedPreferences.setString('Asr', 'Asr');
    }

    Future getBookingAsr() async {
        List<dynamic> result = [];
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        var prayer = await sharedPreferences.getString('Asr');
        var status = await sharedPreferences.getBool('book_asr');
        result.add(prayer);
        result.add(status);
        return result;
    }

    saveBookingMaghrib({bool book}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('book_maghrib');
        await sharedPreferences.remove('Maghrib');
        await sharedPreferences.setBool('book_maghrib', book);
        await sharedPreferences.setString('Maghrib', 'Maghrib');
    }

    Future getBookingMaghrib() async {
        List<dynamic> result = [];
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        var prayer = await sharedPreferences.getString('Maghrib');
        var status = await sharedPreferences.getBool('book_maghrib');
        result.add(prayer);
        result.add(status);
        return result;
    }

    saveBookingIshaa({bool book}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('book_Ishaa');
        await sharedPreferences.remove('Ishaa');
        await sharedPreferences.setBool('book_Ishaa', book);
        await sharedPreferences.setString('Ishaa', 'Ishaa');
    }

    Future getBookingIshaa() async {
        List<dynamic> result = [];
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        var prayer = await sharedPreferences.getString('Ishaa');
        var status = await sharedPreferences.getBool('book_Ishaa');
        result.add(prayer);
        result.add(status);
        return result;
    }

    removeBooking({String prayer_remove}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.remove(prayer_remove);
    }



}

class RelationShared{

    saveRelaionIdSobh({String id_r}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('idr_sobh');
        await sharedPreferences.setString('idr_sobh', id_r);
    }

    getRelationIdSobh() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id_r = sharedPreferences.getString('idr_sobh');
        return id_r;
    }

    removeRelationIdSobh() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('idr_sobh');
    }

    saveRelaionIdDohr({String id_r}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('idr_dohr');
        await sharedPreferences.setString('idr_dohr', id_r);
    }

    getRelationIdDohr() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id_r = sharedPreferences.getString('idr_dohr');
        return id_r;
    }

    removeRelationIdDohr() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('idr_dohr');
    }

    saveRelaionIdAsr({String id_r}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('idr_asr');
        await sharedPreferences.setString('idr_asr', id_r);
    }

    getRelationIdAsr() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id_r = sharedPreferences.getString('idr_asr');
        return id_r;
    }

    removeRelationIdAsr() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('idr_asr');
    }

    saveRelaionIdMaghrib({String id_r}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('idr_maghrib');
        await sharedPreferences.setString('idr_maghrib', id_r);
    }

    getRelationIdMaghrib() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id_r = sharedPreferences.getString('idr_maghrib');
        return id_r;
    }

    removeRelationIdMaghrib() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('idr_maghrib');
    }

    saveRelaionIdIshaa({String id_r}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('idr_ishaa');
        await sharedPreferences.setString('idr_ishaa', id_r);
    }

    getRelationIdIshaa() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id_r = sharedPreferences.getString('idr_ishaa');
        return id_r;
    }

    removeRelationIdIshaa() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('idr_ishaa');
    }


}

class QrCodeShared{
    saveqrSobh({String id_r}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('qr_sobh');
        await sharedPreferences.setString('qr_sobh', id_r);
    }

    getqrSobh() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id_r = sharedPreferences.getString('qr_sobh');
        return id_r;
    }

    removeqrSobh() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('qr_sobh');
    }

    saveqrDohr({String id_r}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('qr_dohr');
        await sharedPreferences.setString('qr_dohr', id_r);
    }

    getqrDohr() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id_r = sharedPreferences.getString('qr_dohr');
        return id_r;
    }

    removeqrDohr() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('qr_dohr');
    }

    saveqrAsr({String id_r}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('qr_asr');
        await sharedPreferences.setString('qr_asr', id_r);
    }

    getqrAsr() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id_r = sharedPreferences.getString('qr_asr');
        return id_r;
    }

    removeqrAsr() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('qr_asr');
    }

    saveqrMaghrib({String id_r}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('qr_maghrib');
        await sharedPreferences.setString('qr_maghrib', id_r);
    }

    getqrMaghrib() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id_r = sharedPreferences.getString('qr_maghrib');
        return id_r;
    }

    removeqrMaghrib() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('qr_maghrib');
    }

    saveqrIshaa({String id_r}) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('qr_ishaa');
        await sharedPreferences.setString('qr_ishaa', id_r);
    }

    getqrIshaa() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id_r = sharedPreferences.getString('qr_ishaa');
        return id_r;
    }

    removeRelationIdIshaa() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.remove('qr_ishaa');
    }
}