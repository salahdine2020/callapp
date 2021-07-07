import 'package:dragble_widget/main.dart';
import 'package:flutter/material.dart';

class DraggableTextPage extends StatefulWidget {
  @override
  _DraggableTextPageState createState() => _DraggableTextPageState();
}

class _DraggableTextPageState extends State<DraggableTextPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
          centerTitle: true,
        ),
        body: Center(
          child: Draggable(
            child: buildText('Drag Me', Colors.purple),
            // when object is dragged itselef
            feedback: Material(child: buildText('Dragged', Colors.green)),
            // widget behind widget dragged 
            childWhenDragging: buildText('Behind', Colors.red),
          ),
        ),
      );

  Widget buildText(String text, Color color) => Container(
        alignment: Alignment.center,
        width: 160,
        height: 100,
        color: color,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 32),
          textAlign: TextAlign.center,
        ),
      );
}
