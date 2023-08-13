import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:globebricks/assistants/data.dart';
import 'package:globebricks/lottie_animation/animation.dart';

class RentPropertySearching extends StatefulWidget {
  final List<String> propertyFilter;
  final double radius;

  const RentPropertySearching(
      {super.key, required this.propertyFilter, required this.radius});

  @override
  State<RentPropertySearching> createState() => _RentPropertySearchingState();
}

class _RentPropertySearchingState extends State<RentPropertySearching> {
  int currentPage = 0;

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
            (_) => Future.delayed(const Duration(milliseconds: 3000), () async {
              setState(() {
                loading = false;
              });
            }));
    return Scaffold(resizeToAvoidBottomInset: false, body: _body());
  }

  Widget _body() {
    GeoPoint location = GeoPoint(UserData.latitude, UserData.longitude);

    GeoFirePoint center = GeoFirePoint(location);
    double radiusInKm = widget.radius;
    const String field = 'geo';

    final CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance
            .collection("rent")
            .doc("data")
            .collection("1 Bhk");

    GeoPoint geopointFrom(Map<String, dynamic> data) =>
        (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint;

    final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> stream =
        GeoCollectionReference<Map<String, dynamic>>(collectionReference)
            .subscribeWithin(
                center: center,
                radiusInKm: radiusInKm,
                field: field,
                geopointFrom: geopointFrom,
                queryBuilder: (query) => query
                    .where("health", isEqualTo: 100)
                    .where("postedBy", isEqualTo: "Owner")
                    .where("isVisible", isEqualTo: true)
                    .where("isVerified", isEqualTo: true),
                strictMode: true);
    return loading
        ? Center(
            child: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.height / 4,
                child:
                    const LottieAnimate(assetName: "assets/searchingMap.json")))
        : StreamBuilder<List<DocumentSnapshot>>(
            stream: stream,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                final List<DocumentSnapshot<Object?>>? docs = snapshot.data;

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: docs!.length,
                  itemBuilder: (_, index) {
                    final doc = docs[index];
                    // List<dynamic> data = doc.get("images");
                    print(docs.length);

                    return Text(doc.get("name"));
                    // return GestureDetector(
                    //   onTap: () {},
                    //   child: Card(
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(30)),
                    //     child: Column(children: [
                    //       CarouselSlider.builder(
                    //         itemCount: data.length,
                    //         itemBuilder: (BuildContext context, int itemIndex,
                    //                 int pageViewIndex) =>
                    //             Stack(
                    //           children: [
                    //             ClipRRect(
                    //               borderRadius: BorderRadius.circular(20),
                    //               child: Image.network(
                    //                 data[itemIndex],
                    //                 errorBuilder: (context, error, stackTrace) {
                    //                   return const Text("Network Error");
                    //                 },
                    //                 loadingBuilder:
                    //                     (context, child, loadingProgress) {
                    //                   if (loadingProgress == null) {
                    //                     return child;
                    //                   }
                    //                   return Shimmer.fromColors(
                    //                     baseColor: Colors.grey.shade300,
                    //                     highlightColor: Colors.grey.shade100,
                    //                     enabled: true,
                    //                     child: Flexible(
                    //                         child: Image.asset("assets/logo.png")),
                    //                   );
                    //                 },
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         options: CarouselOptions(
                    //           initialPage: 0,
                    //           enlargeCenterPage: true,
                    //           enlargeFactor: 0.3,
                    //           scrollDirection: Axis.horizontal,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Expanded(
                    //               child: Text(
                    //                 doc.get(
                    //                   "propertyTitle",
                    //                 ),
                    //                 maxLines: 3,
                    //                 softWrap: true,
                    //                 overflow: TextOverflow.ellipsis,
                    //                 style: TextStyle(
                    //                     fontSize:
                    //                         MediaQuery.of(context).size.width / 20),
                    //               ),
                    //             ),
                    //             const Icon(
                    //               Icons.favorite_border,
                    //               color: Colors.black54,
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Row(
                    //           children: [Text(doc.get("propertyStatus"))],
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Row(
                    //           children: [
                    //             Expanded(
                    //               child: Text(
                    //                 doc.get(
                    //                   "propertyDescription",
                    //                 ),
                    //                 overflow: TextOverflow.ellipsis,
                    //                 maxLines: 3,
                    //                 softWrap: true,
                    //                 style: TextStyle(
                    //                     color: Colors.black54,
                    //                     fontSize:
                    //                         MediaQuery.of(context).size.width / 30),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //         children: [
                    //           Row(
                    //             children: [
                    //               const Text(
                    //                 "Rs.",
                    //                 style: TextStyle(fontWeight: FontWeight.bold),
                    //               ),
                    //               Text(
                    //                 doc.get("propertyRent").toString(),
                    //                 style: TextStyle(
                    //                     fontFamily: "Nunito",
                    //                     fontSize:
                    //                         MediaQuery.of(context).size.width / 20),
                    //               ),
                    //               const Text(
                    //                 "/ Month",
                    //                 style: TextStyle(fontWeight: FontWeight.bold),
                    //               ),
                    //             ],
                    //           ),
                    //           Row(
                    //             children: [
                    //               Text(
                    //                 doc.get("area").toString(),
                    //                 style: TextStyle(
                    //                     fontFamily: "Nunito",
                    //                     fontSize:
                    //                         MediaQuery.of(context).size.width / 20),
                    //               ),
                    //               const Text(" Square Feet"),
                    //             ],
                    //           )
                    //         ],
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Row(
                    //           children: [
                    //             CircleAvatar(
                    //                 backgroundColor: doc.get("isPremium")
                    //                     ? Colors.green
                    //                     : Colors.blueGrey,
                    //                 child: const Icon(
                    //                   Icons.account_circle_rounded,
                    //                   color: Colors.white,
                    //                 )),
                    //             const Text(" Posted by: "),
                    //             Text(
                    //               doc.get(
                    //                 "postedBy",
                    //               ),
                    //               style: const TextStyle(
                    //                   fontFamily: "Nunito",
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //             Row(
                    //               children: [
                    //                 const Text(" ("),
                    //                 Text(doc.get(
                    //                   "postedByType",
                    //                 )),
                    //                 const Text(")"),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 50),
                    //         child: Row(
                    //           children: [
                    //             const Text(
                    //               "Date: ",
                    //               style: TextStyle(color: Colors.black54),
                    //             ),
                    //             Text(doc.get("uploadDate")),
                    //           ],
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             const CircleAvatar(
                    //               child: Icon(
                    //                 Icons.call,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //             CupertinoButton(
                    //                 borderRadius: BorderRadius.circular(30),
                    //                 color: Colors.indigo,
                    //                 child: const Text(
                    //                   "View Number",
                    //                   style: TextStyle(color: Colors.white),
                    //                 ),
                    //                 onPressed: () {}),
                    //             const CircleAvatar(
                    //               backgroundColor: Colors.green,
                    //               child: Icon(
                    //                 MyFlutterApp.whatsapp,
                    //                 color: Colors.white,
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ]),
                    //   ),
                    // );
                  },
                );
              } else {
                return Platform.isIOS
                    ? const Center(
                        child: CupertinoActivityIndicator(
                        color: Colors.black54,
                      ))
                    : const Center(
                        child: CircularProgressIndicator(
                        backgroundColor: Colors.black54,
                      ));
              }
            },
          );
  }

  _panel() {
    return Center(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Unfortunately there's no property available at this location try to change location or increase the radius of your search,",
                style: TextStyle(fontSize: 20, fontFamily: "Nunito"),
              ),
            ),
            CupertinoButton(
                color: Colors.yellow,
                child: const Text(
                  "Change Location",
                  style: TextStyle(color: Colors.black54),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            const LottieAnimate(assetName: "assets/ob.json"),
          ],
        ),
      ),
    );
  }
}
