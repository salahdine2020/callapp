import 'package:block_list/list_scroll.dart';
import 'package:block_list/list_view.dart';
import 'package:block_list/provider/provider_list.dart';
import 'package:block_list/provider/provider_tableitems.dart';
import 'package:block_list/widget_bridg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/* void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BookmarkBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => TableItemBloc(),
        ),
      ],
      child: MyApp(),
    ),
  );
} */
void main() {
  runApp(
    MyApp_List(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WidgetBridg(), //ListViewBlock(),//MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
