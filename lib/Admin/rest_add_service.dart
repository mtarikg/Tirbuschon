import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<User> signUp(
    String email,
    String password,
    String name,
    String address,
    String capacity,
    String reservationCapacity,
    String phone,
    String type,
  ) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());

    await FirebaseFirestore.instance
        .collection('Venues')
        .doc(result.user!.uid)
        .set(
      {'status': true},
    );

    await FirebaseFirestore.instance
        .collection('Venues')
        .doc(result.user!.uid)
        .collection('Profile Information')
        .doc()
        .set({
      'Venue Name': name,
      'Address': address,
      'Phone': phone,
      'Reservation Capacity': reservationCapacity,
      'Capacity': capacity,
      'Type': type
    });

    await FirebaseFirestore.instance
        .collection('Venues')
        .doc(result.user!.uid)
        .collection('Menu')
        .doc()
        .set({
      'Menu': {},
    });

    await FirebaseFirestore.instance
        .collection('Venues')
        .doc(result.user!.uid)
        .collection('Activity')
        .doc()
        .set({
      'Activity': [],
    });

    final User user = result.user!;
    return user;
  }
}
