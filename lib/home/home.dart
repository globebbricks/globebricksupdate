import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:globebricks/assistants/data.dart';
import 'package:globebricks/profile/profile.dart';
import 'package:globebricks/search_field/search.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

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

  var firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    timer.cancel();
    _pageController.dispose();
    firestore.terminate();
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
    timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentPage < hintList.length - 1) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
        _currentPage++;
      } else {
        _pageController.animateToPage(0,
            duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
        timer.cancel();
      }
    });
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: optionStyle,
    ),
    Text(
      'Likes',
      style: optionStyle,
    ),
    Text(
      'Search',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding:  EdgeInsets.all(MediaQuery.of(context).size.width/20),
          child: Container(
            height: MediaQuery.of(context).size.height / 12,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black87,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black54,
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.favorite,
                    text: 'Likes',
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: Icons.people,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Image.asset(
                              "assets/logo.png",
                              color: Colors.black,
                              height: MediaQuery.of(context).size.height / 10,
                              width: MediaQuery.of(context).size.width / 5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width / 15,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.person_outline_sharp,
                                    color: Colors.white,
                                    size:
                                        MediaQuery.of(context).size.width / 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            dayLoading
                                ? DelayedDisplay(
                                    child: Text(
                                      dayTime,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: "Nunito",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              22),
                                    ),
                                  )
                                : Platform.isIOS
                                    ? const CupertinoActivityIndicator()
                                    : const CircularProgressIndicator(),
                            Expanded(
                              child: Text(
                                "Komal Rajwansh",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: "Nunito",
                                    fontSize:
                                        MediaQuery.of(context).size.width / 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                          child: DelayedDisplay(
                              child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 30),
                        child: Card(
                          elevation: 5.0,
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
                                    color: Colors.black38,
                                    fontFamily: "Nunito"),
                                fillColor: Colors.white,
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                ),
                                filled: true,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                )),
                          ),
                        ),
                      ))),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3.5,
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: PageView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          controller: _pageController,
                          itemCount: hintList.length,
                          onPageChanged: _onPageChanged,
                          itemBuilder: (ctx, i) => HomeSlide(i),
                        ),
                      ),
                      DelayedDisplay(
                        delay: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              CupertinoButton(
                                  color: Colors.green,
                                  child: Text(
                                    "Post Advertisement",
                                    style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {
                                    GeoFirePoint geoFirePoint = GeoFirePoint(
                                        GeoPoint(UserData.latitude,
                                            UserData.longitude));

                                    GeoCollectionReference<
                                        Map<String, dynamic>>(
                                      firestore
                                          .collection('rent')
                                          .doc("data")
                                          .collection("1 Bhk"),
                                    ).add(<String, dynamic>{
                                      'geo': geoFirePoint.data,
                                      'name': "Tokyo Station",
                                      'isVisible': true,
                                      'isVerified': true,
                                    }).then((value) => {});
                                  }),
                              const Card(
                                color: Colors.red,
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    "Free",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            LoadHomeCards(
                              imageLink:
                                  'https://firebasestorage.googleapis.com/v0/b/globebricksproject.appspot.com/o/design%2FhomeCardImages%2FrealEstate.png?alt=media&token=7865e63b-7220-4d6f-897b-ba5676939e6c',
                              cardTitle: 'Real Estate',
                              className: SearchField(),
                            ),
                            LoadHomeCards(
                              imageLink:
                                  'https://firebasestorage.googleapis.com/v0/b/globebricksproject.appspot.com/o/design%2FhomeCardImages%2Fhomedecor.png?alt=media&token=601b19f4-d215-4ef4-9750-de42b8a1e051',
                              cardTitle: 'Home Decor',
                              className: SearchField(),
                            ),
                            LoadHomeCards(
                              imageLink:
                                  'https://firebasestorage.googleapis.com/v0/b/globebricksproject.appspot.com/o/design%2FhomeCardImages%2Ffurniture.png?alt=media&token=3558a61e-1043-4ee1-b314-87de1fcdb1d0',
                              cardTitle: 'Furniture',
                              className: SearchField(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            LoadHomeCards(
                              imageLink:
                                  'https://firebasestorage.googleapis.com/v0/b/globebricksproject.appspot.com/o/design%2FhomeCardImages%2FrealEstate.png?alt=media&token=7865e63b-7220-4d6f-897b-ba5676939e6c',
                              cardTitle: 'Real Estate',
                              className: SearchField(),
                            ),
                            LoadHomeCards(
                              imageLink:
                                  'https://firebasestorage.googleapis.com/v0/b/globebricksproject.appspot.com/o/design%2FhomeCardImages%2Fhomedecor.png?alt=media&token=601b19f4-d215-4ef4-9750-de42b8a1e051',
                              cardTitle: 'Home Decor',
                              className: SearchField(),
                            ),
                            LoadHomeCards(
                              imageLink:
                                  'https://firebasestorage.googleapis.com/v0/b/globebricksproject.appspot.com/o/design%2FhomeCardImages%2Fhomedecor.png?alt=media&token=601b19f4-d215-4ef4-9750-de42b8a1e051',
                              cardTitle: 'Home Decor',
                              className: SearchField(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }


}

class LoadHomeCards extends StatelessWidget {
  final String imageLink;
  final Widget className;
  final String cardTitle;

  const LoadHomeCards({
    super.key,
    required this.imageLink,
    required this.cardTitle,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (Platform.isAndroid) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => className,
                  ));
            }
            if (Platform.isIOS) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => className,
                ),
              );
            }
          },
          child: Image.network(
            height: MediaQuery.of(context).size.width / 3.5,
            width: MediaQuery.of(context).size.width / 3.5,
            imageLink,
            errorBuilder: (context, error, stackTrace) {
              return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: const Icon(Icons.access_time_filled_outlined));
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return Card(color: Colors.grey[100], child: child);
              }
              return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: const Icon(Icons.access_time_filled_outlined));
            },
          ),
        ),
        Text(
          cardTitle,
          style: const TextStyle(fontFamily: "Nunito"),
        )
      ],
    );
  }
}

class HomeSlide extends StatefulWidget {
  final int index;

  const HomeSlide(this.index, {super.key});

  @override
  State<HomeSlide> createState() => _HomeSlideState();
}

class _HomeSlideState extends State<HomeSlide> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/${widget.index}.png",
    );
  }
}
