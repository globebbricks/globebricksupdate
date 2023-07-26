import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:globebricks/assistants/data.dart';
import 'package:globebricks/lottie_animation/animation.dart';

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

  static var images = [];

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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
            (_) =>
            Future.delayed(const Duration(milliseconds: 2000), () async {
              if(mounted){
                setState(()  {
                  loading = false;
                });
              }
            }));
    GeoFirePoint center =
    geo.point(latitude: UserData.latitude, longitude: UserData.longitude);

    var collectionReference = firestore
        .collection('globeBricks')
        .doc("Rent")
        .collection(widget.propertyType);
    double radius = 1;
    String field = 'position';

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field);

    return Scaffold(
      body: loading
          ? Center(
          child: SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 4,
              width: MediaQuery
                  .of(context)
                  .size
                  .height / 4,
              child: const LottieAnimate(
                  assetName: "assets/searchingMap.json")))
          : StreamBuilder<List<DocumentSnapshot>>(
        stream: stream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot<Object?>>? docs = snapshot.data;
            return ListView.builder(
              itemCount: docs!.length,
              itemBuilder: (_, index) {
                final doc = docs[index];
                fetchImages(doc.id.toString());
                return Column(children: [
                    CarouselSlider(
                    options: CarouselOptions(
                    ),
                items: images
                    .map((item) => Center(
                    child:
                    Image.network(item, fit: BoxFit.cover, width: MediaQuery.of(context).size.width/2))).toList(),
                )
                ],);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
  static Future<List<Map<String, dynamic>>> fetchImages(
      String uniqueUserId) async {
    List<Map<String, dynamic>> files = [];
    final ListResult result = await FirebaseStorage.instance
        .ref()
        .child('usersPropertyImages')
        .child(uniqueUserId)
        .list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      images.add(fileUrl);

    });

    return files;
}
}

