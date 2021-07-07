import 'package:dragble_widget/main.dart';
import 'package:dragble_widget/projet1/data/data.dart';
import 'package:dragble_widget/projet1/widget/draggable_widget.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class QuizzDirections extends StatefulWidget {
  const QuizzDirections({Key key}) : super(key: key);

  @override
  _QuizzDirectionsState createState() => _QuizzDirectionsState();
}

class _QuizzDirectionsState extends State<QuizzDirections> {
  final List<Animal> all = allAnimals;
  final List<Directions> alldiection = allDirection;
  final List<Directions> solution = [];
  final List<Animal> land = [];
  final List<Animal> air = [];

  final double size = 150;

  void removeAll(Animal toRemove) {
    all.removeWhere((animal) => animal.imageUrl == toRemove.imageUrl);
    land.removeWhere((animal) => animal.imageUrl == toRemove.imageUrl);
    air.removeWhere((animal) => animal.imageUrl == toRemove.imageUrl);
  }

  void removeAll2(Directions toRemove) {
    alldiection.removeWhere(
      (dirc) => dirc.imageUrl == toRemove.imageUrl,
    );
    solution.removeWhere(
      (dirc) => dirc.imageUrl == toRemove.imageUrl,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildTarget2(
              context,
              text: 'All',
              directions: alldiection,
              acceptTypes: DirectionType.values,
              onAccept: (data) => setState(() {
                removeAll2(data);
                alldiection.add(data);
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // use list of images
                /*buildTarget(
                  context,
                  text: 'Animals',
                  animals: land,
                  acceptTypes: [AnimalType.land],
                  onAccept: (data) => setState(() {
                    removeAll(data);
                    land.add(data);
                  }),
                ),*/
                buildQustion(),
                buildTarget3(
                  context,
                  //text: '',
                  directions: solution,
                  acceptTypes: [DirectionType.sl],
                  onAccept: (data) => setState(() {
                    removeAll2(data);
                    solution.add(data);
                  }),
                ),
              ],
            ),
          ],
        ),
      );

  Widget buildTarget(
    BuildContext context, {
    @required String text,
    @required List<Animal> animals,
    @required List<AnimalType> acceptTypes,
    @required DragTargetAccept<Animal> onAccept,
  }) =>
      CircleAvatar(
        radius: size / 2,
        child: DragTarget<Animal>(
          builder: (context, candidateData, rejectedData) => Stack(
            children: [
              ...animals
                  .map(
                    (animal) => DraggableWidget(animal: animal),
                  )
                  .toList(),
              IgnorePointer(
                child: Center(
                  child: buildText(text),
                ),
              ),
            ],
          ),
          onWillAccept: (data) => true,
          onAccept: (data) {
            if (acceptTypes.contains(data.type)) {
              Utils.showSnackBar(
                context,
                text: 'This Is Correct 🥳',
                color: Colors.green,
              );
            } else {
              Utils.showSnackBar(
                context,
                text: 'This Looks Wrong 🤔',
                color: Colors.red,
              );
            }

            onAccept(data);
          },
        ),
      );

  Widget buildTarget2(
    BuildContext context, {
    @required String text,
    @required List<Directions> directions,
    @required List<DirectionType> acceptTypes,
    @required DragTargetAccept<Directions> onAccept,
  }) =>
      DragTarget<Directions>(
        builder: (context, candidateData, rejectedData) => Expanded(
          child: Row(
            //Stack
            //scrollDirection: Axis.horizontal,
            //shrinkWrap: true,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...directions
                  .map(
                    (direction) => DraggableWidget(
                      direction: direction,
                    ),
                  )
                  .toList(),
              IgnorePointer(
                child: Center(
                  child: buildText(text),
                ),
              ),
            ],
          ),
        ),
        onWillAccept: (data) => true,
        onAccept: (data) {
          if (acceptTypes.contains(data.dir_type)) {
            Utils.showSnackBar(
              context,
              text: 'This Is Correct 🥳',
              color: Colors.green,
            );
          } else {
            Utils.showSnackBar(
              context,
              text: 'This Looks Wrong 🤔',
              color: Colors.red,
            );
          }
          onAccept(data);
        },
      );

  Widget buildTarget3(
    BuildContext context, {
    @required String text,
    @required List<Directions> directions,
    @required List<DirectionType> acceptTypes,
    @required DragTargetAccept<Directions> onAccept,
  }) =>
      Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image_direction/qustion.PNG"),
            fit: BoxFit.cover,
          ),
        ),
        child: DragTarget<Directions>(
          builder: (context, candidateData, rejectedData) => Stack(
            //Stack
            //scrollDirection: Axis.horizontal,
            //shrinkWrap: true,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...directions
                  .map(
                    (direction) => DraggableWidget(
                      direction: direction,
                    ),
                  )
                  .toList(),
              IgnorePointer(
                child: Center(
                  child: buildText(text ?? ''),
                ),
              ),
            ],
          ),
          onWillAccept: (data) => true,
          onAccept: (data) {
            if (acceptTypes.contains(data.dir_type)) {
              Utils.showSnackBar(
                context,
                text: 'This Is Correct 🥳',
                color: Colors.green,
              );
            } else {
              Utils.showSnackBar(
                context,
                text: 'This Looks Wrong 🤔',
                color: Colors.red,
              );
            }
            onAccept(data);
          },
        ),
      );

  Widget buildText(String text) => Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 12,
          )
        ]),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget buildQustion() => Container(
    height: MediaQuery.of(context).size.height *.3,
    width: MediaQuery.of(context).size.width *.7,

    decoration: BoxDecoration(
      //color: Colors.redAccent,
      image: DecorationImage(
        image: AssetImage("assets/image_direction/etape2_game2_img1.png",),
        fit: BoxFit.scaleDown,
      ),
    ),
  );
}
