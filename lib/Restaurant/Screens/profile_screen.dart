import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/edit_profile_screen.dart';
import 'package:tirbuschon_feng497/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  final String address;
  final String phone;
  final int capasity;
  final int reservationCapasity;
  final String name;

  ProfileScreen({
    Key? key,
    required this.capasity,
    required this.address,
    required this.phone,
    required this.reservationCapasity,
    required this.name,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

//Venue name in docs should be passed authomatically
//line 33 will be updated

class _ProfileScreenState extends State<ProfileScreen> {
  late CollectionReference collectionReference;
  late var photoUrl;

  @override
  void initState() {
    String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    photoUrl = FirebaseAuth.instance.currentUser!.photoURL ?? null;
    collectionReference = FirebaseFirestore.instance
        .collection('Venues')
        .doc(userId)
        .collection('Profile Information');
    super.initState();
  }
/* 
  Future<void> getVenueData() async {
    String userId = await FirebaseAuth.instance.currentUser!.uid;
    //final User? user = FirebaseAuth.instance.currentUser;

    /* setState(() {
      uid1 = user!.uid;
    }); */
    
  } */

  //retrieve data from database

  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Restaurant Profile',
          style: TextStyle(color: Colors.black87, fontFamily: 'Montserrat'),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.04,
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPage(
                              address: '',
                              capasity: 0,
                              name: '',
                              phone: '',
                              reservationCapasity: 0,
                            )));
              },
              child: Icon(
                Icons.edit,
                color: Colors.black87,
              ),
            ),
          )
        ],
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
                                  title: restaurantProfileWidget(
                                    address: e['Address'],
                                    capasity: e['Capasity'],
                                    phone: e['Phone'],
                                    reservationCapasity:
                                        e['Reservation Capasity'],
                                    name: e['Venue Name'],
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

  Widget restaurantProfileWidget(
      {address, capasity, phone, reservationCapasity, name}) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
                child: photoUrl == null
                    ? CircleAvatar(
                      backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                          'assets/resticon.png',
                        ),
                        radius: 60)
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipOval(
                            child: FadeInImage.assetNetwork(
                                placeholder: 'assets/resticon.png',
                                image: photoUrl,
                                fit: BoxFit.cover,
                                width: 200,
                                height: 120)),
                        radius: 25),
                onTap: () {}),
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.04,
            ),
            Text(
              name,
              style: TextStyle(
                  fontFamily: 'Montserrat', fontSize: 20.0, color: primaryDark),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.grey,
                ),
                Text(
                  address,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      color: primaryDark),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone,
                  color: Colors.grey,
                ),
                Text(
                  phone,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      color: primaryDark),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.05,
        ),
        Container(
          height: 80.0,
          width: double.infinity,
          color: Colors.grey.withOpacity(0.05),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Restaurant Capasity',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        color: primaryDark),
                  ),
                  Text(
                    capasity.toString(),
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        color: Colors.red),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Reservation Capasity',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        color: primaryDark),
                  ),
                  Text(
                    reservationCapasity.toString(),
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
