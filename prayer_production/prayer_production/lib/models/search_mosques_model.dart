class SearchMosques {
  String message;
  int count;
  List<Data> data;

  SearchMosques({this.message, this.count, this.data});

  SearchMosques.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  String designation;
  String adresse;
  String telephone;
  String codePostal;
  String px;
  String py;
  String ville;
  String login;
  String pass;
  String maxPlace; // max places in groupe
  String finishTime;
  /// tranche is groupe
  String trancheSobh;
  String trancheDohr;
  String trancheAsr;
  String trancheMaghrib;
  String trancheIchaa;
  String flagSupp;

  Data({
    this.id,
    this.designation,
    this.adresse,
    this.telephone,
    this.codePostal,
    this.px,
    this.py,
    this.ville,
    this.login,
    this.pass,
    this.maxPlace,
    this.finishTime,
    this.trancheSobh,
    this.trancheDohr,
    this.trancheAsr,
    this.trancheMaghrib,
    this.trancheIchaa,
    this.flagSupp,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    designation = json['designation'];
    adresse = json['adresse'];
    telephone = json['telephone'];
    codePostal = json['code_postal'];
    px = json['px'];
    py = json['py'];
    ville = json['ville'];
    login = json['login'];
    pass = json['pass'];
    maxPlace = json['max_place'];
    finishTime = json['finish_time'];
    trancheSobh = json['tranche_sobh'];
    trancheDohr = json['tranche_dohr'];
    trancheAsr = json['tranche_asr'];
    trancheMaghrib = json['tranche_maghrib'];
    trancheIchaa = json['tranche_ichaa'];
    flagSupp = json['flag_supp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['designation'] = this.designation;
    data['adresse'] = this.adresse;
    data['telephone'] = this.telephone;
    data['code_postal'] = this.codePostal;
    data['px'] = this.px;
    data['py'] = this.py;
    data['ville'] = this.ville;
    data['login'] = this.login;
    data['pass'] = this.pass;
    data['max_place'] = this.maxPlace;
    data['finish_time'] = this.finishTime;
    data['tranche_sobh'] = this.trancheSobh;
    data['tranche_dohr'] = this.trancheDohr;
    data['tranche_asr'] = this.trancheAsr;
    data['tranche_maghrib'] = this.trancheMaghrib;
    data['tranche_ichaa'] = this.trancheIchaa;
    data['flag_supp'] = this.flagSupp;
    return data;
  }
}
