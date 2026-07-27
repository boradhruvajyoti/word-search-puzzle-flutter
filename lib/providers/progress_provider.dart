// Providers: ProgressProvider — persistent level progress via shared_preferences
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ProgressProvider extends ChangeNotifier {
  int _highestUnlockedLevel = 1;
  Map<int, int> _bestTimes = {}; // level → best time remaining
  int _totalStars = 0;
  bool _soundEnabled = true;
  bool _darkMode = false;

  int get highestUnlockedLevel => _highestUnlockedLevel;
  Map<int, int> get bestTimes => Map.unmodifiable(_bestTimes);
  int get totalStars => _totalStars;
  bool get soundEnabled => _soundEnabled;
  bool get darkMode => _darkMode;

  bool isLevelUnlocked(int level) => level <= _highestUnlockedLevel;

  int? bestTimeForLevel(int level) => _bestTimes[level];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _highestUnlockedLevel =
        prefs.getInt(AppConstants.prefHighestLevel) ?? 1;
    _totalStars = prefs.getInt(AppConstants.prefTotalStars) ?? 0;
    _soundEnabled = prefs.getBool(AppConstants.prefSoundEnabled) ?? true;
    _darkMode = prefs.getBool(AppConstants.prefDarkMode) ?? false;

    final bestTimesJson = prefs.getString(AppConstants.prefBestTimes);
    if (bestTimesJson != null) {
      final decoded = jsonDecode(bestTimesJson) as Map<String, dynamic>;
      _bestTimes = decoded.map((k, v) => MapEntry(int.parse(k), v as int));
    }
    notifyListeners();
  }

  /// Called when a user completes a level.
  /// Rewards stars equal to [timeRemaining] (seconds left).
  Future<void> completeLevel(int level, int timeRemaining) async {
    // Unlock next level
    if (level >= _highestUnlockedLevel) {
      _highestUnlockedLevel = level + 1;
    }

    // Record best time
    final existing = _bestTimes[level];
    if (existing == null || timeRemaining > existing) {
      _bestTimes[level] = timeRemaining;
    }

    // Reward as many stars as seconds left
    _totalStars += timeRemaining;

    await _persist();
    notifyListeners();
  }

  /// Called when a user fails a level.
  /// Deducts stars equal to [timeLimit] (total timer time spent).
  Future<void> failLevel(int level, int timeLimit) async {
    _totalStars = (_totalStars - timeLimit).clamp(0, 9999999);
    await _persist();
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefSoundEnabled, value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefDarkMode, value);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    _highestUnlockedLevel = 1;
    _bestTimes = {};
    _totalStars = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefHighestLevel);
    await prefs.remove(AppConstants.prefBestTimes);
    await prefs.remove(AppConstants.prefTotalStars);
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefHighestLevel, _highestUnlockedLevel);
    await prefs.setInt(AppConstants.prefTotalStars, _totalStars);
    final encoded = jsonEncode(
      _bestTimes.map((k, v) => MapEntry(k.toString(), v)),
    );
    await prefs.setString(AppConstants.prefBestTimes, encoded);
  }
}
