import 'package:emall_app/EmallApp/models/Product.dart';

class Favorite{

  int id,productId;
  Product product;
  Favorite(this.id, this.productId, this.product);

  static Favorite fromJson(Map<String, dynamic> jsonObject) {
    int id = int.parse(jsonObject['id'].toString());
    int productId = int.parse(jsonObject['product_id'].toString());
    Product product;
    if(jsonObject['product']!=null)
      product = Product.fromJson(jsonObject['product'])..isFavorite = true;
    print('------fromJson favorite Product $id and $productId and $product-------------');
    return Favorite(id, productId, product);
  }

  static List<Favorite> getListFromJson(List<dynamic> jsonArray) {
    List<Favorite> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      list.add(Favorite.fromJson(jsonArray[i]));
      print('------Totale list of favorite Product ${list[i].productId} -------------');
    }
    return list;
  }

}