import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Core/mainPage.dart';
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
          return const MainPage();
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
    _firestore.collection('Users').doc(currentUserID);

    return document.id;
  }
}
