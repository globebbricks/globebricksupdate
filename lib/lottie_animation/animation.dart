import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimate extends StatefulWidget {
  final String assetName;
  const LottieAnimate({super.key, required this.assetName});

  @override
  State<LottieAnimate> createState() => _LottieAnimateState();
}

class _LottieAnimateState extends State<LottieAnimate> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool loaded = true;

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
    return

      Lottie.asset(
     widget.assetName,
      controller: _controller,
      onLoaded: (composition) {
        // Configure the AnimationController with the duration of the
        // Lottie file and start the animation.
        _controller
          ..duration = composition.duration
          ..forward();
      },
    );
  }

}
