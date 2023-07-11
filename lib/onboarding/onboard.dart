import 'dart:io';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globebricks/login/login.dart';
import 'package:globebricks/onboarding/slide_dots.dart';
import 'package:globebricks/onboarding/slide_items.dart';
import 'package:globebricks/onboarding/slide_list.dart';

import 'package:shared_preferences/shared_preferences.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      home: Scaffold(
          body: PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: slideList.length,
            itemBuilder: (ctx, i) => SlideItem(i),
          ),
          bottomSheet: _currentPage != slideList.length - 1
              ? Container(
            height: MediaQuery.of(context).size.height/18,
                  margin:
                      const EdgeInsets.only(bottom: 40, left: 15, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black87
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < slideList.length; i++)
                            if (i == _currentPage)
                              const SlideDots(true)
                            else
                              const SlideDots(false)
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            _pageController.animateToPage(_currentPage + 1,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeIn);
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              )
                            ],
                          )),
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: DelayedDisplay(
                        child: CupertinoButton(
                          borderRadius: BorderRadius.circular(30),
                          onPressed: () async {
                           userStateSave();
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
                          },
                          color: const Color(0XFFFFDE59),
                          child: Text(
                            "Let's Start",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.height / 50),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}

void userStateSave() async {
  final data = await SharedPreferences.getInstance();
  data.setInt("userState", 1);
}
