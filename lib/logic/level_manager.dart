// Logic: LevelManager — formula-based level configuration generator
import '../models/level_config.dart';
import 'word_bank.dart';

class LevelManager {
  static const int maxGridSize = 15;
  static const int maxWordCount = 20;
  static const int baseGridSize = 4;
  static const int baseWordCount = 4;
  static const int baseTimeLimit = 45;
  static const int timeLimitStep = 15;

  /// Generates a [LevelConfig] for the given [level] (1-indexed).
  static LevelConfig configForLevel(int level) {
    assert(level >= 1, 'Level must be >= 1');
    final gridSize = (baseGridSize + level).clamp(5, maxGridSize);
    final wordCount = (baseWordCount + level).clamp(5, maxWordCount);
    final timeLimit = baseTimeLimit + level * timeLimitStep;
    final category = WordBank.categoryForLevel(level);

    return LevelConfig(
      level: level,
      gridSize: gridSize,
      wordCount: wordCount,
      timeLimit: timeLimit,
      category: category,
    );
  }

  /// Returns the 1-based level number as display string.
  static String levelLabel(int level) => 'Level $level';

  /// How many stars (1-3) earned given timeRemaining vs timeLimit.
  static int starsEarned(int timeRemaining, int timeLimit) {
    final ratio = timeRemaining / timeLimit;
    if (ratio >= 0.6) return 3;
    if (ratio >= 0.3) return 2;
    return 1;
  }
}
