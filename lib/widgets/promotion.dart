import 'package:flutter/material.dart';

class Promotion extends StatefulWidget {
  final int index;

  const Promotion({super.key, required this.index});

  @override
  State<Promotion> createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> with SingleTickerProviderStateMixin {


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
    return Container(
      width: MediaQuery.of(context).size.width/0.5,
      height: MediaQuery.of(context).size.width/0.5,
      decoration: BoxDecoration(color: Colors.pinkAccent[100]),
      child: Row(
        children: [
          const Column(
            children: [
              Text("title"),
              Text("title"),
              Text("title"),
            ],
          ),
          Image.network(
              "https://www.edigitalagency.com.au/wp-content/uploads/Twitter-logo-png-icon-blue-small-size.png")
        ],
      ),
    );
  }
}
