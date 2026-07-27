// Logic: LevelManager — formula-based level config for 1000 levels
import '../models/level_config.dart';
import 'word_bank.dart';

class LevelManager {
  static const int maxGridSize  = 10;  // hard cap at 10×10
  static const int maxWordCount = 20;

  /// Generates a [LevelConfig] for the given [level] (1-indexed, supports 1–1000+).
  ///
  /// Level tiers:
  ///  Levels 1–20:   5x5 grid,  5 words,  60s time
  ///  Levels 21–40:  6x6 grid,  7 words,  75s time
  ///  Levels 41–100: 7x7 grid,  9 words,  90s time
  ///  Levels 101–200: 8x8 grid, 11 words, 120s time
  ///  Levels 201–500: 9x9 grid, 13 words, 150s time
  ///  Levels 501–750: 10x10 grid, 15 words, 180s time
  ///  Levels 751–1000: 10x10 grid, 20 words, 210s time
  static LevelConfig configForLevel(int level) {
    assert(level >= 1, 'Level must be >= 1');

    final int gridSize;
    final int wordCount;
    final int timeLimit;

    if (level <= 20) {
      gridSize = 5;
      wordCount = 5;
      timeLimit = 60;
    } else if (level <= 40) {
      gridSize = 6;
      wordCount = 7;
      timeLimit = 75;
    } else if (level <= 100) {
      gridSize = 7;
      wordCount = 9;
      timeLimit = 90;
    } else if (level <= 200) {
      gridSize = 8;
      wordCount = 11;
      timeLimit = 120;
    } else if (level <= 500) {
      gridSize = 9;
      wordCount = 13;
      timeLimit = 150;
    } else if (level <= 750) {
      gridSize = 10;
      wordCount = 15;
      timeLimit = 180;
    } else {
      gridSize = 10;
      wordCount = 20;
      timeLimit = 210;
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
