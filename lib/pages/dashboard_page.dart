import 'package:ecom_app1/auth/firebase_auth_service.dart';
import 'package:ecom_app1/pages/login_page.dart';
import 'package:ecom_app1/pages/new_product_page.dart';
import 'package:ecom_app1/pages/product_list_page.dart';
import 'package:ecom_app1/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.getAllCategories();
    _productProvider.getAllProducts();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuthService.logoutAdmin().then((_) => Navigator.pushReplacementNamed(context, LoginPage.routeName));
          }, icon: const Icon(Icons.logout),)
        ],
      ),
      body: GridView.count(crossAxisCount: 2,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      children: [
        ElevatedButton(onPressed: () => Navigator.pushNamed(context, NewProductPage.routeName),
            style: ElevatedButton.styleFrom(
              primary: Colors.redAccent,
            ),
            child: const Text('Add Product'),),
        ElevatedButton(onPressed: () => Navigator.pushNamed(context, ProductListPage.routeName),
            style: ElevatedButton.styleFrom(
              primary: Colors.orangeAccent,
            ),
            child: const Text('View Product'),),

        ElevatedButton(onPressed: () => Navigator.pushNamed(context, NewProductPage.routeName),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
          ),
          child: const Text('Orders'),),

        ElevatedButton(onPressed: () => Navigator.pushNamed(context, NewProductPage.routeName),
          style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey,
          ),
          child: const Text('Customers'),),

        ElevatedButton(onPressed: () => Navigator.pushNamed(context, NewProductPage.routeName),
          style: ElevatedButton.styleFrom(
            primary: Colors.lightBlueAccent,
          ),
          child: const Text('Categories'),),

        ElevatedButton(onPressed: () => Navigator.pushNamed(context, NewProductPage.routeName),
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
          child: const Text('Purchase History'),),

        ElevatedButton(onPressed: () => Navigator.pushNamed(context, NewProductPage.routeName),
          style: ElevatedButton.styleFrom(
            primary: Colors.brown,
          ),
          child: const Text('Report'),),

      ],),
    );
  }
}
