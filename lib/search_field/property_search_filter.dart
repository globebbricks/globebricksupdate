import 'dart:io';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globebricks/assistants/data.dart';
import 'package:globebricks/search_field/buy_property_searching.dart';
import 'package:globebricks/search_field/commercial_property_searching.dart';
import 'package:globebricks/search_field/flatmate_searching.dart';
import 'package:globebricks/search_field/pg_property_searching.dart';
import 'package:globebricks/search_field/rent_property_searching.dart';


class PropertySearchFilter extends StatefulWidget {
  const PropertySearchFilter({super.key});

  @override
  State<PropertySearchFilter> createState() => _PropertySearchFilterState();
}

class _PropertySearchFilterState extends State<PropertySearchFilter> {
  bool selected = false;
  int _selectedIndex = 0;

  final List _choiceChipsList = [
    "Rent",
    "Buy",
    "PG",
    "Flatmates",
    "Commercial",
  ];

  bool chipSelected = false;
  double radius = 500;

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
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 15),
                child: Column(
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(
                            "Explore real estate options at your desired location",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize:
                                    MediaQuery.of(context).size.width / 25)),
                      ),
                    ]),
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
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                        children: [
                          Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      elevation: 0.5,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                      ),
                    ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 15,
                            bottom: MediaQuery.of(context).size.width / 15),
                        child: Text(
                          UserData.address,
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height / 60,
                            overflow: TextOverflow.ellipsis,
                          ),
                          softWrap: false,
                          maxLines: 2,
                        ),
                      ),
                      Text(_choiceChipsList[_selectedIndex],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Nunito",
                              fontSize:
                                  MediaQuery.of(context).size.width / 15)),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: filter(_choiceChipsList[_selectedIndex])),

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

  List<String> rentTags = [];
  List<String> buyTags = [];
  List<String> pgTags = [];
  List<String> flatmateTags = [];
  List<String> commercialTags = [];
  List<String> rentOptions = [
    '1 Rk',
    '1 Bhk',
    '2 Bhk',
    '3 Bhk',
    '4 Bhk',
    '5 Bhk',
  ];
  List<String> buyOptions = [
    'House',
    'Apartment',
    'Building',
    'Floor',
    "Plot/Land",
  ];
  List<String> pgOptions = [
    'Male',
    'Female',
  ];
  List<String> flatmateOptions = ['Male', 'Female', 'LGBTQ'];
  List<String> commercialOptions = [
    'Office Space',
    'Shop',
    'Commercial Floor',
    "Commercial Plot/Land",
  ];

  Widget filter(String propertyType) {
    switch (propertyType) {
      case ("Rent"):
        {
          return Column(
            children: [
              ChipsChoice<String>.multiple(
                choiceCheckmark: true,
                value: rentTags,
                onChanged: (val) => setState(() => rentTags = val),
                choiceItems: C2Choice.listFrom<String, String>(
                  source: rentOptions,
                  value: (i, v) => v,
                  label: (i, v) => v,
                  tooltip: (i, v) => v,
                  style: (i, v) {
                    return C2ChipStyle.toned(
                      backgroundColor: Colors.red,
                      checkmarkSize: MediaQuery.of(context).size.width / 25,
                      checkmarkColor: Colors.orange,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    );
                  },
                ),
                wrapped: true,
              ),
              Flexible(child: Image.asset("assets/filter/filterHome.png")),
              CupertinoButton(
                  color: Colors.green,
                  onPressed: () {
                    if (rentTags.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Select Given Options 😔")));
                    } else {
                      double range = radius / 1000;
                      if (Platform.isAndroid) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RentPropertySearching(
                                propertyFilter: rentTags,
                                radius: range,
                              ),
                            ));
                      }
                      if (Platform.isIOS) {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => RentPropertySearching(
                                propertyFilter: rentTags,
                                radius: range,
                              ),
                            ));
                      }
                    }
                  },
                  child: const Text("Search")),
            ],
          );
        }
      case ("Buy"):
        {
          return Column(
            children: [
              ChipsChoice<String>.multiple(
                choiceCheckmark: true,
                value: buyTags,
                onChanged: (val) => setState(() => buyTags = val),
                choiceItems: C2Choice.listFrom<String, String>(
                  source: buyOptions,
                  value: (i, v) => v,
                  label: (i, v) => v,
                  tooltip: (i, v) => v,
                  style: (i, v) {
                    return C2ChipStyle.toned(
                      backgroundColor: Colors.red,
                      checkmarkSize: MediaQuery.of(context).size.width / 25,
                      checkmarkColor: Colors.orange,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    );
                  },
                ),
                wrapped: true,
              ),
              Flexible(child: Image.asset("assets/filter/filterBuy.png")),
              CupertinoButton(
                  color: Colors.green,
                  onPressed: () {
                    if (buyTags.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Select Given Options 😔")));
                    } else {
                      double range = radius / 1000;
                      if (Platform.isAndroid) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BuyPropertySearching(
                                propertyFilter: buyTags,
                                radius: range,
                              ),
                            ));
                      }
                      if (Platform.isIOS) {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => BuyPropertySearching(
                                propertyFilter: buyTags,
                                radius: range,
                              ),
                            ));
                      }
                    }
                  },
                  child: const Text("Search")),
            ],
          );
        }
      case ("PG"):
        {
          return Column(
            children: [
              ChipsChoice<String>.multiple(
                choiceCheckmark: true,
                value: pgTags,
                onChanged: (val) => setState(() => pgTags = val),
                choiceItems: C2Choice.listFrom<String, String>(
                  source: pgOptions,
                  value: (i, v) => v,
                  label: (i, v) => v,
                  tooltip: (i, v) => v,
                  style: (i, v) {
                    return C2ChipStyle.toned(
                      backgroundColor: Colors.red,
                      checkmarkSize: MediaQuery.of(context).size.width / 25,
                      checkmarkColor: Colors.orange,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    );
                  },
                ),
                wrapped: true,
              ),
              Flexible(
                child: Image.asset("assets/filter/filterFlatmates.png"),
              ),
              CupertinoButton(
                  color: Colors.green,
                  onPressed: () {
                    if (pgTags.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Select Given Options 😔")));
                    } else {
                      double range = radius / 1000;

                      if (Platform.isAndroid) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PgPropertySearching(
                                propertyFilter: pgTags,
                                radius: range,
                              ),
                            ));
                      }
                      if (Platform.isIOS) {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => PgPropertySearching(
                                propertyFilter: pgTags,
                                radius: range,
                              ),
                            ));
                      }
                    }
                  },
                  child: const Text("Search")),
            ],
          );
        }
      case ("Flatmates"):
        {
          return Column(
            children: [
              ChipsChoice<String>.multiple(
                choiceCheckmark: true,
                value: flatmateTags,
                onChanged: (val) => setState(() => flatmateTags = val),
                choiceItems: C2Choice.listFrom<String, String>(
                  source: flatmateOptions,
                  value: (i, v) => v,
                  label: (i, v) => v,
                  tooltip: (i, v) => v,
                  style: (i, v) {
                    return C2ChipStyle.toned(
                      backgroundColor: Colors.red,
                      checkmarkSize: MediaQuery.of(context).size.width / 25,
                      checkmarkColor: Colors.orange,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    );
                  },
                ),
                wrapped: true,
              ),
              Flexible(
                child: Image.asset("assets/filter/filterFlatmates.png"),
              ),
              CupertinoButton(
                  color: Colors.green,
                  onPressed: () {
                    if (flatmateTags.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Select Given Options 😔")));
                    } else {
                      double range = radius / 1000;

                      if (Platform.isAndroid) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlatmatesSearching(
                                propertyFilter: flatmateTags,
                                radius: range,
                              ),
                            ));
                      }
                      if (Platform.isIOS) {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => FlatmatesSearching(
                                propertyFilter: flatmateTags,
                                radius: range,
                              ),
                            ));
                      }
                    }
                  },
                  child: const Text("Search")),
            ],
          );
        }
      case ("Commercial"):
        {
          return Column(
            children: [
              ChipsChoice<String>.multiple(
                choiceCheckmark: true,
                value: commercialTags,
                onChanged: (val) => setState(() => commercialTags = val),
                choiceItems: C2Choice.listFrom<String, String>(
                  source: commercialOptions,
                  value: (i, v) => v,
                  label: (i, v) => v,
                  tooltip: (i, v) => v,
                  style: (i, v) {
                    return C2ChipStyle.toned(
                      backgroundColor: Colors.red,
                      checkmarkSize: MediaQuery.of(context).size.width / 25,
                      checkmarkColor: Colors.orange,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    );
                  },
                ),
                wrapped: true,
              ),
              Flexible(
                child: Image.asset("assets/filter/filterCommercial.png"),
              ),
              CupertinoButton(
                  color: Colors.green,
                  onPressed: () {
                    if (commercialTags.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Select Given Options 😔")));
                    } else {
                      double range = radius / 1000;

                      if (Platform.isAndroid) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CommercialPropertySearching(
                                propertyFilter: commercialTags,
                                radius: range,
                              ),
                            ));
                      }
                      if (Platform.isIOS) {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  CommercialPropertySearching(
                                propertyFilter: commercialTags,
                                radius: range,
                              ),
                            ));
                      }
                    }
                  },
                  child: const Text("Search")),
            ],
          );
        }
    }
    return Container();
  }
}
