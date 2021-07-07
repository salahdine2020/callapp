import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:prayer_production/repository/shared_base.dart';
import 'package:prayer_production/views/signup.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            SignupPage(), //SignUpForm(),//SignUpScreen(),//Register(),
      ),
    );
  }

  Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/images/prayer_mosque.png',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    /// ex of assetName : images/choix_mosque.png
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      // pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      //globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            // child: _buildImage('images/prayer_mosque.png', 100),
          ),
        ),
      ),
      /*
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Let\s go right away!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      */
      pages: [
        PageViewModel(
          title: "Prayer Booking",
          body:
              "L'application qui vous aide à ne pas manquez vos heures de prière.",
          image: _buildImage('images/prayer_mosque.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Intuitive",
          body: "Sélectionner simplement la prière que vous voulez réserver.",
          image: _buildImage('images/choix_priere.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Chercher une mosquée proche de vous",
          body:
              "Avec le code postal, l'application vous permettra de voir toutes les mosquées de coin.",
          image: _buildImage('images/choix_mosque.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "A la porte de la mosquée",
          body:
              "Sur l'accueil l'application, cliquez sur la prière réservée pour obtenir votre code d'accès en Qr Code.",
          //image: _buildFullscrenImage(),
          image: _buildImage('images/qr_code.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () async {
        _onIntroEnd(context);
        await RepositeryShared().saveSeenScreen(seen: true);
      },
//      onSkip: () async {
//        _onIntroEnd(context);
//        await RepositeryShared().saveSeenScreen(seen: true);
//      }, // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text(
        'Done',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      /*
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      */
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        //color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        //color: Colors.white,//Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
