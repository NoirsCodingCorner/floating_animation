import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'shape.dart';
import 'shape_painter.dart';

enum FloatingDirection { up, down }

class FloatingAnimation extends StatefulWidget {
  final int maxShapes;
  final double speedMultiplier;
  final double sizeMultiplier;
  final String selectedShape;
  final Map<String, Color> shapeColors;
  final FloatingDirection direction;
  final double spawnRate;

  final IconData? icon;
  final ui.Image? image;
  final void Function(Canvas, Offset, double, Paint)? customPaintMethod;

  final bool enableRotation;
  final double rotationSpeedMultiplier;
  final bool enablePulse;
  final double pulseSpeed;
  final double pulseAmplitude;

  final bool useDepthOpacity;

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
    this.image,
    this.customPaintMethod,
    this.enableRotation = false,
    this.rotationSpeedMultiplier = 1.0,
    this.enablePulse = false,
    this.pulseSpeed = 2.0,
    this.pulseAmplitude = 0.3,
    this.useDepthOpacity = true,
  });

  @override
  FloatingAnimationState createState() => FloatingAnimationState();
}

class FloatingAnimationState extends State<FloatingAnimation>
    with SingleTickerProviderStateMixin {
  final _shapes = ValueNotifier<List<Shape>>([]);
  late final AnimationController _animationController;
  final _random = Random();

  bool _isDisposed = false;
  DateTime _lastUpdateTime = DateTime.now();

  // Mutable State Variables
  late double speedMultiplier;
  late double sizeMultiplier;
  late bool enableRotation;
  late double rotationSpeedMultiplier;
  late bool enablePulse;
  late double pulseSpeed;
  late double pulseAmplitude;
  late bool useDepthOpacity;

  @override
  void initState() {
    super.initState();

    // Init local mutable config
    speedMultiplier = widget.speedMultiplier;
    sizeMultiplier = widget.sizeMultiplier;
    enableRotation = widget.enableRotation;
    rotationSpeedMultiplier = widget.rotationSpeedMultiplier;
    enablePulse = widget.enablePulse;
    pulseSpeed = widget.pulseSpeed;
    pulseAmplitude = widget.pulseAmplitude;
    useDepthOpacity = widget.useDepthOpacity;

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

  void _generateShape() {
    if (_isDisposed) return;

    if (_shapes.value.length < widget.maxShapes) {
      final depth = _random.nextDouble();
      final speed = (0.2 - 0.15 * depth) * speedMultiplier;
      final opacity = useDepthOpacity ? (0.8 - 0.5 * depth) : 1.0;
      final baseRadius = _random.nextDouble() * 20 + 10;
      final radius = baseRadius * sizeMultiplier * (1 - depth * 0.5);
      final startY = widget.direction == FloatingDirection.up ? 1.0 : -0.1;

      final rotation = 0.0;
      final angularSpeed = enableRotation
          ? (_random.nextDouble() * 0.25 - 0.125) * rotationSpeedMultiplier
          : 0.0;

      final pulsePhase = enablePulse ? _random.nextDouble() * 2 * pi : 0.0;
      final pulseFrequency = enablePulse ? pulseSpeed : 0.0;

      final newShape = Shape(
        shape: widget.selectedShape,
        x: _random.nextDouble(),
        y: startY,
        radius: radius,
        speed: speed,
        opacity: opacity,
        depth: depth,
        icon: widget.icon,
        image: widget.image,
        paintMethod: widget.customPaintMethod,
        rotation: rotation,
        angularSpeed: angularSpeed,
        pulsePhase: pulsePhase,
        pulseFrequency: pulseFrequency,
      );

      _shapes.value = [..._shapes.value, newShape];
    }

    final delayMs = (1000.0 / widget.spawnRate * (0.8 + _random.nextDouble() * 0.4)).round();
    Future.delayed(Duration(milliseconds: delayMs), _generateShape);
  }

  void _updateShapes() {
    if (_isDisposed) return;

    final now = DateTime.now();
    var deltaTime = now.difference(_lastUpdateTime).inMilliseconds / 1000.0;
    deltaTime = deltaTime.clamp(0.0, 0.1);
    _lastUpdateTime = now;

    final updatedShapes = <Shape>[];
    for (final shape in _shapes.value) {
      final newY = widget.direction == FloatingDirection.up
          ? shape.y - shape.speed * deltaTime
          : shape.y + shape.speed * deltaTime;

      var newRotation = shape.rotation;
      if (enableRotation) {
        newRotation += shape.angularSpeed * deltaTime;
      }

      var newOpacity = shape.opacity;
      var newPulsePhase = shape.pulsePhase;
      if (enablePulse) {
        newPulsePhase += shape.pulseFrequency * deltaTime;
        newOpacity = (shape.baseOpacity + pulseAmplitude * sin(newPulsePhase)).clamp(0.0, 1.0);
      }

      final isVisible = (widget.direction == FloatingDirection.up && newY >= -0.1) ||
          (widget.direction == FloatingDirection.down && newY <= 1.1);

      if (isVisible) {
        updatedShapes.add(
          shape.copyWith(
            y: newY,
            rotation: newRotation,
            opacity: newOpacity,
            pulsePhase: newPulsePhase,
          ),
        );
      }
    }

    _shapes.value = updatedShapes;
  }

  // ------------------------------
  // ✅ External Control Setters:
  // ------------------------------

  void setSpeedMultiplier(double value) => setState(() => speedMultiplier = value);
  void setSizeMultiplier(double value) => setState(() => sizeMultiplier = value);
  void setEnableRotation(bool value) => setState(() => enableRotation = value);
  void setRotationSpeedMultiplier(double value) => setState(() => rotationSpeedMultiplier = value);
  void setEnablePulse(bool value) => setState(() => enablePulse = value);
  void setPulseSpeed(double value) => setState(() => pulseSpeed = value);
  void setPulseAmplitude(double value) => setState(() => pulseAmplitude = value);
  void setUseDepthOpacity(bool value) => setState(() => useDepthOpacity = value);

  // Access shapes if needed
  List<Shape> get currentShapes => _shapes.value;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ValueListenableBuilder<List<Shape>>(
        valueListenable: _shapes,
        builder: (_, shapes, __) {
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
