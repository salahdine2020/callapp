import 'package:flutter/material.dart';

class TestWidget3 extends StatelessWidget {
  final String title;
  TestWidget3({this.title});
  @override
  Widget build(BuildContext context) {
  return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Container(
              height: 200,
              width: 200,
              color: Colors.blue,
              child: Center(child: Text('Finale $title')),
            ),
          ],
        ),
      ),
    );
  }
}