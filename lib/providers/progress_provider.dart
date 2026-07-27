// Providers: ProgressProvider — persistent level progress via shared_preferences
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ProgressProvider extends ChangeNotifier {
  // Word Search Section
  int _highestUnlockedLevel = 1;
  Map<int, int> _bestTimes = {}; // level → best time remaining
  int _totalStars = 0;

  // Jumbled Words Section
  int _jumbledHighestUnlockedLevel = 1;
  Map<int, int> _jumbledBestTimes = {};
  int _jumbledTotalStars = 0;

  // General Settings
  String _languageCode = 'en';
  bool _soundEnabled = true;
  bool _darkMode = false;

  // Getters - Word Search
  int get highestUnlockedLevel => _highestUnlockedLevel;
  Map<int, int> get bestTimes => Map.unmodifiable(_bestTimes);
  int get totalStars => _totalStars;

  // Getters - Jumbled Words
  int get jumbledHighestUnlockedLevel => _jumbledHighestUnlockedLevel;
  Map<int, int> get jumbledBestTimes => Map.unmodifiable(_jumbledBestTimes);
  int get jumbledTotalStars => _jumbledTotalStars;

  // Getters - Settings
  String get languageCode => _languageCode;
  bool get soundEnabled => _soundEnabled;
  bool get darkMode => _darkMode;

  bool isLevelUnlocked(int level) => level <= _highestUnlockedLevel;
  int? bestTimeForLevel(int level) => _bestTimes[level];

  bool isJumbledLevelUnlocked(int level) => level <= _jumbledHighestUnlockedLevel;
  int? jumbledBestTimeForLevel(int level) => _jumbledBestTimes[level];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // Word Search
    _highestUnlockedLevel = prefs.getInt(AppConstants.prefHighestLevel) ?? 1;
    _totalStars = prefs.getInt(AppConstants.prefTotalStars) ?? 0;

    final bestTimesJson = prefs.getString(AppConstants.prefBestTimes);
    if (bestTimesJson != null) {
      final decoded = jsonDecode(bestTimesJson) as Map<String, dynamic>;
      _bestTimes = decoded.map((k, v) => MapEntry(int.parse(k), v as int));
    }

    // Jumbled Words
    _jumbledHighestUnlockedLevel =
        prefs.getInt(AppConstants.prefJumbledHighestLevel) ?? 1;
    _jumbledTotalStars =
        prefs.getInt(AppConstants.prefJumbledTotalStars) ?? 0;

    final jumbledBestJson = prefs.getString(AppConstants.prefJumbledBestTimes);
    if (jumbledBestJson != null) {
      final decoded = jsonDecode(jumbledBestJson) as Map<String, dynamic>;
      _jumbledBestTimes =
          decoded.map((k, v) => MapEntry(int.parse(k), v as int));
    }

    // Settings
    _languageCode = prefs.getString(AppConstants.prefLanguage) ?? 'en';
    _soundEnabled = prefs.getBool(AppConstants.prefSoundEnabled) ?? true;
    _darkMode = prefs.getBool(AppConstants.prefDarkMode) ?? false;

    notifyListeners();
  }

  /// Called when a user completes a Word Search level.
  Future<void> completeLevel(int level, int timeRemaining) async {
    if (level >= _highestUnlockedLevel) {
      _highestUnlockedLevel = level + 1;
    }

    final existing = _bestTimes[level];
    if (existing == null || timeRemaining > existing) {
      _bestTimes[level] = timeRemaining;
    }

    _totalStars += timeRemaining;

    await _persist();
    notifyListeners();
  }

  /// Called when a user fails a Word Search level.
  Future<void> failLevel(int level, int timeLimit) async {
    _totalStars = (_totalStars - timeLimit).clamp(0, 9999999);
    await _persist();
    notifyListeners();
  }

  /// Called when a user completes a Jumbled Words level.
  Future<void> completeJumbledLevel(int level, int timeRemaining) async {
    if (level >= _jumbledHighestUnlockedLevel) {
      _jumbledHighestUnlockedLevel = level + 1;
    }

    final existing = _jumbledBestTimes[level];
    if (existing == null || timeRemaining > existing) {
      _jumbledBestTimes[level] = timeRemaining;
    }

    _jumbledTotalStars += timeRemaining;

    await _persist();
    notifyListeners();
  }

  /// Called when a user fails a Jumbled Words level.
  Future<void> failJumbledLevel(int level, int timeLimit) async {
    _jumbledTotalStars = (_jumbledTotalStars - timeLimit).clamp(0, 9999999);
    await _persist();
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _languageCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefLanguage, code);
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

    _jumbledHighestUnlockedLevel = 1;
    _jumbledBestTimes = {};
    _jumbledTotalStars = 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefHighestLevel);
    await prefs.remove(AppConstants.prefBestTimes);
    await prefs.remove(AppConstants.prefTotalStars);

    await prefs.remove(AppConstants.prefJumbledHighestLevel);
    await prefs.remove(AppConstants.prefJumbledBestTimes);
    await prefs.remove(AppConstants.prefJumbledTotalStars);

    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();

    // Word Search
    await prefs.setInt(AppConstants.prefHighestLevel, _highestUnlockedLevel);
    await prefs.setInt(AppConstants.prefTotalStars, _totalStars);
    final encodedBest = jsonEncode(
      _bestTimes.map((k, v) => MapEntry(k.toString(), v)),
    );
    await prefs.setString(AppConstants.prefBestTimes, encodedBest);

    // Jumbled Words
    await prefs.setInt(
        AppConstants.prefJumbledHighestLevel, _jumbledHighestUnlockedLevel);
    await prefs.setInt(
        AppConstants.prefJumbledTotalStars, _jumbledTotalStars);
    final encodedJumbledBest = jsonEncode(
      _jumbledBestTimes.map((k, v) => MapEntry(k.toString(), v)),
    );
    await prefs.setString(AppConstants.prefJumbledBestTimes, encodedJumbledBest);

    // Settings
    await prefs.setString(AppConstants.prefLanguage, _languageCode);
  }
}
