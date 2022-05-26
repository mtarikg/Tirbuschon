import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<User> signUp(
      String email,
      String password,
      String name,
      String address,
      String capasity,
      String reservationCapasity,
      String phone
      ) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());


    await FirebaseFirestore.instance
        .collection('Venues')
        .doc(result.user!.uid)
        .collection('Profile Information')
        .doc()
        .set({
      'Venue Name': name,
      'Address': address,
      'Phone': phone,
      'Reservation Capasity': reservationCapasity,
      'Capasity': capasity,
    });
    final User user = result.user!;
    return user;
  }
}
