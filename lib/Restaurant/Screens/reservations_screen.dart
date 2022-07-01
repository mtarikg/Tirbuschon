import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tirbuschon_feng497/palette.dart';

import '../../services/firestoreService.dart';

class ReservationScreen extends StatefulWidget {
  final int PartySize;
  // late List<String> orders = [];
  final String ReservationDate;
  final String CreatedDate;
  final int TotalPrice;
  final int UserID;
  //final int ReservationID;

  ReservationScreen(
      {Key? key,
      required this.PartySize,
      //required this.orders,
      //required this.ReservationID,
      required this.ReservationDate,
      required this.CreatedDate,
      required this.TotalPrice,
      required this.UserID})
      : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  //retrieve data from database
  var username;

  late CollectionReference collectionReference;
  late Query query;
  var name;
  @override
  void initState() {
    String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    collectionReference = FirebaseFirestore.instance
        .collection('Venues')
        .doc(userId)
        .collection('Reservations');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'All Reservations',
            style: TextStyle(color: Colors.black87, fontFamily: 'Montserrat'),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: collectionReference
                            .orderBy('Reservation Date', descending: true)
                            .where('Reservation Date',
                                isGreaterThanOrEqualTo: Timestamp.now())
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasData) {
                            return ListView(
                                children: snapshot.data!.docs
                                    .map((e) => FutureBuilder(
                                        future: getUsername(e['User ID']),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic>
                                                secondSnapshot) {
                                          if (secondSnapshot.hasData) {
                                            return ListTile(
                                                title: createReservation(
                                                    PartySize: e['Party Size'],
                                                    //ReservationID: res[index]['Reservation ID'],
                                                    ReservationDate: DateFormat
                                                            .yMMMd()
                                                        .add_jm()
                                                        .format(
                                                            e['Reservation Date']
                                                                .toDate()
                                                                .toLocal()),
                                                    CreatedDate: DateFormat
                                                            .yMMMd()
                                                        .add_jm()
                                                        .format(
                                                            e['Created Date']
                                                                .toDate()
                                                                .toLocal()),
                                                    TotalPrice:
                                                        e['Total Price'],
                                                    //orders: res['Orders'].toString(),
                                                    UserID:
                                                        secondSnapshot.data));
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        }))
                                    .toList());
                          }

                          return const Center(
                              child: CircularProgressIndicator());
                        }))
              ],
            )));
  }

  Widget createReservation(
      {PartySize,
      //orders,
      UserID,
      //ReservationID,
      ReservationDate,
      CreatedDate,
      TotalPrice}) {
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
                      "Name : $UserID",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 15),
                    ),
                    Text(
                      "Party Size : $PartySize",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 15),
                    ),
                    /*Text(
                      "ReservationID : $ReservationID",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),*/
                    Text(
                      "Reservation Date : $ReservationDate",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 15),
                    ),
                    Text(
                      "Reservation Made : $CreatedDate",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 15),
                    ),
                    Text(
                      "Total Price : $TotalPrice",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 15),
                    ),
                    /*Text(
                      "Orders : $orders",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),*/
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getUsername(userID) async {
    var usernameValue =
        await FirestoreService().getProfileInfo(userID.toString(), 'fullName');

    return usernameValue;
  }
}
