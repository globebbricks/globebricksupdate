import 'package:flutter/material.dart';
import 'package:globebricks/assistants/data.dart';
import 'package:lottie/lottie.dart';

class SelectFeatures extends StatefulWidget {
  const SelectFeatures({super.key});

  @override
  State<SelectFeatures> createState() => _SelectFeaturesState();
}

class _SelectFeaturesState extends State<SelectFeatures>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.green,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  UserData.address,
                  style: const TextStyle(fontFamily: "Nunito"),
                ),
              ),
              Lottie.asset(
                'assets/searchNext.json',
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..repeat();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/features/house.png",
                            height: MediaQuery.of(context).size.width / 4,
                            width: MediaQuery.of(context).size.width / 4,
                          ),
                          const Text(
                            "Rent",
                            style: TextStyle(fontFamily: "Nunito"),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),

                      child: Column(
                        children: [
                          Image.asset(
                            "assets/features/house.png",
                            height: MediaQuery.of(context).size.width / 4,
                            width: MediaQuery.of(context).size.width / 4,
                          ),
                          const Text(
                            "Buy Property",
                            style: TextStyle(fontFamily: "Nunito"),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
