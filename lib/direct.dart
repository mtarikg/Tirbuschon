import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Core/mainPage.dart';
import 'welcomePage.dart';

class Direct extends StatelessWidget {
  const Direct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return const MainPage();
    } else {
      return const WelcomePage();
    }
  }
}