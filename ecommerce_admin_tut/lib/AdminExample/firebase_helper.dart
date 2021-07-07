import 'package:firebase/firebase.dart' as fb;

class FirebaseHelper {
  static fb.Database initDatabase() {
    try {
      if (fb.apps.isEmpty) {
        fb.initializeApp(
            apiKey: "AIzaSyDU7Xvg40RovFQKYPIwuGjmI0MYbPtv2ss",
            authDomain: "mailer2-beb83.firebaseapp.com",
            databaseURL: "https://mailer2-beb83.firebaseio.com",
            projectId: "mailer2-beb83",
            storageBucket: "mailer2-beb83.appspot.com",
            messagingSenderId: "745908994533",
            appId: "1:745908994533:web:2d27752df8908ee8f7ef0c",
            measurementId: "G-T3GK566D3Q"
        );
      }
    } on fb.FirebaseJsNotLoadedException catch (e) {
      print(e);
    }
    return fb.database();
  }
}
