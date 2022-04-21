import 'package:flutter/material.dart';
import 'Auth/furtherInfoToSignUpPage.dart';
import 'services/authService.dart';
import 'Auth/loginPage.dart';
import 'Auth/signUpPage.dart';
import 'Core/mainPage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
        oAuthButtons(context),
      ],
    );
  }

  Row oAuthButtons(BuildContext context) {
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
              _loginWithGoogle();
            },
            child: const Text(
              "Sign in with Google",
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
          ),
        ],
      ),
    );
  }

  void _loginWithGoogle() async {
    final AuthService _authService = AuthService();
    final googleUser = await _authService.signInWithGoogle();

    final String userId, email;
    userId = googleUser!.uid;
    email = googleUser.email!;

    _authService.createGoogleUser(email, userId);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FurtherInfoToSignUpPage(id: userId)),
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
