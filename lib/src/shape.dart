import 'package:flutter/material.dart';

/// Represents a drawable shape that can be rendered on a canvas.
///
/// A [Shape] instance holds properties defining its position, size,
/// movement, opacity, and additional transformation properties such as
/// rotation and pulsing. These properties allow for flexible animations
/// and custom painting behaviors.
class Shape {
  /// The horizontal coordinate (normalized between 0 and 1).
  double x;

  /// The vertical coordinate (normalized between 0 and 1).
  double y;

  /// The radius of the shape.
  double radius;

  /// The movement speed of the shape.
  double speed;

  /// The current opacity of the shape (between 0.0 and 1.0).
  double opacity;

  /// The depth used for z-ordering and visual scaling.
  double depth;

  /// The type of shape (e.g., 'circle', 'rectangle', etc.).
  String? shape;

  /// Optional custom painting function that draws the shape.
  void Function(Canvas, Offset, double, Paint)? paintMethod;

  /// Optional icon to be drawn within the shape.
  IconData? icon;

  // Additional transformation properties:

  /// The current rotation angle in radians.
  final double rotation;

  /// The rotation speed in radians per second.
  final double angularSpeed;

  /// The base (original) opacity of the shape.
  final double baseOpacity;

  /// The current phase of the pulsing effect.
  final double pulsePhase;

  /// The frequency of the pulsing effect.
  final double pulseFrequency;

  /// Creates a [Shape] with the given properties.
  ///
  /// The [x], [y], [radius], [speed], [opacity], and [depth] parameters are required.
  /// If [baseOpacity] is not provided, it defaults to the value of [opacity].
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
