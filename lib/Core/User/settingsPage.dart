import 'package:flutter/material.dart';
import '../../MyWidgets/navigatorButtonCard.dart';
import 'profileSettingsPage.dart';
import '../../welcomePage.dart';
import '../../services/authService.dart';
import 'policyPage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _tirbuschonText(context),
          const SizedBox(
            width: double.infinity,
            height: 200,
          ),
          const NavigatorButtonCard(
              pageToNavigate: ProfileSettingsPage(), text: "Profile Settings"),
          const NavigatorButtonCard(
              pageToNavigate: PolicyPage(), text: "Policy Page"),
          const NavigatorButtonCard(
              text: "Report a problem"),
          Card(
            color: Colors.blue,
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                  onPressed: () {
                    _logOut();
                  },
                  child: const Text("Log Out",
                      style: TextStyle(color: Colors.white, fontSize: 20))),
            ),
          ),
        ],
      ),
    );
  }

  RichText _tirbuschonText(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText1,
        children: const [
          TextSpan(
              text: "Tirbuschon",
              style: TextStyle(fontSize: 50, color: Colors.blue)),
        ],
      ),
    );
  }

  void _logOut() {
    final AuthService _authService = AuthService();

    _authService.signOut().then((value) {
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (route) => false);
    });
  }
}
