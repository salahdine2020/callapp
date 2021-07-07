import 'dart:async';
import 'package:block_list/provider/provider_list.dart';
import 'package:block_list/widgets/widget1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListViewBlock extends StatefulWidget {
  @override
  _ListViewBlockState createState() => _ListViewBlockState();
}

class _ListViewBlockState extends State<ListViewBlock> {
  final widgetStream = StreamController<Widget>();

  int widgetCounter = -1;
  bool etap1 = false;
  bool etap2 = false;
  @override
  void initState() {
    // TODO: implement initState
    //List<Widget> _list = [];
    super.initState();
  }

  List<Widget> _list = [];

  Widget testWidget(String title) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Container(
              height: 200,
              width: 200,
              color: Colors.amber,
              child: Center(child: Text('Hi $title')),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  widgetCounter++;
                  print(
                      'index befor add in condition $widgetCounter and chage val is :');
                  etap1 == false ? _list.add(
                    testWidget2('Widget $widgetCounter'),
                  ) : null;
                  etap1 = true;
                  print(
                      'length of this list is ${_list[0]} and list length is ${_list.length} and change value is :',
                      );
                },
                child: Text('Etape 1'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget testWidget2(String title) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Container(
              height: 200,
              width: 200,
              color: Colors.red,
              child: Center(child: Text('Hi $title')),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  widgetCounter++;
                  print(
                      'index befor add in condition $widgetCounter and chage val is :');
                  etap2 == false ? _list.add(
                    testWidget3('Widget $widgetCounter'),
                  ) : null;
                  etap2 = true;
                  print(
                      'length of this list is ${_list[0]} and list length is ${_list.length} and change value is :',
                      );
                },
                child: Text('Etape 2'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget testWidget3(String title) {
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

  @override
  Widget build(BuildContext context) {

    var bookmarkBloc = Provider.of<BookmarkBloc>(context);
    /*
    _list = [
      //testWidget('One'),
      TestWidget1(
        title: 'One',
        list_widget: _list,
      ),
    ];
    */
   // print('content of list inside Rebuilde : $_list');
    return Scaffold(
      appBar: AppBar(
        title: Text('Etaps'),
      ),
      body: ListView(
        shrinkWrap: false,
        physics: AlwaysScrollableScrollPhysics(),
        children: bookmarkBloc.items,//_list,
      ),
      /*
      StreamBuilder(
        stream: widgetStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.done) {}
          return snapshot.data;
        },
      ),
      */
    );
  }
}
