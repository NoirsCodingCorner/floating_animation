/// Represents a drawable shape with various properties.
///
/// The [Shape] class encapsulates the characteristics required to render
/// different shapes such as circles, rectangles, triangles, and hearts.
/// Each shape has properties that determine its position, size, movement,
/// appearance, and rendering order based on depth.
class Shape {
  /// Normalized horizontal position (0.0 to 1.0) relative to the canvas width.
  double x;

  /// Normalized vertical position (0.0 to 1.0) relative to the canvas height.
  double y;

  /// Radius or size parameter for the shape.
  /// For circles, it represents the radius.
  /// For rectangles and other shapes, it can denote width, height, or other dimensions.
  double radius;

  /// Normalized speed at which the shape moves upwards (units per second).
  double speed;

  /// Opacity of the shape (0.0 fully transparent to 1.0 fully opaque).
  double opacity;

  /// Depth of the shape determining its rendering order.
  /// 0.0 represents the foreground, and 1.0 represents the background.
  double depth;

  /// Type of the shape (e.g., 'circle', 'rectangle', 'triangle', 'heart').
  String shape;

  /// Constructs a [Shape] with the given properties.
  ///
  /// All properties are required and must be provided during instantiation.
  Shape({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
    required this.depth,
    required this.shape,
  });
}