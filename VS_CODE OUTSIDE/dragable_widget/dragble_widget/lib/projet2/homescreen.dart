import 'package:flutter/material.dart';

import 'itemmodel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //var player = AudioCache();
  List<ItemModel> items;
  List<ItemModel> items2;
  List<ItemModel> items3;
  int score;
  bool gameOver;
  bool accepting = false;

  initGame() {
    gameOver = false;
    score = 0;
    items = [
      ItemModel(
        value: 'lu',
        name: 'line Up',
        img: 'assets/image_direction/image_lu.PNG',
      ),
      ItemModel(
        value: 'cld',
        name: 'c line droit',
        img: 'assets/image_direction/image_cld.PNG',
      ),
      ItemModel(
        value: 'sl',
        name: 'solution',
        img: 'assets/image_direction/image_sl.PNG',
      ),
    ];

    items3 = [
      ItemModel(
        value: 'lg',
        name: 'line gauche',
        img: 'assets/image_direction/image_lg.PNG',
      ),
      ItemModel(
        value: 'ld',
        name: 'line droit',
        img: 'assets/image_direction/image_ld.PNG',
      ),
      ItemModel(
        value: 'cld',
        name: 'c line droit',
        img: 'assets/image_direction/image_cld.PNG',
      ),
      ItemModel(
        value: 'clg',
        name: 'c line gauche',
        img: 'assets/image_direction/image_clg.PNG',
      ),
      ItemModel(
        value: 'lu',
        name: 'line Up',
        img: 'assets/image_direction/image_lu.PNG',
      ),
      ItemModel(
        value: 'qustion',
        name: 'qustion',
        img: 'assets/image_direction/qustion.PNG',
      ),
    ];
    items2 = List<ItemModel>.from(items);

    items.shuffle();
    items2.shuffle();
  }

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) gameOver = true;
    return Container(
      //backgroundColor: Colors.amber,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!gameOver)
                accepting
                    ? correctAnswer()
                    : GridView.count(
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 3,
                        children: items3.map((item) {
                          return DragTarget(
                            onAccept: (receivedItem) {
                              print(
                                  'item.value is : ${item.value}  and receivedItem.value is ${receivedItem.value}');
                              if (item.value == 'qustion' &&
                                  receivedItem.value == 'sl') {
                                setState(() {
                                  accepting = true;
                                  //items.remove(receivedItem);
                                  //items3.remove(item); // maybe use clear and replace by other message
                                });
                                //-------------yèèèèèèèèyèèèèèèèèèèèèèèèèèèèèèèèèèèèèèscore += 10;
                                //item.accepting = false;

                                //player.play('true.wav');
                              } else {
                                setState(() {
                                  //score -= 5;
                                  //item.accepting = false;
                                  //player.play('false.wav');
                                });
                              }
                              print(accepting);
                            },
                            onWillAccept: (receivedItem) {
                              setState(() {
                                item.accepting = true;
                              });
                              return true;
                            },
                            onLeave: (receivedItem) {
                              setState(() {
                                item.accepting = false;
                              });
                            },
                            builder: (context, acceptedItems, rejectedItems) {
                              return Container(
                                padding: const EdgeInsets.all(8),
                                //child: const Text('Revolution is coming...'),
                                //color: Colors.teal[500],
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(item.img),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
              if (!gameOver)
                Row(
                  children: [
                    Spacer(),
                    accepting ? Container(child: Text('Correct Answer 😃',style: TextStyle(fontSize: 24))): Row(
                      children: items.map((item) {
                        return Container(
                          margin: EdgeInsets.all(8),
                          child: Draggable<ItemModel>(
                            data: item,
                            childWhenDragging: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(item.img),
                              radius: 40,
                            ),
                            feedback: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(item.img),
                              radius: 30,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(item.img),
                              radius: 32,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Spacer(),
                  ],
                ),
              if (gameOver)
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Game Over',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          result(),
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                    ],
                  ),
                ),
              if (gameOver)
                Container(
                  height: MediaQuery.of(context).size.width / 10,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        initGame();
                      });
                    },
                    child: Text(
                      'New Game',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  //Functions:

  String result() {
    if (score == 100) {
      //player.play('success.wav');
      return 'Awesome!';
    } else {
      //player.play('tryAgain.wav');
      return 'Play again to get better score';
    }
  }
}

class correctAnswer extends StatelessWidget {
  correctAnswer({
    Key key,
  }) : super(key: key);

  List<ItemModel> items3 = [
    ItemModel(
      value: 'lg',
      name: 'line gauche',
      img: 'assets/image_direction/image_lg.PNG',
    ),
    ItemModel(
      value: 'ld',
      name: 'line droit',
      img: 'assets/image_direction/image_ld.PNG',
    ),
    ItemModel(
      value: 'cld',
      name: 'c line droit',
      img: 'assets/image_direction/image_cld.PNG',
    ),
    ItemModel(
      value: 'clg',
      name: 'c line gauche',
      img: 'assets/image_direction/image_clg.PNG',
    ),
    ItemModel(
      value: 'lu',
      name: 'line Up',
      img: 'assets/image_direction/image_lu.PNG',
    ),
    ItemModel(
      value: 'sl',
      name: 'solution',
      img: 'assets/image_direction/image_sl.PNG',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 3,
      children: items3.map((item) {
        return Container(
          padding: const EdgeInsets.all(8),
          //child: const Text('Revolution is coming...'),
          //color: Colors.teal[500],
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(item.img),
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }
}
