import 'package:flutter/material.dart';
import 'package:prayer_production/controller/api_provider.dart';
import 'package:prayer_production/utils/constants.dart';

enum SingingCharacter { Homme, Femme }

class DialogExample extends StatefulWidget {

  final String nom;
  final String prenom;
  final String code_postal;
  final String num_telephone;
  final String id;
  final String flage_sex;
  final String status_widget;

  DialogExample({
    this.nom,
    this.prenom,
    this.code_postal,
    this.num_telephone,
    this.id,
    this.flage_sex,
    this.status_widget,
  });

  @override
  _DialogExampleState createState() => _DialogExampleState();
}

class _DialogExampleState extends State<DialogExample> {
  TextEditingController _nom;
  TextEditingController _prenom;
  TextEditingController _code_postal;
  TextEditingController _num_telephone;
  //TextEditingController _id;
  //TextEditingController _flag_sex;
  @override
  void initState() {
    // TODO: implement initState
    isInProgress = false;
    _nom = TextEditingController(text: widget.nom);
    _prenom = TextEditingController(text: widget.prenom);
    _code_postal = TextEditingController(text: widget.code_postal);
    _num_telephone = TextEditingController(text: widget.num_telephone);
    //_id = TextEditingController(text: widget.id);
    //_flag_sex = TextEditingController(text: widget.flage_sex);
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  String _gender_category = 'Homme';

  SingingCharacter _character = SingingCharacter.Homme;

  bool isInProgress;

  Future<void> collectInscriptio() async {
    if (mounted) {
      setState(() {
        isInProgress = true;
      });
    }
    await PrayerProvider().PostToUpdateUser(
      nom: _nom.text,
      prenom: _prenom.text,
      num_telephone: _num_telephone.text,
      code_postal: _code_postal.text,
      flag_sexe: _gender_category,
      id: widget.id,
    ).then((v) {
      print('-------- print val when User Update Inscription $v -------');
    });
    if (mounted) {
      setState(() {
        isInProgress =  false;
      });
    }
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

  Future<T> showBottomDialog<T>({@required BuildContext context, String title, String content, Widget titleWidget, Widget contentWidget, List<Widget> actions, bool allowBackNavigation = false,})
  {
//    assert(title != null || titleWidget != null,
//    'title and titleWidget both must not be null');
    assert(content != null || contentWidget != null,
    'content and contentWidget both must not be null');

    final theme = Theme.of(context);

    return showModalBottomSheet(
      //backgroundColor: Colors.yellowAccent,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      isDismissible: allowBackNavigation,
      builder: (context) => WillPopScope(
        onWillPop: () async => allowBackNavigation,
        child: Padding(
          padding: EdgeInsets.all(
              16), //const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titleWidget ??
                  Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
              SizedBox(height: 22),
              if (actions != null)
                ...actions
              else
                OutlineButton(
                  child: Text('GOT IT!'),
                  borderSide: BorderSide(color: theme.primaryColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showBottomDialog(
      context: context,
      allowBackNavigation: true,
      title: widget.nom + '  ' + widget.prenom,
      content: 'Contain TextFormField',
      actions: [
        SwitchWidget(),
      ],
    );
  }
  Widget SwitchWidget(){
    switch(widget.status_widget) {
      case 'update': {
        return Column(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                                  print(
                                      '------- character : $_character ---- value: $value ----');
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: isInProgress ? CircularProgressIndicator() : Text('OUI, UPDATE'),
                onPressed: () async {
                  /// call Update Methode
                  await validate();
                },
              ),
            ),
            FlatButton(
              child: Text('NON'),
              onPressed: () {
                /// call Navigation Pop methode
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
      break;

      case 'code_bar': {
        return Column(
          children: [
            Text('QR CODE'),
            SizedBox(height: 30,),
            Image.asset('assets/images/qr_code.png'),
          ],
        );
      }
      case 'helep': {
        return Column(
          children: [
            Text('Helep'),
            SizedBox(height: 30,),
          ],
        );
      }
      case 'about_us': {
        return Column(
          children: [
            Text('About US'),
            SizedBox(height: 30,),
          ],
        );
      }
      break;
      default: {
        return Container();
      }
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Container(
          height: MediaQuery.of(context).size.height * .07,//16,//kSpacingUnit.w * 5,
          width: MediaQuery.of(context).size.width * .75,//48,//kSpacingUnit.w * 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              16,//kSpacingUnit.w * 1.5,
            ),
            color: Theme.of(context).accentColor,
          ),
          child: Center(
            child: Text(
              'Update',
              style: kButtonTextStyle,
            ),
          ),
        ),
      ),
      onTap: () {
        _showDialog(context);
      },
    );
  }
}