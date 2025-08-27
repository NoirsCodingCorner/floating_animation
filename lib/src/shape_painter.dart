import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'shape.dart';

class ShapePainter extends CustomPainter {
  final List<Shape> shapes;
  final Map<String, Color> shapeColors;

  ShapePainter({required this.shapes, required this.shapeColors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final drawingShapes = List.of(shapes)
      ..sort((a, b) => a.depth.compareTo(b.depth));

    for (final shape in drawingShapes) {
      final shapeKey = shape.shape?.toLowerCase() ?? '';
      final baseColor = shapeColors[shapeKey] ?? Colors.white;
      paint.color = baseColor.withOpacity(shape.opacity);

      final dx = shape.x * size.width;
      final dy = shape.y * size.height;
      final center = Offset(dx, dy);

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(shape.rotation);
      canvas.translate(-center.dx, -center.dy);

      if (shape.paintMethod != null) {
        shape.paintMethod!(canvas, center, shape.radius, paint);
      } else if (shape.image != null) {
        _drawImage(canvas, center, shape.radius, shape.image!, shape.opacity);
      } else if (shape.icon != null) {
        _drawIcon(canvas, center, shape.radius, paint, shape.icon!);
      } else {
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
        }
      }

      canvas.restore();
    }
  }

  void _drawImage(Canvas canvas, Offset center, double radius, ui.Image image, double opacity) {
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final dstSize = Size.square(radius * 2);
    final dstRect = Rect.fromCenter(center: center, width: dstSize.width, height: dstSize.height);
    final srcRect = Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);

    final paint = Paint()..color = Colors.white.withOpacity(opacity);
    canvas.drawImageRect(image, srcRect, dstRect, paint);
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
    final path = Path();
    final height = size * sqrt(3) / 2;
    path.moveTo(center.dx, center.dy - (2 / 3) * height);
    path.lineTo(center.dx - size / 2, center.dy + height / 3);
    path.lineTo(center.dx + size / 2, center.dy + height / 3);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final width = size * 2.5;
    final height = size * 2;
    final path = Path();

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

    final offset = center - Offset(textPainter.width / 2, textPainter.height / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
