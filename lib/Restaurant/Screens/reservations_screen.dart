import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/palette.dart';

class ReservationScreen extends StatefulWidget {
  final int capasity;
  late List<String> orders = [];
  final DateTime time;
  final int userId;

  ReservationScreen(
      {Key? key,
      required this.capasity,
      required this.orders,
      required this.time,
      required this.userId})
      : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

//Venue name in docs should be passed authomatically
//line 30 will be updated

class _ReservationScreenState extends State<ReservationScreen> {
  //retrieve data from database
  final CollectionReference collectionReference = FirebaseFirestore.instance
      .collection('Venues')
      .doc('Venue Name')
      .collection('Reservations');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Reservations',
          style: TextStyle(color: Colors.black87, fontFamily: 'Montserrat'),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.symmetric( vertical: 10),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: collectionReference.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.docs
                        .map((e) => Column(
                              children: [
                                ListTile(
                                  title: createReservation(
                                    capasity: e['Capasity'],
                                    orders: e['Orders'].toString(),
                                    time: e['Time'],
                                    userId: e['User ID'].toString(),
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget createReservation({capasity, orders, time, userId}) {
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width * 0.99,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: primaryLightWhite,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.05,
          left: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
      
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Name : $userId",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                    Text(
                      "Pax : $capasity",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                    Text(
                      "Time : $time",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                    Text(
                      "Orders : $orders",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
