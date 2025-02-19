// src/shape_painter.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'shape.dart';

/// A CustomPainter that draws a list of Shape instances on the canvas.
/// It applies any rotation transformation specified on each Shape.
class ShapePainter extends CustomPainter {
  final List<Shape> shapes;
  final Map<String, Color> shapeColors;

  ShapePainter({required this.shapes, required this.shapeColors});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Sort shapes by depth (background first)
    List<Shape> drawingShapes = List.from(shapes)
      ..sort((a, b) => a.depth.compareTo(b.depth));

    for (Shape shape in drawingShapes) {
      // Get the color for this shape (defaulting to white).
      Color color = shapeColors[shape.shape ?? ''] ?? Colors.white;
      paint.color = color.withAlpha((shape.opacity * 255).toInt());

      // Calculate the actual center based on normalized coordinates.
      final double dx = shape.x * size.width;
      final double dy = shape.y * size.height;
      final Offset center = Offset(dx, dy);

      // Save canvas state, apply rotation if needed.
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(shape.rotation);
      canvas.translate(-center.dx, -center.dy);

      // Custom drawing takes precedence.
      if (shape.paintMethod != null) {
        shape.paintMethod!(canvas, center, shape.radius, paint);
      }
      // If an icon is provided, draw it.
      else if (shape.icon != null) {
        _drawIcon(canvas, center, shape.radius, paint, shape.icon!);
      }
      // Otherwise, draw the default shape.
      else {
        switch (shape.shape?.toLowerCase()) {
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
      canvas.restore();
    }
  }

  void _drawCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawCircle(center, radius, paint);
  }

  void _drawRectangle(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawRect(
      Rect.fromCenter(center: center, width: size, height: size),
      paint,
    );
  }

  void _drawTriangle(Canvas canvas, Offset center, double size, Paint paint) {
    Path path = Path();
    double height = size * sqrt(3) / 2;
    path.moveTo(center.dx, center.dy - (2 / 3) * height);
    path.lineTo(center.dx - size / 2, center.dy + (height / 3));
    path.lineTo(center.dx + size / 2, center.dy + (height / 3));
    path.close();
    canvas.drawPath(path, paint);
  }

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

  void _drawIcon(Canvas canvas, Offset center, double radius, Paint paint, IconData icon) {
    final textPainter = TextPainter(
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
    Offset iconOffset = center - Offset(textPainter.width / 2, textPainter.height / 2);
    textPainter.paint(canvas, iconOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
