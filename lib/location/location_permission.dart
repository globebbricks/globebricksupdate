import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LocationPermission extends StatefulWidget {
  const LocationPermission({super.key});

  @override
  State<LocationPermission> createState() => _LocationPermissionState();
}

class _LocationPermissionState extends State<LocationPermission> with SingleTickerProviderStateMixin {
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
    return  Scaffold(
      body: SafeArea(child: Center(
        child: Column(
          children: [
            const Text("Location Required",style: TextStyle(fontFamily: "Nunito"),),
            SizedBox(
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.height/4,
              child: Lottie.asset(
                "assets/map-pin-location.json",
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
