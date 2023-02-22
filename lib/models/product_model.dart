
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{
  String ? id;
  String ? name;
  String ? catagory;
  num? price;
  String ? localImagePath;
  String ? imageName;
  String ? imageDownloadUrl;
  String ? description;
  int stock;
  bool isAvailable;
  Timestamp ? purchaseDate;

  ProductModel(
  {this.id,
      this.name,
      this.catagory,
      this.price,
      this.localImagePath,
      this.imageDownloadUrl,
      this.description,
      this.stock =1,
    this.imageName,
      this.isAvailable = true,
      this.purchaseDate});

  Map<String , dynamic> toMap(){
    var map= <String,dynamic>{
      'id' : id,
      'name' : name,
      'catagory' : catagory,
      'price' : price,
      'localImagePath' : localImagePath,
      'imageDownloadUrl' : imageDownloadUrl,
      'description' : description,
      'stock' : stock,
      'isAvailable' : isAvailable,
      'timestamp' : purchaseDate,
      'imageName' : imageName,
    };
    return map;
  }

  factory ProductModel.fromMap(Map<String , dynamic> map) => ProductModel(
    id: map['id'],
    name: map['name'],
    catagory: map['catagory'],
    price: map['price'],
    localImagePath: map['localImagePath'],
    imageDownloadUrl: map['imageDownloadUrl'],
    description: map['description'],
    stock: map['stock'],
    isAvailable: map['isAvailable'],
    purchaseDate: map['Timestamp'],
    imageName: map['imageName'],
  );

  @override
  String toString() {
    return 'ProductModel{id: $id, name: $name, catagory: $catagory, price: $price, localImagePath: $localImagePath, imageName: $imageName, imageDownloadUrl: $imageDownloadUrl, description: $description, stock: $stock, isAvailable: $isAvailable, purchaseDate: $purchaseDate}';
  }
}