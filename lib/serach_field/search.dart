import 'dart:async';
import 'dart:io';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:globebricks/assistants/data.dart';
import 'package:globebricks/assistants/map_key.dart';
import 'package:globebricks/assistants/request_api.dart';
import 'package:globebricks/lottie_animation/animation.dart';
import 'package:globebricks/serach_field/property_searching.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late String address;
  final GlobalKey<FormState> searchKey = GlobalKey<FormState>();
  PanelController pc = PanelController();
  late Position position;
  List<PlacePrediction> listData = [];

  var searchController = TextEditingController();

  bool searching = false;

  bool load = true;

  @override
  void initState() {
    rootBundle.loadString('assets/mapStyle.json').then((string) {
      _mapStyle = string;
    });
    _determinePosition();

    super.initState();
  }

  @override
  void dispose() {
    if(!mounted){
      searchController.dispose();
    }
    super.dispose();
  }
  final List<Marker> markers = <Marker>[];
  double panelHeightOpen = 0.0;
  double panelHeightClosed = 0.0;
  bool addressUpdated = false;
  FocusNode focusNode = FocusNode();
  late GoogleMapController refController;

  late String _mapStyle;

  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(20.593683, 78.962883),
    zoom: 18,
  );

  @override
  Widget build(BuildContext context) {
    if (load) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => Future.delayed(const Duration(milliseconds: 1500), () async {
                panelHeightOpen = MediaQuery.of(context).size.height -
                    MediaQuery.of(context).size.height / 10;
                setState(() {
                  pc.open();
                  panelHeightClosed = MediaQuery.of(context).size.height/2.5;
                  load = false;
                });
              }));
    }

    return MaterialApp(
      home: Scaffold(
        floatingActionButton: searching ? Container(): FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            pc.open();
            locateMe();
            setState(() {
              searching = false;
            });
          },
          child: const Icon(Icons.location_on),
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
          searching ? Container():  GoogleMap(
              initialCameraPosition: _kGoogle,
              markers: Set<Marker>.of(markers),
              mapType: MapType.normal,
              scrollGesturesEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              buildingsEnabled: false,
              tiltGesturesEnabled: false,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                controller.setMapStyle(_mapStyle);
              },
            ),
            if (searching) SafeArea(
                    child: Column(
                      children: [
                        Form(
                            child: DelayedDisplay(
                                child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width / 20),
                          child: TextFormField(
                            controller: searchController,
                            onChanged: (value) {
                              _placeApiRequest(value, MapKey.key);
                            },
                            focusNode: focusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                                hintText: "Search Area, Locality, City",
                                hintStyle: const TextStyle(
                                    color: Colors.black38,
                                    fontFamily: "Nunito"),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide.none,
                                )),
                          ),
                        ))),
                        (listData.isNotEmpty)
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListView.separated(
                                  itemCount: listData.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return PredictionTile(
                                        placesData: listData[index]);
                                  },
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                ),
                              )
                            : Container(),

                        CupertinoButton(onPressed: (){
                            Navigator.pop(context);
                            searchController.clear();
                        }, child: const Text("Cancel",style: TextStyle(color: Colors.red),)),

                        const LottieAnimate(assetName: "assets/property.json",)
                      ],
                    ),
                  ) else Container(),
            SlidingUpPanel(
              controller: pc,
              defaultPanelState: PanelState.CLOSED,
              maxHeight: panelHeightOpen,
              minHeight: panelHeightClosed,
              parallaxEnabled: true,
              parallaxOffset: .5,
              panelBuilder: (sc) => _panel(sc),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
            ),
          ],
        ),
      ),
    );
  }

  bool locating = false;

  _panel(ScrollController sc) {
    return Scaffold(
      backgroundColor: const Color(0XFFf0f0f0),
      body: SingleChildScrollView(
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
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 20,
                  right: MediaQuery.of(context).size.width / 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "You are here",
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Icon(
                        Icons.location_on,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          panelHeightClosed = 0.0;
                          pc.close();
                          searching = true;
                          FocusScope.of(context).requestFocus();
                        });
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Change Location",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            locating
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      address,
                      style: const TextStyle(fontFamily: "Nunito"),
                    ),
                  )
                : Platform.isIOS
                    ? const CupertinoActivityIndicator()
                    : const CircularProgressIndicator(
                        backgroundColor: Colors.black54,
                        strokeWidth: 2,
                      ),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Chip(label: Text("Rent"), backgroundColor: Colors.white),
                Chip(label: Text("Buy"), backgroundColor: Colors.white),
                Chip(
                    label: Text("PG/Co-Living"), backgroundColor: Colors.white),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Chip(
                    label: Text("Flat Sharing"), backgroundColor: Colors.white),
                Chip(label: Text("Commercial"), backgroundColor: Colors.white),
              ],
            ),
             const LottieAnimate(assetName: 'assets/search.json',)
          ],
        ),
      ),
    );
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showError();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return locateMe();
  }

  void locateMe() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
    final GoogleMapController controller = await _controller.future;
    refController = controller;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String data = await RequestMethods.searchCoordinateRequests(position);

    setState(() {
      address = data;
      locating = true;
      Future.delayed(const Duration(milliseconds: 1500))
          .then((value) => {pc.open()});
    });
  }

  showError() {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Location Disabled"),
          content:
              const Text("Location is disabled please allow in app setting"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Allow"))
          ],
        ),
      );
    }
    if (Platform.isIOS) {
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Location Disabled"),
          content:
              const Text("Location is disabled please allow in app setting"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Allow"))
          ],
        ),
      );
    }
  }

  Future<void> _placeApiRequest(String userkeyboardData, String key) async {
    if (userkeyboardData.length > 1) {
      String autoComplete =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$userkeyboardData&location=${position.latitude}%2C${position.longitude}&radius=50&key=$key";

      var response = await RequestApi.getRequestUrl(autoComplete);
      if (response["status"] == "OK") {
        var prediction = response["predictions"];
        var placeList = (prediction as List)
            .map((e) => PlacePrediction.fromJson(e))
            .toList();
        setState(() {
          if (mounted) {
            listData = placeList;
          }
        });
      }
    }
  }
}

