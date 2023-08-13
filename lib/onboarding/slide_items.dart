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
Container(
  height: MediaQuery.of(context).size.height/5,
),
          Column(
            children: [
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
              Padding(
                padding:  EdgeInsets.all(MediaQuery.of(context).size.height / 55),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          slideList[widget.index].title,
                          style: TextStyle(
                              fontFamily: "LeagueSpartan",
                              fontSize: MediaQuery.of(context).size.height / 40,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            slideList[widget.index].description,
                            style: TextStyle(
                              fontFamily: "Nunito",
                              fontSize: MediaQuery.of(context).size.height / 50,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
