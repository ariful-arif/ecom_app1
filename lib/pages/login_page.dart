import 'package:ecom_app1/auth/firebase_auth_service.dart';
import 'package:ecom_app1/pages/dashboard_page.dart';
import 'package:ecom_app1/providers/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  String errMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            children: [
              Center(child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text('Admin Login'),
              )),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
                onSaved: (value){
                  _email = value;
                },
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                obscureText: true,
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
                onSaved: (value){
                  _password = value;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: ElevatedButton(onPressed: _loginAdmin,
                    child: Text('Login')),
              ),
              SizedBox(height: 20,),
              Center(child: Text(errMsg , style: TextStyle(fontSize: 16,color: Colors.red),)),
            ],
          ),
        ),
      ),
    );
  }

  void _loginAdmin() async {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      try{
        final user = await FirebaseAuthService.loginAdmin(_email!, _password!);
        if (user != null) {
          final isAdmin = Provider
          .of<ProductProvider>(context, listen: false)
          .checkAdmin(_email!);
          if(await isAdmin){
            Navigator.pushReplacementNamed(context, DashboardPage.routeName);
          }else{
            setState(() {
              errMsg = 'you are not Admin';
            });
          }
        }
      }on FirebaseAuthException catch (e) {
        setState(() {
          errMsg = e.message!;
        });
      }
    }
  }
}
