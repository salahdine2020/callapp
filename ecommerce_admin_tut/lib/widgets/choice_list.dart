import 'package:flutter/material.dart';

class ChoiceList extends StatefulWidget {
  @override
  _ChoiceListState createState() => _ChoiceListState();
}

class _ChoiceListState extends State<ChoiceList> {
  List<int> _list = List.generate(20, (i) => i);
  List<bool> _selected = List.generate(20, (i) => false);
  @override
  Widget build(BuildContext context) {
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
      child: Text("Add"),
      onPressed: () {
        // return to first form
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ADD PRODUCT"),
      content: Container(
        height: MediaQuery.of(context).size.height * .6,
        width: MediaQuery.of(context).size.width * .3,
        child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (_, i) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              color: _selected[i]
                  ? Colors.blue
                  : null, // if current item is selected show blue color
              child: ListTile(
                title: Text("Item ${_list[i]}"),
                onTap: () => setState(
                    () => _selected[i] = !_selected[i]), // reverse bool value
              ),
            );
          },
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
        return alert;

        //alert;
      },
    );
  }
}
