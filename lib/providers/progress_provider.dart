// Providers: ProgressProvider — persistent level progress via shared_preferences
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ProgressProvider extends ChangeNotifier {
  // Word Search Section
  Map<int, int> _bestTimes = {}; // level → best time remaining
  Set<int> _starUnlockedLevels = {}; // levels unlocked via stars (skip-ahead)

  // Sudoku Section
  Map<int, int> _sudokuBestTimes = {};
  Set<int> _sudokuStarUnlockedLevels = {};

  // Shared Star Economy
  int _totalStars = 0;

  // General Settings
  String _languageCode = 'en';
  bool _soundEnabled = true;
  bool _darkMode = false;

  // ── Getters — Word Search ──────────────────────────────────────────────────
  int get highestUnlockedLevel {
    int maxLvl = 1;
    for (final lvl in _starUnlockedLevels) {
      if (lvl > maxLvl) maxLvl = lvl;
    }
    for (final lvl in _bestTimes.keys) {
      if (lvl >= maxLvl) maxLvl = lvl + 1;
    }
    return maxLvl;
  }

  int get completedLevelsCount => _bestTimes.length;
  Map<int, int> get bestTimes => Map.unmodifiable(_bestTimes);

  // ── Getters — Sudoku ───────────────────────────────────────────────────────
  int get sudokuHighestUnlockedLevel {
    int maxLvl = 1;
    for (final lvl in _sudokuStarUnlockedLevels) {
      if (lvl > maxLvl) maxLvl = lvl;
    }
    for (final lvl in _sudokuBestTimes.keys) {
      if (lvl >= maxLvl) maxLvl = lvl + 1;
    }
    return maxLvl;
  }

  int get sudokuCompletedLevelsCount => _sudokuBestTimes.length;
  Map<int, int> get sudokuBestTimes => Map.unmodifiable(_sudokuBestTimes);

  // ── Getters — Shared ───────────────────────────────────────────────────────
  int get totalStars => _totalStars;

  // ── Getters — Settings ─────────────────────────────────────────────────────
  String get languageCode => _languageCode;
  bool get soundEnabled => _soundEnabled;
  bool get darkMode => _darkMode;

  // ── Level unlock checks ────────────────────────────────────────────────────
  /// True if the Word Search level is accessible (level 1 by default, star-unlocked,
  /// completed, or immediately following a completed level).
  bool isLevelUnlocked(int level) {
    if (level <= 1) return true;
    if (_starUnlockedLevels.contains(level)) return true;
    if (_bestTimes.containsKey(level)) return true;
    if (_bestTimes.containsKey(level - 1)) return true;
    return false;
  }

  int? bestTimeForLevel(int level) => _bestTimes[level];

  /// True if the Sudoku level is accessible (level 1 by default, star-unlocked,
  /// completed, or immediately following a completed level).
  bool isSudokuLevelUnlocked(int level) {
    if (level <= 1) return true;
    if (_sudokuStarUnlockedLevels.contains(level)) return true;
    if (_sudokuBestTimes.containsKey(level)) return true;
    if (_sudokuBestTimes.containsKey(level - 1)) return true;
    return false;
  }

  int? sudokuBestTimeForLevel(int level) => _sudokuBestTimes[level];

  // ── Star-unlock helpers ────────────────────────────────────────────────────
  /// Stars required to unlock [level] = level × 5.
  static int starCostToUnlock(int level) => level * 5;

  /// Whether the user has enough stars to unlock [level].
  bool canAffordUnlock(int level) => _totalStars >= starCostToUnlock(level);

  /// Spends stars to unlock a locked Word Search level.
  /// Returns false if the user cannot afford it.
  Future<bool> unlockLevelWithStars(int level) async {
    final cost = starCostToUnlock(level);
    if (_totalStars < cost) return false;
    _totalStars -= cost;
    _starUnlockedLevels.add(level);
    await _persist();
    notifyListeners();
    return true;
  }

  /// Spends stars to unlock a locked Sudoku level.
  /// Returns false if the user cannot afford it.
  Future<bool> unlockSudokuLevelWithStars(int level) async {
    final cost = starCostToUnlock(level);
    if (_totalStars < cost) return false;
    _totalStars -= cost;
    _sudokuStarUnlockedLevels.add(level);
    await _persist();
    notifyListeners();
    return true;
  }

  // ── Load / Persist ─────────────────────────────────────────────────────────
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // Shared stars
    _totalStars = prefs.getInt(AppConstants.prefTotalStars) ?? 0;

    // Word Search
    final bestTimesJson = prefs.getString(AppConstants.prefBestTimes);
    if (bestTimesJson != null) {
      final decoded = jsonDecode(bestTimesJson) as Map<String, dynamic>;
      _bestTimes = decoded.map((k, v) => MapEntry(int.parse(k), v as int));
    }
    final wsStarJson = prefs.getString(AppConstants.prefStarUnlockedLevels);
    if (wsStarJson != null) {
      final decoded = jsonDecode(wsStarJson) as List<dynamic>;
      _starUnlockedLevels = decoded.map((e) => e as int).toSet();
    }

    // Sudoku
    final sudokuBestJson = prefs.getString(AppConstants.prefSudokuBestTimes);
    if (sudokuBestJson != null) {
      final decoded = jsonDecode(sudokuBestJson) as Map<String, dynamic>;
      _sudokuBestTimes =
          decoded.map((k, v) => MapEntry(int.parse(k), v as int));
    }
    final sdkStarJson =
        prefs.getString(AppConstants.prefSudokuStarUnlockedLevels);
    if (sdkStarJson != null) {
      final decoded = jsonDecode(sdkStarJson) as List<dynamic>;
      _sudokuStarUnlockedLevels = decoded.map((e) => e as int).toSet();
    }

    // Settings
    _languageCode = prefs.getString(AppConstants.prefLanguage) ?? 'en';
    _soundEnabled = prefs.getBool(AppConstants.prefSoundEnabled) ?? true;
    _darkMode = prefs.getBool(AppConstants.prefDarkMode) ?? false;

    notifyListeners();
  }

  // ── Game outcome methods ───────────────────────────────────────────────────

  /// Called when a user completes a Word Search level.
  Future<void> completeLevel(int level, int timeRemaining) async {
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

  /// Called when a user completes a Sudoku level.
  /// Stars are added to the shared totalStars pool.
  Future<void> completeSudokuLevel(int level, int timeRemaining) async {
    final existing = _sudokuBestTimes[level];
    if (existing == null || timeRemaining > existing) {
      _sudokuBestTimes[level] = timeRemaining;
    }
    // Shared star pool — same as Word Search
    _totalStars += timeRemaining;
    await _persist();
    notifyListeners();
  }

  /// Called when a user fails a Sudoku level.
  /// Stars are deducted from the shared totalStars pool.
  Future<void> failSudokuLevel(int level, int timeLimit) async {
    _totalStars = (_totalStars - timeLimit).clamp(0, 9999999);
    await _persist();
    notifyListeners();
  }

  // ── Settings ───────────────────────────────────────────────────────────────
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
    _bestTimes = {};
    _starUnlockedLevels = {};
    _totalStars = 0;

    _sudokuBestTimes = {};
    _sudokuStarUnlockedLevels = {};

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefHighestLevel);
    await prefs.remove(AppConstants.prefBestTimes);
    await prefs.remove(AppConstants.prefTotalStars);
    await prefs.remove(AppConstants.prefStarUnlockedLevels);
    await prefs.remove(AppConstants.prefSudokuHighestLevel);
    await prefs.remove(AppConstants.prefSudokuBestTimes);
    await prefs.remove(AppConstants.prefSudokuStarUnlockedLevels);

    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();

    // Shared stars
    await prefs.setInt(AppConstants.prefTotalStars, _totalStars);

    // Word Search
    await prefs.setInt(AppConstants.prefHighestLevel, highestUnlockedLevel);
    await prefs.setString(
      AppConstants.prefBestTimes,
      jsonEncode(_bestTimes.map((k, v) => MapEntry(k.toString(), v))),
    );
    await prefs.setString(
      AppConstants.prefStarUnlockedLevels,
      jsonEncode(_starUnlockedLevels.toList()),
    );

    // Sudoku
    await prefs.setInt(
        AppConstants.prefSudokuHighestLevel, sudokuHighestUnlockedLevel);
    await prefs.setString(
      AppConstants.prefSudokuBestTimes,
      jsonEncode(_sudokuBestTimes.map((k, v) => MapEntry(k.toString(), v))),
    );
    await prefs.setString(
      AppConstants.prefSudokuStarUnlockedLevels,
      jsonEncode(_sudokuStarUnlockedLevels.toList()),
    );

    // Settings
    await prefs.setString(AppConstants.prefLanguage, _languageCode);
  }
}
