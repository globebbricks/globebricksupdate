import 'dart:io';
import 'package:delayed_display/delayed_display.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globebricks/authentication/phone_authentication.dart';
import 'package:globebricks/home/home.dart';
import 'package:globebricks/my_flutter_app_icons.dart';


import '../sign_up/sign_up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>  with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool passwordView = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }
  final db= FirebaseAuth.instance;
  bool _serverConnect = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xffFFC8B0),
              Color(0xffffdb8f),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            DelayedDisplay(
              slidingCurve: Curves.easeInOut,
              child: SafeArea(
                child: Text(
                  "Welcome!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Mukta",
                      fontSize: MediaQuery.of(context).size.width / 12),
                ),
              ),
            ),
            DelayedDisplay(
              child: Text(
                textAlign: TextAlign.center,
                "Nice to see you here 👋 ",
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "Nunito",
                    fontSize: MediaQuery.of(context).size.width / 25),
              ),
            ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.asset(
                    "assets/logo.png",
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
            Form(
              key: _emailKey,
              child: DelayedDisplay(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 15,
                      right: MediaQuery.of(context).size.width / 15),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your Email";
                      } else if (!EmailValidator.validate(
                          emailController.value.text)) {
                        return "Email is Invalid";
                      } else {
                        return null;
                      }
                    },
                    showCursor: true,
                    decoration: InputDecoration(
                        errorStyle:
                            const TextStyle(color: Colors.black),
                        filled: true,
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: Colors.black54, size: 20),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
              ),
            ),
            Form(
              key: _passwordKey,
              child: DelayedDisplay(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 10,
                    right: MediaQuery.of(context).size.width / 10,
                    top: MediaQuery.of(context).size.width / 20,
                    bottom: MediaQuery.of(context).size.width / 20,
                  ),
                  child: TextFormField(
                    obscureText: passwordView,
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your password";
                      } else if (value.length < 7) {
                        return "Password should 8 characters";
                      } else {
                        return null;
                      }
                    },
                    showCursor: true,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              passwordView = !passwordView;
                            });
                      },
                          child: const Icon(Icons.remove_red_eye,color: Colors.black,)),
                        errorStyle:
                            const TextStyle(color: Colors.black),
                        filled: true,
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock,
                            color: Colors.black54, size: 20),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
              ),
            ),
            DelayedDisplay(
              child: _serverConnect
                  ? Platform.isIOS
                      ? const CupertinoActivityIndicator()
                      : const CircularProgressIndicator()
                  : CupertinoButton(
                      borderRadius: BorderRadius.circular(10),
                      onPressed: () {
                        if (_emailKey.currentState!.validate() &
                            _passwordKey.currentState!.validate()) {
                          login(emailController.value.text,
                              passwordController.value.text);
                        }
                      },
                      color: Colors.black,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 5,
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          children: [
                            Text("Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    fontFamily: "Nunito")),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DelayedDisplay(
                    child: CupertinoButton(
                      onPressed: () {
                        if (Platform.isAndroid) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PhoneAuthentication(),
                              ));
                        }

                        if (Platform.isIOS) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const PhoneAuthentication(),
                              ));
                        }
                      },
                      color: Colors.black,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          children: [
                            Text("Continue with Number"),
                            Icon(
                              Icons.perm_phone_msg,
                              color: Colors.greenAccent,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 50,
                  bottom: MediaQuery.of(context).size.height / 50),
              child: DelayedDisplay(
                child: CupertinoButton(
                  onPressed: () {},
                  color: Colors.black,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Continue with Google"),
                        Icon(MyFlutterApp.google)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Platform.isIOS
                ? const DelayedDisplay(
                    child: CircleAvatar(
                      child: Icon(Icons.apple),
                    ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      if (Platform.isAndroid) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      }
                      if (Platform.isIOS) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      }
                    },
                    child: const Text("Create Account")),
                SizedBox(height: MediaQuery.of(context).size.height/5)
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> login(String email, String password) async {
    setState(() {
      _serverConnect = true;
    });
    try {
      await db
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                if (Platform.isAndroid)
                  {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                        (route) => false),
                  },
                if (Platform.isIOS)
                  {
                    Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const Home(),
                        ),
                        (route) => false)
                  }
              });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _serverConnect = false;
      });
      if (e.code == "wrong-password") {
        errorSheet(
            "Wrong password!",
            "You've entered incorrect password please try again with the correct password.",
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Try Again")));
      } else if (e.code == "too-many-requests") {
        errorSheet(
            "Too many requests!",
            "You have exceeded login limits. As we doubt some suspicious activity therefore, we have blocked your requests. To unblock it immediately reset your password.",
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Change Password")));

      }else if(e.code == 'user-not-found'){
        errorSheet(
            "User not found!",
            "User not found or may deleted please check your entered email.",
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Try Again")));

      } else if (e.code == "network-request-failed") {
        errorSheet(
            "Connection error!",
            "No internet connection. Please turn on your Mobile data or Wifi & try again.",
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Try Again")));
      }
    }
  }

  Future<void> errorSheet(
      String errorTitle, String errorContent, TextButton action) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3.5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.warning_amber,
                  color: Colors.red,
                ),
                Text(
                  errorTitle,
                  style: const TextStyle(color: Colors.red),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorContent,
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: MediaQuery.of(context).size.width / 25),
                  ),
                ),
                TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [const Icon(Icons.refresh), action],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
