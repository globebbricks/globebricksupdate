import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globebricks/login/login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child: Column(children: [
        CupertinoButton(child: const Text("Sign Out"), onPressed: (){
          FirebaseAuth.instance.signOut().then((value) => {
          if (Platform.isAndroid) {

              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              )),
        },
          if (Platform.isIOS) {
          Navigator.push(
          context,
          CupertinoPageRoute(
          builder: (context) => const Login(),
          )),
          }
          });
        })
      ],)),
    );
  }
}
