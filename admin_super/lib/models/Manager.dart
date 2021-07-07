
import 'package:admin_super/utils/TextUtils.dart';

class Manager{

  int id;
  String name;
  String email;
  String avatarUrl;

  Manager(this.id, this.name, this.email, this.avatarUrl);

  static fromJson(Map<String,dynamic> jsonObject){

    int id = int.parse(jsonObject['id'].toString());
    String name = jsonObject['name'].toString();
    String email = jsonObject['email'].toString();
    String avatarUrl = jsonObject['avatar_url'].toString();

    return Manager(id, name, email, avatarUrl);
  }


}