import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Restaurant/Screens/helper/navigator.dart';
import 'direct.dart';
import 'Auth/furtherInfoToSignUpPage.dart';
import 'services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'Auth/loginPage.dart';
import 'Auth/signUpPage.dart';

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
        ],
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
        textAlign: TextAlign.center,
      ),
    );
  }

  Container _welcomeTextContainer() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          const Text(
            "Welcome",
            style: TextStyle(
              color: Colors.green,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Tirbuschon",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 50,
            ),
          ),
          _mottoText(),
          const SizedBox(height: 15),
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
              const SizedBox(height: 30),
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
              const SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Expanded(
                          child: SignInButton(Buttons.Google,
                              text: "Sign up with Google", onPressed: () async {
                        try {
                          _signInWithGoogle();
                        } catch (e) {
                          if (e is FirebaseAuthException) {
                            print(e.message!);
                          }
                        }
                      }))),
                  const SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Expanded(
                      child: SignInButton(
                        Buttons.Facebook,
                        text: "Sign up with Facebook",
                        onPressed: () {
                          // signInWithFacebook();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 50,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BottomNavigationBar1()),
                        );
                      },
                      child: const Text(
                        "Venue Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 110, 20, 229),
                      borderRadius: BorderRadius.circular(45),
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
        MaterialPageRoute(builder: (context) => const Direct()),
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
  }
}
