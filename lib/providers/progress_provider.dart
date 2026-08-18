// Providers: ProgressProvider — persistent level progress via shared_preferences
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ProgressProvider extends ChangeNotifier {
  static const int maxFreeAttempts = 2;

  // Word Search Section
  Map<int, int> _bestTimes = {}; // level → best time remaining
  Set<int> _starUnlockedLevels = {}; // levels unlocked via stars (skip-ahead)
  Map<int, int> _failedAttempts = {}; // level → count of failed attempts (2 free attempts allowed)

  // Sudoku Section
  Map<int, int> _sudokuBestTimes = {};
  Set<int> _sudokuStarUnlockedLevels = {};
  Map<int, int> _sudokuFailedAttempts = {};

  // Cryptogram Section
  Map<int, int> _cryptogramBestTimes = {};
  Set<int> _cryptogramStarUnlockedLevels = {};
  Map<int, int> _cryptogramFailedAttempts = {};

  // Quadsum Section
  Map<int, int> _quadsumBestTimes = {};
  Set<int> _quadsumStarUnlockedLevels = {};
  Map<int, int> _quadsumFailedAttempts = {};

  // Per-Game Star Economies
  int _wordSearchStars = 0;
  int _sudokuStars = 0;
  int _cryptogramStars = 0;
  int _quadsumStars = 0;

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
  int get wordSearchStars => _wordSearchStars;

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
  int get sudokuStars => _sudokuStars;

  // ── Getters — Cryptogram ───────────────────────────────────────────────────
  int get cryptogramHighestUnlockedLevel {
    int maxLvl = 1;
    for (final lvl in _cryptogramStarUnlockedLevels) {
      if (lvl > maxLvl) maxLvl = lvl;
    }
    for (final lvl in _cryptogramBestTimes.keys) {
      if (lvl >= maxLvl) maxLvl = lvl + 1;
    }
    return maxLvl;
  }

  int get cryptogramCompletedLevelsCount => _cryptogramBestTimes.length;
  Map<int, int> get cryptogramBestTimes => Map.unmodifiable(_cryptogramBestTimes);
  int get cryptogramStars => _cryptogramStars;

  // ── Getters — Quadsum ──────────────────────────────────────────────────────
  int get quadsumHighestUnlockedLevel {
    int maxLvl = 1;
    for (final lvl in _quadsumStarUnlockedLevels) {
      if (lvl > maxLvl) maxLvl = lvl;
    }
    for (final lvl in _quadsumBestTimes.keys) {
      if (lvl >= maxLvl) maxLvl = lvl + 1;
    }
    return maxLvl;
  }

  int get quadsumCompletedLevelsCount => _quadsumBestTimes.length;
  Map<int, int> get quadsumBestTimes => Map.unmodifiable(_quadsumBestTimes);
  int get quadsumStars => _quadsumStars;

  // ── Getters — Shared / Total ───────────────────────────────────────────────
  int get totalStars =>
      _wordSearchStars + _sudokuStars + _cryptogramStars + _quadsumStars;

  // ── Getters — Settings ─────────────────────────────────────────────────────
  String get languageCode => _languageCode;
  bool get soundEnabled => _soundEnabled;
  bool get darkMode => _darkMode;

  // ── Level unlock checks ────────────────────────────────────────────────────
  /// True if the Word Search level is accessible.
  bool isLevelUnlocked(int level) {
    if (level <= 1) return true;
    if (_starUnlockedLevels.contains(level)) return true;
    if (_bestTimes.containsKey(level)) return true;
    if (_bestTimes.containsKey(level - 1)) return true;
    return false;
  }

  int? bestTimeForLevel(int level) => _bestTimes[level];

  /// Remaining free attempts on this Word Search level (out of 2).
  int remainingFreeAttempts(int level) =>
      (maxFreeAttempts - (_failedAttempts[level] ?? 0)).clamp(0, maxFreeAttempts);

  /// True if the player used all 2 free attempts on this Word Search level and must watch a rewarded ad.
  bool isRetryAdRequired(int level) =>
      (_failedAttempts[level] ?? 0) >= maxFreeAttempts;

  /// True if the Sudoku level is accessible.
  bool isSudokuLevelUnlocked(int level) {
    if (level <= 1) return true;
    if (_sudokuStarUnlockedLevels.contains(level)) return true;
    if (_sudokuBestTimes.containsKey(level)) return true;
    if (_sudokuBestTimes.containsKey(level - 1)) return true;
    return false;
  }

  int? sudokuBestTimeForLevel(int level) => _sudokuBestTimes[level];

  /// Remaining free attempts on this Sudoku level (out of 2).
  int sudokuRemainingFreeAttempts(int level) =>
      (maxFreeAttempts - (_sudokuFailedAttempts[level] ?? 0)).clamp(0, maxFreeAttempts);

  /// True if the player used all 2 free attempts on this Sudoku level and must watch a rewarded ad.
  bool isSudokuRetryAdRequired(int level) =>
      (_sudokuFailedAttempts[level] ?? 0) >= maxFreeAttempts;

  /// True if the Cryptogram level is accessible.
  bool isCryptogramLevelUnlocked(int level) {
    if (level <= 1) return true;
    if (_cryptogramStarUnlockedLevels.contains(level)) return true;
    if (_cryptogramBestTimes.containsKey(level)) return true;
    if (_cryptogramBestTimes.containsKey(level - 1)) return true;
    return false;
  }

  int? cryptogramBestTimeForLevel(int level) => _cryptogramBestTimes[level];

  /// Remaining free attempts on this Cryptogram level (out of 2).
  int cryptogramRemainingFreeAttempts(int level) =>
      (maxFreeAttempts - (_cryptogramFailedAttempts[level] ?? 0)).clamp(0, maxFreeAttempts);

  /// True if the player used all 2 free attempts on this Cryptogram level and must watch a rewarded ad.
  bool isCryptogramRetryAdRequired(int level) =>
      (_cryptogramFailedAttempts[level] ?? 0) >= maxFreeAttempts;

  /// True if the Quadsum level is accessible.
  bool isQuadsumLevelUnlocked(int level) {
    if (level <= 1) return true;
    if (_quadsumStarUnlockedLevels.contains(level)) return true;
    if (_quadsumBestTimes.containsKey(level)) return true;
    if (_quadsumBestTimes.containsKey(level - 1)) return true;
    return false;
  }

  int? quadsumBestTimeForLevel(int level) => _quadsumBestTimes[level];

  /// Remaining free attempts on this Quadsum level (out of 2).
  int quadsumRemainingFreeAttempts(int level) =>
      (maxFreeAttempts - (_quadsumFailedAttempts[level] ?? 0)).clamp(0, maxFreeAttempts);

  /// True if the player used all 2 free attempts on this Quadsum level and must watch a rewarded ad.
  bool isQuadsumRetryAdRequired(int level) =>
      (_quadsumFailedAttempts[level] ?? 0) >= maxFreeAttempts;

  // ── Star-unlock helpers ────────────────────────────────────────────────────
  /// Stars required to unlock [level] = level × 5.
  static int starCostToUnlock(int level) => level * 5;

  /// Whether the user has enough Word Search stars to unlock [level].
  bool canAffordUnlock(int level) => _wordSearchStars >= starCostToUnlock(level);

  /// Spends Word Search stars to unlock a locked Word Search level.
  Future<bool> unlockLevelWithStars(int level) async {
    final cost = starCostToUnlock(level);
    if (_wordSearchStars < cost) return false;
    _wordSearchStars -= cost;
    _starUnlockedLevels.add(level);
    await _persist();
    notifyListeners();
    return true;
  }

  /// Whether the user has enough Sudoku stars to unlock [level].
  bool canAffordSudokuUnlock(int level) =>
      _sudokuStars >= starCostToUnlock(level);

  /// Spends Sudoku stars to unlock a locked Sudoku level.
  Future<bool> unlockSudokuLevelWithStars(int level) async {
    final cost = starCostToUnlock(level);
    if (_sudokuStars < cost) return false;
    _sudokuStars -= cost;
    _sudokuStarUnlockedLevels.add(level);
    await _persist();
    notifyListeners();
    return true;
  }

  /// Whether the user has enough Cryptogram stars to unlock [level].
  bool canAffordCryptogramUnlock(int level) =>
      _cryptogramStars >= starCostToUnlock(level);

  /// Spends Cryptogram stars to unlock a locked Cryptogram level.
  Future<bool> unlockCryptogramLevelWithStars(int level) async {
    final cost = starCostToUnlock(level);
    if (_cryptogramStars < cost) return false;
    _cryptogramStars -= cost;
    _cryptogramStarUnlockedLevels.add(level);
    await _persist();
    notifyListeners();
    return true;
  }

  /// Whether the user has enough Quadsum stars to unlock [level].
  bool canAffordQuadsumUnlock(int level) =>
      _quadsumStars >= starCostToUnlock(level);

  /// Spends Quadsum stars to unlock a locked Quadsum level.
  Future<bool> unlockQuadsumLevelWithStars(int level) async {
    final cost = starCostToUnlock(level);
    if (_quadsumStars < cost) return false;
    _quadsumStars -= cost;
    _quadsumStarUnlockedLevels.add(level);
    await _persist();
    notifyListeners();
    return true;
  }

  // ── Load / Persist ─────────────────────────────────────────────────────────
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // Stars per game (with fallback to total_stars for existing word search progress)
    _wordSearchStars = prefs.getInt(AppConstants.prefWordSearchStars) ??
        prefs.getInt(AppConstants.prefTotalStars) ??
        0;
    _sudokuStars = prefs.getInt(AppConstants.prefSudokuStars) ?? 0;
    _cryptogramStars = prefs.getInt(AppConstants.prefCryptogramStars) ?? 0;
    _quadsumStars = prefs.getInt(AppConstants.prefQuadsumStars) ?? 0;

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
    final retryAdJson = prefs.getString(AppConstants.prefRetryAdLevels);
    if (retryAdJson != null) {
      try {
        final decoded = jsonDecode(retryAdJson);
        if (decoded is Map<String, dynamic>) {
          _failedAttempts = decoded.map((k, v) => MapEntry(int.parse(k), v as int));
        } else if (decoded is List<dynamic>) {
          _failedAttempts = {for (final e in decoded) e as int: maxFreeAttempts};
        }
      } catch (_) {}
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
    final sdkRetryAdJson = prefs.getString(AppConstants.prefSudokuRetryAdLevels);
    if (sdkRetryAdJson != null) {
      try {
        final decoded = jsonDecode(sdkRetryAdJson);
        if (decoded is Map<String, dynamic>) {
          _sudokuFailedAttempts = decoded.map((k, v) => MapEntry(int.parse(k), v as int));
        } else if (decoded is List<dynamic>) {
          _sudokuFailedAttempts = {for (final e in decoded) e as int: maxFreeAttempts};
        }
      } catch (_) {}
    }

    // Cryptogram
    final cryptoBestJson = prefs.getString(AppConstants.prefCryptogramBestTimes);
    if (cryptoBestJson != null) {
      final decoded = jsonDecode(cryptoBestJson) as Map<String, dynamic>;
      _cryptogramBestTimes =
          decoded.map((k, v) => MapEntry(int.parse(k), v as int));
    }
    final cryptoStarJson =
        prefs.getString(AppConstants.prefCryptogramStarUnlockedLevels);
    if (cryptoStarJson != null) {
      final decoded = jsonDecode(cryptoStarJson) as List<dynamic>;
      _cryptogramStarUnlockedLevels = decoded.map((e) => e as int).toSet();
    }
    final cryptoRetryAdJson =
        prefs.getString(AppConstants.prefCryptogramRetryAdLevels);
    if (cryptoRetryAdJson != null) {
      try {
        final decoded = jsonDecode(cryptoRetryAdJson);
        if (decoded is Map<String, dynamic>) {
          _cryptogramFailedAttempts = decoded.map((k, v) => MapEntry(int.parse(k), v as int));
        } else if (decoded is List<dynamic>) {
          _cryptogramFailedAttempts = {for (final e in decoded) e as int: maxFreeAttempts};
        }
      } catch (_) {}
    }

    // Quadsum
    final quadBestJson = prefs.getString(AppConstants.prefQuadsumBestTimes);
    if (quadBestJson != null) {
      final decoded = jsonDecode(quadBestJson) as Map<String, dynamic>;
      _quadsumBestTimes =
          decoded.map((k, v) => MapEntry(int.parse(k), v as int));
    }
    final quadStarJson =
        prefs.getString(AppConstants.prefQuadsumStarUnlockedLevels);
    if (quadStarJson != null) {
      final decoded = jsonDecode(quadStarJson) as List<dynamic>;
      _quadsumStarUnlockedLevels = decoded.map((e) => e as int).toSet();
    }
    final quadRetryAdJson =
        prefs.getString(AppConstants.prefQuadsumRetryAdLevels);
    if (quadRetryAdJson != null) {
      try {
        final decoded = jsonDecode(quadRetryAdJson);
        if (decoded is Map<String, dynamic>) {
          _quadsumFailedAttempts = decoded.map((k, v) => MapEntry(int.parse(k), v as int));
        } else if (decoded is List<dynamic>) {
          _quadsumFailedAttempts = {for (final e in decoded) e as int: maxFreeAttempts};
        }
      } catch (_) {}
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
    _wordSearchStars += timeRemaining;
    _failedAttempts.remove(level);
    await _persist();
    notifyListeners();
  }

  /// Called when a user fails a Word Search level.
  Future<void> failLevel(int level, int timeLimit) async {
    _wordSearchStars = (_wordSearchStars - timeLimit).clamp(0, 9999999);
    _failedAttempts[level] = (_failedAttempts[level] ?? 0) + 1;
    await _persist();
    notifyListeners();
  }

  /// Called when a user completes a Sudoku level.
  Future<void> completeSudokuLevel(int level, int timeRemaining) async {
    final existing = _sudokuBestTimes[level];
    if (existing == null || timeRemaining > existing) {
      _sudokuBestTimes[level] = timeRemaining;
    }
    _sudokuStars += timeRemaining;
    _sudokuFailedAttempts.remove(level);
    await _persist();
    notifyListeners();
  }

  /// Called when a user fails a Sudoku level.
  Future<void> failSudokuLevel(int level, int timeLimit) async {
    _sudokuStars = (_sudokuStars - timeLimit).clamp(0, 9999999);
    _sudokuFailedAttempts[level] = (_sudokuFailedAttempts[level] ?? 0) + 1;
    await _persist();
    notifyListeners();
  }

  /// Called when a user completes a Cryptogram level.
  Future<void> completeCryptogramLevel(int level, int timeRemaining) async {
    final existing = _cryptogramBestTimes[level];
    if (existing == null || timeRemaining > existing) {
      _cryptogramBestTimes[level] = timeRemaining;
    }
    _cryptogramStars += timeRemaining;
    _cryptogramFailedAttempts.remove(level);
    await _persist();
    notifyListeners();
  }

  /// Called when a user fails a Cryptogram level.
  Future<void> failCryptogramLevel(int level, int timeLimit) async {
    _cryptogramStars = (_cryptogramStars - timeLimit).clamp(0, 9999999);
    _cryptogramFailedAttempts[level] = (_cryptogramFailedAttempts[level] ?? 0) + 1;
    await _persist();
    notifyListeners();
  }

  /// Called when a user completes a Quadsum level.
  Future<void> completeQuadsumLevel(int level, int timeRemaining) async {
    final existing = _quadsumBestTimes[level];
    if (existing == null || timeRemaining > existing) {
      _quadsumBestTimes[level] = timeRemaining;
    }
    _quadsumStars += timeRemaining;
    _quadsumFailedAttempts.remove(level);
    await _persist();
    notifyListeners();
  }

  /// Called when a user fails a Quadsum level.
  Future<void> failQuadsumLevel(int level, int timeLimit) async {
    _quadsumStars = (_quadsumStars - timeLimit).clamp(0, 9999999);
    _quadsumFailedAttempts[level] = (_quadsumFailedAttempts[level] ?? 0) + 1;
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
    _failedAttempts = {};
    _wordSearchStars = 0;

    _sudokuBestTimes = {};
    _sudokuStarUnlockedLevels = {};
    _sudokuFailedAttempts = {};
    _sudokuStars = 0;

    _cryptogramBestTimes = {};
    _cryptogramStarUnlockedLevels = {};
    _cryptogramFailedAttempts = {};
    _cryptogramStars = 0;

    _quadsumBestTimes = {};
    _quadsumStarUnlockedLevels = {};
    _quadsumFailedAttempts = {};
    _quadsumStars = 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefHighestLevel);
    await prefs.remove(AppConstants.prefBestTimes);
    await prefs.remove(AppConstants.prefTotalStars);
    await prefs.remove(AppConstants.prefWordSearchStars);
    await prefs.remove(AppConstants.prefStarUnlockedLevels);
    await prefs.remove(AppConstants.prefRetryAdLevels);

    await prefs.remove(AppConstants.prefSudokuHighestLevel);
    await prefs.remove(AppConstants.prefSudokuBestTimes);
    await prefs.remove(AppConstants.prefSudokuStars);
    await prefs.remove(AppConstants.prefSudokuStarUnlockedLevels);
    await prefs.remove(AppConstants.prefSudokuRetryAdLevels);

    await prefs.remove(AppConstants.prefCryptogramHighestLevel);
    await prefs.remove(AppConstants.prefCryptogramBestTimes);
    await prefs.remove(AppConstants.prefCryptogramStars);
    await prefs.remove(AppConstants.prefCryptogramStarUnlockedLevels);
    await prefs.remove(AppConstants.prefCryptogramRetryAdLevels);

    await prefs.remove(AppConstants.prefQuadsumHighestLevel);
    await prefs.remove(AppConstants.prefQuadsumBestTimes);
    await prefs.remove(AppConstants.prefQuadsumStars);
    await prefs.remove(AppConstants.prefQuadsumStarUnlockedLevels);
    await prefs.remove(AppConstants.prefQuadsumRetryAdLevels);

    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();

    // Per-game stars & total
    await prefs.setInt(AppConstants.prefWordSearchStars, _wordSearchStars);
    await prefs.setInt(AppConstants.prefSudokuStars, _sudokuStars);
    await prefs.setInt(AppConstants.prefCryptogramStars, _cryptogramStars);
    await prefs.setInt(AppConstants.prefQuadsumStars, _quadsumStars);
    await prefs.setInt(AppConstants.prefTotalStars, totalStars);

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
    await prefs.setString(
      AppConstants.prefRetryAdLevels,
      jsonEncode(_failedAttempts.map((k, v) => MapEntry(k.toString(), v))),
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
    await prefs.setString(
      AppConstants.prefSudokuRetryAdLevels,
      jsonEncode(_sudokuFailedAttempts.map((k, v) => MapEntry(k.toString(), v))),
    );

    // Cryptogram
    await prefs.setInt(
        AppConstants.prefCryptogramHighestLevel, cryptogramHighestUnlockedLevel);
    await prefs.setString(
      AppConstants.prefCryptogramBestTimes,
      jsonEncode(_cryptogramBestTimes.map((k, v) => MapEntry(k.toString(), v))),
    );
    await prefs.setString(
      AppConstants.prefCryptogramStarUnlockedLevels,
      jsonEncode(_cryptogramStarUnlockedLevels.toList()),
    );
    await prefs.setString(
      AppConstants.prefCryptogramRetryAdLevels,
      jsonEncode(_cryptogramFailedAttempts.map((k, v) => MapEntry(k.toString(), v))),
    );

    // Quadsum
    await prefs.setInt(
        AppConstants.prefQuadsumHighestLevel, quadsumHighestUnlockedLevel);
    await prefs.setString(
      AppConstants.prefQuadsumBestTimes,
      jsonEncode(_quadsumBestTimes.map((k, v) => MapEntry(k.toString(), v))),
    );
    await prefs.setString(
      AppConstants.prefQuadsumStarUnlockedLevels,
      jsonEncode(_quadsumStarUnlockedLevels.toList()),
    );
    await prefs.setString(
      AppConstants.prefQuadsumRetryAdLevels,
      jsonEncode(_quadsumFailedAttempts.map((k, v) => MapEntry(k.toString(), v))),
    );

    // Settings
    await prefs.setString(AppConstants.prefLanguage, _languageCode);
  }
}
