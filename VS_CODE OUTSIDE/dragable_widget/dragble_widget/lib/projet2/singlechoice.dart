import 'package:flutter/material.dart';

class ChoiceItem extends StatefulWidget {
  const ChoiceItem({ Key key }) : super(key: key);

  @override
  _ChoiceItemState createState() => _ChoiceItemState();
}

class _ChoiceItemState extends State<ChoiceItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choice Item'),
      ),
      body: Column(
       children: [
         
       ],
      ),
    );
  }
}