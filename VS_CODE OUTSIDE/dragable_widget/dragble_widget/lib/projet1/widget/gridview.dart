import 'package:flutter/material.dart';

Widget GridViewGame({bool validate = false}) {
  return Padding(
    padding: const EdgeInsets.all(32),
    child: GridView.count(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 3,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.all(8),
            //child: const Text("He'd have you all unravel at the"),
            //color: Colors.teal[100],
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image_direction/image_lg.PNG"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
            padding: const EdgeInsets.all(8),
            //child: const Text('Heed not the rabble'),
            //color: Colors.teal[200],
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image_direction/image_ld.PNG"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
            padding: const EdgeInsets.all(8),
            //child: const Text('Sound of screams but the'),
            //color: Colors.teal[300],
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image_direction/image_clg.PNG"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
            padding: const EdgeInsets.all(8),
            //child: const Text('Who scream'),
            //color: Colors.teal[400],
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image_direction/image_cld.PNG"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
            padding: const EdgeInsets.all(8),
            //child: const Text('Revolution is coming...'),
            //color: Colors.teal[500],
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image_direction/image_lu.PNG"),
                fit: BoxFit.cover,
              ),
            ),
        ),
        validate
            ? Container(
                padding: const EdgeInsets.all(8),
                //child: const Text('Revolution is coming...'),
                //color: Colors.teal[500],
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/image_direction/image_sl.PNG"),
                    fit: BoxFit.cover,
                  ),
                ))
            : Container(
                padding: const EdgeInsets.all(8),
                //child: const Text('Revolution, they...'),
                //color: Colors.teal[600],
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/image_direction/qustion.PNG"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ],
    ),
  );
}
