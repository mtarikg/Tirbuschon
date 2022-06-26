import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tirbuschon_feng497/palette.dart';

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
                            .orderBy('Reservation Date')
                            .where('Reservation Date',
                                isGreaterThanOrEqualTo: Timestamp.now())
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
                                  DateTime d_res = t_res.toDate().toLocal();
                                  Timestamp t_created =
                                      res[index]['Created Date'];
                                  DateTime d_created =
                                      t_created.toDate().toLocal();
                                  var d_res_f = new DateFormat.yMMMd()
                                      .add_jm()
                                      .format(d_res);
                                  var d_created_f = new DateFormat.yMMMd()
                                      .add_jm()
                                      .format(d_created);

                                  FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(res[index]["User ID"])
                                        .collection("profileInfo")
                                        .doc()
                                        .get(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (snapshot.hasError) {
                                        return Text("Something went wrong");
                                      }

                                      if (snapshot.hasData &&
                                          !snapshot.data!.exists) {
                                        return Text("Document does not exist");
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        Map<String, dynamic> data =
                                            snapshot.data!.data()
                                                as Map<String, dynamic>;
                                        print("agagagagagagag");
                                        name = data['fullName'].toString();
                                      }
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );

                                  return ListTile(
                                      title: createReservation(
                                          PartySize: res[index]['Party Size'],
                                          //ReservationID: res[index]['Reservation ID'],
                                          ReservationDate: d_res_f,
                                          CreatedDate: d_created_f,
                                          TotalPrice: res[index]['Total Price'],
                                          //orders: res['Orders'].toString(),
                                          UserID: name));
                                });
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })),
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
}
