import 'package:block_list/provider/provider_tableitems.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class TableQuizzeCell extends StatefulWidget {
  final int row, col;

  TableQuizzeCell(this.row, this.col);
  @override
  _TableQuizzeCellState createState() => _TableQuizzeCellState();
}

class _TableQuizzeCellState extends State<TableQuizzeCell> {
  bool click = false;
  List<String> listvalues = [];
  List<String> listvalues2 = [];
  List<String> list_fill = []; //List(15);

  //List<String> list_fill = [];

  ///['0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'];
  Text fillCell() {
    if ((widget.row == 2 && widget.col == 2) ||
        (widget.row == 3 && widget.col == 3) ||
        (widget.row == 3 && widget.col == 7) ||
        (widget.row == 5 && widget.col == 3) ||
        (widget.row == 6 && widget.col == 7)) {
      return Text('0', textAlign: TextAlign.center);
    } else if ((widget.row == 0 && widget.col == 0) ||
        (widget.row == 0 && widget.col == 0) ||
        (widget.row == 0 && widget.col == 7) ||
        (widget.row == 1 && widget.col == 4) ||
        (widget.row == 2 && widget.col == 5) ||
        (widget.row == 4 && widget.col == 3) ||
        (widget.row == 5 && widget.col == 2) ||
        (widget.row == 5 && widget.col == 9) ||
        (widget.row == 6 && widget.col == 5) ||
        (widget.row == 7 && widget.col == 0) ||
        (widget.row == 7 && widget.col == 9)) {
      return Text('1', textAlign: TextAlign.center);
    } else if ((widget.row == 0 && widget.col == 3) ||
        (widget.row == 0 && widget.col == 8) ||
        (widget.row == 1 && widget.col == 2) ||
        (widget.row == 1 && widget.col == 9) ||
        (widget.row == 2 && widget.col == 4) ||
        (widget.row == 3 && widget.col == 9) ||
        (widget.row == 4 && widget.col == 4) ||
        (widget.row == 5 && widget.col == 0) ||
        (widget.row == 5 && widget.col == 8) ||
        (widget.row == 6 && widget.col == 1) ||
        (widget.row == 7 && widget.col == 2) ||
        (widget.row == 7 && widget.col == 6)) {
      return Text('2', textAlign: TextAlign.center);
    } else if ((widget.row == 3 && widget.col == 1) ||
        (widget.row == 7 && widget.col == 7) ||
        (widget.row == 3 && widget.col == 6)) {
      return Text('3', textAlign: TextAlign.center);
    } else if ((widget.row == 0 && widget.col == 2) ||
        (widget.row == 0 && widget.col == 9) ||
        (widget.row == 1 && widget.col == 0) ||
        (widget.row == 1 && widget.col == 6) ||
        (widget.row == 1 && widget.col == 8) ||
        (widget.row == 2 && widget.col == 3) ||
        (widget.row == 2 && widget.col == 9) ||
        (widget.row == 3 && widget.col == 0) ||
        (widget.row == 4 && widget.col == 1) ||
        (widget.row == 4 && widget.col == 8) ||
        (widget.row == 5 && widget.col == 4) ||
        (widget.row == 6 && widget.col == 2) ||
        (widget.row == 7 && widget.col == 3)) {
      return Text('4', textAlign: TextAlign.center);
    } else if ((widget.row == 1 && widget.col == 3) ||
        (widget.row == 3 && widget.col == 4) ||
        (widget.row == 4 && widget.col == 2) ||
        (widget.row == 5 && widget.col == 7)) {
      return Text('5', textAlign: TextAlign.center);
    } else if ((widget.row == 0 && widget.col == 4) ||
        (widget.row == 2 && widget.col == 1) ||
        (widget.row == 2 && widget.col == 8) ||
        (widget.row == 3 && widget.col == 4) ||
        (widget.row == 4 && widget.col == 0) ||
        (widget.row == 4 && widget.col == 9) ||
        (widget.row == 2 && widget.col == 9) ||
        (widget.row == 5 && widget.col == 6) ||
        (widget.row == 6 && widget.col == 4) ||
        (widget.row == 6 && widget.col == 8) ||
        (widget.row == 7 && widget.col == 5)) {
      return Text('6', textAlign: TextAlign.center);
    } else if ((widget.row == 0 && widget.col == 5) ||
        (widget.row == 1 && widget.col == 1) ||
        (widget.row == 1 && widget.col == 7) ||
        (widget.row == 4 && widget.col == 6) ||
        (widget.row == 2 && widget.col == 6) ||
        (widget.row == 2 && widget.col == 9) ||
        (widget.row == 5 && widget.col == 1) ||
        (widget.row == 6 && widget.col == 0) ||
        (widget.row == 6 && widget.col == 6) ||
        (widget.row == 7 && widget.col == 4) ||
        (widget.row == 7 && widget.col == 8)) {
      return Text('7', textAlign: TextAlign.center);
    } else if ((widget.row == 3 && widget.col == 2) ||
        (widget.row == 3 && widget.col == 2) ||
        (widget.row == 3 && widget.col == 5) ||
        (widget.row == 4 && widget.col == 7)) {
      return Text('8', textAlign: TextAlign.center);
    } else if ((widget.row == 0 && widget.col == 1) ||
        (widget.row == 0 && widget.col == 6) ||
        (widget.row == 1 && widget.col == 5) ||
        (widget.row == 2 && widget.col == 0) ||
        (widget.row == 2 && widget.col == 7) ||
        (widget.row == 3 && widget.col == 8) ||
        (widget.row == 4 && widget.col == 5) ||
        (widget.row == 5 && widget.col == 5) ||
        (widget.row == 6 && widget.col == 3) ||
        (widget.row == 6 && widget.col == 9) ||
        (widget.row == 7 && widget.col == 1)) {
      return Text('9', textAlign: TextAlign.center);
    }
  }

  Color setColorState({bolck}) {
    if (click) {
      return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    var listTableBloc = Provider.of<TableItemBloc>(context);
    return InkResponse(
      enableFeedback: true,
      onTap: () {
        var fill = '${widget.row}-${widget.col}';
        // code add or remove from provider list
        print('value of click $click');
        click == false
            ? listTableBloc.addItems_table(fill)
            : listTableBloc.removetems_table(fill);
        setState(() {
          click = !click;
        });
        var table = listTableBloc.itemsList;
        print('list when fill by items is : $table');
      },
      child: Container(
        color: click ? Colors.yellowAccent : Colors.white,
        child: fillCell(),
      ),
    );
  }
}
