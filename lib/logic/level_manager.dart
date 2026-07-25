// Logic: LevelManager — formula-based level config for 1000 levels, max 10x10 grid
import '../models/level_config.dart';
import 'word_bank.dart';

class LevelManager {
  static const int maxGridSize  = 10;  // hard cap at 10×10
  static const int maxWordCount = 20;
  static const int baseGridSize  = 4;
  static const int baseWordCount = 4;

  /// Generates a [LevelConfig] for the given [level] (1-indexed, supports 1–1000+).
  ///
  /// Difficulty phases:
  ///  Phase 1 (levels 1–6):   grid grows 5×5 → 10×10, words grow 5→10, time grows 60→135 s
  ///  Phase 2 (levels 7–16):  grid stays 10×10, words grow 11→20, time grows 150→285 s
  ///  Phase 3 (levels 17–1000): grid 10×10, 20 words, time DECREASES 2 s per level → min 45 s
  static LevelConfig configForLevel(int level) {
    assert(level >= 1, 'Level must be >= 1');

    final gridSize  = (baseGridSize + level).clamp(5, maxGridSize);
    final wordCount = (baseWordCount + level).clamp(5, maxWordCount);

    final int timeLimit;
    if (level <= 16) {
      // Scales 60 s → 285 s
      timeLimit = 45 + level * 15;
    } else {
      // Decreases 2 s per level beyond 16, floor at 45 s
      timeLimit = (285 - (level - 16) * 2).clamp(45, 300);
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
