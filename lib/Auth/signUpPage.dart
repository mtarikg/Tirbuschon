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
  final passwordKey = GlobalKey<FormFieldState>();
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
                    _confirmPasswordTextField(),
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
        key: passwordKey,
        obscureText: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: "Password",
          hintText: "Please enter your password",
        ),
        validator: (value) {
          String pattern =
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
          String? errorDetail;

          if (value!.isEmpty) {
            errorDetail = "Password field can not be empty!";
          } else if (!value.contains(RegExp(pattern))) {
            errorDetail =
                "Password should consist of at least 1 uppercase, 1 lowercase, 1 numeric and 1 special character "
                "with at least 6 characters in total.";
          }

          errorDetail != null
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(errorDetail.toString()),
                ))
              : null;
        },
      ),
    );
  }

  Padding _confirmPasswordTextField() {
    var passwordValue = passwordKey.currentState?.value;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: "Confirm Password",
          hintText: "Please confirm your password",
        ),
        validator: (value) {
          String? errorDetail;

          if (value != passwordValue) {
            errorDetail = "Passwords should be matched!";
          }

          errorDetail != null
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(errorDetail.toString()),
                ))
              : null;
        },
        onSaved: (value) {
          if (value == passwordValue) {
            password = value.toString();
          }
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
          String? errorDetail;

          if (value!.isEmpty) {
            errorDetail = "Email field can not be empty!";
          } else if (!value.contains("@")) {
            errorDetail = "Value should be an email format.";
          }

          errorDetail != null
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(errorDetail.toString()),
                ))
              : null;
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
          errorDetail = "This account is disabled.";
        } else if (error.toString().contains('user-not-found')) {
          errorDetail = "The user has not been found.";
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
