import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:booking_fustal/AppoinmentDoctore/screens/myAppointments.dart';
import 'package:intl/intl.dart';

String selectedChoice = "selection le tempe";
int salle2;

class BookingScreen extends StatefulWidget {
  final String doctor;
  final String docId;
  const BookingScreen({Key key, this.doctor, this.docId}) : super(key: key);
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController(
      text: selectedChoice.toString() == ""
          ? 'no time'
          : selectedChoice.toString());

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime selectedDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String timeText = 'Select Time';
  String dateUTC;
  String date_Time;
  int salle;
  //String selectedChoice = "";

  List<String> reportList = [
    "8:00AM  9:00AM",
    "9:00AM  10:00AM",
    "10:00AM  11:00AM",
    "11:00AM  12:00AM",
    "12:00AM  13:00AM",
    "13:00AM  14:00AM",
    "14:00AM  15:00AM",
    "15:00AM  16:00AM",
    "16:00AM  17:00AM",
    "17:00AM  18:00AM",
    "18:00AM  19:00AM",
    "19:00AM  20:00AM",
  ];

  FirebaseAuth _auth = FirebaseAuth.instance;

  User user;

  switchindexes({index}) {
    print('initiale number of salle is : $salle');
    //    int time1 = salle;
//    int time2 = salle;
//    int time3 = salle;
//    int time4 = salle;
//    int time5 = salle;
//    int time6 = salle;
//    int time7 = salle;
//    int time8 = salle;
//    int time9 = salle;
//    int time10 = salle;
//    int time11 = salle;
//    int time12 = salle;

    Future<void> deleteField({index}) {
      CollectionReference doctors =
          FirebaseFirestore.instance.collection('doctors');
      return doctors
          .doc(widget.docId)
          .update({
            'listtimes': FieldValue.arrayRemove([index]),
          })
          .then((value) => print("User's Property Deleted"))
          .catchError(
            (error) => print(
              "Failed to delete user's property: $error",
            ),
          );
    }

    switch (index) {
      case 0:
        {
          // TODO: decrement from time1
          int time1 = --salle;
          print('time1 is : $time1');
          if (time1 == 0) {
            print('time1 in else statment is : $time1');
            setState(() {
              salle = salle2; // get it from firebase directly
            });

            /// TODO: delet item from firebase
            deleteField(index: "8:00AM  9:00AM");
            reportList.removeAt(index);
          }
        }
        break;
      case 1:
        {
          int time2 = --salle;
          print('time2 is : $time2');
          if (time2 == 0) {
            print('time2 in else statment is : $time2');
            setState(() {
              salle = salle2; // get it from firebase directly
            });
            reportList.removeAt(index);
          }
        }
        break;
      case 2:
        {
          /// TODO: decrement from time1
          int time3 = --salle;
          print('time3 is : $time3');
          if (time3 == 0) {
            print('time3 in else statment is : $time3');
            setState(() {
              salle = salle2; // get it from firebase directly
            });
            reportList.removeAt(index);
          }
        }
        break;
      case 3:
        {
          /// TODO: decrement from time1

          int time4 = --salle;
          print('time4 is : $time4');
          if (time4 == 0) {
            print('time4 in else statment is : $time4');
            setState(() {
              salle = salle2; // get it from firebase directly
            });
            reportList.removeAt(index);
          }
        }
        break;
      case 4:
        {
          int time5 = --salle;
          print('time5 is : $time5');
          if (time5 == 0) {
            print('time5 in else statment is : $time5');
            setState(() {
              salle = salle2; // get it from firebase directly
            });
            reportList.removeAt(index);
          }
        }
        break;
      case 5:
        {
          int time6 = --salle;
          print('time6 is : $time6');
          if (time6 == 0) {
            print('time6 in else statment is : $time6');
            setState(() {
              salle = salle2; // get it from firebase directly
            });
            reportList.removeAt(index);
          }
        }
        break;
      case 6:
        {
          int time7 = --salle;
          print('time7 is : $time7');
          if (time7 == 0) {
            print('time7 in else statment is : $time7');
            setState(() {
              salle = salle2; // get it from firebase directly
            });
            reportList.removeAt(index);
          }
        }
        break;
      case 7:
        {
          int time8 = --salle;
          print('time8 is : $time8');
          if (time8 == 0) {
            print('time8 in else statment is : $time8');
            setState(() {
              salle = salle2; // get it from firebase directly
            });
            reportList.removeAt(index);
          }
        }
        break;
      case 8:
        {
          int time9 = --salle;
          print('time1 is : $time9');
          if (time9 == 0) {
            print('time9 in else statment is : $time9');
            setState(() {
              salle = salle2; // get it from firebase directly
            });
            reportList.removeAt(index);
          }
        }
        break;
      case 9:
        {
          int time10 = --salle;
          print('time10 is : $time10');
          if (time10 == 0) {
            print('time1 in else statment is : $time10');
            setState(() {
              salle = salle2; // get it from firebase directly
            });
            reportList.removeAt(index);
          }
        }
        break;
      case 10:
        {
          int time11 = --salle;
          print('time11 is : $time11');
          if (time11 == 0) {
            print('time11 in else statment is : $time11');
            setState(() {
              salle = salle2; // get it from firebase directly
            });
            reportList.removeAt(index);
          }
        }
        break;
      case 11:
        {
          int time12 = --salle;
          print('time12 is : $time12');
          if (time12 == 0) {
            print('time12 in else statment is : $time12');
            setState(() {
              salle = salle2; // get it from firebase directly
            });
            reportList.removeAt(index);
          }
        }
        break;
      default:
        {
          print("Invalid choice");
        }
        break;
    }
  }

