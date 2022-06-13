import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewVenue extends StatefulWidget {
  final String address;
  final String phone;
  final int capacity;
  final int reservationCapacity;
  final String name;

  const ViewVenue({
    Key? key,
    required this.capacity,
    required this.address,
    required this.phone,
    required this.reservationCapacity,
    required this.name,
  }) : super(key: key);

  @override
  State<ViewVenue> createState() => _ViewVenueState();
}

class _ViewVenueState extends State<ViewVenue> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                    ? const CircleAvatar(
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
                  const Text(
                    'Restaurant Capacity',
                  ),
                  Text(
                    capasity.toString(),
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        color: Colors.red),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  const Text(
                    'Reservation Capacity',
                  ),
                  Text(
                    reservationCapasity.toString(),
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
      ],
    );
  }
}
