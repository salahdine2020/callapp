import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_tut/helpers/costants.dart';
import 'package:ecommerce_admin_tut/models/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ProductsServices {
  User _user;
  String collection = "products";
  String subcollection = "product";
  Future<List<ProductModel>> getAllProducts() async => firebaseFiretore
          .collection(collection)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection(subcollection)
          .get()
          .then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });
  Future<ProductModel> addProduct(ProductModel product) async {
    firebaseFiretore
        .collection(collection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(subcollection)
        .add(product.toJson())
        .then((v) => updateId(v.id));
  }

  Future<ProductModel> updateId(String Id) async {
    firebaseFiretore
        .collection(collection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(subcollection)
        .doc(Id)
        .update({
      'id': Id,
    });
  }

  Future<void> deletById({String ID}) async {
      var userUid = FirebaseAuth.instance.currentUser.uid;
      print(userUid);
      firebaseFiretore
          .collection(collection)
          .doc(userUid.toString())
          .collection(subcollection)
          .doc(ID)
          .delete()
          .then((value) => print("Product Deleted"))
          .catchError(
            (error) => print(
              "Failed to delete user: $error",
            ),
          );

  }
//
//  Future<String> uploadImageProduct(File imageFile) async {
//    String photoId = Uuid().v4();
//    File image = await compressImage(photoId, imageFile);
//    UploadTask uploadTask = FirebaseStorage.instance
//        .ref()
//        .child('images/product/product_$photoId.jpg')
//        .putFile(image);
//    TaskSnapshot storageSnap = await uploadTask;
//    String downloadUrl = await storageSnap.ref.getDownloadURL();
//    return downloadUrl;
//  }
//
//  Future<File> compressImage(String photoId, File image) async {
//    final tempDir = await getTemporaryDirectory();
//    final path = tempDir.path;
//    File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
//      image.absolute.path,
//      '$path/img_$photoId.jpg',
//      quality: 70,
//    );
//    return compressedImageFile;
//  }

  void uploadImage({@required Function(File file) onSelected}) {
    InputElement uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }

  Future<void> uploadToStorage() {
//    User user;
    final dateTime = DateTime.now();
//    final userId = user.uid;
    // final path = '$image/$dateTime';
    uploadImage(onSelected: (file) async {
//        fb
//            .storage()
//            .refFromURL('gs://happy-haris-play.appspot.com/')
//            .child(path)
//            .put(file)
//            .future
//            .then((_) {
      FirebaseFirestore.instance
          .collection('Imagees_product_linck')
          .add({'picture': file.toString()});
      //.doc(user.uid)
      //.update({'picture': path});
    });

    /*
       UploadTask uploadTask = FirebaseStorag.instance.ref().child('images/product/product_$path.jpg').putFile(file);
       TaskSnapshot storageSnap = await uploadTask;
       String downloadUrl = await storageSnap.ref.getDownloadURL();
       return downloadUrl;
       */
  }
}
