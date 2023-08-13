import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globebricks/authentication/phone_authentication.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height / 30),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    const Icon(Icons.fiber_manual_record,color: Colors.greenAccent,),
                    CircleAvatar(
                      maxRadius: MediaQuery.of(context).size.height / 12,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.person_outline_sharp,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.height / 12),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "Komal Rajwansh",
              maxLines: 3,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "Nunito",
                  fontSize: MediaQuery.of(context).size.width / 20),
            ),
            const Text("Online"),

            CupertinoButton(
                child: const Text("Sign Out"),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) => {
                        if (Platform.isAndroid)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PhoneAuthentication(),
                                )),
                          },
                        if (Platform.isIOS)
                          {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      const PhoneAuthentication(),
                                )),
                          }
                      });
                })
          ],
        ),
      )),
    );
  }
}
