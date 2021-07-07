import 'package:flutter/material.dart';

class GetServices {
  String message;
  int count; /// length of list
  List<Data> data;

  GetServices({this.message, this.count, this.data});

  GetServices.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String designation; // contain services
  String logo;
  String flag;
  String idr;

  Data({this.id, this.designation, this.logo, this.flag, this.idr});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    designation = json['designation'];
    logo = json['logo'];
    flag = json['flag'];
    idr = json['idr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['designation'] = this.designation;
    data['logo'] = this.logo;
    data['flag'] = this.flag;
    data['idr'] = this.idr;
    return data;
  }
}