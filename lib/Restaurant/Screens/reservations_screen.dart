import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/palette.dart';

class ReservationScreen extends StatefulWidget {
  ReservationScreen({Key? key}) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reservations',
          style: TextStyle(color: Colors.black87, fontFamily: 'Montserrat'),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: 400,
       
      ),
    );
  }
}
