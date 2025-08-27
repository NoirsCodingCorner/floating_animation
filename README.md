

# Floating Animation Package

A customizable Flutter package for creating animated and dynamic floating shapes as a background. Supports various shapes like circles, rectangles, triangles, and hearts with configurable properties like color, size, speed, direction, spawn rate, and opacity.

This widget also supports seamless state changes, allowing the shapes to adapt dynamically without disrupting the animation. For example, you can change the shape mid-program, and the widget will continue running smoothly with the newly selected shape.
Now with **icon support** and **additional transformations** such as slow rotation and pulsing opacity!

**New in version 1.1.0:** You can now use **PNG images** (with transparency) as floating elements in addition to shapes and icons. This makes it possible to add custom graphics like snowflakes, leaves, stars, or any themed assets directly into your animations.

Here are some examples of how it works:

### Circles with a background gradient:

![Floating circles](https://github.com/user-attachments/assets/fcee9416-7ca5-415a-9b24-ddcbf21486a0)

### Hearts with a background gradient:

![Floating hearts](https://github.com/user-attachments/assets/d8e30d0b-c5b5-4b39-9674-766e33ff0cd0)

### Raining with a background gradient:

![Recording2024-12-11165702-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/5b7daad7-1b78-4526-9b0b-00d056327754)

### Icon with Transformations

![ui\_testarea2025-02-1910-47-59-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/f7c9a6c7-dcde-4015-9d3e-dcce7ae395bf)

---

## Features

* **Multiple Shape Types**: Circle, rectangle, triangle, heart, and more.
* **Icon Support**: Easily display custom icons instead of shapes.
* **PNG Image Support (NEW in 1.1.0)**: Use any transparent PNG as a floating element.
* **Customizable Colors**: Define unique colors for each shape or icon.
* **Dynamic Animations**: Shapes and icons float with customizable speed, size, and direction.
* **Layered Depth**: Shapes render in layers based on their depth value.
* **Seamless Transitions**: Change properties on-the-fly without interrupting the animation.
* **Adjustable Size**: Control the size of shapes using a size multiplier.
* **Floating Direction**: Specify the direction in which shapes float (e.g., up, down, left, right).
* **Spawn Rate Control**: Set the rate at which new shapes are spawned.
* **Additional Transformations**:

  * **Rotation**: Slowly rotate shapes or icons for extra flair.
  * **Pulsing Opacity**: Make shapes or icons gently pulse in opacity.
* **Scalable Design**: Automatically adjusts to different screen sizes.

---

## Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  floating_animation: ^1.1.0
```

Then fetch the package by running:

```bash
flutter pub get
```


---

## Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  floating_animation: ^1.0.9
```

Then fetch the package by running:

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
          sizeMultiplier: 1.0,
          selectedShape: 'circle',
          shapeColors: {
            'circle': Colors.blue,
            'rectangle': Colors.green,
            'heart': Colors.pink,
            'triangle': Colors.purple,
          },
          direction: FloatingDirection.up,
          spawnRate: 10.0,
        ),
      ),
    );
  }
}
```

---

### Icon with Transformations Example

This example demonstrates how to have an icon (a star) fall from the top of the screen with a slow rotation and pulsing opacity. You can set the icon color using the `selectedShape` key in the `shapeColors` map.

```dart
import 'package:flutter/material.dart';
import 'package:floating_animation/floating_animation.dart';

void main() {
  runApp(IconTransformationApp());
}

class IconTransformationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icon with Transformations',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Icon with Transformations'),
        ),
        body: Container(
          color: Colors.black,
          child: FloatingAnimation(
            direction: FloatingDirection.down, // Icons fall from top to bottom.
            icon: Icons.star, // The icon to animate.
            selectedShape: 'icon', // Use a key that maps to icon-specific colors.
            shapeColors: {
              'icon': Colors.orange, // Icon color
              'circle': Colors.blue,
              'rectangle': Colors.green,
              'heart': Colors.pink,
              'triangle': Colors.purple,
            },
            spawnRate: 3.0,
            maxShapes: 20,
            enableRotation: true,         // Enable slow rotation.
            rotationSpeedMultiplier: 1.0,
            enablePulse: true,            // Enable pulsing in opacity.
            pulseSpeed: 2.0,              // 2 oscillations per second.
            pulseAmplitude: 0.3,          // Adjusts the opacity oscillation.
          ),
        ),
      ),
    );
  }
}
```

---

## Customization

### Shape Types

Specify the type of shapes to render using the `selectedShape` property. Supported values include:

- `circle`
- `rectangle`
- `triangle`
- `heart`
- `icon` (when using icons)

### Colors

Define custom colors for each shape or icon using the `shapeColors` property:

```dart
FloatingAnimation(
  shapeColors: {
    'circle': Colors.orange,
    'rectangle': Colors.teal,
    'heart': Colors.redAccent,
    'triangle': Colors.yellow,
    'icon': Colors.orange, // Set icon color
  },
)
```

### Speed, Size, and Direction

- **Speed**: Adjust the overall speed with `speedMultiplier`.
- **Size**: Use `sizeMultiplier` to scale the shapes.
- **Direction**: Set the floating direction (e.g., `FloatingDirection.up`, `FloatingDirection.down`, `FloatingDirection.left`, or `FloatingDirection.right`).

```dart
FloatingAnimation(
  speedMultiplier: 1.5,
  sizeMultiplier: 0.8,
  direction: FloatingDirection.left,
)
```

### Spawn Rate

Control the frequency of new shapes with `spawnRate` (shapes per second):

```dart
FloatingAnimation(
  spawnRate: 15.0, // 15 shapes per second
)
```

### Transformations

- **Rotation**: Enable rotation with `enableRotation` and control its speed using `rotationSpeedMultiplier`.
- **Pulsing Opacity**: Enable opacity pulsing with `enablePulse`, and adjust its behavior using `pulseSpeed` and `pulseAmplitude`.

```dart
FloatingAnimation(
  enableRotation: true,
  rotationSpeedMultiplier: 1.0,
  enablePulse: true,
  pulseSpeed: 2.0,
  pulseAmplitude: 0.3,
)
```


---

### FloatingAnimation Properties

| Property                  | Type                                       | Default                  | Description                                                                   |
| ------------------------- | ------------------------------------------ | ------------------------ | ----------------------------------------------------------------------------- |
| `maxShapes`               | `int`                                      | `50`                     | Maximum number of shapes/images/icons on the screen.                          |
| `speedMultiplier`         | `double`                                   | `1.0`                    | Overall speed adjustment for shapes/images. Can also be changed at runtime.   |
| `sizeMultiplier`          | `double`                                   | `1.0`                    | Scales the size of shapes/images. Can also be changed at runtime.             |
| `selectedShape`           | `String`                                   | `'circle'`               | Type of the shape (e.g., `'circle'`, `'rectangle'`, `'heart'`, `'triangle'`). |
| `shapeColors`             | `Map<String, Color>`                       | See example above        | Defines colors for shape types or icons.                                      |
| `direction`               | `FloatingDirection` (`up`/`down`)          | `FloatingDirection.up`   | Direction in which shapes float.                                              |
| `spawnRate`               | `double`                                   | `10.0` shapes per second | Frequency at which new shapes are spawned.                                    |
| `icon`                    | `IconData?`                                | `null`                   | Icon to display (overrides shape if provided).                                |
| `image`                   | `ui.Image?`                                | `null`                   | PNG image to display (supports transparency, new in `1.1.0`).                 |
| `customPaintMethod`       | `Function(Canvas, Offset, double, Paint)?` | `null`                   | Custom drawing callback for advanced control.                                 |
| `enableRotation`          | `bool`                                     | `false`                  | Enables slow rotation transformation. Can be changed at runtime.              |
| `rotationSpeedMultiplier` | `double`                                   | `1.0`                    | Adjusts rotation speed of shapes/icons/images. Can be changed at runtime.     |
| `enablePulse`             | `bool`                                     | `false`                  | Enables pulsing opacity effect. Can be changed at runtime.                    |
| `pulseSpeed`              | `double`                                   | `2.0`                    | Speed of opacity pulsing oscillations. Can be changed at runtime.             |
| `pulseAmplitude`          | `double`                                   | `0.3`                    | Magnitude of opacity pulsing. Can be changed at runtime.                      |
| `useDepthOpacity`         | `bool`                                     | `true`                   | Whether opacity decreases with depth. Can be changed at runtime.              |

---


## Example Use Cases

- Floating bubbles as a background.
- Themed animations for holidays (e.g., hearts for Valentine's Day).
- Customizable visual effects for Flutter apps.
- **Dynamic Icons with Transformations**: Use icons with smooth rotation and pulsing opacity to add extra visual appeal.

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

---