class PredictionTile extends StatefulWidget {
  final PlacePrediction placesData;

  const PredictionTile({Key? key, required this.placesData}) : super(key: key);

  @override
  State<PredictionTile> createState() => _PredictionTileState();
}

class _PredictionTileState extends State<PredictionTile> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final getAddress =
            "${widget.placesData.mainText} ${widget.placesData.secondaryText}";
        UserData.placeId = widget.placesData.placeId;
        UserData.selectLocation = await getLatLng(UserData.placeId);
        UserData.address = getAddress;
        moveToPropertySearch();
      },
      child: ListBody(
        children: [
          Text(
            widget.placesData.mainText,
            style: const TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            softWrap: false,
            maxLines: 3,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.placesData.secondaryText,
            softWrap: false,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  static Future<LatLng> getLatLng(String placeId) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=${MapKey.key}";
    var response = await RequestApi.getRequestUrl(url);
    if (RequestApi.responseState) {
      double lat = response["result"]["geometry"]["location"]["lat"];
      double lng = response["result"]["geometry"]["location"]["lng"];
      return LatLng(lat, lng);
    }
    return const LatLng(20.593683, 78.962883);
  }

  void moveToPropertySearch() {
    if (Platform.isAndroid) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PropertySearching(),
          ),
              );
    }
    if (Platform.isIOS) {
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const PropertySearching(),
          ),
             );
    }
  }
}

class PlacePrediction {
  late String secondaryText;

  late String mainText;

  late String placeId;

  PlacePrediction(
      {required this.secondaryText,
      required this.mainText,
      required this.placeId});

  PlacePrediction.fromJson(Map<String, dynamic> json) {
    placeId = json["place_id"];
    mainText = json["structured_formatting"]["main_text"];
    secondaryText = json["structured_formatting"]["secondary_text"];
  }
}
