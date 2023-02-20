import 'dart:io';

import 'package:ecom_app1/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = '/products';

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Product List"),
        ),
        body:_productProvider.productList.isEmpty? const Center(
          child: Text('No items found'),
        ): ListView.builder(
          itemCount: _productProvider.productList.length,
          itemBuilder: (context, index) {
            final product = _productProvider.productList[index];
            return Card(
              elevation: 5,
              child: ListTile(
                title: Text(product.name!),
                leading: Image.file(File(product.localImagePath!),
                width: 100,
                height: 100,
                fit: BoxFit.cover,),
                trailing: Chip(label: Text('$takaSymbol${product.price}')),
              ),
            );
          },
        ));
  }
}
