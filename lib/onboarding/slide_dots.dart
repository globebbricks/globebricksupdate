import 'package:flutter/material.dart';

class SlideDots extends StatelessWidget {
  final bool isActive;
  const SlideDots(this.isActive, {super.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 10 : 5,
      width: isActive ? 10 : 5,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white60,
        borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}