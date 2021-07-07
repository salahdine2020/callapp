import 'package:block_list/provider/provider_list.dart';
import 'package:block_list/widgets/widget3.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestWidget2 extends StatelessWidget {
  final String title;
 
  TestWidget2({this.title});
  bool etap2 = false;
  @override
  Widget build(BuildContext context) {
    var bookmarkBloc = Provider.of<BookmarkBloc>(context);
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
                  print('onpresse of TestWidget2');
                  

                  var widget3 =TestWidget3(title : 'Widget 2');
                  etap2 == false ? 
                  bookmarkBloc.addItems(widget3)
                  /*
                  list_widget.add(
                    TestWidget2(
                      title : 'Widget 2',
                      list_widget: list_widget,
                    ),),
                  */
                  : null;
                  etap2 = true;

                  /*
                  etap2 == false ? list_widget.add(
                    TestWidget3(title : 'Widget 2'),
                  ) : null;
                  etap2 = true;
                  print('content of list after : $list_widget');
                  */
                },
                child: Text('Etape 1'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}