import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/Admin/add_new_restaurant/page/rest_add_page.dart';
import 'services/firestoreService.dart';
import 'Restaurant/Screens/helper/navigator.dart';
import 'direct.dart';
import 'Auth/furtherInfoToSignUpPage.dart';
import 'services/authService.dart';
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
          _bodyContainer(),
        ],
      ),
    );
  }

  Container _bodyContainer() {
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
          const MottoText(),
          const SizedBox(height: 15),
          Column(
            children: [
              LoginContainer(context: context),
              const SizedBox(height: 30),
              SignUpContainer(context: context),
              const SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: GoogleSignUp(context: context)),
                  const SizedBox(width: 5),
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 50,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminSignUpPage()),
                        );
                      },
                      child: const Text(
                        "Admin Login",
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
}

class GoogleSignUp extends StatelessWidget {
  const GoogleSignUp({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SignInButton(Buttons.Google, text: "Sign up with Google",
            onPressed: () {
      _signInWithGoogle();
    }));
  }

  void _signInWithGoogle() async {
    final AuthService _authService = AuthService();
    final FirestoreService _firestoreService = FirestoreService();

    final googleUser = await _authService.signInWithGoogle();
    final String userID, email, avatarURL;
    userID = googleUser!.uid;
    email = googleUser.email!;
    avatarURL = googleUser.photoURL!;

    var result = await _firestoreService.userExists(userID);
    if (result) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Direct()),
      );
    } else {
      _authService.createGoogleUser(email, userID, avatarURL);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FurtherInfoToSignUpPage(id: userID)),
      ).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    }
  }
}

class SignUpContainer extends StatelessWidget {
  const SignUpContainer({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 50,
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
        borderRadius: BorderRadius.circular(45),
      ),
    );
  }
}

class LoginContainer extends StatelessWidget {
  const LoginContainer({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 50,
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
        borderRadius: BorderRadius.circular(45),
      ),
    );
  }
}

class MottoText extends StatelessWidget {
  const MottoText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
