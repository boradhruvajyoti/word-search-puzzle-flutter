// Logic: SudokuLevelManager — formula-based level config for 1000 Sudoku levels
import '../models/sudoku_level_config.dart';

class SudokuLevelManager {
  /// Generates a [SudokuLevelConfig] for the given [level] (1-indexed, 1–1000+).
  ///
  /// Difficulty is controlled by clue count (pre-filled cells out of 81).
  /// Fewer clues = harder puzzle.
  ///
  /// Level tiers:
  ///  Levels 1–20:   Easy       — 36 clues, 120s
  ///  Levels 21–40:  Easy-Med   — 30 clues, 150s
  ///  Levels 41–100: Medium     — 27 clues, 180s
  ///  Levels 101–200: Med-Hard  — 24 clues, 240s
  ///  Levels 201–500: Hard      — 22 clues, 300s
  ///  Levels 501–750: Expert    — 20 clues, 360s
  ///  Levels 751–1000: Master   — 17 clues, 420s
  static SudokuLevelConfig configForLevel(int level) {
    assert(level >= 1, 'Level must be >= 1');

    final int clueCount;
    final int timeLimit;

    if (level <= 20) {
      clueCount = 36;
      timeLimit = 120;
    } else if (level <= 40) {
      clueCount = 30;
      timeLimit = 150;
    } else if (level <= 100) {
      clueCount = 27;
      timeLimit = 180;
    } else if (level <= 200) {
      clueCount = 24;
      timeLimit = 240;
    } else if (level <= 500) {
      clueCount = 22;
      timeLimit = 300;
    } else if (level <= 750) {
      clueCount = 20;
      timeLimit = 360;
    } else {
      clueCount = 17;
      timeLimit = 420;
    }

    return SudokuLevelConfig(
      level: level,
      clueCount: clueCount,
      timeLimit: timeLimit,
    );
  }

  /// Stars earned (1–3) based on time remaining vs total time (same as Word Search).
  static int starsEarned(int timeRemaining, int timeLimit) {
    if (timeLimit == 0) return 1;
    final ratio = timeRemaining / timeLimit;
    if (ratio >= 0.6) return 3;
    if (ratio >= 0.3) return 2;
    return 1;
  }

  /// Display label for a level.
  static String levelLabel(int level) => 'Sudoku Level $level';

  /// Difficulty name for the given level.
  static String difficultyName(int level) {
    if (level <= 20) return 'Easy';
    if (level <= 40) return 'Easy-Medium';
    if (level <= 100) return 'Medium';
    if (level <= 200) return 'Medium-Hard';
    if (level <= 500) return 'Hard';
    if (level <= 750) return 'Expert';
    return 'Master';
  }
}
