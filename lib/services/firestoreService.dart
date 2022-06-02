import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Future<List?> getAllVenues() async {
    final QuerySnapshot qs = await _firestore.collection("Venues").get();
    var venuesList = [];

    if (qs.docs.isNotEmpty) {
      for (var doc in qs.docs) {
        var profileInfo = await doc.reference
            .collection("Profile Information")
            .get()
            .then((value) => value.docs[0].data());
        venuesList.add(profileInfo);
      }

      return venuesList;
    }

    return null;
  }

  Future<dynamic> getVenueByID(String venueID) async {}

  Future<String?> getVenueByName(String venueName) async {
    final QuerySnapshot qs = await _firestore
        .collection("Venues")
        .where("Venue", isEqualTo: venueName)
        .get();

    if (qs.docs.isNotEmpty) {
      return qs.docs[0].id;
    }

    return null;
  }

  Future<dynamic> getMenu(String venueID) async {
    final QuerySnapshot qs = await _firestore
        .collection("Venues")
        .doc(venueID)
        .collection("Menu")
        .get();

    if(qs.docs.isNotEmpty){
      return qs.docs[0];
    }

    return null;
  }

  Future<bool> userExists(String userID) async {
    var existingUser = false;

    await _firestore
        .collection('Users')
        .doc(userID)
        .collection("profileInfo")
        .get()
        .then((value) => existingUser = value.docs.isNotEmpty);
    return existingUser;
  }

  Future<String> getUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    var currentUser = _auth.currentUser;
    var currentUserID = currentUser!.uid;

    var document = _firestore.collection('Users').doc(currentUserID);

    return document.id;
  }
}
