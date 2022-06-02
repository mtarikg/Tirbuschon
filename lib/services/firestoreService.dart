import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Future<List?> getCurrentVenues() async {
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
}
