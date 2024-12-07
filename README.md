# Flutter Shape Background

A customizable Flutter package for creating animated and dynamic floating shapes as a background. Supports various shapes like circles, rectangles, triangles, and hearts with configurable properties like color, size, speed, and opacity.

This widget also supports seamless state changes, allowing the shapes to adapt dynamically without disrupting the animation. For example, you can change the shape mid-program, and the widget will continue running smoothly with the newly selected shape.

Here are some examples of how it works:

### Circles with a background gradient:

![Floating circles](https://github.com/user-attachments/assets/fcee9416-7ca5-415a-9b24-ddcbf21486a0)

### Hearts with a background gradient:

![Floating hearts](https://github.com/user-attachments/assets/d8e30d0b-c5b5-4b39-9674-766e33ff0cd0)

---

## Features

- **Multiple Shape Types**: Circle, rectangle, triangle, heart, and more.
- **Customizable Colors**: Define unique colors for each shape type.
- **Dynamic Animations**: Shapes float upwards with customizable speed and size.
- **Layered Depth**: Shapes render in layers based on their depth value.
- **Seamless Transitions**: Change properties on-the-fly without interrupting the animation.
- **Scalable Design**: Automatically adjusts to different screen sizes.

---

## Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  floating_animation: ^1.0.1
```

Run the command to fetch the package:

```bash
flutter pub get
```

---

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:floating_animation/floating_animation.dart';

void main() {
  runApp(ShapeFloatingApp());
}

class ShapeFloatingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Floating Shapes')),
        body: FloatingAnimation(
          maxShapes: 50,
          speedMultiplier: 1.0,
          selectedShape: 'circle',
          shapeColors: {
            'circle': Colors.blue,
            'rectangle': Colors.green,
            'heart': Colors.pink,
            'triangle': Colors.purple,
          },
        ),
      ),
    );
  }
}
```

---

### Customization

#### Shape Types

You can specify the type of shapes to render using the `selectedShape` property. Supported values are:

- `circle`
- `rectangle`
- `triangle`
- `heart`

#### Colors

Use the `shapeColors` property to define custom colors for each shape type:

```dart
FloatingAnimation(
  shapeColors: {
    'circle': Colors.orange,
    'rectangle': Colors.teal,
    'heart': Colors.redAccent,
    'triangle': Colors.yellow,
  },
)
```

#### Speed and Size

- **Speed**: Adjust the `speedMultiplier` property to control the overall speed of the shapes.
- **Size**: Shape sizes are randomized within a range, scaled based on depth for a layered effect.

---

## Reference

### FloatingAnimation Properties

| Property         | Type                  | Default             | Description                                      |
|------------------|-----------------------|---------------------|--------------------------------------------------|
| `maxShapes`      | `int`                | `50`                | Maximum number of shapes on the screen.         |
| `speedMultiplier`| `double`             | `1.0`               | Adjusts the overall speed of the shapes.        |
| `selectedShape`  | `String`             | `'circle'`          | Type of shape to generate.                      |
| `shapeColors`    | `Map<String, Color>` | See example above.  | Defines colors for each shape type.             |

### Shape Properties

| Property  | Type    | Description                                   |
|-----------|---------|-----------------------------------------------|
| `x`       | `double`| Normalized horizontal position (0.0 to 1.0). |
| `y`       | `double`| Normalized vertical position (0.0 to 1.0).   |
| `radius`  | `double`| Size of the shape.                           |
| `speed`   | `double`| Speed at which the shape floats upward.      |
| `opacity` | `double`| Opacity of the shape (0.0 to 1.0).           |
| `depth`   | `double`| Depth of the shape (0.0 to 1.0).             |
| `shape`   | `String`| Type of the shape (e.g., 'circle').          |

---

## Example Use Cases

- Floating bubbles in a background.
- Themed animations for holidays (e.g., hearts for Valentine's Day).
- Customizable visual effects for Flutter apps.

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## Support

If you encounter any issues or have questions, feel free to open an issue on the [GitHub repository](https://github.com/NoirsCodingCorner/floating_animation/).
