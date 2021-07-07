import 'package:flutter/material.dart';

class RenderBox  extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = Colors.yellow;
    // center of the canvas is (x,y) => (width/2, height/2)
    final center = Offset(size.width / 2, size.height / 2);

    // draw the circle on centre of canvas having radius 75.0
    canvas.drawCircle(center, size.width / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool hitTest(Offset position) {
    final Offset center = Offset(200, 200);
    Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 400, height: 400),
        Radius.circular(center.dx),),);
    path.close();
    return path.contains(position);
  }
}

class ShapesPainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = Colors.red;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);

    // draw the circle on centre of canvas having radius 75.0
    canvas.drawCircle(center, size.width / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  @override
  bool hitTest(Offset position) {
    final Offset center = Offset(100, 100);
    Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 200, height: 200),
        Radius.circular(center.dx)));
    path.close();
    return path.contains(position);
  }
}
