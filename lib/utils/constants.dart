// Utils: Constants
import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // Grid
  static const int maxGridSize = 15;
  static const int minGridSize = 5;

  // Animation durations
  static const Duration cellHighlightDuration = Duration(milliseconds: 100);
  static const Duration foundWordAnimDuration = Duration(milliseconds: 400);
  static const Duration screenTransitionDuration = Duration(milliseconds: 350);
  static const Duration timerWarningThreshold = Duration(seconds: 15);

  // UI sizing
  static const double minCellSize = 28.0;
  static const double maxCellSize = 52.0;
  static const double gridPadding = 12.0;
  static const double wordListMaxHeight = 200.0;

  // SharedPreferences keys
  static const String prefCurrentLevel = 'current_level';
  static const String prefHighestLevel = 'highest_level';
  static const String prefBestTimes = 'best_times';
  static const String prefSoundEnabled = 'sound_enabled';
  static const String prefDarkMode = 'dark_mode';

  // Found word highlight colors (vibrant palette)
  static const List<Color> wordColors = [
    Color(0xFF6C63FF), // violet
    Color(0xFF00C9A7), // teal
    Color(0xFFFF6B6B), // coral
    Color(0xFFFFBE0B), // amber
    Color(0xFF06D6A0), // emerald
    Color(0xFFFF9E00), // orange
    Color(0xFF8338EC), // purple
    Color(0xFF3A86FF), // blue
    Color(0xFFFF006E), // pink
    Color(0xFF43AA8B), // green-teal
    Color(0xFFFF595E), // red
    Color(0xFF1982C4), // steel blue
    Color(0xFF6A994E), // olive green
    Color(0xFFF15BB5), // hot pink
    Color(0xFF9B5DE5), // lavender
    Color(0xFF00BBF9), // sky blue
    Color(0xFFF8961E), // saffron
    Color(0xFF90BE6D), // light green
    Color(0xFFF3722C), // deep orange
    Color(0xFF577590), // slate
  ];
}
