import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:schema_drawline/line.dart';
import 'package:schema_drawline/utils.dart';
import 'dart:math' as math;


void main() async {
   runApp(
    MyApp(),
  );
}

int i = 0;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyPainter(),
    );
  }
}

class MyPainter extends StatefulWidget {
  @override
  _MyPainterState createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter> with SingleTickerProviderStateMixin {
  var _radius = 100.0;
  // here use late
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    );

    Tween<double> _rotationTween = Tween(begin: -math.pi, end: math.pi);

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(
          () {},
        );
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    PointerEvent details;
    PointPainter pp = PointPainter(_radius, animation.value);
   // var provder_shema = Provider.of<ShemaProvider>(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Visualizer'),
      // ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/img_etape5_partie1.PNG",
              ),
              fit: BoxFit.fill, // -> 02
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Listener(
                  onPointerDown: (PointerEvent d) {
                    Utils.pointerEventEnd = d;
                    Utils.pointerEventStart = d;

                    if (Utils.distance(
                            Utils.getCloserPoint().dx,
                            Utils.getCloserPoint().dy,
                            d.position.dx,
                            d.position.dy) <
                        Utils.distanceMin) {
                      print("Closer start");
                      Utils.startedDraw = true;
                    } else {
                      print("Closer start ${Utils.startedDraw}");
                      Utils.startedDraw = false;
                    }
                  },
                  onPointerMove: ((PointerEvent d) {
                    Utils.pointerEventEnd = d;
                    // print(Utils.getCloserPoint().toString());
                    if (Utils.isCloserPointVeryClose()) {
                      Utils.addLine(Utils.pointerEventStart.position, Utils.getCloserPoint(), context: context);
                    }
                  }),
                  child: CustomPaint(
                    foregroundPainter: pp,
                    painter: LinePainter(_radius),
                    child: Container(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 160),
                child: Container(
                  color: Colors.redAccent,
                 // child: provder_shema.schema_check ? Text('True', style: TextStyle(fontSize: 24),) : Text('False', style: TextStyle(fontSize: 24),),
                  child: Text('Wait', style: TextStyle(fontSize: 24),),
                ),
              ),
              SizedBox(
                height: 78,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// FOR PAINTING THE CIRCLE
class LinePainter extends CustomPainter {
  final double radius;
  LinePainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    ));
    // canvas.drawPath(path, paint);

    Offset p1 = Offset(200, 200);
    Offset p2 = Offset(400.0, 400.0);
    // canvas.drawLine(p1, p2, paint);

    // canvas.drawCircle(Utils.p1(), 2, paint);
    // canvas.drawCircle(Utils.p2(), 2, paint);
    // canvas.drawCircle(Utils.p3(), 2, paint);
    // canvas.drawCircle(Utils.p4(), 2, paint);

    for (var point in Utils.getPoints()) {
      canvas.drawCircle(point, 2, paint);
    }

    for (Line line in Utils.lines) {
      canvas.drawLine(line.p1, line.p2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// FOR PAINTING THE TRACKING POINT
class PointPainter extends CustomPainter {
  final double radius;
  final double radians;

  bool detailsNotNull = false;
  // late
  PointerEvent details;

  PointPainter(this.radius, this.radians);

  void setPosition(PointerEvent d) {
    details = d;
    detailsNotNull = true;
    // print("Setting point : " + details.position.toString());
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();

    path.close();
    canvas.drawPath(path, paint);

    // print("Details Not Null : " + detailsNotNull.toString());
    // if(detailsNotNull) {
    Offset pointA = Offset(Utils.getPointerEventStart().position.dx,
        Utils.getPointerEventStart().position.dy);
    Offset pointB = Offset(Utils.getPointerEventEnd().position.dx,
        Utils.getPointerEventEnd().position.dy);
    canvas.drawLine(pointA, pointB, paint);
    // }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
