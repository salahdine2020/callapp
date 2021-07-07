import 'package:dragble_widget/projet2/itemmodel.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// change by list of Widget
  List<String> reportList = [
    "Not relevant",
    "Illegal",
    "Spam",
    "Offensive",
    "Uncivil"
  ];

  List items_all = [
    ItemModel(
      value: 'lg',
      name: 'line gauche',
      img: 'assets/image_direction/image_lg.PNG',
    ),
    ItemModel(
      value: 'ld',
      name: 'line droit',
      img: 'assets/image_direction/image_ld.PNG',
    ),
    ItemModel(
      value: 'cld',
      name: 'c line droit',
      img: 'assets/image_direction/image_cld.PNG',
    ),
    ItemModel(
      value: 'clg',
      name: 'c line gauche',
      img: 'assets/image_direction/image_clg.PNG',
    ),
    ItemModel(
      value: 'lu',
      name: 'line Up',
      img: 'assets/image_direction/image_lu.PNG',
    ),
    ItemModel(
      value: 'qustion',
      name: 'qustion',
      img: 'assets/image_direction/qustion.PNG',
    ),
  ];

  List<Widget> items_sol = [
    Image.asset('assets/image_direction/image_lu.PNG'),
    Image.asset('assets/image_direction/image_cld.PNG'),
    Image.asset('assets/image_direction/image_sl.PNG'),
    ];
  
  List<String> selectedReportList = [];

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Report Video"),
            content: MultiSelectChip(
              reportList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Report"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Report"),
              onPressed: () => _showReportDialog(),
            ),
            Text(selectedReportList.join(" , ")),
          ],
        ),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.reportList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<Widget> selectedChoices = [];
  
  List<Widget> items_sol = [
    Image.asset('assets/image_direction/image_lu.PNG'),
    Image.asset('assets/image_direction/image_cld.PNG'),
    Image.asset('assets/image_direction/image_sl.PNG'),
    ];

  _buildChoiceList() {
    List<Widget> choices = [];
    ///  widget.reportList.forEach((item) {
  items_sol.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: null,//Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              //widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
