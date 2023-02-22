import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app1/models/product_model.dart';
import 'package:ecom_app1/utils/helper_function.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName = '/new_product';

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  late ProductProvider _productProvider;
  final _formKey = GlobalKey<FormState>();
  String? _category;
  DateTime? _dateTime;
  ProductModel _productModel = ProductModel();
  ImageSource _imageSource = ImageSource.camera;
  String? _imagePath;
  bool isSaving = false;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
        actions: [
          IconButton(onPressed: _saveProduct, icon: const Icon(Icons.save))
        ],
      ),
      body: Stack(
        children: [
          if (isSaving)
            Center(
              child: CircularProgressIndicator(),
            ),
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productModel.name = value;
                  },
                  decoration: InputDecoration(
                      labelText: 'Product Name', border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productModel.description = value;
                  },
                  decoration: InputDecoration(
                      labelText: 'Product Description',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productModel.price = num.parse(value!);
                  },
                  decoration: InputDecoration(
                      labelText: 'Price', border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productModel.stock = int.parse(value!);
                  },
                  decoration: InputDecoration(
                      labelText: 'Quantity', border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  hint: const Text('Select Category'),
                  value: _category,
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                    _productModel.catagory = value;
                  },
                  items: _productProvider.categoryList
                      .map((cat) => DropdownMenuItem<String>(
                            child: Text(cat),
                            value: cat,
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showDatePicker,
                        icon: const Icon(Icons.date_range),
                        label: const Text('Select Date'),
                      ),
                      Text(_dateTime == null
                          ? 'No date chosen'
                          : getFormattedDate(_dateTime!, 'MMM dd, yyy')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 10,
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2)),
                        child: _imagePath == null
                            ? Image.asset('images/img.png')
                            : Image.file(
                                File(_imagePath!),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _imageSource = ImageSource.camera;
                              _pickImage();
                            },
                            child: const Text('Camera'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _imageSource = ImageSource.gallery;
                              _pickImage();
                            },
                            child: const Text('Gallery'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveProduct() async {
    final isConnected = await isConnectedToInternet();
    if (isConnected) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (_dateTime == null) {
          showMessage(context, 'Please select a date');
          return;
        }
        if (_imagePath == null) {
          showMessage(context, 'Please select a image');
          return;
        }
        setState(() {
          isSaving = true;
        });
        print(_productModel);
        _uploadImageAndSaveProduct();
      }
    } else {
      showMessage(context, 'No Internet connection detected');
    }
  }

  void _showDatePicker() async {
    final dt = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if (dt != null) {
      setState(() {
        _dateTime = dt;
      });
      _productModel.purchaseDate = Timestamp.fromDate(_dateTime!);
    }
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: _imageSource,imageQuality: 60);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
      _productModel.localImagePath = _imagePath;
    }
  }

  void _uploadImageAndSaveProduct() async {
    final uploadFile = File(_imagePath!);
    final imageName = 'Product_${DateTime.now()}';
    final photoRef =
        FirebaseStorage.instance.ref().child("EcomFlutter01/$imageName");
    try {
      final uploadTask = photoRef.putFile(uploadFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final dlUrl = await snapshot.ref.getDownloadURL();
      _productModel.imageDownloadUrl = dlUrl;
      _productModel.imageName = imageName;
      _productProvider.insertNewProduct(_productModel).then((_) {
        setState(() {
          isSaving = false;
        });
        Navigator.pop(context);
      });
    } catch (error) {
      setState(() {
        isSaving = false;
      });
      showMessage(context, 'Failed to Upload image');
      throw error;
    }
  }
}
