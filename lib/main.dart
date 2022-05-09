import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/Admin/sign_up/page/sign_up_page.dart';
import 'direct.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    print('initState()');

    //MyApp.setLocale(context, locale);
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tirbuschon Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home:  Direct(),
      // WelcomePage(),
    );
  }
}
