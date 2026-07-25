// Utils: Extensions
import 'package:flutter/material.dart';

extension StringExt on String {
  String get reversed => split('').reversed.join();
}

extension ColorExt on Color {
  Color withOpacityFactor(double factor) =>
      withValues(alpha: (a * factor).clamp(0.0, 1.0));
}

extension DurationExt on int {
  String toTimerString() {
    final m = this ~/ 60;
    final s = this % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
