// floating_animation.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'shape.dart';
import 'shape_painter.dart';



/// Enum to define the direction of floating shapes.
enum FloatingDirection { up, down }

/// A StatefulWidget that manages and animates a background of floating shapes.
/// In addition to basic movement, it can optionally rotate and pulse the shapes.
class FloatingAnimation extends StatefulWidget {
  final int maxShapes;
  final double speedMultiplier;
  final double sizeMultiplier;
  final String selectedShape;
  final Map<String, Color> shapeColors;
  final FloatingDirection direction;
  final double spawnRate;
  final IconData? icon;
  final void Function(Canvas, Offset, double, Paint)? customPaintMethod;

  // New transformation parameters:
  final bool enableRotation;
  final double rotationSpeedMultiplier;
  final bool enablePulse;
  final double pulseSpeed;
  final double pulseAmplitude;

  const FloatingAnimation({
    super.key,
    this.maxShapes = 50,
    this.speedMultiplier = 1.0,
    this.sizeMultiplier = 1.0,
    this.selectedShape = 'circle',
    this.shapeColors = const {
      'circle': Colors.blue,
      'rectangle': Colors.green,
      'heart': Colors.red,
      'triangle': Colors.purple,
    },
    this.direction = FloatingDirection.up,
    this.spawnRate = 10.0,
    this.icon,
    this.customPaintMethod,
    this.enableRotation = false,
    this.rotationSpeedMultiplier = 1.0,
    this.enablePulse = false,
    this.pulseSpeed = 2.0,
    this.pulseAmplitude = 0.3,
  });

  @override
  FloatingAnimationState createState() => FloatingAnimationState();
}

class FloatingAnimationState extends State<FloatingAnimation>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<List<Shape>> _shapes = ValueNotifier<List<Shape>>([]);
  late AnimationController _animationController;
  final Random _random = Random();
  DateTime _lastUpdateTime = DateTime.now();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..addListener(_updateShapes);

    _animationController.repeat();
    _generateShape();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    _shapes.dispose();
    super.dispose();
  }

  /// Generates a new shape (with optional rotation and pulsing properties)
  /// and adds it to the list if the maximum number hasn't been reached.
  void _generateShape() {
    if (_isDisposed) return;

    if (_shapes.value.length < widget.maxShapes) {
      double depth = _random.nextDouble(); // Determines z-ordering.
      double speed = (0.2 - (0.15 * depth)) * widget.speedMultiplier;
      double opacity = 0.8 - (0.5 * depth);
      double baseRadius = _random.nextDouble() * 20 + 10; // Size between 10 and 30.
      double radius = baseRadius * widget.sizeMultiplier * (1 - depth * 0.5);
      // Start at bottom (for upward motion) or top (for downward motion).
      double startY = widget.direction == FloatingDirection.up ? 1.0 : -0.1;

      // Additional transformation properties.
      double rotation = widget.enableRotation ? 0.0 : 0.0;
      double angularSpeed = widget.enableRotation
          ? (_random.nextDouble() * 0.25 * widget.rotationSpeedMultiplier) -
          (0.125 * widget.rotationSpeedMultiplier)
          : 0.0;
      double pulsePhase = widget.enablePulse ? _random.nextDouble() * 2 * pi : 0.0;
      double pulseFrequency = widget.enablePulse ? widget.pulseSpeed : 0.0;

      Shape newShape = Shape(
        x: _random.nextDouble(),
        y: startY,
        radius: radius,
        speed: speed,
        opacity: opacity,
        depth: depth,
        shape: widget.selectedShape,
        icon: widget.icon,
        paintMethod: widget.customPaintMethod,
        rotation: rotation,
        angularSpeed: angularSpeed,
        pulsePhase: pulsePhase,
        pulseFrequency: pulseFrequency,
      );

      if (!_isDisposed) {
        _shapes.value = [..._shapes.value, newShape];
      }
    }

    // Determine delay between spawns (with a bit of randomness).
    double baseDelayMs = 1000.0 / widget.spawnRate;
    double randomFactor = 0.8 + _random.nextDouble() * 0.4;
    int delayMs = (baseDelayMs * randomFactor).round();

    Future.delayed(Duration(milliseconds: delayMs), _generateShape);
  }

  /// Updates the positions and transformation properties of all shapes.
  /// Also removes shapes that have moved off-screen.
  void _updateShapes() {
    if (_isDisposed) return;

    DateTime now = DateTime.now();
    double deltaTime = now.difference(_lastUpdateTime).inMilliseconds / 1000.0;
    _lastUpdateTime = now;
    if (deltaTime > 0.1) {
      deltaTime = 0.1;
    }

    List<Shape> updatedShapes = _shapes.value.map((shape) {
      double newY = widget.direction == FloatingDirection.up
          ? shape.y - shape.speed * deltaTime
          : shape.y + shape.speed * deltaTime;

      double newRotation = shape.rotation;
      if (widget.enableRotation) {
        newRotation = shape.rotation + shape.angularSpeed * deltaTime;
      }

      double newPulsePhase = shape.pulsePhase;
      double newOpacity = shape.opacity;
      if (widget.enablePulse) {
        newPulsePhase = shape.pulsePhase + shape.pulseFrequency * deltaTime;
        newOpacity = shape.baseOpacity + widget.pulseAmplitude * sin(newPulsePhase);
        newOpacity = newOpacity.clamp(0.0, 1.0);
      }

      return Shape(
        shape: shape.shape,
        x: shape.x,
        y: newY,
        radius: shape.radius,
        speed: shape.speed,
        opacity: newOpacity,
        depth: shape.depth,
        icon: shape.icon,
        paintMethod: shape.paintMethod,
        rotation: newRotation,
        angularSpeed: shape.angularSpeed,
        baseOpacity: shape.baseOpacity,
        pulsePhase: newPulsePhase,
        pulseFrequency: shape.pulseFrequency,
      );
    }).toList();

    // Remove shapes that have gone off-screen.
    if (widget.direction == FloatingDirection.up) {
      updatedShapes.removeWhere((shape) => shape.y < -0.1);
    } else {
      updatedShapes.removeWhere((shape) => shape.y > 1.1);
    }

    if (!_isDisposed) {
      _shapes.value = updatedShapes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ValueListenableBuilder<List<Shape>>(
        valueListenable: _shapes,
        builder: (context, shapes, child) {
          return CustomPaint(
            painter: ShapePainter(
              shapes: shapes,
              shapeColors: widget.shapeColors,
            ),
            child: Container(),
          );
        },
      ),
    );
  }
}
