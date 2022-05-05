import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Core/mainPage.dart';
import 'Restaurant/Screens/helper/navigator.dart';
import 'welcomePage.dart';

class Direct extends StatelessWidget {
  const Direct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserType(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          if (snapshot.toString().contains('Customer')) {
            return const MainPage();
          } else if (snapshot.toString().contains('Venue Owner')) {
            return const BottomNavigationBar1();
          }
        }

        return const WelcomePage();
      },
    );
  }

  Future<String> getUserType() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    var currentUser = _auth.currentUser;
    var currentUserID = currentUser!.uid;

    var document =
        await _firestore.collection('users').doc(currentUserID).get();
    var userData = document.data();

    return userData!['role'];
  }
}
