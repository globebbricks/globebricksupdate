import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:globebricks/assistants/data.dart';
import 'package:globebricks/profile.dart';
import 'package:globebricks/serach_field/search.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller;
  late String dayTime;
  bool dayLoading = false;
  var pc = PanelController();
  final PageController _pageController = PageController(initialPage: 0);
  late Timer timer;

  int _currentPage = 0;

  bool panelOpened = false;

  List<String> hintList = [
    "Search Property Anywhere",
    "Find Flatmates, Roommates",
    "Sell your Property, House or Land",
    "Buy property, House or Land",
    "Repair House, Wall paint, Decoration",
    "Find Commercial Spaces",
    "Find Furniture Near You",
    "Find Builders or Collaboration",
    "Need Worker or Labour",

  ];

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    timer.cancel();
    _pageController.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onPaused();
        break;
      case AppLifecycleState.paused:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  void onResumed() {
    pageScroller();
  }

  void onPaused() {}

  void onInactive() {}

  void onDetached() {}

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addObserver(this);
    var hour = DateTime.now().hour;
    if (hour <= 12) {
      dayTime = "Good Morning, ";
    } else if ((hour > 12) && (hour <= 16)) {
      dayTime = "Good Afternoon, ";
    } else {
      dayTime = "Good Evening, ";
    }
    setState(() {
      dayLoading = true;
    });
    pageScroller();
    super.initState();
  }

  void pageScroller() {
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {

      if (_currentPage < hintList.length) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
          _currentPage++;
      } else {
          _currentPage = 0;
          _pageController.animateToPage(_currentPage,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height / 1.2;
    double minHeight = MediaQuery.of(context).size.height / 3;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xffe29587),
        body: Stack(alignment: Alignment.topCenter, children: [
          SlidingUpPanel(
            maxHeight: maxHeight,
            minHeight: minHeight,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            onPanelClosed: () {
              setState(() {
                panelOpened = false;
              });
            },
            onPanelOpened: () {
              setState(() {
                panelOpened = true;
              });
            },
            controller: pc,
            panelBuilder: (sc) => _panel(sc),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
          ),
        ]));
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 25,
                top: MediaQuery.of(context).size.width / 25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      height: MediaQuery.of(context).size.height / 10,
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (Platform.isAndroid) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Profile(),
                                ));
                          }
                          if (Platform.isIOS) {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const Profile(),
                                ));
                          }
                        },
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person_outline_sharp,
                            color: Colors.black,
                            size: MediaQuery.of(context).size.width / 15,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    dayLoading
                        ? DelayedDisplay(
                            child: Text(
                              dayTime,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Nunito",
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22),
                            ),
                          )
                        : Platform.isIOS
                            ? const CupertinoActivityIndicator()
                            : const CircularProgressIndicator(),
                    Text(
                      "Amrit",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Nunito",
                          fontSize: MediaQuery.of(context).size.width / 20),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Form(
                        child: DelayedDisplay(
                            child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 20),
                      child: TextFormField(
                        onTap: () {
                          if (Platform.isAndroid) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchField(),
                                ));
                          }
                          if (Platform.isIOS) {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const SearchField(),
                                ));
                          }
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: hintList[_currentPage],
                            hintStyle: const TextStyle(
                                color: Colors.black38, fontFamily: "Nunito"),
                            fillColor: Colors.white,
                            suffixIcon: const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ))),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              itemCount: hintList.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (ctx, i) => HomeSlide(i),
            ),
          ),
        ],
      ),
    );
  }

  _panel(ScrollController sc) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF8F4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height / 100),
              child: panelOpened
                  ? const Icon(Icons.keyboard_arrow_down)
                  : const Icon(Icons.keyboard_arrow_up),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.sell_outlined,
                                color: Colors.green,
                              ),
                              TextButton(
                                onPressed: () {
                                  const GeoFirePoint geoFirePoint = GeoFirePoint(GeoPoint(35.681236, 139.767125));
                                  final Map<String, dynamic> data = geoFirePoint.data;
                                  FirebaseFirestore.instance.collection('locations').add(
                                    <String, dynamic>{
                                      'geo': geoFirePoint.data,
                                      'name': 'Tokyo Station',
                                      'isVisible': true,
                                    },
                                  );
                                  // if (Platform.isAndroid) {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) => const SellerRegistration(),
                                  //       ));
                                  // }
                                  // if (Platform.isIOS) {
                                  //   Navigator.push(
                                  //       context,
                                  //       CupertinoPageRoute(
                                  //         builder: (context) => const SellerRegistration(),
                                  //       ));
                                  // }
                                },
                                child: Text(
                                  "Seller Listing",
                                  style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Card(
                          color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              "Free",
                              style: TextStyle(color: Colors.white),
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HomeSlide extends StatefulWidget {
  final int index;

  const HomeSlide(this.index, {super.key});

  @override
  State<HomeSlide> createState() => _HomeSlideState();
}

class _HomeSlideState extends State<HomeSlide>
    with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/${widget.index}.png",
    );
  }
}
