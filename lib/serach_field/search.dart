import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:globebricks/assistants/data.dart';
import 'package:globebricks/assistants/map_key.dart';
import 'package:globebricks/assistants/request_api.dart';
import 'package:globebricks/home/home.dart';
import 'package:globebricks/lottie_animation/animation.dart';
import 'package:globebricks/serach_field/property_search_filter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';


class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> with WidgetsBindingObserver {
  late String address;
  final GlobalKey<FormState> searchKey = GlobalKey<FormState>();
  PanelController pc = PanelController();
  late Position position;
  List<dynamic> listData = [];
  var searchController = TextEditingController();

  bool load = true;
  late double customLatitude;

  late double customLongitude;

  double radius = 500;

  @override
  void initState() {
    _determinePosition();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    if (!mounted) {
      searchController.dispose();
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  final List<Marker> markers = <Marker>[];
  double panelHeightOpen = 0.0;
  double panelHeightClosed = 0.0;
  late GoogleMapController refController;
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(20.593683, 78.962883),
    zoom: 18,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
              )),
          title: const Text(
            "Search Everywhere",
            style: TextStyle(color: Colors.black87),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            setState(() {
              _determinePosition();
              myLocationMarker();
            });
          },
          child: const Icon(
            Icons.location_on,
            color: Colors.green,
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            GoogleMap(
              zoomGesturesEnabled: true,
              initialCameraPosition: _kGoogle,
              markers: Set<Marker>.of(markers),
              mapType: MapType.normal,
              scrollGesturesEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              buildingsEnabled: true,
              tiltGesturesEnabled: true,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DelayedDisplay(
                        child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 20),
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) {
                          _placeApiRequest(value);
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchController.clear();
                                    listData = [];
                                  });
                                },
                                icon: const CircleAvatar(
                                    child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ))),
                            hintText: "Search location",
                            hintStyle: const TextStyle(
                                color: Colors.black38, fontFamily: "Nunito"),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    )),
                    (listData.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.builder(
                              itemCount: listData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () async {
                                    UserData.address =
                                        "${listData[index]["structured_formatting"]["main_text"] + " ${listData[index]["structured_formatting"]["secondary_text"]}" + " ${listData[index]["description"]}"}";

                                    setState(() {
                                      address = UserData.address;
                                    });

                                    UserData.placeId =
                                        listData[index]["place_id"];

                                    String url =
                                        "https://maps.googleapis.com/maps/api/place/details/json?placeid=${listData[index]["place_id"]}&key=${MapKey.key}";
                                    var response =
                                        await RequestApi.getRequestUrl(url);
                                    if (RequestApi.responseState) {
                                      customLatitude = await response["result"]
                                          ["geometry"]["location"]["lat"];
                                      customLongitude = await response["result"]
                                          ["geometry"]["location"]["lng"];
                                    }
                                    clearList();
                                    final GoogleMapController controller =
                                        await _controller.future;
                                    await controller.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: LatLng(customLatitude,
                                                    customLongitude),
                                                zoom: 18)));
                                    markers.add(
                                      Marker(
                                          draggable: true,
                                          onDragEnd: (latlng) {
                                            dragCustomLocation(latlng);
                                          },
                                          visible: true,
                                          infoWindow: InfoWindow(
                                            // given title for marker
                                            title:
                                                'Location: ${UserData.address}',
                                          ),
                                          position: LatLng(
                                              customLatitude, customLongitude),
                                          markerId:
                                              const MarkerId("Custom Location"),
                                          icon: BitmapDescriptor.defaultMarker),
                                    );
                                    UserData.latitude = customLatitude;
                                    UserData.longitude = customLongitude;
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.height /
                                              60),
                                      child: ListBody(
                                        children: [
                                          Text(
                                            listData[index][
                                                        "structured_formatting"]
                                                    ["main_text"]
                                                .toString(),
                                            style: const TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            softWrap: false,
                                            maxLines: 4,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                          ),
                                          Text(
                                            listData[index][
                                                        "structured_formatting"]
                                                    ["secondary_text"]
                                                .toString(),
                                            softWrap: false,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            listData[0]["description"]
                                                .toString(),
                                            softWrap: false,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            DelayedDisplay(
              child: SlidingUpPanel(
                controller: pc,
                defaultPanelState: PanelState.CLOSED,
                maxHeight: panelHeightOpen = MediaQuery.of(context).size.height,
                minHeight: panelHeightClosed =
                    MediaQuery.of(context).size.height / 3,
                parallaxEnabled: true,
                parallaxOffset: .5,
                panelBuilder: () =>  _panel(),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0)),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool locating = false;

  _panel( ) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 5,
                    decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  ),
                ],
              ),
            ),
            const Text(
              "Hold & drag marker to change location",
              style: TextStyle(fontFamily: "Nunito"),
            ),
            locating
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                "You are here",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                            ],
                          ),
                          Text(
                            UserData.address,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 28,
                                fontFamily: "Nunito"),
                          ),
                        ],
                      ),
                    ),
                  )
                : Platform.isIOS
                    ? const CupertinoActivityIndicator()
                    : const CircularProgressIndicator(
                        backgroundColor: Colors.black54,
                        strokeWidth: 2,
                      ),
            const LottieAnimate(
              assetName: 'assets/search.json',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.center,
                "We will give you relevant results according to your select location ",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 25,
                    fontFamily: "Nunito"),
              ),
            ),
            locating
                ? Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 15),
                    child: CupertinoButton(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.green,
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          if (Platform.isAndroid) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PropertySearchFilter(),
                                ));
                          }
                          if (Platform.isIOS) {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      const PropertySearchFilter(),
                                ));
                          }
                        }),
                  )
                : const Text("Please Wait.."),
            SizedBox(
              height: MediaQuery.of(context).size.height / 7,
            )
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

    String data = await RequestMethods.searchCoordinateRequests(
        LatLng(position.latitude, position.longitude));
    UserData.latitude = position.latitude;
    UserData.longitude = position.longitude;
    UserData.address = data;

    setState(() {
      myLocationMarker();
      address = data;
      locating = true;
    });
  }

  void myLocationMarker() {
    markers.add(
      Marker(
          draggable: true,
          onDragEnd: (latlng) {
            dragCustomLocation(latlng);
          },
          visible: true,
          infoWindow: InfoWindow(
            title: 'Location: ${UserData.address}',
          ),
          position: LatLng(position.latitude, position.longitude),
          markerId: const MarkerId("My Location"),
          icon: BitmapDescriptor.defaultMarker),
    );
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

  Future<void> onResumed() async {
    _determinePosition();
  }

  void onPaused() {

  }

  void onInactive() {}

  void onDetached() {}

  showError() {
    if (Platform.isAndroid) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Location Disabled"),
          content:
              const Text("Location is disabled please allow in app settings"),
          actions: [
            TextButton(
                onPressed: () {
                  AppSettings.openAppSettings();
                  Navigator.pop(context);
                },
                child: const Text("Allow")),
            TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                      (route) => false);
                },
                child: const Text("Cancel"))
          ],
        ),
      );
    }
    if (Platform.isIOS) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Location Disabled"),
          content:
              const Text("Location is disabled please allow in app settings"),
          actions: [
            TextButton(
                onPressed: () {
                  AppSettings.openAppSettings();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Allow",
                  style: TextStyle(color: Colors.black),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const Home(),
                      ),
                      (route) => false);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      );
    }
  }

  Future<void> dragCustomLocation(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 18)));
    UserData.address = await RequestMethods.searchCoordinateRequests(position);
    UserData.longitude = position.longitude;
    UserData.latitude = position.latitude;
    setState(() {
      address = UserData.address;
    });
  }

  Future<void> _placeApiRequest(String userkeyboardData) async {
    if (userkeyboardData.length > 1) {
      String autoComplete =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$userkeyboardData&location=${UserData.latitude}%2C${UserData.longitude}&radius=100&key=${MapKey.key}";
      var response = await RequestApi.getRequestUrl(autoComplete);
      if (response["status"] == "OK") {
        var prediction = response["predictions"];
        setState(() {
          listData = prediction;
        });
      }
    }
  }

  void clearList() {
    searchController.clear();
    listData = [];
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
