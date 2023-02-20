import 'package:ecom_app1/db/firestore_helper.dart';
import 'package:flutter/foundation.dart';

class ProductProvider extends ChangeNotifier {
  Future<bool> checkAdmin(String email) => FirestoreHelper.checkAdmin(email);
}
