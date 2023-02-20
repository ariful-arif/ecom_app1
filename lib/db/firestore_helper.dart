import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  static const String collectionAdmin = 'Admins';
  static const String collectionProduct = 'Products';

  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<bool> checkAdmin(String email) async {
    final snapshot = await _db.collection(collectionAdmin)
        .where('email',isEqualTo: email)
        .get();
    if(snapshot.docs.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

}