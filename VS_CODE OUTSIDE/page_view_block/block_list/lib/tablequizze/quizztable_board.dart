import 'package:block_list/tablequizze/quizztable_cell.dart';
import 'package:flutter/material.dart';

class TableQuizzeBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Table(
            border: TableBorder(
              left: BorderSide(width: 3.0, color: Colors.black),
              top: BorderSide(width: 3.0, color: Colors.black),
              bottom: BorderSide(width: 3.0, color: Colors.black),
              right: BorderSide(width: 3.0, color: Colors.black),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: _getTableRows(),
          );
  }

  List<TableRow> _getTableRows() {
    return List.generate(8, (int rowNumber) {
      return TableRow(children: _getRow(rowNumber));
    });
  }

  List<Widget> _getRow(int rowNumber) {
    return List.generate(10, (int colNumber) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              width: (colNumber % 3 == 2) ? 1.0 : 1.0,
              color: Colors.black,
            ),
            bottom: BorderSide(
              width: (rowNumber % 3 == 2) ? 1.0 : 1.0,
              color: Colors.black,
            ),
            left: BorderSide(
              width: (rowNumber % 3 == 2) ? 1.0 : 1.0,
              color: Colors.black,
            ),
            top: BorderSide(
              width: (rowNumber % 3 == 2) ? 1.0 : 1.0,
              color: Colors.black,
            ),
          ),
        ),
        child: TableQuizzeCell(rowNumber, colNumber),
      );
    });
  }
}

