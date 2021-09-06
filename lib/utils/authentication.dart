import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_todo_app/screens/home_page_screen.dart';
import 'package:flutter_firebase_todo_app/screens/sign_in_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase({
    BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePageScreen(user: user)),
          (route) => false);

      // Get.off(UserInfoScreen(user: user));
    }

    return firebaseApp;
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<User> signInWithGoogle({BuildContext context}) async {
    //FirebaseAuth auth = FirebaseAuth.instance;
    try {
      User user;

      final GoogleSignIn googleSignIn = GoogleSignIn();
      // Trigger the authentication flow
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        // Create a new credential
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          // Once signed in, return the UserCredential
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          //return user Object from user credential
          user = userCredential.user;
          return user;
        } on FirebaseAuthException catch (e) {
          print('111111111111');
        } catch (e) {
          print('2222222222');
        }
      } else {
        print('333333333');
      }
    } on PlatformException catch (e) {
      print('4444444');
    }
  }

  Future<void> signOut({BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await auth.signOut();
      //await storage.delete(key: "token");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static SnackBar customSnackBar({String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
