import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Auth/furtherInfoToSignUpPage.dart';
import 'services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/services.dart';

import 'Auth/loginPage.dart';
import 'Auth/signUpPage.dart';
import 'Auth/FirebaseService.dart';
import 'Core/mainPage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          _welcomeTextContainer(),
          _mottoText(),
          _buttonsColumn(context),
        ],
      ),
    );
  }

  Column _buttonsColumn(BuildContext context) {
    return Column(
      children: [
        _loginButton(context),
        const SizedBox(
          height: 10,
        ),
        _signUpButton(context),
        const SizedBox(
          height: 10,
        ),
        _oAuthButtons(context),
      ],
    );
  }

  Row _oAuthButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _googleButton(),
        const SizedBox(width: 5),
        _facebookButton(context),
      ],
    );
  }

  Padding _facebookButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      child: Expanded(
        child: Container(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
              );
            },
            child: const Text(
              "Sign In with Facebook",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1),
          ),
        ),
      ),
    );
  }

  Padding _googleButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      child: Expanded(
        child: Container(
          child: TextButton(
            onPressed: () {
              _signInWithGoogle();
            },
            child: const Text(
              "Sign in with Google",

          Container(
            alignment: Alignment.center,
            child: Column(
              children: const [
                SizedBox(height: 50),
                Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Tirbuschon",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Making reservations with Tirbuschon is easy peasy!",
              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1),
          ),
        ),
      ),
    );
  }

  Container _signUpButton(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 20,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUpPage()),
          );
        },
        child: const Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(width: 1),
      ),
    );
  }

  Container _loginButton(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 20,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        child: const Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(width: 1),
      ),
    );
  }

  Padding _mottoText() {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Text(
        "Making reservations with Tirbuschon is easy peasy!",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 20,
        ),
      ),
    );
  }

  Container _welcomeTextContainer() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: const [
          Text(
            "Welcome",
            style: TextStyle(
              color: Colors.green,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Tirbuschon",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),

          Column(
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 50,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(45),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 50,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(45),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Expanded(
                          child: Container(
                              child: SignInButton(Buttons.Google,
                                  text: "Sign up with Google",
                                  onPressed: () async {
                        try {
                          await signInwithGoogle();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage()),
                          );
                        } catch (e) {
                          if (e is FirebaseAuthException) {
                            showMessage(e.message!);
                          }
                          ;
                        }
                      })))),
                  const SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Expanded(
                      child: Container(
                        child: SignInButton(
                          Buttons.Facebook,
                          text: "Sign up with Facebook",
                          onPressed: () {
                            // signInWithFacebook();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

          ),
        ],
      ),
    );
  }


  void _signInWithGoogle() async {
    final AuthService _authService = AuthService();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final googleUser = await _authService.signInWithGoogle();
    final String userId, email, avatarURL;
    userId = googleUser!.uid;
    email = googleUser.email!;
    avatarURL = googleUser.photoURL!;

    var document = await _firestore.collection('users').doc(userId).get();
    var userData = document.data();
    if (userData != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      _authService.createGoogleUser(email, userId, avatarURL);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FurtherInfoToSignUpPage(id: userId)),
      ).catchError((error) {
        String errorDetail;
        if (error.toString().contains('user-disabled')) {
          errorDetail = "Email is invalid";
        } else if (error.toString().contains('user-not-found')) {
          errorDetail = "The user is not found.";
        } else {
          errorDetail = "There is an error that we can not define.$error";
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorDetail.toString()),
        ));
      });
    }
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
