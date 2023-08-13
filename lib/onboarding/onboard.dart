import 'dart:io';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globebricks/authentication/phone_authentication.dart';
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
  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      home: Scaffold(
          body: Stack(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding:  EdgeInsets.all(MediaQuery.of(context).size.height/25),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        child: Image.asset(
                          "assets/logo.png",
                          color: Colors.black,
                          height: MediaQuery.of(context).size.height/5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: slideList.length,
                itemBuilder: (ctx, i) => SlideItem(i),
              ),
            ],
          ),
          bottomSheet: _currentPage != slideList.length - 1
              ? Container(
            height: MediaQuery.of(context).size.height/18,
                  margin:
                      const EdgeInsets.only(bottom: 40, left: 15, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color:  const Color(0xffe29587),
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
                                   builder: (context) => const PhoneAuthentication(),
                                 ),
                                     (route) => false);
                           }
                           if (Platform.isIOS) {
                             Navigator.pushAndRemoveUntil(
                                 context,
                                 CupertinoPageRoute(
                                   builder: (context) => const PhoneAuthentication(),
                                 ),
                                     (route) => false);
                           }
                          },
                          color: const  Color(0xffe29587),
                          child: Text(
                            "Let's Start",
                            style: TextStyle(
                                color: Colors.white,
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
