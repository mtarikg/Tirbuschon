import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/Auth/loginPage.dart';
import 'package:tirbuschon_feng497/palette.dart';

class SettingsPage extends StatefulWidget {
  final String name;
  final String address;
  final String phone;
  final int capasity;
  final int reservationCapasity;

  SettingsPage({
    Key? key,
    required this.name,
    required this.address,
    required this.phone,
    required this.capasity,
    required this.reservationCapasity,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //retrieve data from database

  late String uid1;
  late CollectionReference collectionReference;

  @override
  void initState() {
    String userId = FirebaseAuth.instance.currentUser!.uid.toString();

    collectionReference = FirebaseFirestore.instance
        .collection('Venues')
        .doc(userId)
        .collection('Profile Information');
    super.initState();

    //final _nameController = TextEditingController(text: collectionReference.doc().name.toString(),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: primaryOrange,
          ),
        ),
      ),
      body: Container(
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
                                  title: _settingsContent(
                                    context: context,
                                    name: e['Venue Name'],
                                    address: e['Address'],
                                    phone: e['Phone'],
                                    capasity: e['Capasity'],
                                    reservationCapasity:
                                        e['Reservation Capasity'],
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
            )),
          ],
        ),
      ),
    );
  }
}

final addressController = new TextEditingController();
final capasityController = new TextEditingController();
final reservationcapasityController = new TextEditingController();
final phoneController = new TextEditingController();
Widget _settingsContent({
  context,
  name,
  address,
  phone,
  capasity,
  reservationCapasity,
}) {
  return Stack(
    children: [
      SizedBox(height: 15),
      Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: primaryOrange,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Venue Name",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextField(
              obscureText: false,
              readOnly: true,
              style: TextStyle(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: name,
                hintStyle: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: primaryOrange,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Venue Location",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextField(
              controller: addressController,
              obscureText: false,
              style: TextStyle(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: address,
                hintStyle: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.phone,
                  color: primaryOrange,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Venue Phone",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextField(
              controller: phoneController,
              obscureText: false,
              style: TextStyle(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: phone,
                hintStyle: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.people,
                  color: primaryOrange,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Venue Capasity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextField(
              controller: capasityController,
              obscureText: false,
              style: TextStyle(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: capasity.toString(),
                hintStyle: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  color: primaryOrange,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Reservation Capasity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextField(
              controller: reservationcapasityController,
              obscureText: false,
              style: TextStyle(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: reservationCapasity.toString(),
                hintStyle: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: OutlineButton(
                padding: EdgeInsets.symmetric(horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () async {
                  String userId =
                      FirebaseAuth.instance.currentUser!.uid.toString();
                  final QuerySnapshot result = await FirebaseFirestore.instance
                      .collection('Venues')
                      .doc(userId)
                      .collection('Profile Information')
                      .get();
                  final List<DocumentSnapshot> documents = result.docs;
                  List<String> followingList = [];
                  documents.forEach((snapshot) {
                    followingList.add(snapshot.id);
                  });
                  var snapshots = FirebaseFirestore.instance
                      .collection('Venues')
                      .doc(userId)
                      .collection('Profile Information')
                      .doc(followingList.first)
                      .update({
                        'Address': addressController.text.isEmpty
                            ? address
                            : addressController.text,
                        'Capasity': capasityController.text.isEmpty
                            ? capasity
                            : capasityController.text,
                        'Phone': phoneController.text.isEmpty
                            ? phone
                            : phoneController.text,
                        'Reservation Capasity':
                            reservationcapasityController.text.isEmpty
                                ? reservationCapasity
                                : reservationcapasityController.text,
                      })
                      .then((value) => print("Data updated"))
                      .catchError((error) => print("Failed to update data"));
                  ;
                },
                child: Text("UPDATE INFO",
                    style: TextStyle(
                        fontSize: 16, letterSpacing: 2.2, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
