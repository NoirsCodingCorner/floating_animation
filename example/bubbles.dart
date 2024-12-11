// main.dart
import 'package:flutter/material.dart';
import 'package:floating_animation/floating_animation.dart';

void main() {
  runApp(BubblesApp());
}

class BubblesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Floating Shapes Demo',
      home: FloatingBubbles(),
    );
  }
}

class FloatingBubbles extends StatelessWidget {
  const FloatingBubbles({super.key});

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
                Colors.cyanAccent,
                Colors.cyan.shade300,
                Colors.indigoAccent.shade100
              ],
            )),
          ),
          FloatingAnimation(
            maxShapes: 50,
            selectedShape: "circle",
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
