// main.dart
import 'package:flutter/material.dart';
import 'package:floating_animation/floating_animation.dart';

void main() {
  runApp(HeartsApp());
}

class HeartsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Floating Shapes Demo',
      home: FloatingHearts(),
    );
  }
}

class FloatingHearts extends StatelessWidget {
  const FloatingHearts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Optional: Set a background color or image
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purpleAccent.shade100,
                Colors.pinkAccent.shade100,
                Colors.red.shade100
              ],
            )),
          ),
          FloatingAnimation(
            maxShapes: 50,
            selectedShape: "heart",
            shapeColors: {
              "circle": Colors.blue,
              "rectangle": Colors.green,
              "heart": Colors.red.shade900,
            },
          )
        ],
      ),
    );
  }
}
