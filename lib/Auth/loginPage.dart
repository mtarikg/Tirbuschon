import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/Admin/adm_bottom_navigation/admin_navigator.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/helper/navigator.dart';
import '../Core/mainPage.dart';
import '../direct.dart';
import '../services/authService.dart';
import 'forgotPassword.dart';
import 'signUpPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                "Tirbuschon",
                style: TextStyle(
                  fontSize: 42,
                  color: Colors.blue[400],
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  _emailTextField(),
                  _passwordTextField(),
                  _forgotPasswordButton(context),
                  const SizedBox(
                    height: 10,
                  ),
                  _loginButton(context),
                ],
              ),
              _newUserReminderButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Container _loginButton(BuildContext context) {
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
          _loginWithEmailPassword();
        },
        child: const Text(
          "Login",
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
        onSaved: (value) {
          email = value.toString();
        },
      ),
    );
  }

  TextButton _forgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ForgotPassword(),
          ),
        );
      },
      child: const Text(
        "Forgot Password?",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 15,
        ),
      ),
    );
  }

  TextButton _newUserReminderButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpPage()),
        );
      },
      child: const Text(
        "New User? Create Account.",
        style: TextStyle(color: Colors.black87),
      ),
    );
  }

  void _loginWithEmailPassword() async {
    final AuthService _authService = AuthService();

    var _formState = _formKey.currentState;
    if (_formState!.validate()) {
      _formState.save();

      await _authService.signInWithEmail(email, password).then((value) {
        //venue email validation
        var venueValidation =
            RegExp("\b*@tirbuschon\.com\$", caseSensitive: false);
        //admin email validation
        var adminValidation =
            RegExp("\b*@tirbuschon\.admin.com\$", caseSensitive: false);
        if (venueValidation.hasMatch(email)) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomNavigationBar1()),
              (route) => false);
        } else if (adminValidation.hasMatch(email)) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminBottomNavBar()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Direct()),
              (route) => false);
        }
      }).catchError((error) {
        String errorDetail;
        if (error.toString().contains('invalid-email')) {
          errorDetail = "Email is invalid";
        } else if (error.toString().contains('user-not-found')) {
          errorDetail = "The user is not found.";
        } else if (error.toString().contains('wrong-password')) {
          errorDetail = "The password is wrong.";
        } else {
          errorDetail = "Fields can not be empty.";
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorDetail.toString()),
        ));
      });
    }
  }
}
