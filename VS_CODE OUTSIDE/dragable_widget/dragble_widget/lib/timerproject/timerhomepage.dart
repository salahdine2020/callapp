import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../main.dart';
import 'settings.dart';
import 'timer.dart';
import 'timermodel.dart';
import 'widgets.dart';

class TimerHomePage extends StatefulWidget {
  @override
  _TimerHomePageState createState() => _TimerHomePageState();
}

class _TimerHomePageState extends State<TimerHomePage> {
  final double defaultPadding = 5.0;

  final CountDownTimer timer = CountDownTimer();
  @override
  void deactivate() {
    // TODO: implement deactivate
    timer.stopTimer();
    super.deactivate();
  }

  @override
  void initState() {
    // TODO: implement initState
    //timer.startWork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> menuItems = List<PopupMenuItem<String>>();
    menuItems.add(
      PopupMenuItem(
        value: 'Settings',
        child: Text('Settings'),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('My Work Timer'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              /*
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Example(),
                  ),
                );
              */
            },
          ),
          actions: [
//            PopupMenuButton<String>(
//              itemBuilder: (BuildContext context) {
//                return menuItems.toList();
//              },
//              onSelected: (s) {
//                // if u have multi item the best way is to use switch
//                if (s == 'Settings') {
//                  goToSettings(context);
//                }
//              },
//            ),
            StreamBuilder(
              initialData: TimerModel('00:00:00', 1),
              stream: timer.streamTimer(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                TimerModel timer = snapshot.data;
                //print('test value of timer inside stream is ${timer.time}');
                if(!snapshot.hasData) return Center(
                  child: Text('00:00:00',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                );
                return Container(
                    child: Center(
                      child: Text(
                        (timer.time == null) ? '00:00' : timer.time,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),

                );
              },
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double availableWidth = constraints.maxWidth;
            return Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                    Expanded(
                      child: ProductivityButton(
                        color: Color(0xff009688),
                        text: "Commencer la partie",
                        onPressed: () => timer.startWork2(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                    Expanded(
                      child: ProductivityButton(
                        color: Colors.black,
                        text: "Penalite",
                        onPressed: () => timer.pinalite(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(),
                  //                  child: StreamBuilder(
//                    initialData: TimerModel('00:00', 1),
//                    stream: timer.stream(),
//                    builder: (BuildContext context, AsyncSnapshot snapshot) {
//                      TimerModel timer = snapshot.data;
//                      return Container(
//                        child: CircularPercentIndicator(
//                          radius: availableWidth / 2,
//                          lineWidth: 10.0,
//                          percent: (timer.percent == null) ? 1 : timer.percent,
//                          center: Text(
//                            (timer.time == null) ? '00:00' : timer.time,
//                            style: Theme.of(context).textTheme.headline4,
//                          ),
//                          progressColor: Color(0xff009688),
//                        ),
//                      );
//                    },
//                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                    Expanded(
                      child: ProductivityButton(
                        color: Color(0xff212121),
                        text: 'Stop',
                        onPressed: () => timer.stopTimer(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                    Expanded(
                      child: ProductivityButton(
                        color: Color(0xff009688),
                        text: 'Contiue', //'Restart',
                        onPressed: () =>
                            timer.startWork(),
                            //emptyMethod(),
                            //timer.continueTimer(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
  }

  void emptyMethod() {}

  void goToSettings(BuildContext context) {
    print('in gotoSettings');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }
}
