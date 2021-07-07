import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:schema_drawline/provider/provider_schema.dart';
import 'dart:math';
import 'line.dart';

class Utils {
  static double distanceMin = 20;
  static PointerEvent pointerEventStart = PointerEnterEvent();
  static PointerEvent pointerEventEnd = PointerEnterEvent();
  static Offset lastCloserPoint = Offset(0, 0);
  static bool startedDraw = false;
  static List<String> lines_corr = [];
  static List<String> lines_compare = [
    '16.0-232.0-392.0-28.0',
    '392.0-28.0-392.0-476.0',
    '392.0-476.0-16.0-348.0',
    '16.0-348.0-18.0-628.0',
    '18.0-628.0-394.0-525.0'
  ];

  static List<Line> lines = [];
  //var provder_shema = Provider.of<ShemaProvider>(context);
  static List getPoints() {
    var myList = [];

    myList.add(Offset(16, 232)); // j
    myList.add(Offset(392, 28)); // j

    myList.add(Offset(392, 476)); // j
    myList.add(Offset(16, 348)); // j

    myList.add(Offset(18, 628)); // j
    myList.add(Offset(394, 525)); // j

    return myList;
  }

  static getPointerEventEnd() {
    return pointerEventEnd;
  }

  static getPointerEventStart() {
    return pointerEventStart;
  }

  static bool isCloserPointVeryClose() {
    return distance(getCloserPoint().dx, getCloserPoint().dy,
            pointerEventEnd.position.dx, pointerEventEnd.position.dy) <
        10;
  }

  static Offset getCloserPoint() {
    var pointRetour = null;
    var points = getPoints();
    double minDist = double.maxFinite;
    for (Offset point in points) {
      if (distance(pointerEventEnd.position.dx, pointerEventEnd.position.dy,
              point.dx, point.dy) <
          minDist) {
        minDist = distance(pointerEventEnd.position.dx,
            pointerEventEnd.position.dy, point.dx, point.dy);
        pointRetour = point;
      }
    }
    // print(distance(pointRetour.dx, pointRetour.dy, pointerEventEnd.position.dx, pointerEventEnd.position.dy) );
    return pointRetour;
  }

  static double distance(double x1, double y1, double x2, double y2) {
    return sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
  }

  static double distanceOffset(Offset p1, Offset p2) {
    return sqrt(
        (p1.dx - p2.dx) * (p1.dx - p2.dx) + (p1.dy - p2.dy) * (p1.dy - p2.dy));
  }

  static void addLine(Offset p1, Offset p2, {context}) async {
    // Si on n'a pas commencé à dessiner
    var provder_shema = Provider.of<ShemaProvider>(context);
    if (!startedDraw) {
      return;
    }

    // Si on a déjà dessiné la ligne, on sort
    if (lineIsAdded(p1, p2)) {
      return;
    }

    // Si dernier point à dessiner proche du dernier, on sort
    if (equalsOffset(lastCloserPoint, getCloserPoint())) {
      return;
    }

    lastCloserPoint = getCloserPoint();

    // if(distance(getCloserPoint().dx, getCloserPoint().dy, pointerEventStart.position.dx, pointerEventStart.position.dy) > distanceMin){
    //   print("distance Grande");
    //   pointerEventStart = new PointerDownEvent(position: getCloserPoint(),);
    // }else {
    print("add Line");
    if (distanceOffset(p1, p2) > 40) {
      lines.add(Line(p1, p2));
      // use foreEach
      lines.forEach((e) {
//        print('point a :  ${e.p1.dx}-${e.p1.dy} point b : ${e.p2.dx}-${e.p2.dy}');
        lines_corr.contains('${e.p1.dx}-${e.p1.dy}-${e.p2.dx}-${e.p2.dy}')
            ? null
            : lines_corr.add('${e.p1.dx}-${e.p1.dy}-${e.p2.dx}-${e.p2.dy}');
      });
//      lines_corr == lines_compare ? print('CORECT : $lines_corr') : print('ERROR !!: $lines_corr');
      if (lines_corr.length == 5) {
        // save shared prefs
        listEquals(lines_corr,lines_compare)
        // use firestore hhh update value
            ? provder_shema.schema_check = true : provder_shema.schema_check = false;
             //SharedShema().savevalue(val: true)//print('CORECT : $lines_corr and $lines_compare')
//             await FireFunction().updateSchemaQuizz(val: true)
//            : await FireFunction().updateSchemaQuizz(val: true);//print('ERROR !!: $lines_corr and $lines_compare');
      }
    }
//    lines_corr == lines_compare
//        ? print('CORECT : $lines_corr')
//        : print('ERROR !!: $lines_corr');
    print("Line Added " + Utils.lines.length.toString());
    pointerEventStart = PointerDownEvent(
      position: getCloserPoint(),
    );

    /// here u should add condition to validate draw :
  }

  static bool lineIsAdded(Offset p1, Offset p2) {
    /// 
    for (Line line in lines) {
      if ((equalsOffset(line.p1, p1) && equalsOffset(line.p2, p2)) || (equalsOffset(line.p1, p2) && equalsOffset(line.p2, p1))) {
        return true;
      }
    }
    return false;
  }

  static bool equalsOffset(Offset p1, Offset p2) {
    /// means p1 is above p2 each is in same position 
    return p1.dx == p2.dx && p1.dy == p2.dy;
  }
}