  /// TODO:get number of salle
  getsallenumber({docId = '7sctWrXekNmPTaTiue3C'}) async {
    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(docId)

        /// TODO : change when change doctor choice replace after
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var salle1 = documentSnapshot.get(FieldPath(['salle']));
        setState(() {
          salle = salle1;
          salle2 = salle1;
        });
        print('Document exists on the database : $salle');
      }
    });
  }

  Future getliattimes({docId = '7sctWrXekNmPTaTiue3C'}) async {
    List<dynamic> listtimes = [];
    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(docId)

        /// TODO : change when change doctor choice replace after
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        listtimes = documentSnapshot.get(FieldPath(['listtimes']));
        print(
            'Document exists on the database list is : ${listtimes[0]} and type is : ${listtimes.runtimeType}');
      }
    });
    return listtimes;
  }

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    ).then(
      (date) {
        setState(
          () {
            selectedDate = date;
            String formattedDate =
                DateFormat('dd-MM-yyyy').format(selectedDate);
            _dateController.text = formattedDate;
            dateUTC = DateFormat('yyyy-MM-dd').format(selectedDate);
          },
        );
      },
    );
  }

  showReportDialogChips() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog

          return AlertDialog(
            title: Text("Les Houraires Disponible"),
            content:

                /// TODO: get it from firebase
                MultiSelectChip(
              reportList,
              docId: widget.docId,
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text("Reserve"),
                  onPressed: () async {
                    /// TODO : save in TextField
                    /// TODO: delet time selection from liste if < number of salle
                    ///  TODO: get it from firebase
                    int indexr = reportList.indexOf(selectedChoice);
                    print(
                        'reportList is ${reportList.indexOf(selectedChoice)}');

                    /// TODO:  salle-- var  and update from firebase
                    /// TODO:
                    //getsallenumber();
                    print('number of salle is : $salle');
                    var res = await getliattimes();
                    print('list result is : $res');
                    switchindexes(index: indexr);
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(selectedTime,
        alwaysUse24HourFormat: false);

    if (formattedTime != null) {
      setState(() {
        timeText = formattedTime;
        _timeController.text = timeText;
      });
    }
    date_Time = selectedTime.toString().substring(10, 15);
  }

  /// TODO: change into chip multi selection of time
  /// String selectedChoice = "";
  /// this function will build and return the choice list

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyAppointments(),
          ),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Done!",
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Appointment is registered.",
        style: GoogleFonts.lato(),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print('document get it by Constructor is : ${widget.docId}');
    getsallenumber(docId: widget.docId);
    _getUser();
    selectTime(context);
    _doctorController.text = widget.doctor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Appointment booking',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return;
          },
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                child: Image(
                  image: AssetImage('assets/appointment.jpg'),
                  height: 250,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Enter Patient Details',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _nameController,
                        focusNode: f1,
                        validator: (value) {
                          if (value.isEmpty) return 'Please Enter Patient Name';
                          return null;
                        },
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[350],
                          hintText: 'Patient Name*',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onFieldSubmitted: (String value) {
                          f1.unfocus();
                          FocusScope.of(context).requestFocus(f2);
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        focusNode: f2,
                        controller: _phoneController,
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[350],
                          hintText: 'Mobile*',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Phone number';
                          } else if (value.length < 10) {
                            return 'Please Enter correct Phone number';
                          }
                          return null;
                        },
                        onFieldSubmitted: (String value) {
                          f2.unfocus();
                          FocusScope.of(context).requestFocus(f3);
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: f3,
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[350],
                          hintText: 'Description',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onFieldSubmitted: (String value) {
                          f3.unfocus();
                          FocusScope.of(context).requestFocus(f4);
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        enabled: false,
                        controller: _doctorController,
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter Doctor name';
                          return null;
                        },
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[350],
                          hintText: 'Doctor Name*',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              focusNode: f4,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left: 20,
                                  top: 10,
                                  bottom: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[350],
                                hintText: 'Select Date*',
                                hintStyle: GoogleFonts.lato(
                                  color: Colors.black26,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              controller: _dateController,
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please Enter the Date';
                                return null;
                              },
                              onFieldSubmitted: (String value) {
                                f4.unfocus();
                                FocusScope.of(context).requestFocus(f5);
                              },
                              textInputAction: TextInputAction.next,
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: ClipOval(
                                child: Material(
                                  color: Colors.indigo, // button color
                                  child: InkWell(
                                    // inkwell color
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        Icons.date_range_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      selectDate(context);
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          //alignment: Alignment.centerRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                selectedChoice.toString(),
                                style: GoogleFonts.lato(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),

                            Spacer(),
//                            TextFormField(
//                              //enabled: false,
//                              focusNode: f5,
//                              decoration: InputDecoration(
//                                contentPadding: EdgeInsets.only(
//                                  left: 20,
//                                  top: 10,
//                                  bottom: 10,
//                                ),
//                                border: OutlineInputBorder(
//                                  borderRadius:
//                                      BorderRadius.all(Radius.circular(90.0)),
//                                  borderSide: BorderSide.none,
//                                ),
//                                filled: true,
//                                fillColor: Colors.grey[350],
//                                hintText: 'Select Time*',
//                                hintStyle: GoogleFonts.lato(
//                                  color: Colors.black26,
//                                  fontSize: 18,
//                                  fontWeight: FontWeight.w800,
//                                ),
//                              ),
//                              controller: _timeController,
//                              validator: (value) {
//                                if (value.isEmpty)
//                                  return 'Please Enter the Time';
//                                return null;
//                              },
//                              onFieldSubmitted: (String value) {
//                                f5.unfocus();
//                              },
//                              textInputAction: TextInputAction.next,
//                              style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
//                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: ClipOval(
                                child: Material(
                                  color: Colors.indigo, // button color
                                  child: InkWell(
                                    // inkwell color
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        Icons.timer_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      //selectTime(context);
                                      print(selectedChoice);
                                      showReportDialogChips();
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            primary: Colors.indigo,
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              print(_nameController.text);
                              print(_dateController.text);
                              print(widget.doctor);
                              showAlertDialog(context);
                              _createAppointment();
                            }
                          },
                          child: Text(
                            "Book Appointment",
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createAppointment() async {
    //print(dateUTC + ' ' + date_Time + ':00');
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.email)
        .collection('pending')
        .doc()
        .set({
      'name': _nameController.text,
      'phone': _phoneController.text,
      'description': _descriptionController.text,
      'doctor': _doctorController.text,
      'date': DateTime.parse(dateUTC),

      ///  + ' ' + date_Time + ':00'
      'time': selectedChoice,
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.email)
        .collection('all')
        .doc()
        .set({
      'name': _nameController.text,
      'phone': _phoneController.text,
      'description': _descriptionController.text,
      'doctor': _doctorController.text,
      'date': DateTime.parse(dateUTC),

      ///  + ' ' + date_Time + ':00'
      'time': selectedChoice,
    }, SetOptions(merge: true));
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final String docId;
  MultiSelectChip(this.reportList, {this.docId});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
//  String selectedChoice = "";
//  this function will build and return the choice list
//  Multiple Choices
//  List<String> selectedChoices = List();
//  _buildChoiceList() {
//    List<Widget> choices = List();
//    widget.reportList.forEach((item) {
//      choices.add(
//          Container(
//        padding: const EdgeInsets.all(2.0),
//        child: ChoiceChip(
//          label: Text(item),
//          selected: selectedChoices.contains(item),
//          onSelected: (selected) {
//            setState(() {
//              selectedChoices.contains(item)
//                  ? selectedChoices.remove(item)
//                  : selectedChoices.add(item);
//            });
//          },
//        ),
//      ));
//    });
//    return choices;
//  }
  /// Single Item Selected

//  String selectedChoice = "";
// this function will build and return the choice list

  List<dynamic> listTimes1 = [];

  getlisttimes({docId = '7sctWrXekNmPTaTiue3C'}) {
    /// List<dynamic> listtimes = [];
    List<dynamic> listTimes = []; //listTimes1;
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(docId)

        /// TODO : change when change doctor choice replace after
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        listTimes = documentSnapshot.get(FieldPath(['listtimes']));

        /// TODO: mybe save in saredprefs
        print(
            'Document exists on the database list is : ${listTimes[0]} and type is : ${listTimes.runtimeType}');
      }
    });
    return listTimes;
  }

  @override
  void initState() {
    super.initState();
    print('docID is : ${widget.docId}');
    listTimes1 = getlisttimes(docId: widget.docId);
    print('List of Times is : $listTimes1');
  }

  getFutureTimes() {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('doctors')
            .doc(widget.docId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data.data() as Map<String, dynamic>;
            List<dynamic> listpreapear = data['listtimes'];
            return ListView.builder(
                itemCount: listpreapear.length,
                itemBuilder: (context, item) {
                  return Container(
                    padding: const EdgeInsets.all(2.0),
                    child: ChoiceChip(
                      label: Text(listpreapear[item]),
                      selected: selectedChoice == listpreapear[item],
                      onSelected: (selected) {
                        setState(() {
                          selectedChoice = listpreapear[item];
                        });
                        //            print(
//                'Item selected is : $selected '
//                'and item is $item '
//                 'and selectedChoice is : $selectedChoice'
//                 ' and index list :}'
//            );
                      },
                    ),
                  );
                });
            listpreapear.forEach((item) {
              Container(
                padding: const EdgeInsets.all(2.0),
                child: ChoiceChip(
                  label: Text(item),
                  selected: selectedChoice == item,
                  onSelected: (selected) {
                    setState(() {
                      selectedChoice = item;
                    });
                    //            print(
//                'Item selected is : $selected '
//                'and item is $item '
//                 'and selectedChoice is : $selectedChoice'
//                 ' and index list :}'
//            );
                  },
                ),
              );
            });
            //return Text("Full Name: ${data['listtimes']} and type of list is : ${data['listtimes'].runtimeType}}");
          }

          return Text("loading");
        });
  }

  _buildChoiceList() {
    List<Widget> choices = List();
    List<dynamic> listTimes = []; //listTimes1;
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(widget.docId)

        /// TODO : change when change doctor choice replace after
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        listTimes = documentSnapshot.get(FieldPath(['listtimes']));

        /// TODO: mybe save in saredprefs
        print(
            'Document exists on the database list is : ${listTimes[0]} and type is : ${listTimes.runtimeType}');
        listTimes.forEach((item) {
          choices.add(Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              label: Text(item),
              selected: selectedChoice == item,
              onSelected: (selected) {
                setState(() {
                  selectedChoice = item;
                });
                //            print(
//                'Item selected is : $selected '
//                'and item is $item '
//                 'and selectedChoice is : $selectedChoice'
//                 ' and index list :}'
//            );
              },
            ),
          ));
        });
      }
    });
    print('Element is : ${widget.reportList.indexOf(selectedChoice)}');
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return getFutureTimes();

//      Wrap(
//      direction: Axis.vertical,
//      children: _buildChoiceList(),
//    );
//  return Row(
//    children: _buildChoiceList(),
//  );
  }
}
