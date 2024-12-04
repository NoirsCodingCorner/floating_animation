import 'dart:math';

import 'package:floating_animation/shape.dart';
import 'package:floating_animation/shape_painter.dart';
import 'package:flutter/material.dart';


/// A [StatefulWidget] that manages and animates a background of floating shapes.
///
/// The [FloatingAnimation] widget continuously generates shapes that float
/// upwards across the screen. It handles the lifecycle of shapes, including
/// their creation, movement, and removal once they move off-screen.
class FloatingAnimation extends StatefulWidget {
  /// The maximum number of shapes allowed on the screen at any given time.
  final int maxShapes;

  /// A multiplier to adjust the speed of the shapes.
  final double speedMultiplier;

  /// The type of shape to generate ('circle', 'rectangle', 'triangle', 'heart', etc.).
  final String selectedShape;

  /// A map defining customizable colors for each shape type.
  ///
  /// The key is the shape type as a string, and the value is the corresponding [Color].
  /// If a shape type is not specified in this map, it defaults to [Colors.white].
  final Map<String, Color> shapeColors;

  /// Constructs a [FloatingAnimation] with the given parameters.
  ///
  /// [maxShapes], [speedMultiplier], [selectedShape], and [shapeColors] are optional
  /// and have default values if not provided.
  /// thr available shapes are 'circle', 'rectangle', 'triangle', and 'heart'.
  const FloatingAnimation({
    Key? key,
    this.maxShapes = 50,
    this.speedMultiplier = 1.0,
    this.selectedShape = 'circle',
    this.shapeColors = const {
      'circle': Colors.blue,
      'rectangle': Colors.green,
      'heart': Colors.red,
      'triangle': Colors.purple,
    }, // Default colors
  }) : super(key: key);

  @override
  _FloatingAnimationState createState() => _FloatingAnimationState();
}

class _FloatingAnimationState extends State<FloatingAnimation>
    with SingleTickerProviderStateMixin {
  /// A [ValueNotifier] that holds the current list of shapes.
  final ValueNotifier<List<Shape>> _shapes = ValueNotifier<List<Shape>>([]);

  /// The [AnimationController] that drives the shape animations.
  late AnimationController _animationController;

  /// A [Random] instance for generating random properties of shapes.
  final Random _random = Random();

  /// Tracks the last update time to calculate delta time for animations.
  DateTime _lastUpdateTime = DateTime.now();

  /// Indicates whether the widget has been disposed to prevent further updates.
  bool _isDisposed = false;

  /// Initializes the animation controller and starts generating shapes.
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

  /// Disposes the animation controller and notifier to free resources.
  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    _shapes.dispose();
    super.dispose();
  }

  /// Generates a new shape and adds it to the list if the maximum is not reached.
  ///
  /// This method schedules itself to run again after a random delay, creating
  /// a continuous stream of shapes being added.
  void _generateShape() {
    if (_isDisposed) return;

    if (_shapes.value.length < widget.maxShapes) {
      double depth = _random.nextDouble(); // Determines z-ordering
      double speed = (0.2 - (0.15 * depth)) * widget.speedMultiplier;
      double opacity = 0.8 - (0.5 * depth);
      double radius = (_random.nextDouble() * 20 + 10) * (1 - depth * 0.5);

      Shape newShape = Shape(
        x: _random.nextDouble(),
        y: 1.0, // Start at the bottom (normalized)
        radius: radius,
        speed: speed,
        opacity: opacity,
        depth: depth,
        shape: widget.selectedShape,
      );

      if (!_isDisposed) {
        _shapes.value = [..._shapes.value, newShape];
      }
    }

    // Schedule the next shape addition after a random delay
    Future.delayed(
      Duration(milliseconds: _random.nextInt(80) + 20),
      _generateShape,
    );
  }

  /// Updates the positions of all shapes based on their speed and elapsed time.
  ///
  /// Removes shapes that have moved above the top of the screen.
  void _updateShapes() {
    if (_isDisposed) return;

    DateTime now = DateTime.now();
    double deltaTime = now.difference(_lastUpdateTime).inMilliseconds / 1000.0;
    _lastUpdateTime = now;

    if (deltaTime > 0.1) {
      deltaTime = 0.1; // Cap deltaTime to prevent large jumps
    }

    List<Shape> updatedShapes = _shapes.value.map((shape) {
      // Update the y position based on speed and deltaTime
      double newY = shape.y - shape.speed * deltaTime;

      // Optionally, update rotation or other properties here

      return Shape(
        shape: shape.shape,
        x: shape.x,
        y: newY,
        radius: shape.radius,
        speed: shape.speed,
        opacity: shape.opacity,
        depth: shape.depth,
      );
    }).toList();

    // Remove shapes that have moved above the top of the screen
    updatedShapes.removeWhere((shape) => shape.y < -0.1);

    if (!_isDisposed) {
      _shapes.value = updatedShapes;
    }
  }

  /// Builds the widget tree with a [CustomPaint] widget to render shapes.
  ///
  /// Uses a [ValueListenableBuilder] to listen to changes in the shape list
  /// and trigger repaints accordingly.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Shape>>(
      valueListenable: _shapes,
      builder: (context, shapes, child) {
        return CustomPaint(
          painter: ShapePainter(
            shapes: shapes,
            shapeColors: widget.shapeColors, // Pass the color map to the painter
          ),
          child: Container(),
        );
      },
    );
  }
}
