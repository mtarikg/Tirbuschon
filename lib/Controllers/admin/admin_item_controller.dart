import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/restaurant_menu_changing/item.dart';

class AdminItemController with ChangeNotifier {
  late Item _item;
  late File _imageFile;
  late String _oldImage;
  late String _error = '';

  Item get item => _item;
  void setItem(Item item) {
    _item = item;
    notifyListeners();
  }

  void initItemIfNull() {
    if (_item == null) _item = Item();
  }

  File get imageFile => _imageFile;
  void setImageFile(newValue) {
    _imageFile = newValue;
    notifyListeners();
  }

  String? get name => _item.name;
  void setName(newValue) {
    initItemIfNull();
    item.name = newValue;
    notifyListeners();
  }

  double? get price => _item.price;
  void setPrice(newValue) {
    initItemIfNull();
    item.price = newValue;
    notifyListeners();
  }

  String? get desc => _item.desc;
  void setDesc(newValue) {
    initItemIfNull();
    item.desc = newValue;
    notifyListeners();
  }

  String? get imageName => _item.image;
  void setImageName(newValue) {
    initItemIfNull();
    item.image = newValue;
    notifyListeners();
  }

  String get error => _error;
  void setError(newValue) {
    initItemIfNull();
    _error = newValue;
    notifyListeners();
  }

 /*  /*  
  Opens system diaglog to select image. 
  Assigns it to _imageFile if any image is selected.
  Sets item.image to selected images path.
  */
  Future pickImage() async {
    // opens system dialog to select an image
    _imageFile = (await ImagePicker.pick(source: ImageSource.gallery)) as File;

  
  }
 */

  // GENERATE FILE NAME
  String generateFileName(String name) => DateFormat('yMdHms').format(DateTime.now()) + getFileExtension(name);

  // GET FILE EXTENSION
  String getFileExtension(String name) => name.substring(name.lastIndexOf('.'));

  // Uploads _imageFile to DB Storage with custom generated file name.
  Future<String> uploadImage() async {

    FirebaseStorage storage = FirebaseStorage.instance;
Reference ref = storage.ref().child("images/" + generateFileName(_imageFile.path));
TaskSnapshot uploadTask = await ref.putFile(_imageFile);
    return await ref.getDownloadURL();
  }

  // Calls uploadImage function to upload _imageFile. Creates a new item instance in DB.
  Future addEditItem() async {
    // if item.id is defined this means item exists in DB. Thus performs update.
    if (item.id == null) {
      String imagePath = await uploadImage();
      FirebaseFirestore.instance.collection('items').add({'name': item.name, 'price': item.price, 'desc': item.desc, 'image': imagePath});
      return "A new record has been created.";
    }

    // if item.id is not defined this means item does not exist in DB. Thus performs create.
    if (item.id != null) {
      // if any new image is not selected update without image.
      if (_imageFile == null) {
        FirebaseFirestore.instance.collection('items').doc(item.id).update({'name': item.name, 'price': item.price, 'desc': item.desc});
      }
      // if any new image is selected update with image.
      if (_imageFile != null) {
        // delete old image
        FirebaseStorage.instance.refFromURL(_oldImage).delete();
        // upload new image
        String imagePath = await uploadImage();
        // update collection record
        FirebaseFirestore.instance
            .collection('items')
            .doc(item.id)
            .update({'name': item.name, 'price': item.price, 'desc': item.desc, 'image': imagePath});
      }

      return "Record has been updated.";
    }
  }

  String deleteItem(Item  item) {
    // delete document record
    FirebaseFirestore.instance.collection('items').doc(item.id).delete();
    // image storage
    FirebaseStorage.instance.refFromURL(item.image.toString()).delete();
    return "Item deleted.";
  }
}
