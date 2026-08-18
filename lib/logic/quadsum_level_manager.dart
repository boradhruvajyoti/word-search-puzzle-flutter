// Logic: QuadsumLevelManager — level configuration factory for 1000 Quadsum levels
import '../models/quadsum_level_config.dart';
import 'quadsum_generator.dart';

class QuadsumLevelManager {
  QuadsumLevelManager._();

  /// Generates a [QuadsumLevelConfig] for the given [level] (1-indexed, 1–1000+).
  static QuadsumLevelConfig configForLevel(int level) {
    assert(level >= 1, 'Level must be >= 1');

    final int revealedCount;
    final int timeLimit;
    final String difficulty;

    if (level <= 20) {
      revealedCount = 4;
      timeLimit = 120;
      difficulty = 'Beginner';
    } else if (level <= 40) {
      revealedCount = 4;
      timeLimit = 150;
      difficulty = 'Easy';
    } else if (level <= 100) {
      revealedCount = 3;
      timeLimit = 180;
      difficulty = 'Easy-Medium';
    } else if (level <= 200) {
      revealedCount = 3;
      timeLimit = 210;
      difficulty = 'Medium';
    } else if (level <= 500) {
      revealedCount = 2;
      timeLimit = 240;
      difficulty = 'Medium-Hard';
    } else if (level <= 750) {
      revealedCount = 2;
      timeLimit = 270;
      difficulty = 'Hard';
    } else {
      revealedCount = 2;
      timeLimit = 300;
      difficulty = 'Master';
    }

    return QuadsumGenerator.generate(
      level: level,
      revealedCount: revealedCount,
      timeLimit: timeLimit,
      difficulty: difficulty,
    );
  }

  /// Stars earned (1–3) based on time remaining vs total time.
  static int starsEarned(int timeRemaining, int timeLimit) {
    if (timeLimit == 0) return 1;
    final ratio = timeRemaining / timeLimit;
    if (ratio >= 0.6) return 3;
    if (ratio >= 0.3) return 2;
    return 1;
  }

  /// Display label for a level.
  static String levelLabel(int level) => 'Quadsum Level $level';

  /// Difficulty name for the level.
  static String difficultyName(int level) =>
      configForLevel(level).difficulty;
}
