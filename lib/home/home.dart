import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globebricks/profile.dart';
import 'package:globebricks/serach_field/search.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../onboarding/slide_items.dart';
import '../onboarding/slide_list.dart';

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



  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
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
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height / 1.2;
    double minHeight = MediaQuery.of(context).size.height / 2.5;
    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0XFFffe48c),

        body: Stack(alignment: Alignment.topCenter, children: [
          SlidingUpPanel(
            maxHeight: maxHeight,
            minHeight: minHeight,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            controller: pc,
            panelBuilder: (sc) => _panel(sc),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              minHeight = maxHeight;
            }),
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
                                  color: Colors.black54,
                                  fontFamily: "Nunito",
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22),
                            ),
                          )
                        : const Text(""),
                    Text(
                      "Amrit",
                      style: TextStyle(
                          color: Colors.black54,
                          fontFamily: "Nunito",
                          fontSize: MediaQuery.of(context).size.width / 22),
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
                        onTap: (){
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
                            hintText: "Search Locality, Properties, Projects",
                            hintStyle: const TextStyle(
                                color: Colors.black38, fontFamily: "Nunito"),
                            fillColor: Colors.white,
                            suffixIcon: const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(Icons.search,color: Colors.white,),),
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
            height: 200,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              itemCount: 4,
              itemBuilder: (ctx, i) => HomeSlide(i),
            ),
          ),
        ],
      ),
    );
  }

  _panel(ScrollController sc) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
          ),
           Card(
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

             child: Stack(
               alignment: Alignment.topRight,
               children: [
            SizedBox(
              width: MediaQuery.of(context).size.width/2,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   Icon(Icons.house,color: Colors.green,),
                    Text("Post Property",style: TextStyle(fontFamily: "Nunito"),),
                  ],
                ),
              ),
            ),
              const Card(
                  color: Colors.red,
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(

                "Free",style: TextStyle(color: Colors.white),),
                  ))
          ],),)
        ],
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
    return Image.asset("assets/${widget.index}.png",
      height: MediaQuery.of(context).size.height/5,
      width: MediaQuery.of(context).size.width/2,
    );
  }
}
