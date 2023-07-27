

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:globebricks/assistants/data.dart';
import 'package:globebricks/lottie_animation/animation.dart';
import 'package:globebricks/my_flutter_app_icons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PropertySearching extends StatefulWidget {
  final String propertyType;

  const PropertySearching({super.key, required this.propertyType});

  @override
  State<PropertySearching> createState() => _PropertySearchingState();
}

class _PropertySearchingState extends State<PropertySearching>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool loaded = true;
  FirebaseFirestore server = FirebaseFirestore.instance;

  List<String> images = [];

  bool noData = false;


  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  var filter = ["Owner"];

  @override
  void dispose() {
    server.terminate();
    if (_controller.isCompleted) {
      _controller.dispose();
    }
    super.dispose();
  }

  final geo = GeoFlutterFire();
  final firestore = FirebaseFirestore.instance;
  bool loading = true;
PanelController pc =  PanelController();
  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double minHeight = 0;

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Future.delayed(const Duration(milliseconds: 2000), () async {
              if (mounted) {
                setState(() {
                  loading = false;
                });
              }
            }));


    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xffFFC8B0),
        body: SlidingUpPanel(
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
        )
    );
  }

  // void fetchImages(String uniqueUserId) async {
  //   late String fileUrl;
  //   final ListResult result = await FirebaseStorage.instance
  //       .ref()
  //       .child('usersPropertyImages')
  //       .child(uniqueUserId)
  //       .list();
  //   final List<Reference> allFiles = result.items;
  //   await Future.forEach<Reference>(allFiles, (file) async {
  //     fileUrl = await file.getDownloadURL();
  //   });
  //   images.add(fileUrl);
  // }

 Widget _body() {
    GeoFirePoint center =
    geo.point(latitude: UserData.latitude, longitude: UserData.longitude);

    var collectionReference = firestore
        .collection('globeBricks')
        .doc("Rent")
        .collection(widget.propertyType);
    double radius = 5;
    String field = 'position';

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field);
    return loading
          ? Center(
          child: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.height / 4,
              child: const LottieAnimate(
                  assetName: "assets/searchingMap.json")))
          : noData ?  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("No property Found"),
            const LottieAnimate(assetName: "assets/search.json"),
            CupertinoButton(
                borderRadius:
                BorderRadius.circular(30),
                color: Colors.indigo,
                child: const Text(
                  "Change Location",
                  style: TextStyle(
                      color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],),
      ) :  StreamBuilder<List<DocumentSnapshot>>(
        stream: stream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot<Object?>>? docs = snapshot.data;
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: docs!.length,
              itemBuilder: (_, index) {

                if(docs.isEmpty){
                  pc.open();
                }
                final doc = docs[index];


                return GestureDetector(
                    onTap: () {},
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(children: [
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(20),
                                    child: Image(
                                      image:  NetworkImage(
                                          doc.get("coverImage")),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          doc.get(
                                            "propertyTitle",
                                          ),
                                          maxLines: 3,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  20),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.favorite_border,
                                        color: Colors.black54,
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(doc.get("propertyStatus"))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          doc.get(
                                            "propertyDescription",
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          softWrap: true,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  30),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Rs.",
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        Text(
                                          doc
                                              .get("propertyRent")
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontSize:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  20),
                                        ),
                                        const Text(
                                          "/ Month",
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          doc.get("area"),
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontSize:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  20),
                                        ),
                                        const Text(" Square Feet"),
                                      ],
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor:
                                          doc.get("isPremium")
                                              ? Colors.green
                                              : Colors.blueGrey,
                                          child: const Icon(
                                            Icons.account_circle_rounded,
                                            color: Colors.white,
                                          )),
                                      const Text(" Posted by: "),
                                      Text(
                                        doc.get(
                                          "postedBy",
                                        ),
                                        style: const TextStyle(
                                            fontFamily: "Nunito",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          const Text(" ("),
                                          Text(doc.get(
                                            "postedByType",
                                          )),
                                          const Text(")"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Date: ",
                                        style: TextStyle(
                                            color: Colors.black54),
                                      ),
                                      Text(doc.get("uploadDate")),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const CircleAvatar(
                                        child: Icon(Icons.call,color: Colors.white,),),
                                      CupertinoButton(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          color: Colors.indigo,
                                          child: const Text(
                                            "View Number",
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                          onPressed: () {}),
                                      const CircleAvatar(
                                        backgroundColor: Colors.green,
                                        child: Icon(MyFlutterApp.whatsapp,color: Colors.white,),)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ])));
              },
            );
          } else {

            return Container();
          }
        },
    );

  }

  _panel(ScrollController sc) {

    return const Column(children: [

    ],);
  }
}
