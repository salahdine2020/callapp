enum AnimalType { land, air }
enum DirectionType { lu, lg, ld, clg, cld, sl}

class Animal {
  final String imageUrl;
  final AnimalType type;

  Animal({
    this.imageUrl,
    this.type,
  });
}

final allAnimals = [
  Animal(
    type: AnimalType.land,
    imageUrl: 'assets/animal1.png',
  ),
  Animal(
    type: AnimalType.air,
    imageUrl: 'assets/bird1.png',
  ),
  Animal(
    type: AnimalType.air,
    imageUrl: 'assets/bird2.png',
  ),
  Animal(
    type: AnimalType.land,
    imageUrl: 'assets/animal2.png',
  ),
  Animal(
    type: AnimalType.air,
    imageUrl: 'assets/bird3.png',
  ),
  Animal(
    type: AnimalType.land,
    imageUrl: 'assets/animal3.png',
  ),
];

class Directions {
  final String imageUrl;
  final DirectionType dir_type;
  Directions({this.imageUrl, this.dir_type});
}

final allDirection = [
  Directions(
    imageUrl: 'assets/image_direction/image_lu.PNG',
    dir_type: DirectionType.lu,
  ),
  Directions(
    imageUrl: 'assets/image_direction/image_lg.PNG',
    dir_type: DirectionType.lg,
  ),
  /*
  Directions(
    imageUrl: 'assets/image_direction/image_ld.PNG',
    dir_type: DirectionType.ld,
  ),
  Directions(
    imageUrl: 'assets/image_direction/image_clg.PNG',
    dir_type: DirectionType.clg,
  ),
  Directions(
    imageUrl: 'assets/image_direction/image_cld.PNG',
    dir_type: DirectionType.cld,
  ),
  */
  Directions(
    imageUrl: 'assets/image_direction/image_sl.PNG',
    dir_type: DirectionType.sl,
  ),
];
