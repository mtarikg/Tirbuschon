import 'package:flutter/material.dart';
import '../services/firestoreService.dart';
import '../Core/User/BottomNavigationBarPages/mainPage.dart';
import '../welcomePage.dart';

class Direct extends StatelessWidget {
  const Direct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return const MainPage();
          }

          return const WelcomePage();
        });
  }

  Future<String> getUser() async {
    FirestoreService _firestoreService = FirestoreService();
    return await _firestoreService.getUser();
  }
}
