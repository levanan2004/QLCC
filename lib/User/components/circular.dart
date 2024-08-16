import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Circular extends StatefulWidget {
  const Circular({super.key});

  @override
  State<Circular> createState() => _CircularState();
}

class _CircularState extends State<Circular> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      padding: EdgeInsets.all(10),
      child: Lottie.asset('assets/animation/loading.json'),
    ));
  }
}
