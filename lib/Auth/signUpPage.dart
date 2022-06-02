import 'package:flutter/material.dart';
import '../services/authService.dart';
import 'furtherInfoToSignUpPage.dart';
import 'loginPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _tirbuschonText(),
                const SizedBox(height: 10),
                Column(
                  children: [
                    _emailTextField(),
                    _passwordTextField(),
                    const SizedBox(height: 10),
                    _signUpButton(context),
                  ],
                ),
              ],
            ),
            _alreadySignedUpReminderButton(context),
          ],
        ),
      ),
    );
  }

  Container _signUpButton(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(width: 1),
        color: Colors.blue,
      ),
      child: TextButton(
        onPressed: () {
          _createUser();
        },
        child: const Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Padding _passwordTextField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: "Password",
          hintText: "Please enter your password",
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Password field can not be empty!";
          } else if (value.trim().length < 4) {
            return "Password can not be less then 4 chars.";
          }
          return null;
        },
        onSaved: (value) {
          password = value.toString();
        },
      ),
    );
  }

  Padding _emailTextField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.mail),
          labelText: "Email",
          hintText: "Please enter your email",
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Email field can not be empty!";
          } 
          else if (value.contains("@tirbuschon.com")) {
            return "You cannot signup with @tirbuschon.com domain";
          } 
          else if (!value.contains("@")) {
            return "Value should be an email format.";
          }
          return null;
        },
        onSaved: (value) {
          email = value.toString();
        },
      ),
    );
  }

  Text _tirbuschonText() {
    return Text(
      "Tirbuschon",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Colors.blue[400],
        fontStyle: FontStyle.italic,
      ),
    );
  }

  TextButton _alreadySignedUpReminderButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      child: const Text("Signed Up Before? Login Instead."),
    );
  }

  void _createUser() async {
    final AuthService _authService = AuthService();
    var _formState = _formKey.currentState;
    if (_formState!.validate()) {
      _formState.save();

      var uid = await _authService.createUser(email, password);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FurtherInfoToSignUpPage(id: uid)))
          .catchError((error) {
        String errorDetail;
        if (error.toString().contains('user-disabled')) {
          errorDetail = "Email is invalid";
        } else if (error.toString().contains('user-not-found')) {
          errorDetail = "The user is not found.";
        } else {
          errorDetail = "There is an error that we can not define.$error";
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorDetail.toString()),
        ));
      });
    }
  }
}