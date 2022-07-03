import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final _storageRef = FirebaseStorage.instance.ref();
  late String imageID;

  Future<String> uploadImage(File image) async {
    imageID = const Uuid().v4();
    final uploadTask =
        _storageRef.child('profileImages/$imageID').putFile(image);
    final taskSnapshot = await uploadTask;
    String uploadedImageURL = await taskSnapshot.ref.getDownloadURL();
    return uploadedImageURL;
  }

  Future<String> uploadVenueImage(File image) async {
    imageID = const Uuid().v4();
    final uploadTask =
        _storageRef.child('venueProfileImages/$imageID').putFile(image);
    final taskSnapshot = await uploadTask;
    String uploadedImageURL = await taskSnapshot.ref.getDownloadURL();
    return uploadedImageURL;
  }
}
