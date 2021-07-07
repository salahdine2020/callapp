import 'package:dragble_widget/projet1/data/data.dart';
import 'package:flutter/material.dart';

class DraggableWidget extends StatelessWidget {
  final Animal animal;
  final Directions direction;

  const DraggableWidget({
    Key key,
    this.animal,
    @required this.direction,
  }) : super(key: key);

  static double size = 80;

  @override
  Widget build(BuildContext context) => buidDirection();//buidAnimal();

  Widget buildImage() => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Image.asset(animal.imageUrl),
      );

    Widget buildImage2() => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Image.asset(direction.imageUrl),
      );    

  Widget buidAnimal() => Draggable<Animal>(
        data: animal,
        feedback: buildImage(),
        child: buildImage(),
        childWhenDragging: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey,
          ),
        ),
      );

  Widget buidDirection() => Draggable<Directions>(
        data: direction,
        feedback: buildImage2(),
        child: buildImage2(),
        childWhenDragging: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey,
          ),
        ),
      );
}
