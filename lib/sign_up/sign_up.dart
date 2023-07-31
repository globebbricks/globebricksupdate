import 'dart:io';
import 'package:delayed_display/delayed_display.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globebricks/home/home.dart';
import 'package:globebricks/login/login.dart';

import 'package:url_launcher/url_launcher.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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

  final db = FirebaseAuth.instance;
  bool _serverConnect = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchUniversalLinkIos(Uri url) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  final Uri toLaunch =
      Uri(scheme: 'https', host: 'www.okstitch.com', path: 'headers/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFC8B0),
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder:(context, constraints) =>  SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 15,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios,
                            color: Platform.isIOS ? Colors.blue : Colors.black),
                        Text(
                          "Back",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 25,
                              fontWeight: FontWeight.w400,
                              color: Platform.isIOS ? Colors.blue : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              DelayedDisplay(
                slidingCurve: Curves.easeInOut,
                child: Text(
                  "Hello!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Nunito",
                      fontSize: MediaQuery.of(context).size.width / 15),
                ),
              ),
              DelayedDisplay(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 20),
                  child: Row(
                    children: [
                      Text(
                        textAlign: TextAlign.start,
                        "Create an account\n& Start using GlobeBricks",
                        style: TextStyle(
                            color: Colors.black54,
                            fontFamily: "Nunito",
                            fontSize: MediaQuery.of(context).size.width / 20),
                      ),
                    ],
                  ),
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
                          errorStyle: const TextStyle(color: Colors.black),
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
                          errorStyle: const TextStyle(color: Colors.black),
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
                          child: const Text("Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontFamily: "Nunito")),
                        )),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 30,
                  left: MediaQuery.of(context).size.height / 30,
                  right: MediaQuery.of(context).size.height / 30,
                ),
                child: GestureDetector(
                  onTap: () async {
                    Platform.isIOS
                        ? _launchUniversalLinkIos(toLaunch)
                        : _launchInBrowser(toLaunch);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'By signing up, you agree to our ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width / 30,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms,',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: MediaQuery.of(context).size.width / 30,
                          ),
                        ),
                        TextSpan(
                          text: ' Privacy Policy',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: MediaQuery.of(context).size.width / 30,
                          ),
                        ),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width / 30,
                          ),
                        ),
                        TextSpan(
                          text: 'Cookies Policy',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: MediaQuery.of(context).size.width / 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 30,
                  left: MediaQuery.of(context).size.height / 30,
                  right: MediaQuery.of(context).size.height / 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",),
                    TextButton(
                        onPressed: () {
                          if (Platform.isAndroid) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          }
                          if (Platform.isIOS) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          }
                        },
                        child: const Text("Login"))
                  ],
                ),
              )
            ],
          ),
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
          .createUserWithEmailAndPassword(email: email, password: password)
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
      if (e.code == "email-already-in-use") {
        errorSheet(
            "Email already exist!",
            "That email you've entered is already in use by other account.",
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Try Again or Contact Support")));
      } else if (e.code == "weak-password") {
        errorSheet(
            "Password is weak!",
            "You have entered weak password someone can easily guess try something strong.",
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Change Password")));
      } else if (e.code == "network-request-failed") {
        errorSheet(
            "Connection error!",
            "No internet connection. Please turn on your Mobile data or Wifi & try again.",
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Try Again")));
      } else {
        errorSheet(
            "Something went wrong!",
            "Something went wrong with the server or application please update your app & try again.",
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Try Again")));
      }
    } catch (e) {
      errorSheet(
          "Something went wrong!",
          "Something went wrong with the server or application please update your app & try again.",
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Try Again")));
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
