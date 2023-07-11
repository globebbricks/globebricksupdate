import 'package:flutter/material.dart';

class PropertySearching extends StatefulWidget {
  const PropertySearching({super.key});

  @override
  State<PropertySearching> createState() => _PropertySearchingState();
}

class _PropertySearchingState extends State<PropertySearching>     with SingleTickerProviderStateMixin {
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
    return const Scaffold(

    );
  }
}
