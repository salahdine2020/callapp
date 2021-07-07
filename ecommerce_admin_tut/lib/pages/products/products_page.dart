//import 'dart:io';
import 'dart:core';
import 'dart:core';
import 'dart:html';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_tut/models/products.dart';
import 'package:ecommerce_admin_tut/provider/tables.dart';
import 'package:ecommerce_admin_tut/rounting/route_names.dart';
import 'package:ecommerce_admin_tut/services/navigation_service.dart';
import 'package:ecommerce_admin_tut/services/products.dart';
import 'package:ecommerce_admin_tut/widgets/choice_list.dart';
import 'package:ecommerce_admin_tut/widgets/page_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_image_picker/flutter_web_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_table/ResponsiveDatatable.dart';
import 'package:responsive_table/responsive_table.dart';
import '../../locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase/firebase.dart' as fb;

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController brand = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController price = TextEditingController();
  Map<String, bool> List = {
    'Egges': false,
    'Chocolates': false,
    'Flour': false,
    'Fllower': false,
    'Fruits': false,
  };
  var holder_1 = [];
  String imagePath;
  File imageFile;
  final _picker = ImagePicker();
  Image image;
  String imgUrl;
  String pathcomplet;
  String url;
  String newurl;
  fb.UploadTask _uploadTask;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TablesProvider tablesProvider = Provider.of<TablesProvider>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              PageHeader(
                text: 'Products',
              ),
              Spacer(),
              RaisedButton.icon(
                onPressed: () {
                  // 1/delet Items selected
                  //tablesProvider.selecteds[0].keys.first;
                  var listIdsdelet = [];
                  for(int i = 0; i < tablesProvider.selecteds.length ; i++){
                    var valueKey = tablesProvider.selecteds[i].values.first;
                    listIdsdelet.add(valueKey);
                    print('${listIdsdelet[i]}');
                    ProductsServices().deletById(ID: listIdsdelet[i].toString());
                  }
                },
                icon: Icon(Icons.delete),
                label: Text("DELETE"),
              ),
              SizedBox(
                width: 16,
              ),
            ],
          ),
