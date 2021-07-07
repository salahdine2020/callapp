import 'package:flutter/material.dart';
import 'package:prayer_production/controller/api_provider.dart';
import 'package:prayer_production/repository/shared_base.dart';
import 'package:prayer_production/views/check_succes.dart';
import 'package:prayer_production/widgets/gender_field.dart';

enum SingingCharacter { Homme, Femme }
class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nom = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _code_postal = TextEditingController();
  TextEditingController _num_telephone = TextEditingController();
  String _gender_category = 'Homme';

  Future<void> collectInscriptio() async {
    await PrayerProvider().PostFieldInscription(
        nom: _nom.text,
        prenom: _prenom.text,
        num_telephone: _num_telephone.text,
        code_postal: _code_postal.text,
        flag_sexe: _gender_category,
    ).then((v) {
      print('-------- print val when User Inscription $v -------');
    });
  }
  Future<bool> validate() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await collectInscriptio();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Processing Data'),
        ),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enter values'),
        ),
      );
      return false;
    }
  }
  SingingCharacter _character = SingingCharacter.Homme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
//      appBar: AppBar(
//        //backgroundColor: Colors.teal,
//        title: Text('Enregistrer'),
//        centerTitle: true,
////        actions: [
////          IconButton(
////              icon: Icon(Icons.info_sharp),
////              onPressed: () async {
////                await PrayerProvider().PostFieldInscription(
////                  nom: '_nom.text',
////                  prenom: '_prenom.text',
////                  num_telephone: '_num_telephone.text',
////                  code_postal: '_code_postal.text',
////                  flag_sexe: '_gender_category',
////                ).then((v) {
////                  print('-------- print val when User Inscription $v -------');
////                });
////              }),
////          IconButton(
////              icon: Icon(Icons.get_app),
////              onPressed: () async {
////                await RepositeryShared().getUserID();
////              }),
////        ],
//      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      child: Image.asset(
                        'assets/images/prayer_mosque_logo.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nom',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                          ),
                          controller: _nom,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'PRENOME ',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                          ),
                          controller: _prenom,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
//                      Padding(
//                        padding: EdgeInsets.all(2),
//                        child: GenderField(['Male', 'Female']),
//                      ),
                        Row(
                          children: <Widget>[
                            Text('Homme'),
                            Radio<SingingCharacter>(
                              value: SingingCharacter.Homme,
                              groupValue: _character,
                              onChanged: (SingingCharacter value) {
                                setState(() {
                                  _character = value;
                                  _gender_category = 'Homme';
                                });
                                print('------- character : $_character ---- value: $value ----');
                              },
                            ),
                            Text('Femme'),
                            Radio<SingingCharacter>(
                              value: SingingCharacter.Femme,
                              groupValue: _character,
                              onChanged: (SingingCharacter value) {
                                setState(() {
                                  _character = value;
                                  _gender_category = 'Femme';
                                });
                              },
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _code_postal,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                            labelText: 'CODE POSTAL',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              if (value.length == 3 || value.length == 4) {
                                return null;
                              }
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _num_telephone,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                            labelText: 'TELEPHONE',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              if (value.length == 10 || value.length == 13) {
                                return null;
                              }
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 40),
                        Container(
                          height: 60,
                          child: Material(
                            borderRadius: BorderRadius.circular(6),
                            shadowColor: Colors.teal,
                            color: Colors.teal,
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () async {
                                /// validate first
                                bool correct = await validate();
                                if (correct) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CheckSucces(),
                                    ),
                                  );
                                }
                              },
                              child: Center(
                                child: Text(
                                  'ENREGESTRER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
