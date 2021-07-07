import 'package:block_list/list_view.dart';
import 'package:block_list/provider/provider_tableitems.dart';
import 'package:block_list/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WidgetBridg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var listTableBloc = Provider.of<TableItemBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bridge'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                //  Navigate To second Screen
                listTableBloc.itemsList.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListViewBlock(),
                  ),
                );
              },
              child: Text('Etape'),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerPage(),//MyHomePage(),
                  ),
                );
              },
              child: Text('Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
 /*
  build widget : 
      var bookmarkBloc = Provider.of<TableItemBloc>(context);
      var bookmarkBloc2 = Provider.of<TablemarkBloc>(context);
  onTap : 
                  var widget = EtapeFivePezilla();
                        if (etap5 == false) {
                          // ps: u should creat seconde timer to show pinality time
                          value_check
                              ? addBlock(function: () {
                                  bookmarkBloc2.addItems(widget);
                                })
                              : bookmarkBloc.compareReponse(
                                  list_datacompare: bookmarkBloc.itemsList,
                                )
                                  ? bookmarkBloc2.addItems(widget)
                                  : null;
                        } else {
                          null;
                        }
                        etap5 = true;

  */

  /*

  var bookmarkBloc2 = Provider.of<TablemarkBloc>(context);
  
  var widget = EtapeTwoPezilla();
                  etap == false ? bookmarkBloc2.addItems(widget)  : null;
                  etap = true;
  */