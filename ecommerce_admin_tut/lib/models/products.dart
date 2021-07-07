import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const ID = "id";
  static const NAME = "name";
  static const PICTURE = "picture";
  static const PRICE = "price";
  static const DESCRIPTION = "description";
  static const CATEGORY = "category";
  static const FEATURED = "featured";
  static const QUANTITY = "quantity";
  static const BRAND = "brand";
  static const SALE = "sale";
  static const SIZES = "sizes";
  static const COLORS = "colors";

  ProductModel({
    this.id,
    this.name,
    this.picture,
    this.description,
    this.category,
    this.brand,
    this.quantity,
    this.price,
    this.sale,
    this.featured,
    this.colors,
    this.sizes,
  });
  String id;
  String name;
  String picture;
  String description;
  String category;
  String brand;
  int quantity;
  int price;
  bool sale;
  bool featured;
  List colors;
  List sizes;

//  String get id => _id;
//
//  String get name => _name;
//
//  String get picture => _picture;
//
//  String get brand => _brand;
//
//  String get category => _category;
//
//  String get description => _description;
//
//  int get quantity => _quantity;
//
//  int get price => _price;
//
//  bool get featured => _featured;
//
//  bool get sale => _sale;
//
//  List get colors => _colors;
//
//  List get sizes => _sizes;

  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.data()[ID];
    brand = snapshot.data()[BRAND];
    sale = snapshot.data()[SALE];
    description = snapshot.data()[DESCRIPTION] ?? " ";
    featured = snapshot.data()[FEATURED];
    price = snapshot.data()[PRICE].floor();
    category = snapshot.data()[CATEGORY];
    colors = snapshot.data()[COLORS];
    sizes = snapshot.data()[SIZES];
    name = snapshot.data()[NAME];
    picture = snapshot.data()[PICTURE];
    quantity = snapshot.data()[QUANTITY];
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'picture': picture,
        'description': description,
        'category': category,
        'brand': brand,
        'quantity': quantity,
        'price': price,
        'sale': sale,
        'featured': featured,
        'colors': colors,
        'sizes': sizes,
      };
}
