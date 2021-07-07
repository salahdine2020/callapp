import 'package:emall_app/EmallApp/utils/TextUtils.dart';

class Account{


  String name,email,token,avatarUrl;

  Account(this.name, this.email, this.token,this.avatarUrl);

  Account.empty(){
    name="";
    email="";
    token="";
  }
  /// return link of Image to access it withe http requests
  getAvatarUrl(){
    return TextUtils.getImageUrl(avatarUrl);
  }



}