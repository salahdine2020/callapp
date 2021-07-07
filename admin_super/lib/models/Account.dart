
import 'package:admin_super/utils/TextUtils.dart';

class Account{


  String name,email,token,avatarUrl;

  Account(this.name, this.email, this.token,this.avatarUrl);

  Account.empty(){
    name="";
    email="";
    token="";
  }

  getAvatarUrl(){
    return TextUtils.getImageUrl(avatarUrl);
  }



}