//          PageHeader(
//            text: 'Products',
//          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(0),
            constraints: BoxConstraints(
              maxHeight: 700,
            ),
            child: Card(
              elevation: 1,
              shadowColor: Colors.black,
              clipBehavior: Clip.none,
              child: ResponsiveDatatable(
                title: !tablesProvider.isSearch
                    ? RaisedButton.icon(
                        onPressed: () {
                          // 1/add Alert Dialog with Form  + ImagePicker.
                          // 2/add Product.
                          //ProductsServices().addProduct(product3);
                          //locator<NavigationService>().globalNavigateTo(FormInputRoute, context);
                          //globalNavigateTo(LayoutRoute, context);
                          AlertDialogForm();
                          print('wait add function');
                        },
                        icon: Icon(Icons.add),
                        label: Text("ADD PRODUCT"),
                      )
                    : null,
                actions: [
                  if (tablesProvider.isSearch)
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  tablesProvider.isSearch = false;
                                });
                              }),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  if (!tablesProvider.isSearch)
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            tablesProvider.isSearch = true;
                          });
                        })
                ],
                headers: tablesProvider.productsTableHeader,
                source: tablesProvider.productsTableSource,
                selecteds: tablesProvider.selecteds,
                showSelect: tablesProvider.showSelect,
                autoHeight: false,
                onTabRow: (data) {
                  // here check radio button
                  // check : true, non check : false
                  Map map = Map<int, String>();
                  map = data;
                  print(map.keys);
                },
                onSort: tablesProvider.onSort,
                sortAscending: tablesProvider.sortAscending,
                sortColumn: tablesProvider.sortColumn,
                isLoading: tablesProvider.isLoading,
                onSelect: tablesProvider.onSelected,
                onSelectAll: tablesProvider.onSelectAll,
                footers: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text("Rows per page:"),
                  ),
                  if (tablesProvider.perPages != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButton(
                        value: tablesProvider.currentPerPage,
                        items: tablesProvider.perPages
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text("$e"),
                                value: e,
                              ),
                            )
                            .toList(),
                        onChanged: (value) {},
                      ),
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "${tablesProvider.currentPage} - ${tablesProvider.currentPage} of ${tablesProvider.total}",
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                    ),
                    onPressed: tablesProvider.previous,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: tablesProvider.next,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget AlertDialogForm() {
    return showAlertDialog(context);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        //not work here : locator<NavigationService>().goBack();
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("ADD"),
      onPressed: () async {
        ProductModel product = ProductModel(
          name: name.text,
          picture: url ?? '',///await Uri.parse(url) ?? '',
          description: description.text,
          category: category.text,
          brand: brand.text,
          quantity: int.parse(quantity.text.toString()),
          price: int.parse(price.text.toString()),
          sale: false,
          featured: false,
          colors: ['Red', 'Black', 'White', 'Blue'],
          sizes: ['X', 'XM', 'A', 'L'],
        );
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          ProductsServices().addProduct(product);
          clearcontroller();
          //uploadToStorage2();
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ADD PRODUCT"),
      content: Container(
        height: MediaQuery.of(context).size.height * .6,
        width: MediaQuery.of(context).size.width * .3,
        child: ListView(
          shrinkWrap: true,
          children: [
            nameField(
                label: 'product', hinit: 'product name', controllerVal: name),
            nameField(
                label: 'description',
                hinit: 'write some product description',
                controllerVal: description),
            nameField(
                label: 'category',
                hinit: 'ex: clothes',
                controllerVal: category),
            nameField(label: 'brand', hinit: 'ex: Nike', controllerVal: brand),
            nameField(
                label: 'quantity', hinit: 'ex: 12', controllerVal: quantity),
            nameField(label: 'price', hinit: 'ex: 1200£', controllerVal: price),
            Row(
              children: [
                Text('select Image for Product'),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: () {
                      //getImageWeb();
                      //getGalleryImage();
                      uploadToStorage2();
                    }),
              ],
            ),
            Container(
//              child: CachedNetworkImage(
//                imageUrl:'' ?? "http://via.placeholder.com/350x150",
//                progressIndicatorBuilder: (context, url, downloadProgress) =>
//                CircularProgressIndicator(value: downloadProgress.progress),
//                errorWidget: (context, url, error) => Icon(Icons.error),
//              ),
            child: StreamBuilder<Uri>(
              stream: downloadUrl(url ?? 'images/2021-03-28 12:11:22.162.png').asStream(),
              builder: (context, snapshot) {
                //print(snapshot.data.toString());
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return CircleAvatar(
                  radius: 48,
                  child: Image.network(snapshot.data.toString()),
                );
              },
            ),
            ),
          ],
        ),
      ),
      actions: [
        //cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: alert,
          ),
        );
        //alert;
      },
    );
  }

  AlertDialog alertsucces = AlertDialog(
    title: Text(
      "🙂",
      style: TextStyle(fontSize: 48),
    ),
    content: Container(
      child: Text('Added succefully 👌'),
    ),
  );

  Widget nameField({hinit, label, TextEditingController controllerVal}) {
    return TextFormField(
      controller: controllerVal,
      decoration: InputDecoration(labelText: label, hintText: hinit),
      validator: (val) => val.isEmpty ? 'Name is required' : null,
      onSaved: (String value) {
        controllerVal.text = value;
      },
    );
  }

  void getGalleryImage() async {
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
      if (kIsWeb) {
        image = Image.network(pickedFile.path);
        //ProductsServices().uploadToStorage();
        //ProductsServices().uploadImage(onSelected:(_){});
        //ProductsServices().uploadImageProduct(File(imagePath));
        //print(File(imagePath));
        //uploadToStorage2();
        //uploadToFirebase(file);
      } else {
        //image = Image.file(File(pickedFile.path));
      }
      print(image);
    } else {
      print('No image selected.');
    }
  }

  uploadToStorage2() {
    InputElement input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((ev) {
      final file = input.files.first;
      print(ev.path);
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((e) async {
        print(file.toString());
        print(e.path);
        uploadToFirebase(file);
//        var snapshot = await fs.ref().child('newfile').putBlob(file);
//        String downloadUrl = await snapshot.ref.getDownloadURL();
//        print(downloadUrl);
//        setState(() {
//          imgUrl = downloadUrl;
//        });
      });
    });
  }

  uploadToFirebase(File imageFile) async {
    final filePath = 'images/${DateTime.now()}.png'; //
    setState(() {
      _uploadTask = fb
          .storage()
          .refFromURL('gs://mailer2-beb83.appspot.com')
          .child(filePath)
          .put(imageFile);
    });
    _uploadTask.future.then((v) async {
     /// url = v.ref.fullPath;
      /// var res = await downloadUrl(url);
      setState(() {
        /// newurl = res.toString();
        /// String url = await v.ref.getDownloadURL();
        url = v.ref.fullPath;
      });
    });
  }

  Future<Uri> downloadUrl(String photoUrl) {
    return fb
        .storage()
        .refFromURL('gs://mailer2-beb83.appspot.com')
        .child(photoUrl)
        .getDownloadURL();
  }

  getItems() {
    List.forEach((key, value) {
      if (value == true) {
        holder_1.add(key);
      }
    });
    print(holder_1);
    holder_1.clear();
  }

  Widget selectColor() {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: List.keys.map((String key) {
        return CheckboxListTile(
          title: Text(key),
          value: List[key],
          activeColor: Colors.deepPurple[400],
          checkColor: Colors.white,
          onChanged: (bool value) {
            setState(() {
              List[key] = value;
            });
          },
        );
      }).toList(),
    );
  }

  void clearcontroller() {
    name.clear();
    description.clear();
    category.clear();
    brand.clear();
    quantity.clear();
    price.clear();
  }
}
