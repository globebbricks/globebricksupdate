import 'dart:io';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globebricks/firebase_options.dart';
import 'package:globebricks/home/home.dart';
import 'package:globebricks/login/login.dart';
import 'package:globebricks/onboarding/onboard.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: "6LcwIg8nAAAAAEEt8w2Vo4Qq73ejGmV_2dXihuPe",
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MaterialApp(home: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool loaded = true;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Future.delayed(const Duration(milliseconds: 3000), () async {
              if (loaded) {
                if (FirebaseAuth.instance.currentUser != null) {
                  loaded = false;
                  if (Platform.isAndroid) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                        (route) => false);
                  }
                  if (Platform.isIOS) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const Home(),
                        ),
                        (route) => false);
                  }
                } else {
                  loaded = false;
                  userStateSave();
                }
              }
            }));

    return Scaffold(
      backgroundColor: const Color(0xffFFC8B0),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Image.asset(
                      "assets/logo.png",
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Lottie.asset(
                      'assets/loading.json',
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller
                          ..duration = composition.duration
                          ..repeat();
                      },
                    ),
                  ),
                ],
              ),
              Platform.isIOS
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CupertinoActivityIndicator(
                        color: Colors.black,
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                          color: Colors.black, strokeWidth: 2),
                    )
            ],
          ),
        ),
      ),
    );
  }

  moveToDecision() async {
    if (mounted) {
      if (Platform.isAndroid) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
            (route) => false);
      }
      if (Platform.isIOS) {
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (context) => const Login(),
            ),
            (route) => false);
      }
    }
  }

  moveToGettingStart() {
    if (Platform.isAndroid) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const OnBoard(),
          ),
          (route) => false);
    }
    if (Platform.isIOS) {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => const OnBoard(),
          ),
          (route) => false);
    }
  }

  Future<void> userStateSave() async {
    final value = await SharedPreferences.getInstance();
    if (value.getInt("userState") != 1) {
      moveToGettingStart();
    } else {
      moveToDecision();
    }
  }
}
