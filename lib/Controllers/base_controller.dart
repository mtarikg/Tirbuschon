/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/admin/item.dart';


enum MessageTypes { success, error, warning, info }

class FunctionFeedback {
  FunctionFeedback({required this.type, required this.message});
  MessageTypes type;
  String message;
}

class BaseController {

  final CollectionReference itemsCollection = FirebaseFirestore.instance.collection('items');
 


  // MAP FIREBASE SNAPSHOT TO ITEM CLASS
  List<Item> itemsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Item(
        id: doc.documentID ?? '',
        name: doc.data['name'] ?? '',
        image: doc.data['image'],
        price: doc.data['price'] ?? 0,
      );
    }).toList();
  }

  // ACCESSING ITEM BY ITS ID. USED TO ACCESS ITEM THROUGH ORDER.
  Future<Item> getItemByID(String itemID) {
    return itemsCollection.doc(itemID).get().then((doc) {
      return Item(
        id: doc.documentID ?? '',
        name: doc.data['name'] ?? '',
        image: doc.data['image'],
        price: doc.data['price'] ?? 0,
      );
    });
  }


} */
