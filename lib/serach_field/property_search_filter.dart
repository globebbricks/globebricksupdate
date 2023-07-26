import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globebricks/assistants/data.dart';
import 'package:globebricks/lottie_animation/animation.dart';
import 'package:globebricks/serach_field/property_searching.dart';

class PropertySearchFilter extends StatefulWidget {
  const PropertySearchFilter({super.key});

  @override
  State<PropertySearchFilter> createState() => _PropertySearchFilterState();
}

class _PropertySearchFilterState extends State<PropertySearchFilter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool selected = false;
  int _selectedIndex = 0;

  final List _choiceChipsList = [
    "Rent",
    "Buy",
    "PG",
    "Flatmates",
    "Commercial",
    "Plot/land",
    "Collaboration",
  ];

  bool chipSelected = false;

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
    return Scaffold(
      backgroundColor: const Color(0xffe29587),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Image.asset(
                  "assets/logo.png",
                  width: MediaQuery.of(context).size.width / 4,
                ),
              ),
              const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.green,
                  )),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 15,
                    bottom: MediaQuery.of(context).size.width / 15),
                child: Text(
                  UserData.address,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height / 60,
                    overflow: TextOverflow.ellipsis,
                  ),
                  softWrap: false,
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Get started with",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width / 15),
                        ),
                      ],
                    ),
                    Row(children: [
                      Expanded(
                        child: Text(
                            "Explore real estate options at selected location",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width / 30)),
                      ),
                    ]),
                  ],
                ),
              ),
              Wrap(
                spacing: 6,
                direction: Axis.horizontal,
                children: choiceChips(),
              ),
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width / 60),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Text(_choiceChipsList[_selectedIndex],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Nunito",
                              fontSize: MediaQuery.of(context).size.width / 15)),
                      SizedBox(
                          height: MediaQuery.of(context).size.height/3,
                          child: filter(_choiceChipsList[_selectedIndex])),
                      CupertinoButton(
                        color: Colors.green,
                          onPressed: () {
                            if (Platform.isAndroid) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                         PropertySearching(propertyType: '1Bhk',),
                                  ));
                            }
                            if (Platform.isIOS) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        PropertySearching(propertyType: '1Bhk',),

                                  ));
                            }
                          },
                          child: const Text("Search"))
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> choiceChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _choiceChipsList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: ChoiceChip(
          label: Text(_choiceChipsList[i]),
          labelStyle: const TextStyle(color: Colors.black),
          backgroundColor: Colors.white,
          selected: _selectedIndex == i,
          selectedColor: const Color(0xffffd2c1),
          onSelected: (bool value) {
            setState(() {
              chipSelected = value;
              _selectedIndex = i;
              filter(_choiceChipsList[i]);
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  Widget filter(String propertyType) {
    switch (propertyType) {
      case ("Rent"):
        {
          return const LottieAnimate(
              assetName: "assets/filter/filterHome.json");
        }
      case ("Buy"):
        {
          return const LottieAnimate(assetName: "assets/filter/filterBuy.json");
        }
      case ("PG"):
        {
          return const LottieAnimate(
              assetName: "assets/filter/filterHome.json");
        }
      case ("Flatmates"):
        {
          return const LottieAnimate(
              assetName: "assets/filter/filterHome.json");
        }
      case ("Commercial"):
        {
          return const LottieAnimate(
              assetName: "assets/filter/filterHome.json");
        }
      case ("Plot/land"):
        {
          return const LottieAnimate(
              assetName: "assets/filter/filterHome.json");
        }
      case ("Collaboration"):
        {
          return const LottieAnimate(
              assetName: "assets/filter/filterHome.json");
        }
    }
    return const LottieAnimate(assetName: "assets/filter/filterHome.json");
  }
}
