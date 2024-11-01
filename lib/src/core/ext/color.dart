import 'package:flutter/material.dart';

const _interactiveStates = <WidgetState>{
  WidgetState.pressed,
  WidgetState.hovered,
  WidgetState.focused,
  WidgetState.selected
};

extension ColorX on Color {
  /// Returns the color hex like `#FF112233`.
  String get toHex {
    final alphaStr = alpha.toRadixString(16).padLeft(2, '0');
    final redStr = red.toRadixString(16).padLeft(2, '0');
    final greenStr = green.toRadixString(16).padLeft(2, '0');
    final blueStr = blue.toRadixString(16).padLeft(2, '0');
    return '#$alphaStr$redStr$greenStr$blueStr';
  }

  /// Whether this color is bright.
  bool get isBrightColor => estimateBrightness == Brightness.light;

  /// Plus the [val] to each channel.
  Color operator +(int val) {
    final r = (red + val).clamp(0, 255);
    final g = (green + val).clamp(0, 255);
    final b = (blue + val).clamp(0, 255);
    return Color.fromARGB(alpha, r, g, b);
  }

  /// Subtract [val] from each channel.
  Color operator -(int val) {
    final r = (red - val).clamp(0, 255);
    final g = (green - val).clamp(0, 255);
    final b = (blue - val).clamp(0, 255);
    return Color.fromARGB(alpha, r, g, b);
  }

  /// Get the brightness of the color.
  Brightness get estimateBrightness =>
      ThemeData.estimateBrightnessForColor(this);

  /// Get the [WidgetStateProperty] of the color.
  WidgetStateProperty<Color?> get materialStateColor {
    return WidgetStateProperty.resolveWith((states) {
      if (states.any(_interactiveStates.contains)) {
        return this;
      }
      return null;
    });
  }

  /// Get the [MaterialColor] of the color.
  MaterialColor get materialColor => MaterialColor(
        value,
        {
          50: withOpacity(0.05),
          100: withOpacity(0.1),
          200: withOpacity(0.2),
          300: withOpacity(0.3),
          400: withOpacity(0.4),
          500: withOpacity(0.5),
          600: withOpacity(0.6),
          700: withOpacity(0.7),
          800: withOpacity(0.8),
          900: withOpacity(0.9),
        },
      );
}
