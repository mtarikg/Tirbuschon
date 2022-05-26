import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/Core/User/uploadProfileImagePage.dart';
import 'package:tirbuschon_feng497/welcomePage.dart';

import '../Core/mainPage.dart';
import '../services/authService.dart';

class NavigatorButtonCard extends StatelessWidget {
  final String text;
  final dynamic pageToNavigate;

  const NavigatorButtonCard({
    required this.text,
    this.pageToNavigate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
            onPressed: () {
              if (text.toLowerCase().contains("username")) {
                _changeUsername(context);
              } else if (text.toLowerCase().contains("full name")) {
                _changeFullName(context);
              } else if (text.toLowerCase().contains("phone number")) {
                _changePhoneNumber(context);
              } else if (text.toLowerCase().contains("profile image")) {
                _changeProfileImage(context);
              } else if (text.toLowerCase().contains("delete account")) {
                _deleteAccount(context);
              }

              pageToNavigate == null
                  ? null
                  : Navigator.push(context,
                      MaterialPageRoute(builder: (context) => pageToNavigate));
            },
            child: Text(text,
                style: const TextStyle(color: Colors.white, fontSize: 20))),
      ),
    );
  }
}

_changePhoneNumber(BuildContext context) {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _textFieldController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("New Phone number"),
        content: TextField(
          onChanged: (value) async {
            var user = FirebaseAuth.instance.currentUser;
            var userID = user!.uid;

            var document = await _firestore
                .collection('Users')
                .doc(userID)
                .collection('profileInfo')
                .get();
            document.docs[0].reference.update({'phoneNumber': value});
          },
          controller: _textFieldController,
          decoration: const InputDecoration(
              hintText: "Please enter your new phone number."),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"))
        ],
      );
    },
  ).then((value) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
      (route) => false));
}

_changeUsername(BuildContext context) {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _textFieldController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("New Username"),
        content: TextField(
          onChanged: (value) async {
            var user = FirebaseAuth.instance.currentUser;
            var userID = user!.uid;

            var document = await _firestore
                .collection('Users')
                .doc(userID)
                .collection('profileInfo')
                .get();
            document.docs[0].reference.update({'username': value});
          },
          controller: _textFieldController,
          decoration: const InputDecoration(
              hintText: "Please enter your new username."),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"))
        ],
      );
    },
  ).then((value) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
      (route) => false));
}

_changeFullName(BuildContext context) {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _textFieldController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("New Full Name"),
        content: TextField(
          onChanged: (value) async {
            var user = FirebaseAuth.instance.currentUser;
            var userID = user!.uid;

            var document = await _firestore
                .collection('Users')
                .doc(userID)
                .collection('profileInfo')
                .get();
            document.docs[0].reference.update({'fullName': value});
          },
          controller: _textFieldController,
          decoration: const InputDecoration(
              hintText: "Please enter your new username."),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"))
        ],
      );
    },
  ).then((value) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
      (route) => false));
}

_changeProfileImage(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const UploadProfileImage()));
}

_deleteAccount(BuildContext context) {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Account Deleted"),
              content: const Text("Your account has been deleted."),
              actions: [
                TextButton(
                    onPressed: () {
                      var user = FirebaseAuth.instance.currentUser;
                      var userID = user!.uid;
                      _authService.signOut();
                      deleteUserCollection(_firestore, userID, "profileInfo");
                      user.delete();
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"))
              ],
            );
          })
      .then((value) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (route) => false));
}

void deleteUserCollection(
    FirebaseFirestore _firestore, String userID, String subCollection) {
  _firestore
      .collection('Users')
      .doc(userID)
      .collection(subCollection)
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
  });
}
