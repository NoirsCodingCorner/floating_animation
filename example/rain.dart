// main.dart
import 'package:flutter/material.dart';
import 'package:floating_animation/floating_animation.dart';

void main() {
  runApp(RainApp());
}

class RainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Floating Shapes Demo',
      home: FallingRain(),
    );
  }
}

class FallingRain extends StatelessWidget {
  const FallingRain({super.key});

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
                Colors.grey,
                Colors.blueGrey,
                Colors.indigoAccent.shade100
              ],
            )),
          ),
          FloatingAnimation(
            maxShapes: 200,
            selectedShape: "circle",
            shapeColors: {
              "circle": Colors.blueAccent.shade700,
              "rectangle": Colors.green,
              "heart": Colors.red.shade900,
            },
            sizeMultiplier: 0.3,
            speedMultiplier: 4,
            spawnRate: 100,
            direction: FloatingDirection.down,
          )
        ],
      ),
    );
  }
}
