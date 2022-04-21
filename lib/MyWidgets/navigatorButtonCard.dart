import 'package:flutter/material.dart';

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
