// shape_painter.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'shape.dart';

/// A [CustomPainter] that draws a list of [Shape] instances on the canvas.
///
/// The [ShapePainter] class handles rendering different shapes based on their
/// type. It supports drawing circles, rectangles, triangles, and hearts.
/// Each shape is rendered with its specified color and opacity, adjusted based
/// on depth to manage layering.
class ShapePainter extends CustomPainter {
  /// The list of shapes to be drawn.
  final List<Shape> shapes;

  /// A map defining the color for each shape type.
  ///
  /// The key is the shape type as a string (e.g., 'circle', 'rectangle'),
  /// and the value is the corresponding [Color].
  /// If a shape type is not specified in this map, it defaults to [Colors.white].
  final Map<String, Color> shapeColors;

  /// Constructs a [ShapePainter] with the given shapes and their colors.
  ///
  /// Both [shapes] and [shapeColors] are required and must not be null.
  ShapePainter({required this.shapes, required this.shapeColors});

  /// Paints the shapes onto the given [canvas] within the provided [size].
  ///
  /// This method iterates through each shape, determines its type, and draws it
  /// accordingly. The shapes are sorted based on their [depth] to ensure proper
  /// layering, with deeper shapes drawn first.
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Sort shapes by depth to handle layering (background first)
    List<Shape> drawingShapes = List.from(shapes)
      ..sort((a, b) => a.depth.compareTo(b.depth));

    for (Shape shape in drawingShapes) {
      // Retrieve the color for the current shape type.
      // Defaults to white if the shape type is not specified.
      paint.color = (shapeColors[shape.shape] ?? Colors.white)
          .withAlpha((shape.opacity * 255).toInt());

      // Calculate the actual position based on normalized coordinates.
      final double dx = shape.x * size.width;
      final double dy = shape.y * size.height;

      switch (shape.shape.toLowerCase()) {
        case 'circle':
          _drawCircle(canvas, Offset(dx, dy), shape.radius, paint);
          break;

        case 'rectangle':
          _drawRectangle(canvas, Offset(dx, dy), shape.radius, paint);
          break;

        case 'triangle':
          _drawTriangle(canvas, Offset(dx, dy), shape.radius, paint);
          break;

        case 'heart':
          _drawHeart(canvas, Offset(dx, dy), shape.radius, paint);
          break;

        default:
          // Optionally handle unknown shapes
          break;
      }
    }
  }

  /// Draws a circle on the [canvas] at the given [center] with the specified [radius].
  ///
  /// Uses the provided [paint] to render the circle.
  void _drawCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawCircle(center, radius, paint);
  }

  /// Draws a rectangle on the [canvas] at the given [topLeft] position with the specified [size].
  ///
  /// The [size] parameter is used for both width and height, making it a square.
  /// Use different logic if you need non-square rectangles.
  void _drawRectangle(Canvas canvas, Offset topLeft, double size, Paint paint) {
    canvas.drawRect(Rect.fromLTWH(topLeft.dx, topLeft.dy, size, size), paint);
  }

  /// Draws a triangle on the [canvas] at the given [center] with the specified [size].
  ///
  /// The triangle is an equilateral triangle pointing upwards.
  void _drawTriangle(Canvas canvas, Offset center, double size, Paint paint) {
    Path path = Path();
    double height = size * sqrt(3) / 2;

    path.moveTo(center.dx, center.dy - (2 / 3) * height);
    path.lineTo(center.dx - size / 2, center.dy + (height / 3));
    path.lineTo(center.dx + size / 2, center.dy + (height / 3));
    path.close();

    canvas.drawPath(path, paint);
  }

  /// Draws a heart shape on the [canvas] at the given [center] with the specified [size].
  ///
  /// The heart is drawn using two cubic Bézier curves to form the left and right
  /// lobes of the heart.
  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    double width = size * 2.5; // Increased width for a wider heart
    double height = size * 2; // Height remains the same

    Path path = Path();
    path.moveTo(center.dx, center.dy - height * 0.3);

    // Left curve
    path.cubicTo(
      center.dx - width * 0.4, center.dy - height * 0.5, // Control point 1
      center.dx - width * 0.55, center.dy + height * 0.2, // Control point 2
      center.dx, center.dy + height * 0.5, // End point
    );

    // Right curve
    path.cubicTo(
      center.dx + width * 0.55, center.dy + height * 0.2, // Control point 1
      center.dx + width * 0.4, center.dy - height * 0.5, // Control point 2
      center.dx, center.dy - height * 0.3, // End point
    );

    path.close();

    canvas.drawPath(path, paint);
  }

  /// Determines whether the painter should repaint.
  ///
  /// Always returns `true` to repaint whenever the list of shapes changes.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
