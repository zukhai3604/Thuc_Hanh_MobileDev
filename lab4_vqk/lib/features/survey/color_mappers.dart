import 'package:flutter/material.dart';

Color lightColor(double lux) {
  final t = (lux / 1000.0).clamp(0.0, 1.0);
  return Color.lerp(Colors.grey, Colors.amber, t)!;
}

Color accelColor(double mag) {
  final t = (mag / 20.0).clamp(0.0, 1.0);
  return Color.lerp(Colors.green, Colors.red, t)!;
}

Color magneticColor(double mag) {
  final t = (mag / 150.0).clamp(0.0, 1.0);
  return Color.lerp(Colors.blueGrey, Colors.blue, t)!;
}
