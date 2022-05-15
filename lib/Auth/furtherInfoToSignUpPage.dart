import 'package:flutter/material.dart';
import '../direct.dart';
import '../services/authService.dart';
import 'loginPage.dart';

class FurtherInfoToSignUpPage extends StatefulWidget {
  final String? id;

  const FurtherInfoToSignUpPage({required this.id, Key? key}) : super(key: key);

  @override
  _FurtherInfoToSignUpPageState createState() =>
      _FurtherInfoToSignUpPageState();
}

class _FurtherInfoToSignUpPageState extends State<FurtherInfoToSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late String username, fullName, phoneNumber;

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
                    _fullNameTextField(),
                    _usernameTextField(),
                    _phoneNumberTextField(),
                    const SizedBox(height: 10),
                    _completeButton(context),
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

  Container _completeButton(BuildContext context) {
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
          _updateUser();
        },
        child: const Text(
          "Complete",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Padding _usernameTextField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person_outline),
          labelText: "Username",
          hintText: "Please enter your username",
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Username field can not be empty!";
          } else if (value.trim().length < 4 || value.trim().length > 10) {
            return "Username can be at least 4 and most 10 chars.";
          }
          return null;
        },
        onSaved: (value) {
          username = value.toString();
        },
      ),
    );
  }

  Padding _phoneNumberTextField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.phone),
          labelText: "Phone number",
          hintText: "Please enter your mobile phone number",
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Phone number field can not be empty!";
          } else if (value.trim().length < 4) {
            return "Phone number should be at least 4 chars without country code.";
          }
          return null;
        },
        onSaved: (value) {
          phoneNumber = value.toString();
        },
      ),
    );
  }

  Padding _fullNameTextField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: "Full Name",
          hintText: "Please enter your full name",
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Full name field can not be empty!";
          } else if (value.trim().length < 4) {
            return "Full name should be at least 4 characters.";
          }
          return null;
        },
        onSaved: (value) {
          fullName = value.toString();
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

  void _updateUser() async {
    final AuthService _authService = AuthService();
    var _formState = _formKey.currentState;
    if (_formState!.validate()) {
      _formState.save();

      await _authService
          .updateUser(widget.id, username, fullName, phoneNumber)
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Direct()),
            (route) => false);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
        ));
      });
    }
  }
}
