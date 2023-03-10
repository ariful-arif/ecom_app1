import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app1/models/product_model.dart';

class FirestoreHelper {
  static const String _collectionAdmin = 'Admins';
  static const String _collectionProduct = 'Products';
  static const String _collectionCategory = 'Categories';

  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCategories() => _db
      .collection(_collectionCategory).orderBy('name')
     .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProduct() => _db
      .collection(_collectionProduct)
      .snapshots();

  static Future<void> addNewProduct(ProductModel productModel) {
    final docRef = _db.collection(_collectionProduct).doc();
    productModel.id = docRef.id;
    return docRef.set(productModel.toMap());
  }

  static Future<bool> checkAdmin(String email) async {
    final snapshot = await _db.collection(_collectionAdmin)
        .where('email',isEqualTo: email)
        .get();
    if(snapshot.docs.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

}