/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/palette.dart';
import 'package:async/async.dart';

class ViewAllRestaurants extends StatefulWidget {
  final String venueName;
  late String venueAddress;
  final String venuePhone;
  final String venueCapacity;
  final String venueReservationCapacity;

  ViewAllRestaurants(
      {Key? key,
      required this.venueName,
      required this.venueAddress,
      required this.venuePhone,
      required this.venueCapacity,
      required this.venueReservationCapacity})
      : super(key: key);

  @override
  State<ViewAllRestaurants> createState() => _ViewAllRestaurantsState();
}

//Venue name in docs should be passed authomatically
//line 30 will be updated

class _ViewAllRestaurantsState extends State<ViewAllRestaurants> {
  //retrieve data from database
  /* final CollectionReference collectionReference = FirebaseFirestore.instance
      .collection('Venues')
      .doc()
      .collection('Profile Information'); */


     

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Restaurants',
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
                                  title: ListRestaurants(
                                    venueName: e['Venue Name'],
                                    venueAddress: e['Address'],
                                    venuePhone: e['Phone'],
                                    venueCapacity: e['Capacity'],
                                    venueReservationCapacity:
                                        e['Reservation Capacity'],
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

  Widget ListRestaurants({venueName, venueAddress, venuePhone, venueCapacity, venueReservationCapacity}) {
    return Container(
      height: 300,
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
                      "Name : $venueName",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                    Text(
                      "Address : $venueAddress",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                    Text(
                      "Phone : $venuePhone",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                    Text(
                      "Capacity : $venueCapacity",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                    Text(
                      "Reservation Capacity : $venueReservationCapacity",
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


Future<List<String>> _retrieveUsers() async{
     /*  //get all the users
      QuerySnapshot query = await FirebaseFirestore.instance
              .collection('Venues').get();
      Map<String,Map<String,dynamic>> userMap = Map();
      //add each user to the map
      query.docs.forEach(doc => userMap.putIfAbsent(doc.id, doc.data());
      FutureGroup<QuerySnapshot> queries = FutureGroup(); //add async package in pubspec.yaml [there might be version issues]
      //retrieve sub collections and bind them to the corresponding user
      query.docs.forEach((doc) => queries.add(_retrieveSubCollection(userMap,doc)));
      //Close queries
      queries.close();
      //Await for all the queries to be completed
      await queries.future;
      //now you have for each user a structure containing its data plus everything in its sub collection. Do whatever you want and then return a list or a map according to what you need
      
      return ; */

       QuerySnapshot query = await FirebaseFirestore.instance
    .collection('Venues')
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
            FirebaseFirestore.instance
               .doc(doc.id)
               .collection("Profile Information")
               .get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
            FirebaseFirestore.instance
               .doc(doc.id)
               .collection("Venue Name")
               .get();
              
        });
    });
              
        });
    });
    const snap = await db.collectionGroup('account').get();
const users = snap.docs.map(d => ({id: doc.ref.parent.parent.id, data: d.data()))

    return doc;
 }
 
 Future<Widget> _retrieveSubCollection( Map<String,Map<String,dynamic>> userMap, DocumentSnapshot doc) async{
        //retrieve the subcollection of a document using its id
        QuerySnapshot query = query FirebaseFirestore.instance
              .collection('Venues')
          .doc(doc.id).collection('Profile Information').get();
        //bind the subcollection to the relative user
        Map<String, dynamic>? userData = userMap[doc.id];
        //userData.add("subcollection", query.docs.map((subDoc) =>subDoc.data()).toList());
        //userMap.update(doc.id,(value)=> userData);
        return ;
      }
 */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewAllRestaurants extends StatefulWidget {
  ViewAllRestaurants({Key? key}) : super(key: key);

  @override
  State<ViewAllRestaurants> createState() => _ViewAllRestaurantsState();
}

class _ViewAllRestaurantsState extends State<ViewAllRestaurants> {
  @override
  Widget build(BuildContext context) {
    print(FirebaseFirestore.instance
        .collectionGroup('Profile Information')
        .get());
    return Container();
  }
}
