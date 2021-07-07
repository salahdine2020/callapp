import 'package:dragble_widget/projet1/page/draggable_basic_page.dart';
import 'package:dragble_widget/projet1/page/draggable_text_page.dart';
import 'package:dragble_widget/projet1/page/quizz_direction.dart';
import 'package:dragble_widget/projet1/widget/gridview.dart';
import 'package:dragble_widget/projet2/homescreen.dart';
import 'package:dragble_widget/projet2/singlechoice.dart';
import 'package:dragble_widget/projet3/multiselect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'timerproject/timerhomepage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Draggable & DragTarget';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.blueAccent,
        ),
        home: 
        //ChoiceItem(), 
        //MyHomePage(title: 'Select Items',),
        HomeScreen(),
        // TimerHomePage(),
        // HomeScreen(),
        // Example(),
        // HomeScreen(),
        // MainPage(),
      );
}

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: GridViewGame(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Timer'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Go Timer'),
          onPressed: () {
            // navigate to next page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TimerHomePage(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: buildPages(),
        bottomNavigationBar: buildBottomBar(),
      );

  Widget buildBottomBar() {
    final style = TextStyle(color: Colors.white);

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          icon: Text('Draggable', style: style),
          title: Text('Text'),
        ),
        BottomNavigationBarItem(
          icon: Text('Draggable', style: style),
          title: Text('Basic'),
        ),
        BottomNavigationBarItem(
          icon: Text('Draggable', style: style),
          title: Text('Advanced'),
        ),
      ],
      onTap: (int index) => setState(() => this.index = index),
    );
  }

  Widget buildPages() {
    switch (index) {
      case 0:
        return DraggableTextPage();
      case 1:
        return DraggableBasicPage();
      case 2:
        return QuizzDirections();
      //DraggableAdvancedPage();
      default:
        return Container();
    }
  }
}
