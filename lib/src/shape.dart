// src/shape.dart

import 'package:flutter/material.dart';

/// Represents a drawable shape with various properties,
/// including optional transformation values for rotation and pulsing.
class Shape {
  double x;
  double y;
  double radius;
  double speed;
  double opacity;
  double depth;
  String? shape;
  void Function(Canvas, Offset, double, Paint)? paintMethod;
  IconData? icon;

  // Additional transformation properties:
  final double rotation;
  final double angularSpeed;
  final double baseOpacity;
  final double pulsePhase;
  final double pulseFrequency;

  Shape({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
    required this.depth,
    this.shape,
    this.paintMethod,
    this.icon,
    this.rotation = 0.0,
    this.angularSpeed = 0.0,
    double? baseOpacity,
    this.pulsePhase = 0.0,
    this.pulseFrequency = 0.0,
  }) : baseOpacity = baseOpacity ?? opacity;
}
