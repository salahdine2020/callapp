import 'package:block_list/provider/provider_list.dart';
import 'package:block_list/provider/provider_tableitems.dart';
import 'package:block_list/tablequizze/quizztable_board.dart';
import 'package:block_list/widgets/widget2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestWidget1 extends StatelessWidget {
  final String title;

  TestWidget1({this.title});

  bool etap1 = false;
  @override
  Widget build(BuildContext context) {
    var bookmarkBloc = Provider.of<BookmarkBloc>(context);
    var listTableBloc = Provider.of<TableItemBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .24,
              width: MediaQuery.of(context).size.width * 1,
              //color: Colors.amber,
              decoration: BoxDecoration(
                //color: Colors.amber,
                image: DecorationImage(
                  image: AssetImage("assets/images/img_etape4_partie1.PNG"),
                  fit: BoxFit.cover,
                ),
              ),
              child: TableQuizzeBoard(),
            ),
            SizedBox(
              height: 32,
            ),
            listTableBloc.compareReponse(list_datacompare: listTableBloc.itemsList,)
                ? Text('check Validate')
                : Text('Wait for resault ..'),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  print('onpresse of TestWidget1');
                  var widget2 = TestWidget2(
                    title: 'Widget 2',
                  );
                  etap1 == false ? bookmarkBloc.addItems(widget2)  : null;
                  etap1 = true;
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

/*

'Autem tempus quia omne rem et omne rem quadratum' || 
'controller_etape8.text =='autem tempus quia omne rem et omne rem quadratum'

*/