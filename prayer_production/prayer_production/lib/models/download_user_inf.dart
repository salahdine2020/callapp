class DownloadUsermModel {
  String id;
  String nom;
  String prenom;
  String sexe;
  String codePostal;
  String numTelephone;
  String flagEtat;

  DownloadUsermModel({
    this.id,
    this.nom,
    this.prenom,
    this.sexe,
    this.codePostal,
    this.numTelephone,
    this.flagEtat,
  });

  DownloadUsermModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    sexe = json['sexe'];
    codePostal = json['code_postal'];
    numTelephone = json['num_telephone'];
    flagEtat = json['flag_etat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['prenom'] = this.prenom;
    data['sexe'] = this.sexe;
    data['code_postal'] = this.codePostal;
    data['num_telephone'] = this.numTelephone;
    data['flag_etat'] = this.flagEtat;
    return data;
  }
}
