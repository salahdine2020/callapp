class PrayerTimesModel {
  String message;
  int count;
  List<Data_times> data;

  PrayerTimesModel({this.message, this.count, this.data});

  PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = new List<Data_times>();
      json['data'].forEach((v) {
        data.add(new Data_times.fromJson(v));
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

class Data_times {
  String id;
  String idMosque;
  String idPriere;
  String heure;
  String separationTemps;
  String flagSupp;
  String dateTime;

  Data_times(
      {this.id,
        this.idMosque,
        this.idPriere,
        this.heure,
        this.separationTemps,
        this.flagSupp,
        this.dateTime});

  Data_times.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idMosque = json['id_mosque'];
    idPriere = json['id_priere'];
    heure = json['heure'];
    separationTemps = json['separation_temps'];
    flagSupp = json['flag_supp'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_mosque'] = this.idMosque;
    data['id_priere'] = this.idPriere;
    data['heure'] = this.heure;
    data['separation_temps'] = this.separationTemps;
    data['flag_supp'] = this.flagSupp;
    data['date_time'] = this.dateTime;
    return data;
  }
}