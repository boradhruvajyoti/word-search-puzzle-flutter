// Logic: LevelManager — formula-based level config for 1000 levels
import '../models/level_config.dart';
import 'word_bank.dart';

class LevelManager {
  static const int maxGridSize  = 10;  // hard cap at 10×10
  static const int maxWordCount = 20;

  /// Generates a [LevelConfig] for the given [level] (1-indexed, supports 1–1000+).
  ///
  /// Difficulty phases:
  ///  Phase 1 (Levels 1–20):   Grid 5x5 (1–10) to 6x6 (11–20)
  ///  Phase 2 (Levels 21–40):  Grid 7x7 (21–30) to 8x8 (31–40)
  ///  Phase 3 (Levels 41–100): Grid 9x9
  ///  Phase 4 (Levels 101–1000): Grid 10x10
  static LevelConfig configForLevel(int level) {
    assert(level >= 1, 'Level must be >= 1');

    final int gridSize;
    if (level <= 10) {
      gridSize = 5;
    } else if (level <= 20) {
      gridSize = 6;
    } else if (level <= 30) {
      gridSize = 7;
    } else if (level <= 40) {
      gridSize = 8;
    } else if (level <= 100) {
      gridSize = 9;
    } else {
      gridSize = 10;
    }

    final int wordCount;
    if (level <= 10) {
      wordCount = level <= 5 ? 4 : 5;
    } else if (level <= 20) {
      wordCount = level <= 15 ? 5 : 6;
    } else if (level <= 30) {
      wordCount = level <= 25 ? 6 : 7;
    } else if (level <= 40) {
      wordCount = level <= 35 ? 7 : 8;
    } else if (level <= 100) {
      wordCount = 9 + ((level - 41) * 3 ~/ 59); // 9..12
    } else {
      wordCount = 13 + ((level - 101) * 7 ~/ 899); // 13..20
    }

    final int timeLimit;
    if (level <= 20) {
      timeLimit = 50 + level * 2;
    } else if (level <= 40) {
      timeLimit = 90 + (level - 20) * 2;
    } else if (level <= 100) {
      timeLimit = 130 + ((level - 40) * 50 ~/ 60);
    } else {
      timeLimit = (180 - ((level - 100) ~/ 7)).clamp(60, 180);
    }

    final category = WordBank.categoryForLevel(level);

    return LevelConfig(
      level: level,
      gridSize: gridSize,
      wordCount: wordCount,
      timeLimit: timeLimit,
      category: category,
    );
  }

  /// Display label for a level.
  static String levelLabel(int level) => 'Level $level';

  /// Stars earned (1–3) based on time remaining vs total time.
  static int starsEarned(int timeRemaining, int timeLimit) {
    if (timeLimit == 0) return 1;
    final ratio = timeRemaining / timeLimit;
    if (ratio >= 0.6) return 3;
    if (ratio >= 0.3) return 2;
    return 1;
  }

  /// Category display name for HUD (e.g. "Animals", "Space").
  static String categoryDisplay(int level) =>
      WordBank.categoryDisplayForLevel(level);
}
