import 'package:flutter/material.dart';
import 'package:prayer_production/views/accueil.dart';
import 'package:prayer_production/widgets/bottom_bar_widgets.dart';
import 'package:splashscreen/splashscreen.dart';

class CheckSucces extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SuccesWidget(context);
  }

  Scaffold SuccesWidget(context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 48),
            Text(
              "Envoye avec Success",
              style: TextStyle(
                fontSize: 28, //getProportionateScreenWidth(30),
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .6,
              width: MediaQuery.of(context).size.width * 1,
              child: Image.asset(
                "assets/images/success.png",
                //height: MediaQuery.of(context).size.height *.6, //40%
              ),
            ),
            SizedBox(height: 72),
            Container(
              height: 42,
              width: MediaQuery.of(context).size.width * .8,
              child: Material(
                borderRadius: BorderRadius.circular(6),
                shadowColor: Colors.deepOrangeAccent,
                color: Colors.orangeAccent,
                elevation: 7.0,
                child: GestureDetector(
                  onTap: () {
                    /// validate first
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeMainBottomBar(),
                            ///AccueilPage(),
                      ),
                    );
                    print('clicked');
                  },
                  child: Center(
                    child: Text(
                      'Demarer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
