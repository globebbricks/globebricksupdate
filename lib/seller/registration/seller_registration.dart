import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SellerRegistration extends StatefulWidget {
  const SellerRegistration({super.key});

  @override
  State<SellerRegistration> createState() => _SellerRegistrationState();
}

class _SellerRegistrationState extends State<SellerRegistration> {

  // final geo = GeoFlutterFire();
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){

      }),
    );
  }
}
