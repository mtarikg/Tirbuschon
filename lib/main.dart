import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Auth/direct.dart';


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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tirbuschon Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  Direct(),
    );
  }
}
