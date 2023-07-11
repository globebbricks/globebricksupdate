import 'package:flutter/material.dart';
import 'package:globebricks/onboarding/slide_list.dart';
import 'package:lottie/lottie.dart';

class SlideItem extends StatefulWidget {
  final int index;

  const SlideItem(this.index, {super.key});

  @override
  State<SlideItem> createState() => _SlideItemState();
}

class _SlideItemState extends State<SlideItem>
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
    return SafeArea(
      child: Column(
        children: [
          Text(
            "Globe Bricks",
            style: TextStyle(
                fontFamily: "Nunito",
                fontSize: MediaQuery.of(context).size.width / 20,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Lottie.asset(
              slideList[widget.index].image,
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height / 25,
                  ),
                  child: Row(
                    children: [
                      Text(
                        slideList[widget.index].title,
                        style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: MediaQuery.of(context).size.height / 40,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height / 25,
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          slideList[widget.index].description,
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: MediaQuery.of(context).size.height / 55,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
