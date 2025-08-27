import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Represents a drawable shape that can be rendered on a canvas.
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
  ui.Image? image; // ✅ NEU: PNG-Unterstützung

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
    this.image,
    this.rotation = 0.0,
    this.angularSpeed = 0.0,
    double? baseOpacity,
    this.pulsePhase = 0.0,
    this.pulseFrequency = 0.0,
  }) : baseOpacity = baseOpacity ?? opacity;

  /// Returns a copy with updated values.
  Shape copyWith({
    double? x,
    double? y,
    double? radius,
    double? speed,
    double? opacity,
    double? depth,
    String? shape,
    void Function(Canvas, Offset, double, Paint)? paintMethod,
    IconData? icon,
    ui.Image? image,
    double? rotation,
    double? angularSpeed,
    double? baseOpacity,
    double? pulsePhase,
    double? pulseFrequency,
  }) {
    return Shape(
      x: x ?? this.x,
      y: y ?? this.y,
      radius: radius ?? this.radius,
      speed: speed ?? this.speed,
      opacity: opacity ?? this.opacity,
      depth: depth ?? this.depth,
      shape: shape ?? this.shape,
      paintMethod: paintMethod ?? this.paintMethod,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      rotation: rotation ?? this.rotation,
      angularSpeed: angularSpeed ?? this.angularSpeed,
      baseOpacity: baseOpacity ?? this.baseOpacity,
      pulsePhase: pulsePhase ?? this.pulsePhase,
      pulseFrequency: pulseFrequency ?? this.pulseFrequency,
    );
  }
}
