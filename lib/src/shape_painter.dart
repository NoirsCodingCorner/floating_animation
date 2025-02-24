import 'dart:math';
import 'package:flutter/material.dart';
import 'shape.dart';

/// A [CustomPainter] that renders a list of [Shape] instances onto a canvas.
///
/// Shapes are sorted by their [Shape.depth] value (background first) and can be
/// drawn with rotation, custom drawing callbacks, or default geometric forms.
class ShapePainter extends CustomPainter {
  /// The list of shapes to draw.
  final List<Shape> shapes;

  /// A mapping of shape names to their corresponding colors.
  final Map<String, Color> shapeColors;

  /// Creates a [ShapePainter] with the given [shapes] and [shapeColors].
  ShapePainter({required this.shapes, required this.shapeColors});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Create a local copy of shapes sorted by depth (background shapes first).
    List<Shape> drawingShapes = List.of(shapes)
      ..sort((a, b) => a.depth.compareTo(b.depth));

    // Draw each shape with applied rotation and custom drawing logic.
    for (final shape in drawingShapes) {
      // Determine the shape's color, defaulting to white if not specified.
      final String shapeKey = shape.shape?.toLowerCase() ?? '';
      final Color baseColor = shapeColors[shapeKey] ?? Colors.white;
      paint.color = baseColor.withAlpha((shape.opacity * 255).toInt());

      // Convert normalized coordinates to actual canvas coordinates.
      final double dx = shape.x * size.width;
      final double dy = shape.y * size.height;
      final Offset center = Offset(dx, dy);

      // Save the current canvas state, apply rotation transformation.
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(shape.rotation);
      canvas.translate(-center.dx, -center.dy);

      // If a custom paint method is provided, it takes precedence.
      if (shape.paintMethod != null) {
        shape.paintMethod!(canvas, center, shape.radius, paint);
      }
      // If an icon is provided, draw the icon.
      else if (shape.icon != null) {
        _drawIcon(canvas, center, shape.radius, paint, shape.icon!);
      }
      // Otherwise, draw the default shape based on the type.
      else {
        switch (shapeKey) {
          case 'circle':
            _drawCircle(canvas, center, shape.radius, paint);
            break;
          case 'rectangle':
            _drawRectangle(canvas, center, shape.radius, paint);
            break;
          case 'triangle':
            _drawTriangle(canvas, center, shape.radius, paint);
            break;
          case 'heart':
            _drawHeart(canvas, center, shape.radius, paint);
            break;
          default:
            break;
        }
      }
      // Restore canvas state.
      canvas.restore();
    }
  }

  /// Draws a circle at the given [center] with the specified [radius] using [paint].
  void _drawCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawCircle(center, radius, paint);
  }

  /// Draws a square (represented as a rectangle) centered at [center] with side length [size].
  void _drawRectangle(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawRect(
      Rect.fromCenter(center: center, width: size, height: size),
      paint,
    );
  }

  /// Draws a triangle centered at [center] with a size based on [size].
  ///
  /// The triangle is equilateral with its points calculated relative to [center].
  void _drawTriangle(Canvas canvas, Offset center, double size, Paint paint) {
    Path path = Path();
    double height = size * sqrt(3) / 2;
    path.moveTo(center.dx, center.dy - (2 / 3) * height);
    path.lineTo(center.dx - size / 2, center.dy + (height / 3));
    path.lineTo(center.dx + size / 2, center.dy + (height / 3));
    path.close();
    canvas.drawPath(path, paint);
  }

  /// Draws a heart shape centered at [center] with dimensions based on [size].
  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    double width = size * 2.5;
    double height = size * 2;
    Path path = Path();
    path.moveTo(center.dx, center.dy - height * 0.3);
    path.cubicTo(
      center.dx - width * 0.4, center.dy - height * 0.5,
      center.dx - width * 0.55, center.dy + height * 0.2,
      center.dx, center.dy + height * 0.5,
    );
    path.cubicTo(
      center.dx + width * 0.55, center.dy + height * 0.2,
      center.dx + width * 0.4, center.dy - height * 0.5,
      center.dx, center.dy - height * 0.3,
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  /// Draws an [IconData] icon centered at [center] with a size proportional to [radius].
  void _drawIcon(Canvas canvas, Offset center, double radius, Paint paint, IconData icon) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          fontSize: radius * 2,
          color: paint.color,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final Offset iconOffset = center - Offset(textPainter.width / 2, textPainter.height / 2);
    textPainter.paint(canvas, iconOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Since shapes are frequently updated, always repaint.
    return true;
  }
}
