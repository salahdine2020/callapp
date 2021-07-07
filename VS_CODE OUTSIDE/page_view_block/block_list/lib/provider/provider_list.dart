import 'package:block_list/widgets/widget1.dart';
import 'package:flutter/cupertino.dart';

class BookmarkBloc extends ChangeNotifier {
  int _count = 0;
  List<Widget> items = [
       TestWidget1(
        title: 'One',
        //list_widget: items,
      ),
  ];

  void addCount() {
    _count++;
    notifyListeners();
  }

  void addItems(Widget data) {
    items.add(data);
    notifyListeners();
  }

  int get count {
    return _count;
  }

  List<Widget> get itemsList {
    return items;
  }
}
