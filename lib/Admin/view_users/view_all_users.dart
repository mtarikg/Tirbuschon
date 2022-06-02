import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewAllUsers extends StatefulWidget {
  ViewAllUsers({Key? key}) : super(key: key);

  @override
  State<ViewAllUsers> createState() => _ViewAllUsersState();
}

class _ViewAllUsersState extends State<ViewAllUsers> {

   final databaseReference = FirebaseFirestore.instance;

  @override
  void initState() {
     
  }
 


  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }
}