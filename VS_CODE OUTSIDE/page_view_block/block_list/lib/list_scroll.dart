import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyApp_List extends StatefulWidget {
  //final List<String> items;

  //MyApp({Key key, @required this.items}) : super(key: key);

  @override
  createState() => _ListViewState();
}

class _ListViewState extends State<MyApp_List> {
  String title = 'Long List';
  String prevTitle = '';
  //List<String> items;
  List<String> duplicateItems;
  TextEditingController textController;
  ScrollController con;
  final itemSize = 80.0;
  List<String> items;
  @override
  void initState() {
    super.initState();
    items = List<String>.generate(50, (i) => "Item $i"); //widget.items;
    duplicateItems = List.from(items);
    textController = TextEditingController();
    prevTitle = title;
    con = ScrollController();
    con.addListener(() {
      if (con.offset >= con.position.maxScrollExtent &&
          !con.position.outOfRange) {
        print(
            'DOWN CASE : con.offset is : ${con.offset} \n con.position.maxScrollExtent is : ${con.position.maxScrollExtent} \n and con.position.outOfRange is :${con.position.outOfRange} ');
        setState(() {
          title = "reached the bottom";
        });
      } else if (con.offset <= con.position.minScrollExtent &&
          !con.position.outOfRange) {
        print(
            'UP CASE : con.offset is : ${con.offset} \n con.position.maxScrollExtent is : ${con.position.maxScrollExtent} \n and con.position.outOfRange is :${con.position.outOfRange} ');
        setState(() {
          title = "reached the top";
        });
      } else {
        setState(() {
          title = prevTitle;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          children: <Widget>[
            searchField(),
            rowButtons(),
            Expanded(
              child: ListView.builder(
                controller: con,
                itemExtent: itemSize,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${items[index]}',
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void dispose() {
    // Don't forget to dispose the ScrollController.
    con.dispose();
    super.dispose();
  }

  Widget rowButtons() => Container(
        height: 50.0,
        color: Colors.blue,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                child: Text("up"),
                onPressed: () {
                  con.animateTo(
                    con.offset - itemSize,
                    curve: Curves.linear,
                    duration: Duration(milliseconds: 500),
                  );
//                  con.jumpTo(con.offset - itemSize);
                },
              ),
              RaisedButton(
                child: Text("down"),
                onPressed: () {
                  con.animateTo(
                    con.offset + itemSize,
                    curve: Curves.linear,
                    duration: Duration(milliseconds: 500),
                  );
//                  con.jumpTo(con.offset + itemSize);
                },
              )
            ],
          ),
        ),
      );

  Widget searchField() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (value) {
            filterSearchResults(value);
          },
          controller: textController,
          decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
        ),
      );

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }
}
