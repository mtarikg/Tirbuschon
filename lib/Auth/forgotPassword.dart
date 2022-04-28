import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _emailTextField(),
          const SizedBox(
            height: 20,
          ),
          _resetPasswordButton(context),
        ],
      ),
    );
  }

  Column _emailTextField() {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.mail),
              labelText: "Email",
              hintText: "Please enter your email",
            ),
          ),
        ),
      ],
    );
  }

  Container _resetPasswordButton(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 10,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.blueAccent,
          border: Border.all(
            width: 1,
          )),
      child: TextButton(
        onPressed: () {},
        child: const Text(
          "Request Password Reset",
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
      ),
    );
  }
}
