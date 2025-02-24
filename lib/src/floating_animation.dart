// floating_animation.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'shape.dart';
import 'shape_painter.dart';

/// Enum to define the direction of floating shapes.
enum FloatingDirection { up, down }

/// A [StatefulWidget] that manages and animates a background of floating shapes.
/// Shapes can be configured to optionally rotate and pulse.
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

  /// Creates a [FloatingAnimation] widget.
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

/// State class for [FloatingAnimation] that handles shape creation, updating, and painting.
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

  /// Generates a new shape with optional rotation and pulsing properties.
  ///
  /// If the current number of shapes is less than [widget.maxShapes], a new [Shape]
  /// is created and added to the animation. The method schedules itself to run again
  /// after a randomized delay based on [widget.spawnRate].
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
      double rotation = 0.0;
      double angularSpeed = widget.enableRotation
          ? (_random.nextDouble() * 0.25 * widget.rotationSpeedMultiplier) -
          (0.125 * widget.rotationSpeedMultiplier)
          : 0.0;
      double pulsePhase =
      widget.enablePulse ? _random.nextDouble() * 2 * pi : 0.0;
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
        // Create a new list instance to update the ValueNotifier.
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
  ///
  /// Each shape's vertical position, rotation, and pulsing (opacity) are updated
  /// based on the elapsed time since the last frame. Shapes that have moved off-screen
  /// are filtered out. Common widget parameters are cached locally to improve performance.
  void _updateShapes() {
    if (_isDisposed) return;

    // Cache widget parameters to reduce property lookups.
    final FloatingDirection currentDirection = widget.direction;
    final bool enableRotation = widget.enableRotation;
    final bool enablePulse = widget.enablePulse;
    final double pulseAmplitude = widget.pulseAmplitude;

    final DateTime now = DateTime.now();
    double deltaTime =
        now.difference(_lastUpdateTime).inMilliseconds / 1000.0;
    // Clamp deltaTime to avoid large jumps.
    deltaTime = deltaTime > 0.1 ? 0.1 : deltaTime;
    _lastUpdateTime = now;

    // Use a single loop to update shapes and filter out those off-screen.
    final List<Shape> updatedShapes = [];
    for (final shape in _shapes.value) {
      double newY = currentDirection == FloatingDirection.up
          ? shape.y - shape.speed * deltaTime
          : shape.y + shape.speed * deltaTime;

      double newRotation = shape.rotation;
      if (enableRotation) {
        newRotation += shape.angularSpeed * deltaTime;
      }

      double newPulsePhase = shape.pulsePhase;
      double newOpacity = shape.opacity;
      if (enablePulse) {
        newPulsePhase += shape.pulseFrequency * deltaTime;
        newOpacity =
            shape.baseOpacity + pulseAmplitude * sin(newPulsePhase);
        newOpacity = newOpacity.clamp(0.0, 1.0);
      }

      // Only add shapes that are still within the visible vertical bounds.
      if ((currentDirection == FloatingDirection.up && newY >= -0.1) ||
          (currentDirection == FloatingDirection.down && newY <= 1.1)) {
        updatedShapes.add(
          Shape(
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
          ),
        );
      }
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
