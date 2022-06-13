import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/palette.dart';

class ReservationScreen extends StatefulWidget {
  final int Capacity;
  // late List<String> orders = [];
  final DateTime ReservationDate;
  final DateTime CreatedDate;
  final int TotalPrice;
  final int UserID;
  final int ReservationID;

  ReservationScreen(
      {Key? key,
      required this.Capacity,
      //required this.orders,
      required this.ReservationID,
      required this.ReservationDate,
      required this.CreatedDate,
      required this.TotalPrice,
      required this.UserID})
      : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

//Venue name in docs should be passed authomatically
//line 30 will be updated

class _ReservationScreenState extends State<ReservationScreen> {
  //retrieve data from database

  late CollectionReference collectionReference;
  late Query query;
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
          title: Text(
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
                            .orderBy('Created Date')
                            .limitToLast(2)
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var res = snapshot.data!.docs;
                                  Timestamp t_res =
                                      res[index]['Reservation Date'];
                                  DateTime d_res = t_res.toDate();
                                  Timestamp t_created =
                                      res[index]['Created Date'];
                                  DateTime d_created = t_created.toDate();
                                  return ListTile(
                                    title: createReservation(
                                      Capacity: res[index]['Capacity'],
                                      ReservationID: res[index]
                                          ['Reservation ID'],
                                      ReservationDate: d_res,
                                      CreatedDate: d_created,
                                      TotalPrice: res[index]['Total Price'],
                                      //orders: res['Orders'].toString(),
                                      UserID: res[index]['User ID'].toString(),
                                    ),
                                  );
                                });
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })),
              ],
            )));
  }

  Widget createReservation(
      {Capacity,
      //orders,
      UserID,
      ReservationID,
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
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                    Text(
                      "Capacity : $Capacity",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                    Text(
                      "ReservationID : $ReservationID",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                    Text(
                      "ReservationDate : $ReservationDate",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                    Text(
                      "CreatedDate : $CreatedDate",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                    Text(
                      "TotalPrice : $TotalPrice",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
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
}
