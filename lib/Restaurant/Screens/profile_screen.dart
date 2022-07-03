import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/avatar_picker.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/edit_profile_screen.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/email_sender.dart';
import 'package:tirbuschon_feng497/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/authService.dart';
import '../../welcomePage.dart';

class ProfileScreen extends StatefulWidget {
  final String address;
  final String phone;
  final int capacity;
  final int reservationCapacity;
  final String name;

  const ProfileScreen({
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
  String? photoUrl;
  bool switchValue = true;
  final venueId = FirebaseAuth.instance.currentUser!.uid.toString();

  @override
  void initState() {
    collectionReference = FirebaseFirestore.instance
        .collection('Venues')
        .doc(venueId)
        .collection('Profile Information');

    () async {
      final snap = await collectionReference.get();
      final doc = snap.docs.first;

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          photoUrl = doc['imageUrl'];
        });
      });
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
              child: const Icon(
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
        padding: const EdgeInsets.symmetric(vertical: 10),
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget restaurantProfileWidget({
    address,
    capacity,
    phone,
    reservationCapacity,
    name,
  }) {
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
                  ? const CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/resticon.png'),
                      radius: 60,
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          photoUrl!,
                          fit: BoxFit.cover,
                          width: 200,
                          height: 120,
                        ),
                      ),
                      radius: 50,
                    ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return AvatarPicker(id: venueId);
                  },
                ));
              },
            ),
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
                const Icon(
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
                const Icon(
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
                    style: const TextStyle(
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
                    style: const TextStyle(
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
        const Divider(
          height: 15,
          thickness: 2,
        ),
        Center(
          child: OutlineButton(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              final AuthService _authService = AuthService();

              _authService.signOut().then((value) {
                return Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomePage()),
                    (route) => false);
              });
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
            padding: const EdgeInsets.symmetric(horizontal: 40),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const EmailSender()));
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
