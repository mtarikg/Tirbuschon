import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/Auth/loginPage.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/edit_profile_screen.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/email_sender.dart';
import 'package:tirbuschon_feng497/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  final String address;
  final String phone;
  final int capacity;
  final int reservationCapacity;
  final String name;

  ProfileScreen({
    Key? key,
    required this.capacity,
    required this.address,
    required this.phone,
    required this.reservationCapacity,
    required this.name,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late CollectionReference collectionReference;
  late var photoUrl;
  bool switchValue = true;

  @override
  void initState() {
    String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    photoUrl = FirebaseAuth.instance.currentUser!.photoURL ?? null;
    collectionReference = FirebaseFirestore.instance
        .collection('Venues')
        .doc(userId)
        .collection('Profile Information');
    FirebaseFirestore.instance
        .collection('Venues')
        .doc(userId)
        .collection('Profile Information')
        .doc()
        .update({'Reservation Capacity': 50});
    super.initState();
  }

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
                              name: '',
                              address: '',
                              phone: '',
                              capacity: 0,
                              reservationCapacity: 0,
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
                                    capacity: e['Capacity'],
                                    phone: e['Phone'],
                                    reservationCapacity:
                                        e['Reservation Capacity'],
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
      {address, capacity, phone, reservationCapacity, name}) {
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
                    'Restaurant Capacity',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        color: primaryDark),
                  ),
                  Text(
                    capacity,
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
                    'Reservation Capacity',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        color: primaryDark),
                  ),
                  Text(
                    reservationCapacity,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Notifications",
              style: TextStyle(
                  fontFamily: 'Montserrat', fontSize: 20.0, color: primaryDark),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
            ),
            CupertinoSwitch(
              value: switchValue,
              onChanged: (value) {
                setState(() {
                  switchValue = value;
                });
              },
            ),
          ],
        ),
        Divider(
          height: 15,
          thickness: 2,
        ),
        Center(
          child: OutlineButton(
            padding: EdgeInsets.symmetric(horizontal: 40),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              "SIGN OUT",
              style: TextStyle(
                  fontFamily: 'Montserrat', fontSize: 16.0, color: primaryDark),
            ),
          ),
        ),
        Center(
          child: OutlineButton(
            padding: EdgeInsets.symmetric(horizontal: 40),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EmailSender()));
            },
            child: Text(
              "REPORT an ISSUE",
              style: TextStyle(
                  fontFamily: 'Montserrat', fontSize: 16.0, color: primaryDark),
            ),
          ),
        ),
      ],
    );
  }
}
