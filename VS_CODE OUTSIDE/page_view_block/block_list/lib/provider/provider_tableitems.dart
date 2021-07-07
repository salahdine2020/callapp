import 'package:block_list/widgets/widget1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class TableItemBloc extends ChangeNotifier {
  int _count = 0;
  List<String> items_table = [];

  List<String> list_data = [
    '7-7',
    '6-7',
    '5-7',
    '4-7',
    '3-7',
    '3-6',
    '3-5',
    '3-4',
    '3-3',
    '3-2',
    '3-1',
    '2-2',
    '1-3',
    '4-2',
    '5-3',
  ];

  void addCount() {
    _count++;
    notifyListeners();
  }

  void addItems_table(String data) {
    items_table.add(data);
    notifyListeners();
  }

  void removetems_table(String data) {
    items_table.remove(data);
    notifyListeners();
  }

  void removeAll() {
    items_table.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  int get count {
    return _count;
  }

  List<String> get itemsList {
    return items_table;
  }

  // function to compare between list save and if contain the elements
  bool compareReponse({List<String> list_datacompare}) {
    bool res_finale;
    if (list_datacompare.length == 15) {
      list_datacompare.forEach((e) {
        print('values change og e : $e');
        var res = list_data.contains(e);
        res == false ? res_finale = false : res_finale = true ;
        print('values itemes content $res');
      });
      // or use all posibilites 
      // return listEquals(list_datacompare, list_data);
    } else {
      res_finale = false;
    }
    return res_finale;
  }
}
